import { hilog } from '@kit.PerformanceAnalysisKit';
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

const DOMAIN = 0x0001;
const TAG = 'QuizApp';

export default class EntryBackupAbility extends BackupExtensionAbility {
  onBackup() {
    hilog.info(DOMAIN, TAG, 'onBackup ok');
  }

  onRestore(bundleVersion: BundleVersion) {
    hilog.info(DOMAIN, TAG, 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
  }
}