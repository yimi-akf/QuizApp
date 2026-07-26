import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { Difficulty, Topic } from '../model/Question';
import { formatDateTime } from '../utils/DateUtil';
import hilog from '@ohos.hilog';

export interface HistoryRecord {
  id: number;
  topic: Topic;
  difficulty: Difficulty | 'mixed';
  score: number;
  correctCount: number;
  total: number;          // 本次 quiz 的题目总数
  answeredCount: number;  // 实际已答题数（用于正确率计算，旧记录缺失时回退到 total）
  elapsedSeconds: number;
  date: string;
}

const PREFERENCES_NAME = 'quiz_history';
const KEY_RECORDS = 'history_records';
const MAX_RECORDS = 50;

// 递增计数器，避免同毫秒内创建多条记录导致 id 冲突
let recordIdCounter = 0;

// 答题历史记录本地存储
export class HistoryStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'HistoryStorage', 'getPreferences failed');
      return null;
    }
  }

  // 保存一条答题记录
  static saveRecord(context: common.UIAbilityContext, record: HistoryRecord): void {
    const prefs = HistoryStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      const value = prefs.getSync(KEY_RECORDS, '') as string;
      let records: HistoryRecord[] = [];
      if (value) {
        const parsed = JSON.parse(value) as HistoryRecord[];
        if (Array.isArray(parsed)) {
          records = parsed;
        }
      }
      records.unshift(record);
      if (records.length > MAX_RECORDS) {
        records.length = MAX_RECORDS;
      }
      prefs.putSync(KEY_RECORDS, JSON.stringify(records));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'HistoryStorage', 'saveRecord failed');
    }
  }

  // 读取全部答题记录
  static loadRecords(context: common.UIAbilityContext): HistoryRecord[] {
    const prefs = HistoryStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_RECORDS, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as HistoryRecord[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed;
    } catch (e) {
      hilog.error(0x0000, 'HistoryStorage', 'loadRecords failed');
      return [];
    }
  }

  // 读取最新一条答题记录
  static loadLatestRecord(context: common.UIAbilityContext): HistoryRecord | null {
    const records = HistoryStorage.loadRecords(context);
    if (records.length === 0) {
      return null;
    }
    return records[0];
  }

  // 清空所有答题记录
  static clearRecords(context: common.UIAbilityContext): void {
    const prefs = HistoryStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.deleteSync(KEY_RECORDS);
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'HistoryStorage', 'clearRecords failed');
    }
  }

  // 清空所有历史相关偏好设置
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = HistoryStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'HistoryStorage', 'clearAll failed');
    }
  }
}

// 创建新的历史记录辅助函数
export function createHistoryRecord(
  topic: Topic,
  difficulty: Difficulty | 'mixed',
  score: number,
  correctCount: number,
  total: number,
  answeredCount: number,
  elapsedSeconds: number
): HistoryRecord {
  return {
    id: Date.now() * 1000 + (recordIdCounter++ % 1000),
    topic,
    difficulty,
    score,
    correctCount,
    total,
    answeredCount,
    elapsedSeconds,
    date: formatDateTime(new Date())
  };
}
