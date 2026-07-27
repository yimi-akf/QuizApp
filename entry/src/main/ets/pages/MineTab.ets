import common from '@ohos.app.ability.common';
import { ProgressStorage } from '../data/ProgressStorage';
import { PrivacyStorage } from '../data/PrivacyStorage';
import { HistoryStorage } from '../data/HistoryStorage';
import { WrongBookStorage } from '../data/WrongBookStorage';
import { AchievementStorage } from '../data/AchievementStorage';
import { StatsStorage } from '../data/StatsStorage';
import { FavoriteStorage } from '../data/FavoriteStorage';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES } from '../model/AppTheme';
import { PRIVACY_URL, APP_NAME, APP_VERSION, APP_DEVELOPER } from '../data/AppConstants';
import hilog from '@ohos.hilog';

// 我的标签内容
@Component
export struct MineTab {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State currentThemeName: string = THEMES[0].name;
  @State headerOpacity: number = 0;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 40;
  @StorageLink('mineTabShowTrigger') @Watch('onMineTabShow') mineTabShowTrigger: number = 0;

  @State showClearDialog: boolean = false
  @State showClearedDialog: boolean = false
  @State showAboutDialog: boolean = false
  @State showAnnouncementDialog: boolean = false
  @State showThemeDialog: boolean = false

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.currentThemeName = this.theme.name;
    this.playEntranceAnimation();
  }

  onPageShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.currentThemeName = this.theme.name;
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.currentThemeName = this.theme.name;
  }

  onMineTabShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.currentThemeName = this.theme.name;
  }

  playEntranceAnimation() {
    this.headerOpacity = 1;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  openPrivacyPolicy() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      context.startAbility({
        action: 'ohos.want.action.viewData',
        uri: PRIVACY_URL
      });
    } catch (e) {
      hilog.error(0x0000, 'MineTab', 'open privacy policy failed');
    }
  }

  changeTheme(index: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.setThemeIndex(context, index);
    this.themeIndex = index;
    this.theme = THEMES[index];
    this.currentThemeName = THEMES[index].name;
    this.showThemeDialog = false;
  }

  clearLocalData() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    PrivacyStorage.clearAll(context);
    ProgressStorage.clearAll(context);
    HistoryStorage.clearAll(context);
    WrongBookStorage.clearAll(context);
    AchievementStorage.clearAll(context);
    StatsStorage.clearAll(context);
    FavoriteStorage.clearAll(context);
    ThemeManager.clearAll(context);
    this.themeIndex = 0;
    this.theme = THEMES[0];
    this.currentThemeName = THEMES[0].name;
    this.showClearDialog = false;
    this.showClearedDialog = true;
  }

  onClearedConfirm() {
    this.showClearedDialog = false;
  }

  @Builder
  SettingItem(icon: string, title: string, subtitle: string, onClick: () => void) {
    Row() {
      Text(icon)
        .fontSize(26)
        .margin({ right: 16 })

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme.textPrimary)

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
        .backgroundColor('rgba(0,0,0,0.4)')
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
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
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
  AboutDialog() {
    Column() {
      Column() {
        Text('ℹ')
          .fontSize(48)
          .margin({ bottom: 12 })

        Text(`关于 ${APP_NAME}`)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)
          .margin({ bottom: 16 })

        Column({ space: 8 }) {
          this.AboutRow('应用名称', APP_NAME)
          this.AboutRow('版本号', `v${APP_VERSION}`)
          this.AboutRow('开发者', APP_DEVELOPER)
        }
        .width('100%')
        .margin({ bottom: 16 })

        Text('本应用为纯本地离线应用，不收集任何个人信息。')
          .fontSize(14)
          .fontColor(this.theme.textSecondary)
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 8 })

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
      .backgroundColor('#FFFFFF')
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
            this.AnnouncementItem('2. 快速响应：', `如你发现任何问题，或想给我们提建议，请随时发送邮件至：gr_qqemail@qq.com。我们会在3个工作日内尽力回复。`)
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
      .backgroundColor('#FFFFFF')
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

  build() {
    Stack() {
      Column() {
        // 顶部标题区
        Column() {
          Text('我的')
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
        .width('100%')
        .height(220)
        .justifyContent(FlexAlign.Center)
        .opacity(this.headerOpacity)
        .animation({ duration: 600, curve: Curve.EaseOut })
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
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

        // 设置项列表
        Column({ space: 12 }) {
          // 主题换肤项需要直接读取 currentThemeName，不能通过 @Builder 参数传递，否则状态变化不刷新
          Row() {
            Text('🎨')
              .fontSize(26)
              .margin({ right: 16 })

            Column() {
              Text('主题换肤')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.theme.textPrimary)

              Text(`当前：${this.currentThemeName}`)
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
          .stateStyles({
            pressed: { .scale({ x: 0.98, y: 0.98 }) },
            normal: { .scale({ x: 1, y: 1 }) }
          })
          .onClick(() => {
            this.showThemeDialog = true;
          })

          this.SettingItem('🧹', '清除数据', '清空所有本地记录', () => {
            this.showClearDialog = true;
          })

          this.SettingItem('🔒', '隐私政策', '查看用户协议与隐私政策', () => {
            this.openPrivacyPolicy();
          })

          this.SettingItem('📢', '公告', '致用户的一封信与反馈方式', () => {
            this.showAnnouncementDialog = true;
          })

          this.SettingItem('ℹ️', '关于', '应用名称、版本与开发者信息', () => {
            this.showAboutDialog = true;
          })

          Text(`${APP_NAME} v${APP_VERSION}`)
            .fontSize(12)
            .fontColor(this.theme.textSecondary)
            .margin({ top: 24 })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 20, right: 20, top: 20, bottom: 20 })
        .backgroundColor('#FFFFFF')
        .opacity(this.contentOpacity)
        .translate({ y: this.contentOffset })
        .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')

      // 主题选择弹窗
      if (this.showThemeDialog) {
        this.ThemeDialog()
      }

      // 清除确认弹窗
      if (this.showClearDialog) {
        this.DialogOverlay(
          '清除本地数据',
          '确定要清空所有本地数据吗？这将清除答题进度、上次进度记录、答题历史、错题本、成就、收藏、主题设置以及隐私协议同意状态，且无法恢复。',
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

      // 关于弹窗
      if (this.showAboutDialog) {
        this.AboutDialog()
      }

      // 公告弹窗
      if (this.showAnnouncementDialog) {
        this.AnnouncementDialog()
      }
    }
  }
}
