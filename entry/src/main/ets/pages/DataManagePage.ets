import common from '@ohos.app.ability.common';
import { ProgressStorage } from '../data/ProgressStorage';
import { HistoryStorage } from '../data/HistoryStorage';
import { WrongBookStorage } from '../data/WrongBookStorage';
import { AchievementStorage } from '../data/AchievementStorage';
import { StatsStorage } from '../data/StatsStorage';
import { FavoriteStorage } from '../data/FavoriteStorage';
import { ThemeManager } from '../data/ThemeManager';
import { DailyStorage } from '../data/DailyStorage';
import { DataBackupManager } from '../data/DataBackupManager';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';

@Component
export struct DataManagePage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];

  @State showClearDialog: boolean = false
  @State showClearedDialog: boolean = false
  @State showExportDialog: boolean = false
  @State showExportResultDialog: boolean = false
  @State showImportDialog: boolean = false
  @State showImportResultDialog: boolean = false
  @State resultMessage: string = ''
  @State resultSuccess: boolean = false

  aboutToAppear() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  onThemeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  clearLocalData() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ProgressStorage.clearAll(context);
    HistoryStorage.clearAll(context);
    WrongBookStorage.clearAll(context);
    AchievementStorage.clearAll(context);
    StatsStorage.clearAll(context);
    FavoriteStorage.clearAll(context);
    DailyStorage.clearAll(context);
    ThemeManager.clearAll(context);
    this.themeIndex = 0;
    this.darkMode = false;
    this.theme = THEMES[0];
    this.showClearDialog = false;
    this.showClearedDialog = true;
    AppStorage.setOrCreate('dataClearedSignal', Date.now());
  }

  async doExport() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.showExportDialog = false;
    const success = await DataBackupManager.saveBackupToFile(context);
    this.resultSuccess = success;
    this.resultMessage = success ? '数据已成功导出到所选位置' : '导出失败，请重试';
    this.showExportResultDialog = true;
  }

  async doImport() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.showImportDialog = false;
    const fileContent = await DataBackupManager.selectBackupFile(context);
    if (!fileContent) {
      this.resultSuccess = false;
      this.resultMessage = '未选择文件或文件读取失败';
      this.showImportResultDialog = true;
      return;
    }
    const validation = DataBackupManager.validateBackupData(fileContent);
    if (!validation.valid || !validation.backup) {
      this.resultSuccess = false;
      this.resultMessage = validation.message;
      this.showImportResultDialog = true;
      return;
    }
    const success = DataBackupManager.importAllData(context, validation.backup);
    this.resultSuccess = success;
    this.resultMessage = success
      ? '数据已成功导入，请重启应用以刷新界面'
      : '导入失败，请重试';
    this.showImportResultDialog = true;

    if (success) {
      const tIndex = ThemeManager.getThemeIndex(context);
      const isDark = ThemeManager.isDarkMode(context);
      this.themeIndex = tIndex;
      this.darkMode = isDark;
      this.theme = this.darkMode ? (DARK_THEMES[tIndex] ?? DARK_THEMES[0]) : (THEMES[tIndex] ?? THEMES[0]);
    }
  }

  @Builder
  SettingItem(icon: string, title: string, subtitle: string, warn: boolean, onClick: () => void) {
    Row() {
      Text(icon)
        .fontSize(26)
        .margin({ right: 16 })

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(warn ? this.theme.error : this.theme.textPrimary)

        Text(subtitle)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('›')
        .fontSize(22)
        .fontColor(this.theme.textSecondary)
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .alignItems(VerticalAlign.Center)
    .shadow({
      radius: 8,
      color: this.theme.cardShadow,
      offsetX: 0,
      offsetY: 4
    })
    .stateStyles({
      pressed: { .scale({ x: 0.98, y: 0.98 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(onClick)
  }

  @Builder
  DialogOverlay(title: string, message: string, cancelText: string, confirmText: string,
    onCancel: () => void, onConfirm: () => void) {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => { })

      Column({ space: 16 }) {
        Text(title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        Text(message)
          .fontSize(14)
          .fontColor(this.theme.textPrimary)
          .textAlign(TextAlign.Center)

        Row({ space: 12 }) {
          if (cancelText) {
            Button(cancelText)
              .layoutWeight(1)
              .height(44)
              .fontSize(15)
              .fontColor(this.theme.textPrimary)
              .backgroundColor(this.theme.background)
              .borderRadius(22)
              .onClick(onCancel)
          }

          Button(confirmText)
            .layoutWeight(cancelText ? 1 : 0)
            .width(cancelText ? '100%' : '60%')
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.primary)
            .borderRadius(22)
            .onClick(onConfirm)
        }
        .width('100%')
        .justifyContent(cancelText ? FlexAlign.SpaceBetween : FlexAlign.Center)
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: this.theme.dialogShadow,
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  build() {
    Stack() {
      Column() {
        // 顶部标题区（渐变直接挂在 header Column 上，不用 position/zIndex hack）
        Column() {
          Row() {
            Text('←')
              .fontSize(28)
              .fontColor(this.theme.textOnPrimary)
              .width(44)
              .height(44)
              .textAlign(TextAlign.Center)
              .borderRadius(22)
              .backgroundColor(this.theme.glassBg)
              .onClick(() => {
                this.pageStack.pop();
              })

            Blank()

            Text('数据处理')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .margin({ right: 8 })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 12 })
          .alignItems(VerticalAlign.Center)

          Column() {
            Text('数据管理')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .textShadow({
                radius: 10,
                color: this.theme.cardShadow,
                offsetX: 0,
                offsetY: 4
              })
              .margin({ bottom: 8 })

            Text('导出、导入或清除本地数据')
              .fontSize(15)
              .fontColor(this.theme.textOnPrimaryMuted)
          }
          .width('100%')
          .padding({ top: 16, bottom: 20 })
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .padding({ top: 12, bottom: 20, left: 16, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[this.theme.primaryGradientStart, 0.0], [this.theme.primaryGradientEnd, 1.0]]
        })
        .borderRadius({ bottomLeft: 28, bottomRight: 28 })
        .shadow({
          radius: 12,
          color: this.theme.cardShadow,
          offsetX: 0,
          offsetY: 6
        })

        // 内容区（自然排在 header 下方，不用 Stack 重叠）
        Column({ space: 12 }) {
          this.SettingItem('📤', '导出数据', '备份答题记录到文件', false, () => {
            this.showExportDialog = true;
          })

          this.SettingItem('📥', '导入数据', '从备份文件恢复数据', false, () => {
            this.showImportDialog = true;
          })

          this.SettingItem('🧹', '清除数据', '清空所有本地记录', true, () => {
            this.showClearDialog = true;
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 20, bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)

      // 清除确认弹窗
      if (this.showClearDialog) {
        this.DialogOverlay(
          '清除本地数据',
          '确定要清空所有本地数据吗？这将清除答题进度、上次进度记录、答题历史、错题本、成就、收藏以及主题设置，且无法恢复。',
          '取消',
          '确定清除',
          (): void => {
            this.showClearDialog = false;
          },
          (): void => { this.clearLocalData(); }
        )
      }

      // 清除成功弹窗
      if (this.showClearedDialog) {
        this.DialogOverlay(
          '清除成功',
          '本地数据已清空。',
          '',
          '确定',
          (): void => {
            this.showClearedDialog = false;
          },
          (): void => {
            this.showClearedDialog = false;
          }
        )
      }

      // 导出确认弹窗
      if (this.showExportDialog) {
        this.DialogOverlay(
          '导出数据',
          '将答题记录、收藏、错题本、成就等所有数据导出为备份文件。',
          '取消',
          '导出',
          (): void => {
            this.showExportDialog = false;
          },
          (): void => { this.doExport(); }
        )
      }

      // 导出结果弹窗
      if (this.showExportResultDialog) {
        this.DialogOverlay(
          this.resultSuccess ? '导出成功' : '导出失败',
          this.resultMessage,
          '',
          '确定',
          (): void => {
            this.showExportResultDialog = false;
          },
          (): void => {
            this.showExportResultDialog = false;
          }
        )
      }

      // 导入确认弹窗
      if (this.showImportDialog) {
        this.DialogOverlay(
          '导入数据',
          '从备份文件恢复数据，当前数据将被覆盖。建议先导出备份。',
          '取消',
          '选择文件',
          (): void => {
            this.showImportDialog = false;
          },
          (): void => { this.doImport(); }
        )
      }

      // 导入结果弹窗
      if (this.showImportResultDialog) {
        this.DialogOverlay(
          this.resultSuccess ? '导入成功' : '导入失败',
          this.resultMessage,
          '',
          '确定',
          (): void => {
            this.showImportResultDialog = false;
          },
          (): void => {
            this.showImportResultDialog = false;
          }
        )
      }
    }
  }
}
