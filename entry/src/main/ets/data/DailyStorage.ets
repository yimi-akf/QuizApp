import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { todayString } from '../utils/DateUtil';
import { questionBank } from './QuestionBank';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_daily';
const KEY_COMPLETED_TODAY = 'daily_completed_today';
const KEY_DAILY_QUESTION_ID = 'daily_question_id';

// 每日一题本地存储
export class DailyStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'getPreferences failed');
      return null;
    }
  }

  // 获取用于今日的题目 ID（基于日期确定性选择，全天不变）
  static getTodayQuestionId(context: common.UIAbilityContext): number {
    const prefs = DailyStorage.getPreferences(context);
    if (!prefs) {
      return DailyStorage.pickQuestionByDate();
    }
    try {
      const saved = prefs.getSync(KEY_DAILY_QUESTION_ID, 0) as number;
      if (saved > 0) {
        // 如果已保存且是今天的，直接返回
        const savedDate = prefs.getSync(KEY_COMPLETED_TODAY + '_date', '') as string;
        const today = todayString();
        if (savedDate === today) {
          return saved;
        }
      }
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'getTodayQuestionId failed');
    }
    // 每天重新计算并缓存
    const id = DailyStorage.pickQuestionByDate();
    const date = todayString();
    try {
      prefs.putSync(KEY_DAILY_QUESTION_ID, id);
      // 用 date 后缀标记是哪天的缓存
      prefs.putSync(KEY_COMPLETED_TODAY + '_date', date);
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'save today question id failed');
    }
    return id;
  }

  // 基于日期字符串的确定性选题
  private static pickQuestionByDate(): number {
    const today = todayString();
    // 用日期字符串生成哈希值，映射到题库范围
    let hash = 0;
    for (let i = 0; i < today.length; i++) {
      hash = (hash * 31 + today.charCodeAt(i)) % 0x7FFFFFFF;
    }
    const total = questionBank.length;
    if (total === 0) {
      return 0;
    }
    const idx = Math.abs(hash) % total;
    return questionBank[idx].id;
  }

  // 今日是否已完成
  static isCompletedToday(context: common.UIAbilityContext): boolean {
    const prefs = DailyStorage.getPreferences(context);
    if (!prefs) {
      return false;
    }
    try {
      const savedDate = prefs.getSync(KEY_COMPLETED_TODAY, '') as string;
      return savedDate === todayString();
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'isCompletedToday failed');
      return false;
    }
  }

  // 标记今日已完成
  static markCompletedToday(context: common.UIAbilityContext): void {
    const prefs = DailyStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_COMPLETED_TODAY, todayString());
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'markCompletedToday failed');
    }
  }

  // 清空每日一题数据
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = DailyStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'DailyStorage', 'clearAll failed');
    }
  }
}