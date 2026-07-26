import common from '@ohos.app.ability.common';
import { ProgressStorage } from '../data/ProgressStorage';
import { PrivacyStorage } from '../data/PrivacyStorage';
import { HistoryStorage } from '../data/HistoryStorage';
import { WrongBookStorage } from '../data/WrongBookStorage';
import { AchievementStorage } from '../data/AchievementStorage';
import { StatsStorage } from '../data/StatsStorage';
import { FavoriteStorage } from '../data/FavoriteStorage';
import { QuestionFeedbackStorage } from '../data/QuestionFeedbackStorage';
import { DataBackupManager } from '../data/DataBackupManager';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES } from '../model/AppTheme';
import { PRIVACY_URL, APP_NAME, APP_VERSION, APP_DEVELOPER } from '../data/AppConstants';
import hilog from '@ohos.hilog';

// 设置页：主题切换、本地数据清理、隐私政策、关于
@Component
export struct SettingsPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];

  // 入场动画状态
  @State headerOpacity: number = 0
  @State headerOffset: number = -30
  @State itemsOpacity: number = 0
  @State itemsOffset: number = 40
  @State footerOpacity: number = 0

  // 弹窗状态
  @State showClearDialog: boolean = false
  @State showClearedDialog: boolean = false
  @State showAboutDialog: boolean = false
  @State showAnnouncementDialog: boolean = false
  @State showThemeDialog: boolean = false

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.headerOpacity = 1
    this.headerOffset = 0
    this.itemsOpacity = 1
    this.itemsOffset = 0
    this.footerOpacity = 1
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  // 返回上一页
  goBack() {
    try {
      this.pageStack.pop();
    } catch (e) {
      hilog.error(0x0000, 'SettingsPage', 'pop failed');
    }
  }

  // 在浏览器中打开隐私政策链接
  openPrivacyPolicy() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      context.startAbility({
        action: 'ohos.want.action.viewData',
        uri: PRIVACY_URL
      });
    } catch (e) {
      hilog.error(0x0000, 'SettingsPage', 'open privacy policy failed');
    }
  }

  // 切换主题
  changeTheme(index: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.setThemeIndex(context, index);
    this.themeIndex = index;
    this.theme = THEMES[index];
    this.showThemeDialog = false;
  }

  // 清空本地数据
  clearLocalData() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    PrivacyStorage.clearAll(context);
    ProgressStorage.clearAll(context);
    HistoryStorage.clearAll(context);
    WrongBookStorage.clearAll(context);
    AchievementStorage.clearAll(context);
    StatsStorage.clearAll(context);
    FavoriteStorage.clearAll(context);
    QuestionFeedbackStorage.clearAll(context);
    DataBackupManager.clearAllBackups(context);
    ThemeManager.clearAll(context);
    this.themeIndex = 0;
    this.theme = THEMES[0];
    this.showClearDialog = false;
    this.showClearedDialog = true;
  }

  // 清除完成，返回首页
  onClearedConfirm() {
    this.showClearedDialog = false;
    setTimeout((): void => {
      try {
        this.pageStack.clear();
      } catch (e) {
        hilog.error(0x0000, 'SettingsPage', 'clear stack failed');
      }
    }, 50);
  }

  build() {
    Stack() {
      Column() {
        // 顶部标题区
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            Text('设置')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .textShadow({
                radius: 10,
                color: 'rgba(0,0,0,0.15)',
                offsetX: 0,
                offsetY: 4
              })
              .margin({ bottom: 8 })

            Text('应用偏好与信息')
              .fontSize(15)
              .fontColor('rgba(255,255,255,0.85)')
          }
          .alignItems(HorizontalAlign.Center)

          Column() {
            Row() {
              Text('←')
                .fontSize(28)
                .fontColor(this.theme.textOnPrimary)
                .width(44)
                .height(44)
                .textAlign(TextAlign.Center)
                .borderRadius(22)
                .backgroundColor('rgba(255,255,255,0.15)')
                .onClick(() => this.goBack())

              Blank()

              Text('⚙')
                .fontSize(24)
                .fontColor(this.theme.textOnPrimary)
                .opacity(0.7)
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 8 })
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
        }
        .width('100%')
        .height(220)
        .opacity(this.headerOpacity)
        .translate({ y: this.headerOffset })
        .animation({
          duration: 600,
          curve: Curve.EaseOut
        })
        .linearGradient({
          angle: 135,
          colors: [[this.theme.primaryGradientStart, 0.0], [this.theme.primaryGradientEnd, 1.0]]
        })
        .borderRadius({ bottomLeft: 28, bottomRight: 28 })
        .shadow({
          radius: 12,
          color: 'rgba(0,0,0,0.12)',
          offsetX: 0,
          offsetY: 6
        })

        // 设置项列表
        Column({ space: 12 }) {
          this.SettingsItem('🎨', '主题换肤', `当前：${this.theme.name}`, () => {
            this.showThemeDialog = true;
          })

          this.SettingsItem('🗑', '清除本地数据', '清空答题进度与所有本地记录', () => {
            this.showClearDialog = true;
          })

          this.SettingsItem('📋', '隐私政策', '查看完整隐私政策条款', () => {
            this.openPrivacyPolicy();
          })

          this.SettingsItem('📢', '公告', '致用户的一封信与反馈方式', () => {
            this.showAnnouncementDialog = true;
          })

          this.SettingsItem('ℹ', '关于', '应用名称、版本与开发者信息', () => {
            this.showAboutDialog = true;
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 24, right: 24, top: 28, bottom: 12 })
        .backgroundColor(this.theme.background)
        .opacity(this.itemsOpacity)
        .translate({ y: this.itemsOffset })
        .animation({
          duration: 600,
          curve: Curve.EaseOut,
          delay: 150
        })

        // 底部版本信息
        Column() {
          Text(`${APP_NAME} v${APP_VERSION}`)
            .fontSize(13)
            .fontColor(this.theme.textSecondary)
        }
        .width('100%')
        .padding({ bottom: 24 })
        .opacity(this.footerOpacity)
        .animation({
          duration: 500,
          curve: Curve.EaseOut,
          delay: 300
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)

      // 主题选择弹窗
      if (this.showThemeDialog) {
        this.ThemeDialog()
      }

      // 清除确认弹窗
      if (this.showClearDialog) {
        this.DialogOverlay(
          '清除本地数据',
          '确定要清空所有本地数据吗？这将清除答题进度、上次进度记录、错题本、成就、收藏、主题设置以及隐私协议同意状态，且无法恢复。',
          '取消',
          '确定清除',
          (): void => {
            this.showClearDialog = false;
          },
          (): void => this.clearLocalData()
        )
      }

      // 清除成功弹窗
      if (this.showClearedDialog) {
        this.DialogOverlay(
          '清除成功',
          '本地数据已清空，应用将返回首页。',
          '',
          '确定',
          (): void => {
          },
          (): void => this.onClearedConfirm()
        )
      }

      // 公告弹窗
      if (this.showAnnouncementDialog) {
        this.AnnouncementDialog()
      }

      // 关于弹窗
      if (this.showAboutDialog) {
        this.AboutDialog()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SettingsItem(icon: string, title: string, desc: string, onClick: () => void) {
    Row() {
      Text(icon)
        .fontSize(26)
        .margin({ right: 14 })

      Column() {
        Text(title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textPrimary)

        Text(desc)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('›')
        .fontSize(24)
        .fontColor(this.theme.divider)
        .margin({ right: 4 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 4
    })
    .stateStyles({
      pressed: {
        .scale({ x: 0.98, y: 0.98 })
      },
      normal: {
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(onClick)
  }

  @Builder
  ThemeDialog() {
    Column() {
      Column() {
        Text('🎨')
          .fontSize(40)
          .margin({ bottom: 12 })

        Text('选择主题')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textPrimary)
          .margin({ bottom: 16 })

        Column({ space: 12 }) {
          ForEach(THEMES, (item: AppTheme, index: number) => {
            Row() {
              Row()
                .width(24)
                .height(24)
                .borderRadius(12)
                .backgroundColor(item.primary)
                .margin({ right: 12 })

              Column() {
                Text(item.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.theme.textPrimary)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              if (this.theme.name === item.name) {
                Text('✓')
                  .fontSize(22)
                  .fontColor(this.theme.primary)
                  .fontWeight(FontWeight.Bold)
              }
            }
            .width('100%')
            .padding(14)
            .backgroundColor(this.theme.name === item.name ? `${this.theme.primary}14` : this.theme.background)
            .borderRadius(12)
            .stateStyles({
              pressed: { .scale({ x: 0.98, y: 0.98 }) },
              normal: { .scale({ x: 1, y: 1 }) }
            })
            .onClick(() => this.changeTheme(index))
          }, (item: AppTheme) => item.name)
        }
        .width('100%')

        Button('取消')
          .width('60%')
          .height(44)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.background)
          .fontColor(this.theme.textPrimary)
          .borderRadius(22)
          .margin({ top: 16 })
          .onClick(() => {
            this.showThemeDialog = false;
          })
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 })),
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      ))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0,0,0,0.5)')
  }

  @Builder
  DialogOverlay(title: string, message: string, cancelText: string, confirmText: string, onCancel: () => void,
    onConfirm: () => void) {
    Column() {
      Column() {
        Text(title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)
          .margin({ bottom: 12 })

        Text(message)
          .fontSize(14)
          .fontColor(this.theme.textPrimary)
          .width('100%')
          .lineHeight(22)
          .margin({ bottom: 20 })

        Row({ space: 12 }) {
          if (cancelText) {
            Button(cancelText)
              .layoutWeight(1)
              .height(44)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.theme.background)
              .fontColor(this.theme.textSecondary)
              .borderRadius(22)
              .onClick(onCancel)
          }

          Button(confirmText)
            .layoutWeight(cancelText ? 1 : 0)
            .width(cancelText ? '100%' : '60%')
            .height(44)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(this.theme.primary)
            .fontColor(this.theme.textOnPrimary)
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
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
      .scale({ x: 1, y: 1 })
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 })),
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      ))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0,0,0,0.5)')
    .onClick(() => {
      // 点击遮罩不关闭，仅作为占位
    })
  }

  @Builder
  AnnouncementDialog() {
    Column() {
      Column() {
        Text('📢')
          .fontSize(40)
          .margin({ bottom: 12 })

        Text('致亲爱的用户')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)
          .margin({ bottom: 12 })

        Scroll() {
          Column({ space: 12 }) {
            Text('欢迎使用我们的App！这是一款以轻松娱乐为主的小工具，希望能在闲暇时为你带来一点乐趣。')
              .fontSize(14)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .lineHeight(22)

            Text('我们深知，问答内容的准确性和合理性对体验至关重要。由于题库仍在不断完善中，部分题目可能存在表述不严谨或争议。对此，我们真诚致歉，并承诺：')
              .fontSize(14)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .lineHeight(22)

            this.AnnouncementItem('1. 持续优化：', '我们会不断更新题库，修正或移除有问题的题目，并持续补充优质内容。')
            this.AnnouncementItem('2. 快速响应：', '如你发现任何问题，或想给我们提建议，请随时发送邮件至：gr_qqemail@qq.com。我们会在3个工作日内尽力回复。')
            this.AnnouncementItem('3. 欢迎投稿：', '如果你有好的原创题目，也欢迎发送邮件投稿。一经采纳，我们会在题库中注明你的贡献（如你愿意）。')

            Text('你的每一条反馈，都是我们进步的动力。感谢你的理解与支持！')
              .fontSize(14)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .lineHeight(22)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .margin({ bottom: 16 })

        Button('知道了')
          .width('60%')
          .height(44)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.primary)
          .fontColor(this.theme.textOnPrimary)
          .borderRadius(22)
          .onClick(() => {
            this.showAnnouncementDialog = false;
          })
      }
      .width('85%')
      .height('75%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 })),
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      ))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0,0,0,0.5)')
  }

  @Builder
  AboutDialog() {
    Column() {
      Column() {
        Text('ℹ')
          .fontSize(48)
          .margin({ bottom: 12 })

        Text(APP_NAME)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)
          .margin({ bottom: 16 })

        Column({ space: 8 }) {
          this.AboutRow('版本', APP_VERSION)
          this.AboutRow('开发者', APP_DEVELOPER)
          this.AboutRow('简介', '知识 · 推理 · 脑筋急转弯')
        }
        .width('100%')
        .margin({ bottom: 20 })

        Button('知道了')
          .width('60%')
          .height(44)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.primary)
          .fontColor(this.theme.textOnPrimary)
          .borderRadius(22)
          .onClick(() => {
            this.showAboutDialog = false;
          })
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 })),
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      ))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0,0,0,0.5)')
  }

  @Builder
  AboutRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor(this.theme.textSecondary)
        .width(70)

      Text(value)
        .fontSize(14)
        .fontColor(this.theme.textPrimary)
        .layoutWeight(1)
    }
    .width('100%')
  }

  @Builder
  AnnouncementItem(prefix: string, content: string) {
    Row() {
      Text(prefix)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme.textPrimary)

      Text(content)
        .fontSize(14)
        .fontColor(this.theme.textPrimary)
        .layoutWeight(1)
        .lineHeight(22)
    }
    .width('100%')
  }
}
