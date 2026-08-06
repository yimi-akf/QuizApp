import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import picker from '@ohos.file.picker';
import fileIo from '@ohos.file.fs';
import util from '@ohos.util';
import hilog from '@ohos.hilog';
import { ThemeManager } from './ThemeManager';

const TAG = 'DataBackupManager';
const BACKUP_VERSION = 1;

// 所有需要备份的 preferences 名称及其 key 列表
const BACKUP_STORES: Record<string, string[]> = {
  'quiz_theme': ['theme_index', 'dark_mode_setting'],
  'quiz_progress': ['progress_data', 'last_progress', 'last_home_module'],
  'quiz_history': ['history_records'],
  'quiz_favorite': ['favorite_questions'],
  'quiz_daily': ['daily_completed_today', 'daily_question_id', 'daily_completed_today_date'],
  'quiz_wrong_book': ['wrong_records'],
  'quiz_achievement': ['user_stats', 'achievements'],
  'quiz_stats': ['topic_progress']
};

export interface BackupData {
  version: number;
  exportDate: string;
  stores: Record<string, Record<string, string>>;
}

export interface ValidationResult {
  valid: boolean;
  message: string;
  backup: BackupData | null;
}

// 数据备份管理器：负责导出/导入所有本地数据
export class DataBackupManager {
  // 导出所有数据为 JSON 字符串
  static async exportAllData(context: common.UIAbilityContext): Promise<string> {
    const stores: Record<string, Record<string, string>> = {};
    const storeNames: string[] = Object.keys(BACKUP_STORES);

    for (let i = 0; i < storeNames.length; i++) {
      const storeName: string = storeNames[i];
      const keys: string[] = BACKUP_STORES[storeName];
      const storeData: Record<string, string> = {};

      try {
        const prefs: dataPreferences.Preferences = dataPreferences.getPreferencesSync(context, { name: storeName });
        for (let j = 0; j < keys.length; j++) {
          const key: string = keys[j];
          try {
            const rawValue: dataPreferences.ValueType = prefs.getSync(key, '');
            if (rawValue !== '' && rawValue !== undefined && rawValue !== null) {
              storeData[key] = typeof rawValue === 'string' ? rawValue : JSON.stringify(rawValue);
            }
          } catch (e) {
            // key 不存在，跳过
          }
        }
      } catch (e) {
        hilog.warn(0x0001, TAG, `Failed to read store: ${storeName}`);
      }

      if (Object.keys(storeData).length > 0) {
        stores[storeName] = storeData;
      }
    }

    const backup: BackupData = {
      version: BACKUP_VERSION,
      exportDate: new Date().toISOString(),
      stores: stores
    };

    return JSON.stringify(backup);
  }

  // 保存备份到文件（通过文件选择器）
  static async saveBackupToFile(context: common.UIAbilityContext): Promise<boolean> {
    try {
      const jsonData: string = await DataBackupManager.exportAllData(context);
      const documentSaveOptions: picker.DocumentSaveOptions = {
        newFileNames: [`QuizApp_Backup_${DataBackupManager.formatDate(new Date())}`],
        fileSuffixChoices: ['.json']
      };

      const documentViewPicker: picker.DocumentViewPicker = new picker.DocumentViewPicker(context);
      const uris: string[] = await documentViewPicker.save(documentSaveOptions);
      if (!uris || uris.length === 0) {
        hilog.warn(0x0001, TAG, 'User cancelled save');
        return false;
      }

      const uri: string = uris[0];
      const file: fileIo.File = fileIo.openSync(uri, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, jsonData);
      fileIo.closeSync(file);
      hilog.info(0x0001, TAG, 'Backup saved successfully');
      return true;
    } catch (e) {
      hilog.error(0x0001, TAG, `saveBackupToFile failed`);
      return false;
    }
  }

