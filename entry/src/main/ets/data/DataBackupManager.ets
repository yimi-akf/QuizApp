import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import dataPreferences from '@ohos.data.preferences';
import util from '@ohos.util';
import hilog from '@ohos.hilog';

const BACKUP_VERSION = 1;
const BACKUP_DIR = 'backup';
const MAX_BACKUP_FILES = 10;

// 各 Storage 对应的 preferences 名称与 key
const PREF_CONFIGS: { name: string; key: string }[] = [
  { name: 'quiz_history', key: 'history_records' },
  { name: 'quiz_progress', key: 'progress_data' },
  { name: 'quiz_progress', key: 'last_progress' },
  { name: 'quiz_progress', key: 'last_home_module' },
  { name: 'quiz_wrong_book', key: 'wrong_records' },
  { name: 'quiz_achievement', key: 'user_stats' },
  { name: 'quiz_achievement', key: 'achievements' },
  { name: 'quiz_favorite', key: 'favorite_questions' },
  { name: 'quiz_feedback', key: 'question_feedback' },
  { name: 'quiz_stats', key: 'topic_progress' },
  { name: 'quiz_theme', key: 'theme_index' }
];

// 合法的 preferences 名称白名单，用于恢复时校验，防止外部备份注入未知键
const VALID_PREF_NAMES = new Set<string>([
  'quiz_history', 'quiz_progress', 'quiz_wrong_book',
  'quiz_achievement', 'quiz_favorite', 'quiz_feedback', 'quiz_stats', 'quiz_theme'
]);

export interface BackupInfo {
  fileName: string;
  filePath: string;
  size: number;
  createTime: string;
}

// 数据备份与恢复管理器
export class DataBackupManager {
  private static getBackupDir(context: common.UIAbilityContext): string {
    return context.filesDir + '/' + BACKUP_DIR;
  }

