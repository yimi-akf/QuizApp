import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_wrong_book';
const KEY_WRONG_RECORDS = 'wrong_records';

export interface WrongRecord {
  questionId: number;
  wrongCount: number;
  lastWrongAt: string;
  mastered: boolean;
  correctStreak: number;
}

// 错题本本地存储
export class WrongBookStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'WrongBookStorage', 'getPreferences failed');
      return null;
    }
  }

  // 读取所有错题记录
  static loadRecords(context: common.UIAbilityContext): WrongRecord[] {
    const prefs = WrongBookStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_WRONG_RECORDS, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as WrongRecord[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed;
    } catch (e) {
      hilog.error(0x0000, 'WrongBookStorage', 'loadRecords failed');
      return [];
    }
  }

  // 保存所有错题记录
  private static saveRecords(context: common.UIAbilityContext, records: WrongRecord[]): void {
    const prefs = WrongBookStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_WRONG_RECORDS, JSON.stringify(records));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'WrongBookStorage', 'saveRecords failed');
    }
  }

  // 记录一次错题
  static addWrong(context: common.UIAbilityContext, questionId: number): void {
    const records = WrongBookStorage.loadRecords(context);
    const existing = records.find(r => r.questionId === questionId);
    const now = new Date().toISOString();
    if (existing) {
      existing.wrongCount++;
      existing.lastWrongAt = now;
      existing.mastered = false;
      existing.correctStreak = 0;
    } else {
      records.push({
        questionId,
        wrongCount: 1,
        lastWrongAt: now,
        mastered: false,
        correctStreak: 0
      });
    }
    WrongBookStorage.saveRecords(context, records);
  }

  // 记录一次错题重练答对
  static addCorrect(context: common.UIAbilityContext, questionId: number): void {
    const records = WrongBookStorage.loadRecords(context);
    const existing = records.find(r => r.questionId === questionId);
    if (!existing) {
      return;
    }
    existing.correctStreak++;
    if (existing.correctStreak >= 2) {
      existing.mastered = true;
    }
    WrongBookStorage.saveRecords(context, records);
  }

  // 手动移除错题
  static removeRecord(context: common.UIAbilityContext, questionId: number): void {
    const records = WrongBookStorage.loadRecords(context);
    const filtered = records.filter(r => r.questionId !== questionId);
    WrongBookStorage.saveRecords(context, filtered);
  }

  // 获取所有未掌握的错题 ID
  static getUnmasteredQuestionIds(context: common.UIAbilityContext): number[] {
    const records = WrongBookStorage.loadRecords(context);
    return records.filter(r => !r.mastered).map(r => r.questionId);
  }

  // 清空错题本
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = WrongBookStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'WrongBookStorage', 'clearAll failed');
    }
  }
}