  // 从文件选择器读取备份文件
  static async selectBackupFile(context: common.UIAbilityContext): Promise<string | null> {
    try {
      const documentSelectOptions: picker.DocumentSelectOptions = {
        maxSelectNumber: 1,
        fileSuffixFilters: ['.json']
      };

      const documentViewPicker: picker.DocumentViewPicker = new picker.DocumentViewPicker(context);
      const uris: string[] = await documentViewPicker.select(documentSelectOptions);
      if (!uris || uris.length === 0) {
        hilog.warn(0x0001, TAG, 'User cancelled select');
        return null;
      }

      const uri: string = uris[0];
      const file: fileIo.File = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      const stat: fileIo.Stat = fileIo.statSync(file.fd);
      const buffer: ArrayBuffer = new ArrayBuffer(stat.size);
      fileIo.readSync(file.fd, buffer);
      fileIo.closeSync(file);

      const decoder: util.TextDecoder = new util.TextDecoder('utf-8');
      const content: string = decoder.decodeToString(new Uint8Array(buffer));
      return content;
    } catch (e) {
      hilog.error(0x0001, TAG, `selectBackupFile failed`);
      return null;
    }
  }

  // 验证备份数据格式
  static validateBackupData(data: string): ValidationResult {
    try {
      const parsed: BackupData = JSON.parse(data) as BackupData;
      if (!parsed || typeof parsed !== 'object') {
        const result: ValidationResult = { valid: false, message: '文件格式无效', backup: null };
        return result;
      }
      if (!parsed.version || !parsed.stores || typeof parsed.stores !== 'object') {
        const result: ValidationResult = { valid: false, message: '备份文件格式不正确，缺少必要字段', backup: null };
        return result;
      }
      if (Object.keys(parsed.stores).length === 0) {
        const result: ValidationResult = { valid: false, message: '备份文件内容为空', backup: null };
        return result;
      }
      const result: ValidationResult = { valid: true, message: '验证通过', backup: parsed };
      return result;
    } catch (e) {
      const result: ValidationResult = { valid: false, message: '文件解析失败，请确认是有效的备份文件', backup: null };
      return result;
    }
  }

  // 导入备份数据到所有 preferences
  static importAllData(context: common.UIAbilityContext, backup: BackupData): boolean {
    try {
      const storeNames: string[] = Object.keys(backup.stores);
      for (let i = 0; i < storeNames.length; i++) {
        const storeName: string = storeNames[i];
        const storeData: Record<string, string> = backup.stores[storeName];
        try {
          const prefs: dataPreferences.Preferences = dataPreferences.getPreferencesSync(context, { name: storeName });
          const keys: string[] = Object.keys(storeData);
          for (let j = 0; j < keys.length; j++) {
            const key: string = keys[j];
            const value: string = storeData[key];
            // theme_index 存为数字，其余按字符串处理
            if (key === 'theme_index') {
              prefs.putSync(key, Number(value));
            } else {
              prefs.putSync(key, value);
            }
          }
          prefs.flushSync();
        } catch (e) {
          hilog.warn(0x0001, TAG, `Failed to write store: ${storeName}`);
        }
      }

      // 重新同步主题到 AppStorage
      try {
        ThemeManager.syncToAppStorage(context);
      } catch (e) {
        hilog.warn(0x0001, TAG, 'Failed to sync theme');
      }

      hilog.info(0x0001, TAG, 'Backup imported successfully');
      return true;
    } catch (e) {
      hilog.error(0x0001, TAG, `importAllData failed`);
      return false;
    }
  }

  private static formatDate(date: Date): string {
    const y: number = date.getFullYear();
    const m: string = String(date.getMonth() + 1).padStart(2, '0');
    const d: string = String(date.getDate()).padStart(2, '0');
    const h: string = String(date.getHours()).padStart(2, '0');
    const min: string = String(date.getMinutes()).padStart(2, '0');
    return `${y}${m}${d}_${h}${min}`;
  }
}