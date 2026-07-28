import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { formatDateTime, formatDate, todayString } from '../utils/DateUtil';
import hilog from '@ohos.hilog';
import { Topic } from '../model/Question';

const PREFERENCES_NAME = 'quiz_achievement';
const KEY_USER_STATS = 'user_stats';
const KEY_ACHIEVEMENTS = 'achievements';

export interface Achievement {
  id: string;
  title: string;
  desc: string;
  icon: string;
  unlockedAt: string | null;
}

export interface UserStats {
  answeredCount: number;
  correctCount: number;
  streakDays: number;
  lastAnswerDate: string;
}

const DEFAULT_ACHIEVEMENTS: Achievement[] = [
  { id: 'first_quiz', title: '初次答题', desc: '完成第一次答题', icon: '🎯', unlockedAt: null },
  { id: 'perfect_100', title: '满分高手', desc: '单次答题获得 100 分', icon: '💯', unlockedAt: null },
  { id: 'streak_10', title: '十连对', desc: '连续答对 10 题', icon: '🔥', unlockedAt: null },
  { id: 'answer_50', title: '答题达人', desc: '累计答对 50 题', icon: '📚', unlockedAt: null },
  { id: 'answer_100', title: '百题斩', desc: '累计答对 100 题', icon: '⚔️', unlockedAt: null },
  { id: 'answer_500', title: '百科全书', desc: '累计答对 500 题', icon: '📖', unlockedAt: null },
  { id: 'master_knowledge', title: '知识通关', desc: '完成知识型问答全部难度', icon: '💡', unlockedAt: null },
  { id: 'master_reasoning', title: '推理通关', desc: '完成推理型问答全部难度', icon: '🧠', unlockedAt: null },
  { id: 'master_riddle', title: '脑筋通关', desc: '完成脑筋急转弯全部难度', icon: '🧩', unlockedAt: null }
];

