import common from '@ohos.app.ability.common';
import { HistoryRecord, HistoryStorage } from '../data/HistoryStorage';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { topicLabel, difficultyLabel, formatTime, difficultyColor, difficultyTagBgColor } from '../utils/FormatUtil';
import { popSafe } from '../utils/NavUtil';

// 答题历史页：展示历史答题记录列表
@Component
export struct HistoryPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];
  @State records: HistoryRecord[] = []
  @State showClearDialog: boolean = false
  // 入场动画状态
  @State headerOpacity: number = 0
  @State headerOffset: number = -30
  @State listOpacity: number = 0
  @State listOffset: number = 40
  @State footerOpacity: number = 0
  // 监听来自 NavDestination.onBackPressed 的信号
  @StorageLink('historyPageBackPress') @Watch('onBackPressSignal') backPressSignal: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadRecords()
    this.headerOpacity = 1
    this.headerOffset = 0
    this.listOpacity = 1
    this.listOffset = 0
    this.footerOpacity = 1
  }

  onThemeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  onPageShow() {
    this.loadRecords()
  }

  loadRecords() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext
    this.records = HistoryStorage.loadRecords(context)
  }

  goBack() {
    popSafe(this.pageStack)
  }

  clearHistory() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext
    HistoryStorage.clearRecords(context)
    this.records = []
    this.showClearDialog = false
  }

  // 系统返回键拦截：弹窗打开时优先关闭弹窗，而非退出页面
  onBackPress(): boolean {
    if (this.showClearDialog) {
      this.showClearDialog = false
      return true
    }
    return false
  }

  // NavDestination.onBackPressed 信号处理：弹窗打开时关闭弹窗并拦截返回
  onBackPressSignal() {
    if (this.showClearDialog) {
      this.showClearDialog = false;
      AppStorage.setOrCreate('historyPageBackPressHandled', Date.now());
    }
  }

  build() {
    Stack() {
      Column() {
        // 顶部标题区
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
              .onClick(() => this.goBack())

            Blank()

            Text('📜')
              .fontSize(24)
              .fontColor(this.theme.textOnPrimary)
              .opacity(0.7)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 12 })
          .alignItems(VerticalAlign.Center)

          Column() {
            Text('答题历史')
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

            Text(`共 ${this.records.length} 条记录`)
              .fontSize(15)
              .fontColor(this.theme.textOnPrimaryMuted)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
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
          color: this.theme.cardShadow,
          offsetX: 0,
          offsetY: 6
        })

        // 历史记录列表或空状态
        if (this.records.length === 0) {
          Column() {
            Text('📝')
              .fontSize(64)
              .margin({ bottom: 16 })

            Text('暂无答题记录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textSecondary)
              .margin({ bottom: 8 })

            Text('完成一整局答题（答完所有题目并查看结果）后，\n本次成绩会自动记录到这里')
              .fontSize(14)
              .fontColor(this.theme.textSecondary)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .opacity(this.listOpacity)
          .translate({ y: this.listOffset })
          .animation({
            duration: 600,
            curve: Curve.EaseOut,
            delay: 150
          })
        } else {
          Scroll() {
            Column({ space: 12 }) {
              ForEach(this.records, (record: HistoryRecord, index: number) => {
                this.HistoryItem(record)
              }, (record: HistoryRecord) => record.id.toString())
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 20, bottom: 12 })
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .align(Alignment.Top)
          .opacity(this.listOpacity)
          .translate({ y: this.listOffset })
          .animation({
            duration: 600,
            curve: Curve.EaseOut,
            delay: 150
          })
        }

        // 底部清空历史按钮
        if (this.records.length > 0) {
          Button('清空历史')
            .width('90%')
            .height(52)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(this.theme.error)
            .fontColor(this.theme.textOnPrimary)
            .borderRadius(26)
            .margin({ bottom: 24 })
            .stateStyles({
              pressed: { .scale({ x: 0.97, y: 0.97 }) },
              normal: { .scale({ x: 1, y: 1 }) }
            })
            .opacity(this.footerOpacity)
            .animation({
              duration: 500,
              curve: Curve.EaseOut,
              delay: 300
            })
            .onClick(() => {
              this.showClearDialog = true;
            })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)

      // 清除确认弹窗
      if (this.showClearDialog) {
        Column() {
          Column() {
            Text('清空历史')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.primary)
              .margin({ bottom: 12 })

            Text('确定要清空所有答题历史记录吗？此操作无法恢复。')
              .fontSize(14)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .lineHeight(22)
              .margin({ bottom: 20 })

            Row({ space: 12 }) {
              Button('取消')
                .layoutWeight(1)
                .height(44)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .backgroundColor(this.theme.background)
                .fontColor(this.theme.textSecondary)
                .borderRadius(22)
                .onClick(() => {
                  this.showClearDialog = false;
                })

              Button('确定')
                .layoutWeight(1)
                .height(44)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .backgroundColor(this.theme.error)
                .fontColor(this.theme.textOnPrimary)
                .borderRadius(22)
                .onClick(() => this.clearHistory())
            }
            .width('100%')
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
          .transition(TransitionEffect.asymmetric(
            TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 })),
            TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
          ))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.theme.overlayScrim)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HistoryItem(record: HistoryRecord) {
    Row() {
      Column() {
        Row() {
          Text(topicLabel(record.topic))
            .fontSize(14)
            .fontColor(this.theme.textPrimary)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)

          Text(difficultyLabel(record.difficulty))
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(difficultyColor(this.theme, record.difficulty))
            .padding({ left: 10, right: 10, top: 3, bottom: 3 })
            .backgroundColor(difficultyTagBgColor(record.difficulty, this.theme))
            .borderRadius(10)
        }
        .width('100%')
        .margin({ bottom: 8 })

        Row() {
          Text(`得分 ${record.score}`)
            .fontSize(15)
            .fontColor(this.theme.primary)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)

          Text(`用时 ${formatTime(record.elapsedSeconds)}`)
            .fontSize(13)
            .fontColor(this.theme.textSecondary)
        }
        .width('100%')

        Text(record.date)
          .fontSize(11)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: this.theme.cardShadow,
      offsetX: 0,
      offsetY: 4
    })
  }
}