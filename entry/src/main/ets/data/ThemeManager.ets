import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { AppTheme, DEFAULT_THEME_INDEX, THEMES, DARK_THEMES } from '../model/AppTheme';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_theme';
const KEY_THEME_INDEX = 'theme_index';
const APP_STORAGE_THEME_KEY = 'quizThemeIndex';
const KEY_DARK_MODE_SETTING = 'dark_mode_setting'; // 'system' | 'light' | 'dark'
const APP_STORAGE_DARK_KEY = 'quizDarkMode'; // 实际生效的深色状态 boolean
const APP_STORAGE_DARK_SETTING_KEY = 'quizDarkModeSetting'; // 用户设置的模式 string

// 深色模式设置类型
export type DarkModeSetting = 'system' | 'light' | 'dark';

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

  // 将当前主题索引和深色模式状态同步到 AppStorage
  static syncToAppStorage(context: common.UIAbilityContext): void {
    const index = ThemeManager.getThemeIndex(context);
    AppStorage.setOrCreate(APP_STORAGE_THEME_KEY, index);
    const setting = ThemeManager.getDarkModeSetting(context);
    AppStorage.setOrCreate(APP_STORAGE_DARK_SETTING_KEY, setting);
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

  // 获取深色模式设置（'system' | 'light' | 'dark'）
  static getDarkModeSetting(context: common.UIAbilityContext): DarkModeSetting {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return 'system';
    }
    try {
      const value = prefs.getSync(KEY_DARK_MODE_SETTING, 'system') as string;
      if (value === 'light' || value === 'dark' || value === 'system') {
        return value as DarkModeSetting;
      }
      return 'system';
    } catch (e) {
      return 'system';
    }
  }

  // 保存深色模式设置
  static saveDarkModeSetting(context: common.UIAbilityContext, setting: DarkModeSetting): void {
    const prefs = ThemeManager.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_DARK_MODE_SETTING, setting);
      prefs.flushSync();
      AppStorage.setOrCreate(APP_STORAGE_DARK_SETTING_KEY, setting);
    } catch (e) {
      hilog.error(0x0001, 'ThemeManager', 'saveDarkModeSetting failed');
    }
  }

  // 检查是否为暗色模式（根据设置和系统状态计算实际是否深色）
  static isDarkMode(context: common.UIAbilityContext): boolean {
    const setting = ThemeManager.getDarkModeSetting(context);
    if (setting === 'dark') {
      return true;
    }
    if (setting === 'light') {
      return false;
    }
    // system: 跟随系统
    return ThemeManager.isSystemDarkMode(context);
  }

  // 读取系统当前是否深色模式
  // 从 AppStorage 读取由 EntryAbility 记录的系统深色模式状态
  static isSystemDarkMode(context: common.UIAbilityContext): boolean {
    try {
      const value = AppStorage.get<boolean>('systemDarkMode');
      if (value !== undefined && value !== null) {
        return value;
      }
    } catch (e) {
      // ignore
    }
    // 回退：读取 context.config
    try {
      const config = context.config;
      if (config && config.colorMode !== undefined) {
        return config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      }
    } catch (e) {
      // ignore
    }
    return false;
  }
}