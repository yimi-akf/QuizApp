import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import { HistoryRecord } from './HistoryStorage';
import { Topic, Difficulty } from '../model/Question';

const PREFERENCES_NAME = 'quiz_stats';
const KEY_TOPIC_PROGRESS = 'topic_progress';

export interface TopicProgress {
  topic: string;
  entryCompleted: boolean;
  advancedCompleted: boolean;
  challengeCompleted: boolean;
}

export interface DailyStat {
  date: string;
  correct: number;
  total: number;
}

export interface QuizStats {
  totalQuizzes: number;
  totalQuestions: number;
  totalAnswered: number;   // 实际已答题数，作为总正确率的分母
  totalCorrect: number;
  averageScore: number;
  bestScore: number;
  totalTimeSeconds: number;
  topicProgress: TopicProgress[];
  dailyStats: DailyStat[];
}

// 统计看板本地存储与计算
export class StatsStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'StatsStorage', 'getPreferences failed');
      return null;
    }
  }

  // 读取主题通关进度
  static loadTopicProgress(context: common.UIAbilityContext): TopicProgress[] {
    const prefs = StatsStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_TOPIC_PROGRESS, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as TopicProgress[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed;
    } catch (e) {
      hilog.error(0x0000, 'StatsStorage', 'loadTopicProgress failed');
      return [];
    }
  }

  private static saveTopicProgress(context: common.UIAbilityContext, progress: TopicProgress[]): void {
    const prefs = StatsStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_TOPIC_PROGRESS, JSON.stringify(progress));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'StatsStorage', 'saveTopicProgress failed');
    }
  }

  // 标记某主题某难度已完成
  static markDifficultyCompleted(
    context: common.UIAbilityContext,
    topic: Topic,
    difficulty: Difficulty
  ): void {
    const progress = StatsStorage.loadTopicProgress(context);
    let item = progress.find(p => p.topic === topic);
    if (!item) {
      item = {
        topic,
        entryCompleted: false,
        advancedCompleted: false,
        challengeCompleted: false
      };
      progress.push(item);
    }
    if (difficulty === 'entry') {
      item.entryCompleted = true;
    } else if (difficulty === 'advanced') {
      item.advancedCompleted = true;
    } else if (difficulty === 'challenge') {
      item.challengeCompleted = true;
    }
    StatsStorage.saveTopicProgress(context, progress);
  }

  // 根据历史记录计算综合统计
  static computeStats(records: HistoryRecord[]): QuizStats {
    const totalQuizzes = records.length;
    let totalQuestions = 0;    // 累计出题总数
    let totalAnswered = 0;     // 累计实际已答题数（正确率分母）
    let totalCorrect = 0;
    let totalTimeSeconds = 0;
    let bestScore = 0;
    const dailyMap: Map<string, DailyStat> = new Map();

    records.forEach(r => {
      const answered = r.answeredCount ?? r.total;
      totalQuestions += r.total;
      totalAnswered += answered;
      totalCorrect += r.correctCount;
      totalTimeSeconds += r.elapsedSeconds;
      if (r.score > bestScore) {
        bestScore = r.score;
      }
      const date = r.date.split(' ')[0];
      const existing = dailyMap.get(date);
      if (existing) {
        existing.correct += r.correctCount;
        existing.total += answered;
      } else {
        dailyMap.set(date, { date, correct: r.correctCount, total: answered });
      }
    });

    const averageScore = totalQuizzes > 0
      ? Math.round(records.reduce((sum, r) => sum + r.score, 0) / totalQuizzes)
      : 0;

    const dailyStats = Array.from(dailyMap.values()).sort((a, b) => a.date.localeCompare(b.date));

    return {
      totalQuizzes,
      totalQuestions,
      totalAnswered,
      totalCorrect,
      averageScore,
      bestScore,
      totalTimeSeconds,
      topicProgress: [],
      dailyStats
    };
  }

  // 清空统计数据
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = StatsStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'StatsStorage', 'clearAll failed');
    }
  }
}