// 成就本地存储
export class AchievementStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'getPreferences failed');
      return null;
    }
  }

  // 读取用户统计
  static loadUserStats(context: common.UIAbilityContext): UserStats {
    const prefs = AchievementStorage.getPreferences(context);
    if (!prefs) {
      return AchievementStorage.defaultUserStats();
    }
    try {
      const value = prefs.getSync(KEY_USER_STATS, '') as string;
      if (!value) {
        return AchievementStorage.defaultUserStats();
      }
      const parsed = JSON.parse(value) as UserStats;
      const defaults = AchievementStorage.defaultUserStats();
      return {
        answeredCount: parsed.answeredCount ?? defaults.answeredCount,
        correctCount: parsed.correctCount ?? defaults.correctCount,
        streakDays: parsed.streakDays ?? defaults.streakDays,
        lastAnswerDate: parsed.lastAnswerDate ?? defaults.lastAnswerDate
      };
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'loadUserStats failed');
      return AchievementStorage.defaultUserStats();
    }
  }

  private static defaultUserStats(): UserStats {
    return {
      answeredCount: 0,
      correctCount: 0,
      streakDays: 0,
      lastAnswerDate: ''
    };
  }

  private static saveUserStats(context: common.UIAbilityContext, stats: UserStats): void {
    const prefs = AchievementStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_USER_STATS, JSON.stringify(stats));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'saveUserStats failed');
    }
  }

  private static cloneDefaultAchievements(): Achievement[] {
    const result: Achievement[] = [];
    for (let i = 0; i < DEFAULT_ACHIEVEMENTS.length; i++) {
      const a = DEFAULT_ACHIEVEMENTS[i];
      result.push({
        id: a.id,
        title: a.title,
        desc: a.desc,
        icon: a.icon,
        unlockedAt: a.unlockedAt
      });
    }
    return result;
  }

  // 读取成就列表（按 id 合并：旧成就保留 unlockedAt，新成就补齐默认未解锁）
  // 升级新增成就时不会丢失旧用户的解锁记录
  static loadAchievements(context: common.UIAbilityContext): Achievement[] {
    const prefs = AchievementStorage.getPreferences(context);
    if (!prefs) {
      return AchievementStorage.cloneDefaultAchievements();
    }
    try {
      const value = prefs.getSync(KEY_ACHIEVEMENTS, '') as string;
      if (!value) {
        return AchievementStorage.cloneDefaultAchievements();
      }
      const parsed = JSON.parse(value) as Achievement[];
      if (!Array.isArray(parsed) || parsed.length === 0) {
        return AchievementStorage.cloneDefaultAchievements();
      }
      // 按 id 合并：以默认成就列表为骨架，旧记录有则保留 unlockedAt
      const merged = AchievementStorage.cloneDefaultAchievements();
      const oldMap = new Map<string, Achievement>();
      for (let i = 0; i < parsed.length; i++) {
        const a = parsed[i];
        if (a && a.id) {
          oldMap.set(a.id, a);
        }
      }
      for (let i = 0; i < merged.length; i++) {
        const old = oldMap.get(merged[i].id);
        if (old && old.unlockedAt) {
          merged[i].unlockedAt = old.unlockedAt;
        }
      }
      return merged;
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'loadAchievements failed');
      return AchievementStorage.cloneDefaultAchievements();
    }
  }

  private static saveAchievements(context: common.UIAbilityContext, achievements: Achievement[]): void {
    const prefs = AchievementStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_ACHIEVEMENTS, JSON.stringify(achievements));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'saveAchievements failed');
    }
  }

  // 解锁某个成就
  static unlockAchievement(context: common.UIAbilityContext, id: string): void {
    const achievements = AchievementStorage.loadAchievements(context);
    const item = achievements.find(a => a.id === id);
    if (item && !item.unlockedAt) {
      item.unlockedAt = formatDateTime(new Date());
      AchievementStorage.saveAchievements(context, achievements);
    }
  }

  // 记录一次答题结果（优化：合并 I/O，从 16 次全量读写降为 4 次）
  static recordQuizResult(
    context: common.UIAbilityContext,
    correctCount: number,
    wrongCount: number,
    score: number,
    maxStreakInQuiz: number,
    totalQuestions: number = 0
  ): void {
    // 1. 单次加载用户统计
    const stats = AchievementStorage.loadUserStats(context);
    stats.answeredCount += correctCount + wrongCount;
    stats.correctCount += correctCount;

    // 2. 内存中计算连续打卡（原 updateStreak 逻辑内联，避免重复 I/O）
    const today = todayString();
    if (stats.lastAnswerDate !== today) {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      const yesterdayStr = formatDate(yesterday);
      if (stats.lastAnswerDate === yesterdayStr) {
        stats.streakDays++;
      } else {
        stats.streakDays = 1;
      }
      stats.lastAnswerDate = today;
    }

    // 3. 单次保存用户统计
    AchievementStorage.saveUserStats(context, stats);

    // 4. 单次加载成就列表，内存中批量检查解锁，单次保存
    const achievements = AchievementStorage.loadAchievements(context);
    let changed = false;
    const tryUnlock = (id: string): void => {
      const item = achievements.find(a => a.id === id);
      if (item && !item.unlockedAt) {
        item.unlockedAt = formatDateTime(new Date());
        changed = true;
      }
    };
    if (correctCount + wrongCount > 0) {
      tryUnlock('first_quiz');
    }
    if (totalQuestions > 0 && correctCount === totalQuestions) {
      tryUnlock('perfect_100');
    }
    if (maxStreakInQuiz >= 10) {
      tryUnlock('streak_10');
    }
    if (stats.correctCount >= 50) {
      tryUnlock('answer_50');
    }
    if (stats.correctCount >= 100) {
      tryUnlock('answer_100');
    }
    if (stats.correctCount >= 500) {
      tryUnlock('answer_500');
    }
    // 仅在成就有变化时才保存，避免无谓 I/O
    if (changed) {
      AchievementStorage.saveAchievements(context, achievements);
    }
  }

  // 记录主题通关
  static recordTopicMastery(context: common.UIAbilityContext, topic: Topic): void {
    if (topic === Topic.KNOWLEDGE) {
      AchievementStorage.unlockAchievement(context, 'master_knowledge');
    } else if (topic === Topic.REASONING) {
      AchievementStorage.unlockAchievement(context, 'master_reasoning');
    } else if (topic === Topic.RIDDLE) {
      AchievementStorage.unlockAchievement(context, 'master_riddle');
    }
  }

  // 清空所有成就数据
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = AchievementStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'AchievementStorage', 'clearAll failed');
    }
  }
}
