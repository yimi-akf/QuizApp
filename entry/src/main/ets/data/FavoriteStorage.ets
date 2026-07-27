import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_favorite';
const KEY_FAVORITES = 'favorite_questions';
const KEY_GROUPS = 'favorite_groups';
const GROUP_DEFAULT_ID = 0;

export interface FavoriteRecord {
  questionId: number;
  addedAt: string;
  groupId: number;
}

export interface FavoriteGroup {
  id: number;
  name: string;
  createdAt: string;
}

// 收藏题目本地存储
export class FavoriteStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'getPreferences failed');
      return null;
    }
  }

  // 读取所有收藏记录
  static loadRecords(context: common.UIAbilityContext): FavoriteRecord[] {
    const prefs = FavoriteStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_FAVORITES, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as FavoriteRecord[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      // 兼容旧数据：为没有 groupId 的记录补上默认分组
      return parsed.map(r => {
        if (r.groupId === undefined) {
          return {
            questionId: r.questionId,
            addedAt: r.addedAt,
            groupId: GROUP_DEFAULT_ID
          } as FavoriteRecord;
        }
        return r;
      });
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'loadRecords failed');
      return [];
    }
  }

  // 保存所有收藏记录
  private static saveRecords(context: common.UIAbilityContext, records: FavoriteRecord[]): void {
    const prefs = FavoriteStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_FAVORITES, JSON.stringify(records));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'saveRecords failed');
    }
  }

  // 判断题目是否已收藏
  static isFavorite(context: common.UIAbilityContext, questionId: number): boolean {
    const records = FavoriteStorage.loadRecords(context);
    return records.some(r => r.questionId === questionId);
  }

  // 添加收藏
  static addFavorite(context: common.UIAbilityContext, questionId: number): void {
    const records = FavoriteStorage.loadRecords(context);
    if (records.some(r => r.questionId === questionId)) {
      return;
    }
    records.unshift({
      questionId,
      addedAt: new Date().toISOString(),
      groupId: GROUP_DEFAULT_ID
    });
    FavoriteStorage.saveRecords(context, records);
  }

  // 取消收藏
  static removeFavorite(context: common.UIAbilityContext, questionId: number): void {
    const records = FavoriteStorage.loadRecords(context);
    const filtered = records.filter(r => r.questionId !== questionId);
    FavoriteStorage.saveRecords(context, filtered);
  }

  // 切换收藏状态（优化：单次 load + 单次 save，避免三重全量读写）
  static toggleFavorite(context: common.UIAbilityContext, questionId: number): boolean {
    const records = FavoriteStorage.loadRecords(context);
    const existing = records.find(r => r.questionId === questionId);
    if (existing) {
      // 已收藏 → 取消
      const filtered = records.filter(r => r.questionId !== questionId);
      FavoriteStorage.saveRecords(context, filtered);
      return false;
    } else {
      // 未收藏 → 添加
      records.unshift({
        questionId,
        addedAt: new Date().toISOString(),
        groupId: GROUP_DEFAULT_ID
      });
      FavoriteStorage.saveRecords(context, records);
      return true;
    }
  }

  // 获取收藏的题目 ID 列表
  static getFavoriteQuestionIds(context: common.UIAbilityContext): number[] {
    const records = FavoriteStorage.loadRecords(context);
    return records.map(r => r.questionId);
  }

  // 清空收藏
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = FavoriteStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'clearAll failed');
    }
  }

  // ============ 分组管理 ============

  // 读取所有分组
  static loadGroups(context: common.UIAbilityContext): FavoriteGroup[] {
    const prefs = FavoriteStorage.getPreferences(context);
    if (!prefs) {
      return [];
    }
    try {
      const value = prefs.getSync(KEY_GROUPS, '') as string;
      if (!value) {
        return [];
      }
      const parsed = JSON.parse(value) as FavoriteGroup[];
      if (!Array.isArray(parsed)) {
        return [];
      }
      return parsed;
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'loadGroups failed');
      return [];
    }
  }

  // 保存分组列表
  private static saveGroups(context: common.UIAbilityContext, groups: FavoriteGroup[]): void {
    const prefs = FavoriteStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_GROUPS, JSON.stringify(groups));
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'FavoriteStorage', 'saveGroups failed');
    }
  }

  // 创建分组
  static createGroup(context: common.UIAbilityContext, name: string): FavoriteGroup | null {
    const groups = FavoriteStorage.loadGroups(context);
    const trimmedName = name.trim();
    if (!trimmedName) {
      return null;
    }
    const newGroup: FavoriteGroup = {
      id: Date.now(),
      name: trimmedName,
      createdAt: new Date().toISOString()
    };
    groups.push(newGroup);
    FavoriteStorage.saveGroups(context, groups);
    return newGroup;
  }

  // 删除分组（分组内的收藏移回默认分组）
  static deleteGroup(context: common.UIAbilityContext, groupId: number): void {
    if (groupId === GROUP_DEFAULT_ID) {
      return;
    }
    const groups = FavoriteStorage.loadGroups(context);
    const filtered = groups.filter(g => g.id !== groupId);
    FavoriteStorage.saveGroups(context, filtered);

    // 将该分组下的收藏移回默认分组
    const records = FavoriteStorage.loadRecords(context);
    const updated = records.map(r => {
      if (r.groupId === groupId) {
        return {
          questionId: r.questionId,
          addedAt: r.addedAt,
          groupId: GROUP_DEFAULT_ID
        } as FavoriteRecord;
      }
      return r;
    });
    FavoriteStorage.saveRecords(context, updated);
  }

  // 重命名分组
  static renameGroup(context: common.UIAbilityContext, groupId: number, newName: string): void {
    const groups = FavoriteStorage.loadGroups(context);
    const trimmedName = newName.trim();
    if (!trimmedName) {
      return;
    }
    const group = groups.find(g => g.id === groupId);
    if (group) {
      group.name = trimmedName;
      FavoriteStorage.saveGroups(context, groups);
    }
  }

  // 将收藏题目移动到指定分组
  static moveToGroup(context: common.UIAbilityContext, questionId: number, groupId: number): void {
    const records = FavoriteStorage.loadRecords(context);
    const record = records.find(r => r.questionId === questionId);
    if (record) {
      record.groupId = groupId;
      FavoriteStorage.saveRecords(context, records);
    }
  }

  // 获取默认分组 ID
  static getDefaultGroupId(): number {
    return GROUP_DEFAULT_ID;
  }
}
