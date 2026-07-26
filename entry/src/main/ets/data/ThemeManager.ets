import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { AppTheme, DEFAULT_THEME_INDEX, THEMES } from '../model/AppTheme';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_theme';
const KEY_THEME_INDEX = 'theme_index';
const APP_STORAGE_THEME_KEY = 'quizThemeIndex';

// 主题管理器：负责读取和保存当前主题索引
export class ThemeManager {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'ThemeManager', 'getPreferences failed');
      return null;
    }
  }

  // 获取当前主题
  static getCurrentTheme(context: common.UIAbilityContext): AppTheme {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return THEMES[DEFAULT_THEME_INDEX];
    }
    try {
      const index = prefs.getSync(KEY_THEME_INDEX, DEFAULT_THEME_INDEX) as number;
      if (index >= 0 && index < THEMES.length) {
        return THEMES[index];
      }
      return THEMES[DEFAULT_THEME_INDEX];
    } catch (e) {
      hilog.error(0x0000, 'ThemeManager', 'getCurrentTheme failed');
      return THEMES[DEFAULT_THEME_INDEX];
    }
  }

  // 保存当前主题索引
  static setThemeIndex(context: common.UIAbilityContext, index: number): void {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      if (index >= 0 && index < THEMES.length) {
        prefs.putSync(KEY_THEME_INDEX, index);
        prefs.flushSync();
        AppStorage.setOrCreate(APP_STORAGE_THEME_KEY, index);
      }
    } catch (e) {
      hilog.error(0x0000, 'ThemeManager', 'setThemeIndex failed');
    }
  }

  // 将当前主题索引同步到 AppStorage，供跨页面监听
  static syncToAppStorage(context: common.UIAbilityContext): void {
    const index = ThemeManager.getThemeIndex(context);
    AppStorage.setOrCreate(APP_STORAGE_THEME_KEY, index);
  }

  // 获取当前主题索引
  static getThemeIndex(context: common.UIAbilityContext): number {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return DEFAULT_THEME_INDEX;
    }
    try {
      const index = prefs.getSync(KEY_THEME_INDEX, DEFAULT_THEME_INDEX) as number;
      if (index >= 0 && index < THEMES.length) {
        return index;
      }
      return DEFAULT_THEME_INDEX;
    } catch (e) {
      hilog.error(0x0000, 'ThemeManager', 'getThemeIndex failed');
      return DEFAULT_THEME_INDEX;
    }
  }

  // 清除主题设置
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'ThemeManager', 'clearAll failed');
    }
  }
}
