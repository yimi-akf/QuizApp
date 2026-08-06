import { AbilityConstant, ConfigurationConstant, UIAbility, Want, Configuration } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { ThemeManager } from '../data/ThemeManager';

const DOMAIN = 0x0001;
const TAG = 'QuizApp';

export default class EntryAbility extends UIAbility {
  private isApplyingColorMode: boolean = false;
  // 缓存深色模式设置，避免每次 onConfigurationUpdate 都读 Preferences（磁盘IO）
  private cachedSetting: string = 'system';

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 初始化缓存
    this.cachedSetting = ThemeManager.getDarkModeSetting(this.context);
    this.applyDarkMode();
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
  }

  // 系统配置变化回调（深色模式切换、语言切换等）
  onConfigurationUpdate(newConfig: Configuration): void {
    hilog.info(DOMAIN, TAG, 'onConfigurationUpdate: colorMode=%{public}d', newConfig.colorMode);
    if (this.isApplyingColorMode) {
      return;
    }
    // 用缓存判断，避免磁盘IO导致的延迟
    if (this.cachedSetting === 'system') {
      const isDark = newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      AppStorage.setOrCreate('systemDarkMode', isDark);
      AppStorage.setOrCreate('quizDarkMode', isDark);
      hilog.info(DOMAIN, TAG, 'onConfigurationUpdate applied: isDark=%{public}s', String(isDark));
    }
  }

  // 应用回到前台时重新检查
  onForeground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
    // 重新读取设置（用户可能清除过数据）
    this.cachedSetting = ThemeManager.getDarkModeSetting(this.context);
    this.applyDarkMode();
  }

  // 根据用户设置应用深色模式
  private applyDarkMode(): void {
    this.isApplyingColorMode = true;
    try {
      const setting = this.cachedSetting;
      let isDark: boolean;

      if (setting === 'dark') {
        isDark = true;
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      } else if (setting === 'light') {
        isDark = false;
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
      } else {
        // system: 设为 NOT_SET 让系统管理
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
        const config = this.context.config;
        isDark = !!(config && config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
        AppStorage.setOrCreate('systemDarkMode', isDark);
      }

      // 同步到 AppStorage
      AppStorage.setOrCreate('quizDarkMode', isDark);
      AppStorage.setOrCreate('quizDarkModeSetting', setting);

      hilog.info(DOMAIN, TAG, 'applyDarkMode: setting=%{public}s, isDark=%{public}s', setting, String(isDark));
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'applyDarkMode failed: %{public}s', JSON.stringify(err));
    } finally {
      this.isApplyingColorMode = false;
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }
}