  // 确保备份目录存在
  private static ensureBackupDir(context: common.UIAbilityContext): boolean {
    const dir = DataBackupManager.getBackupDir(context);
    try {
      if (!fs.accessSync(dir)) {
        fs.mkdirSync(dir);
      }
      return true;
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'ensureBackupDir failed');
      return false;
    }
  }

  // 读取单个 preferences 的所有 key
  private static readAllPreferences(context: common.UIAbilityContext): Record<string, string | number | boolean> {
    const result: Record<string, string | number | boolean> = {};
    const prefNameSet = new Set<string>();
    PREF_CONFIGS.forEach(c => prefNameSet.add(c.name));

    prefNameSet.forEach(prefName => {
      try {
        const prefs = dataPreferences.getPreferencesSync(context, { name: prefName });
        const keys = PREF_CONFIGS.filter(c => c.name === prefName).map(c => c.key);
        keys.forEach(key => {
          try {
            const value = prefs.getSync(key, '') as string | number | boolean;
            result[`${prefName}:${key}`] = value;
          } catch (e) {
            result[`${prefName}:${key}`] = '';
          }
        });
      } catch (e) {
        // 忽略单个 preferences 错误
      }
    });
    return result;
  }

  // 导出备份
  static exportBackup(context: common.UIAbilityContext): string | null {
    if (!DataBackupManager.ensureBackupDir(context)) {
      return null;
    }
    try {
      const d = new Date();
      const pad = (n: number) => String(n).padStart(2, '0');
      const datePart = `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}`;
      const timePart = `${pad(d.getHours())}${pad(d.getMinutes())}${pad(d.getSeconds())}`;
      const fileName = `quiz_backup_${datePart}_${timePart}.json`;
      const filePath = DataBackupManager.getBackupDir(context) + '/' + fileName;

      const backupData = {
        version: BACKUP_VERSION,
        exportedAt: d.toISOString(),
        data: DataBackupManager.readAllPreferences(context)
      };

      const file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      try {
        fs.writeSync(file.fd, JSON.stringify(backupData));
      } finally {
        fs.closeSync(file);
      }

      DataBackupManager.cleanupOldBackups(context);
      return filePath;
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'exportBackup failed');
      return null;
    }
  }

  // 清理旧备份，只保留最近 MAX_BACKUP_FILES 个
  private static cleanupOldBackups(context: common.UIAbilityContext): void {
    try {
      const backups = DataBackupManager.listBackups(context);
      if (backups.length > MAX_BACKUP_FILES) {
        const toDelete = backups.slice(MAX_BACKUP_FILES);
        toDelete.forEach(b => DataBackupManager.deleteBackup(b.filePath));
      }
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'cleanupOldBackups failed');
    }
  }

  // 列出所有备份文件
  static listBackups(context: common.UIAbilityContext): BackupInfo[] {
    if (!DataBackupManager.ensureBackupDir(context)) {
      return [];
    }
    try {
      const dir = DataBackupManager.getBackupDir(context);
      const list = fs.listFileSync(dir);
      const backups: BackupInfo[] = [];
      list.forEach(name => {
        if (name.endsWith('.json')) {
          const filePath = dir + '/' + name;
          try {
            const stat = fs.statSync(filePath);
            backups.push({
              fileName: name,
              filePath,
              size: stat.size,
              createTime: new Date(stat.mtime * 1000).toISOString()
            });
          } catch (e) {
            // 忽略单个文件错误
          }
        }
      });
      return backups.sort((a, b) => b.createTime.localeCompare(a.createTime));
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'listBackups failed');
      return [];
    }
  }

  // 读取备份文件内容
  static readBackup(filePath: string): object | null {
    let file: fs.File | null = null;
    try {
      // 先获取文件大小，动态分配缓冲区，避免固定 1MB 截断导致数据损坏
      const stat = fs.statSync(filePath);
      const fileSize = stat.size;
      if (fileSize <= 0) {
        return null;
      }
      file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      const buf = new ArrayBuffer(fileSize);
      const readLen = fs.readSync(file.fd, buf);
      if (readLen !== fileSize) {
        hilog.error(
          0x0001,
          'DataBackupManager',
          'readBackup incomplete: read %{public}d of %{public}d',
          readLen.toString(),
          fileSize.toString()
        );
        return null;
      }
      // 用 TextDecoder 解码 UTF-8，替代逐字节拼接（性能从 O(n²) 降为 O(n)）
      const textDecoder = new util.TextDecoder('utf-8');
      const text = textDecoder.decodeToString(new Uint8Array(buf));
      return JSON.parse(text);
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'readBackup failed: %{public}s', JSON.stringify(e));
      return null;
    } finally {
      if (file !== null) {
        try {
          fs.closeSync(file);
        } catch (e) {
          // 忽略关闭错误
        }
      }
    }
  }

  // 从备份对象恢复数据
  static restoreFromBackup(context: common.UIAbilityContext, backup: object): boolean {
    try {
      const b = backup as {
        version: number;
        data: Record<string, string | number | boolean>;
      };
      if (b.version !== BACKUP_VERSION) {
        return false;
      }
      const grouped: Record<string, { key: string; value: string | number | boolean }[]> = {};
      let skippedCount = 0;
      Object.keys(b.data).forEach(compositeKey => {
        // 校验 compositeKey 格式：必须是 "prefName:key" 且 prefName 在白名单内
        const sepIndex = compositeKey.indexOf(':');
        if (sepIndex <= 0) {
          skippedCount++;
          return;
        }
        const prefName = compositeKey.substring(0, sepIndex);
        const key = compositeKey.substring(sepIndex + 1);
        if (!VALID_PREF_NAMES.has(prefName) || key.length === 0) {
          skippedCount++;
          return;
        }
        if (!grouped[prefName]) {
          grouped[prefName] = [];
        }
        grouped[prefName].push({ key, value: b.data[compositeKey] });
      });

      if (skippedCount > 0) {
        hilog.warn(
          0x0001,
          'DataBackupManager',
          'restoreFromBackup skipped %{public}d invalid keys',
          skippedCount.toString()
        );
      }

      Object.keys(grouped).forEach(prefName => {
        try {
          const prefs = dataPreferences.getPreferencesSync(context, { name: prefName });
          grouped[prefName].forEach(item => {
            prefs.putSync(item.key, item.value);
          });
          prefs.flushSync();
        } catch (e) {
          hilog.error(0x0001, 'DataBackupManager', 'restore preferences failed: %{public}s', JSON.stringify(e));
        }
      });
      return true;
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'restoreFromBackup failed: %{public}s', JSON.stringify(e));
      return false;
    }
  }

  // 删除备份文件
  static deleteBackup(filePath: string): boolean {
    try {
      fs.unlinkSync(filePath);
      return true;
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'deleteBackup failed');
      return false;
    }
  }

  // 清空所有备份文件（供"清空本地数据"调用）
  static clearAllBackups(context: common.UIAbilityContext): void {
    try {
      const backups = DataBackupManager.listBackups(context);
      backups.forEach(b => {
        DataBackupManager.deleteBackup(b.filePath);
      });
    } catch (e) {
      hilog.error(0x0001, 'DataBackupManager', 'clearAllBackups failed');
    }
  }
}
