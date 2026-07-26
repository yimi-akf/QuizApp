import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { Difficulty, Topic } from '../model/Question';
import hilog from '@ohos.hilog';

export interface ProgressInfo {
  topic: Topic;
  difficulty: Difficulty | 'mixed';
  currentIndex: number;
  // 保存当前轮次的题目 ID 顺序，恢复时可保持题目顺序一致
  questionIds: number[];
  userAnswers: number[];
  selfAssessments: ('pending' | 'correct' | 'wrong')[];
  viewedAnswers: boolean[];
}

export interface LastProgressSummary {
  topic: Topic;
  difficulty: Difficulty | 'mixed';
  currentIndex: number;
  total: number;
}

const PREFERENCES_NAME = 'quiz_progress';
const KEY_PROGRESS_DATA = 'progress_data';
const KEY_LAST_PROGRESS = 'last_progress';
const KEY_LAST_HOME_MODULE = 'last_home_module';

// 本地偏好设置存储答题进度
export class ProgressStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'getPreferences failed');
      return null;
    }
  }

  private static progressKey(topic: Topic, difficulty: Difficulty | 'mixed'): string {
    return `progress_${topic}_${difficulty}`;
  }

  private static loadProgressMap(context: common.UIAbilityContext): Record<string, ProgressInfo> {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return {};
    }
    try {
      const value = prefs.getSync(KEY_PROGRESS_DATA, '') as string;
      if (!value) {
        return {};
      }
      const parsed = JSON.parse(value) as Record<string, ProgressInfo>;
      return parsed || {};
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'loadProgressMap failed');
      return {};
    }
  }

  private static saveProgressMap(context: common.UIAbilityContext, map: Record<string, ProgressInfo>): void {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_PROGRESS_DATA, JSON.stringify(map));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'saveProgressMap failed');
    }
  }

  // 保存某主题+难度的进度
  static saveProgress(context: common.UIAbilityContext, progress: ProgressInfo): void {
    const map = ProgressStorage.loadProgressMap(context);
    const key = ProgressStorage.progressKey(progress.topic, progress.difficulty);
    map[key] = progress;
    ProgressStorage.saveProgressMap(context, map);

    // 同时保存为最后一次进度摘要，用于首页显示
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      const summary: LastProgressSummary = {
        topic: progress.topic,
        difficulty: progress.difficulty,
        currentIndex: progress.currentIndex,
        total: progress.userAnswers.length
      };
      prefs.putSync(KEY_LAST_PROGRESS, JSON.stringify(summary));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'saveLastProgress failed');
    }
  }

  // 读取某主题+难度的进度
  static loadProgress(context: common.UIAbilityContext, topic: Topic, difficulty: Difficulty | 'mixed'): ProgressInfo | null {
    const map = ProgressStorage.loadProgressMap(context);
    const key = ProgressStorage.progressKey(topic, difficulty);
    return map[key] || null;
  }

  // 清除某主题+难度的进度
  static clearProgress(context: common.UIAbilityContext, topic: Topic, difficulty: Difficulty | 'mixed'): void {
    const map = ProgressStorage.loadProgressMap(context);
    const key = ProgressStorage.progressKey(topic, difficulty);
    const newMap: Record<string, ProgressInfo> = {};
    Object.keys(map).forEach(k => {
      if (k !== key) {
        newMap[k] = map[k];
      }
    });
    ProgressStorage.saveProgressMap(context, newMap);
  }

  // 读取最后一次进度摘要
  static loadLastProgress(context: common.UIAbilityContext): LastProgressSummary | null {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return null;
    }
    try {
      const value = prefs.getSync(KEY_LAST_PROGRESS, '') as string;
      if (!value) {
        return null;
      }
      return JSON.parse(value) as LastProgressSummary;
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'loadLastProgress failed');
      return null;
    }
  }

  // 清除最后一次进度摘要
  static clearLastProgress(context: common.UIAbilityContext): void {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.deleteSync(KEY_LAST_PROGRESS);
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'clearLastProgress failed');
    }
  }

  // 保存最近一次点击的首页功能模块
  static saveLastHomeModule(context: common.UIAbilityContext, module: string): void {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_LAST_HOME_MODULE, module);
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'saveLastHomeModule failed');
    }
  }

  // 读取最近一次点击的首页功能模块
  static loadLastHomeModule(context: common.UIAbilityContext): string {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return '';
    }
    try {
      return (prefs.getSync(KEY_LAST_HOME_MODULE, '') as string) || '';
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'loadLastHomeModule failed');
      return '';
    }
  }

  // 清空所有答题进度
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = ProgressStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ProgressStorage', 'clearAll failed');
    }
  }
}
