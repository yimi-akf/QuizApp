import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';

const PREFERENCES_NAME = 'quiz_app_settings';
const KEY_PRIVACY_AGREED = 'privacy_agreed';

// 隐私协议与用户设置本地存储
export class PrivacyStorage {
  private static getPreferences(context: common.UIAbilityContext): dataPreferences.Preferences | null {
    try {
      return dataPreferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
    } catch (e) {
      hilog.error(0x0000, 'PrivacyStorage', 'getPreferences failed');
      return null;
    }
  }

  // 保存用户已同意隐私政策
  static setPrivacyAgreed(context: common.UIAbilityContext, agreed: boolean): void {
    const prefs = PrivacyStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.putSync(KEY_PRIVACY_AGREED, agreed);
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'PrivacyStorage', 'setPrivacyAgreed failed');
    }
  }

  // 读取用户是否已同意隐私政策
  static isPrivacyAgreed(context: common.UIAbilityContext): boolean {
    const prefs = PrivacyStorage.getPreferences(context);
    if (!prefs) {
      return false;
    }
    try {
      return prefs.getSync(KEY_PRIVACY_AGREED, false) as boolean;
    } catch (e) {
      hilog.error(0x0000, 'PrivacyStorage', 'isPrivacyAgreed failed');
      return false;
    }
  }

  // 清空所有隐私相关偏好设置
  static clearAll(context: common.UIAbilityContext): void {
    const prefs = PrivacyStorage.getPreferences(context);
    if (!prefs) {
      return;
    }
    try {
      prefs.clearSync();
      prefs.flushSync();
    } catch (e) {
      hilog.error(0x0000, 'PrivacyStorage', 'clearAll failed');
    }
  }
}
