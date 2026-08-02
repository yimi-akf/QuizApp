import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { AppTheme, DEFAULT_THEME_INDEX, THEMES, DARK_THEMES } from '../model/AppTheme';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_theme';
const KEY_THEME_INDEX = 'theme_index';
const APP_STORAGE_THEME_KEY = 'quizThemeIndex';
const KEY_DARK_MODE = 'dark_mode';
const APP_STORAGE_DARK_KEY = 'quizDarkMode';

// 主题管理器：负责读取和保存当前主题索引
export class ThemeManager {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'getPreferences failed');
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
      const isDark = ThemeManager.isDarkMode(context);
      if (isDark) {
        if (index >= 0 && index < DARK_THEMES.length) {
          return DARK_THEMES[index];
        }
        return DARK_THEMES[DEFAULT_THEME_INDEX];
      }
      if (index >= 0 && index < THEMES.length) {
        return THEMES[index];
      }
      return THEMES[DEFAULT_THEME_INDEX];
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'getCurrentTheme failed');
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
      hilog.error(0x0001, 'ThemeManager', 'setThemeIndex failed');
    }
  }

  // 将当前主题索引和暗色模式状态同步到 AppStorage，供跨页面监听
  static syncToAppStorage(context: common.UIAbilityContext): void {
    const index = ThemeManager.getThemeIndex(context);
    AppStorage.setOrCreate(APP_STORAGE_THEME_KEY, index);
    const isDark = ThemeManager.isDarkMode(context);
    AppStorage.setOrCreate(APP_STORAGE_DARK_KEY, isDark);
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
      hilog.error(0x0001, 'ThemeManager', 'getThemeIndex failed');
      return DEFAULT_THEME_INDEX;
    }
  }

  // 清除所有主题和暗色模式设置
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'clearAll failed');
    }
  }

  // 检查是否为暗色模式
  static isDarkMode(context: common.UIAbilityContext): boolean {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return false;
    }
    try {
      return prefs.getSync(KEY_DARK_MODE, false) as boolean;
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'isDarkMode failed');
      return false;
    }
  }

  // 保存暗色模式偏好
  static saveDarkMode(context: common.UIAbilityContext, isDark: boolean): void {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_DARK_MODE, isDark);
      prefs.flushSync();
      AppStorage.setOrCreate(APP_STORAGE_DARK_KEY, isDark);
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'saveDarkMode failed');
    }
  }
}
