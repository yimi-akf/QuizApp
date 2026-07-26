import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_feedback';
const KEY_FEEDBACK = 'question_feedback';
const MAX_FEEDBACK = 100;

export type FeedbackType = 'unclear' | 'wrong_answer' | 'typo' | 'other';

export interface QuestionFeedback {
  questionId: number;
  type: FeedbackType;
  remark: string;
  createdAt: string;
}

// 题目反馈本地存储
export class QuestionFeedbackStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'QuestionFeedbackStorage', 'getPreferences failed');
      return null;
    }
  }

  // 读取所有反馈
  static loadFeedback(context: common.UIAbilityContext): QuestionFeedback[] {
    const prefs = QuestionFeedbackStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_FEEDBACK, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as QuestionFeedback[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed;
    } catch (e) {
      hilog.error(0x0000, 'QuestionFeedbackStorage', 'loadFeedback failed');
      return [];
    }
  }

  // 提交一条反馈
  static submitFeedback(
    context: common.UIAbilityContext,
    questionId: number,
    type: FeedbackType,
    remark: string
  ): void {
    const prefs = QuestionFeedbackStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      const list = QuestionFeedbackStorage.loadFeedback(context);
      list.unshift({
        questionId,
        type,
        remark: remark.trim(),
        createdAt: new Date().toISOString()
      });
      if (list.length > MAX_FEEDBACK) {
        list.length = MAX_FEEDBACK;
      }
      prefs.putSync(KEY_FEEDBACK, JSON.stringify(list));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'QuestionFeedbackStorage', 'submitFeedback failed');
    }
  }

  // 获取某题的反馈
  static getFeedbackByQuestionId(context: common.UIAbilityContext, questionId: number): QuestionFeedback | null {
    const list = QuestionFeedbackStorage.loadFeedback(context);
    return list.find(f => f.questionId === questionId) || null;
  }

  // 清空反馈
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = QuestionFeedbackStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'QuestionFeedbackStorage', 'clearAll failed');
    }
  }
}
