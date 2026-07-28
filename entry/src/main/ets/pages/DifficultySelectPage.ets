import common from '@ohos.app.ability.common';
import { Difficulty, Topic, QuizMode } from '../model/Question';
import { QuizPageParams } from './QuizPage';
import { AppTheme, THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';

export interface DifficultySelectParams {
  topic: Topic;
}

// 难度选择页
@Component
export struct DifficultySelectPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  public topic: Topic = Topic.KNOWLEDGE;
  @State selectedDifficulty: Difficulty | 'mixed' | null = null;
  @State selectedMode: QuizMode = QuizMode.NORMAL;

  // 入场动画状态
  @State titleOpacity: number = 0
  @State titleOffset: number = -30
  @State cardsOpacity: number = 0
  @State cardsOffset: number = 40
  @State btnOpacity: number = 0
  @State btnScale: number = 0.9

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.titleOpacity = 1
    this.titleOffset = 0
    this.cardsOpacity = 1
    this.cardsOffset = 0
    this.btnOpacity = 1
    this.btnScale = 1
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Stack() {
          Circle()
            .width(72)
            .height(72)
            .fill('rgba(255,255,255,0.15)')

          Text('◎')
            .fontSize(34)
            .fontColor(this.theme.textOnPrimary)
        }
        .margin({ bottom: 14 })

        Text('选择难度')
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

        Text('根据自己的水平选择合适的挑战')
          .fontSize(15)
          .fontColor(this.theme.textOnPrimaryMuted)
      }
      .width('100%')
      .height(220)
      .justifyContent(FlexAlign.Center)
      .opacity(this.titleOpacity)
      .translate({ y: this.titleOffset })
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 0
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

      // 难度卡片列表
      Column({ space: 12 }) {
        this.DifficultyCard(
          '入门',
          '轻松上手，巩固基础',
          this.theme.success,
          Difficulty.ENTRY
        )

        this.DifficultyCard(
          '进阶',
          '需要一定知识储备',
          this.theme.warning,
          Difficulty.ADVANCED
        )

        this.DifficultyCard(
          '挑战',
          '高难度，挑战极限',
          this.theme.error,
          Difficulty.CHALLENGE
        )

        this.DifficultyCard(
          '混合乱序',
          '该类型下全部题目随机混合',
          '#9C27B0',
          'mixed'
        )
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 24, right: 24, top: 20, bottom: 12 })
      .backgroundColor(this.theme.background)
      .justifyContent(FlexAlign.Center)
      .opacity(this.cardsOpacity)
      .translate({ y: this.cardsOffset })
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 150
      })

      // 模式选择
      Column({ space: 8 }) {
        Text('选择答题模式')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textPrimary)
          .width('100%')

        Scroll() {
          Row({ space: 10 }) {
            this.ModeCard('普通模式', '常规计分', QuizMode.NORMAL)
            this.ModeCard('闯关模式', '答错即结束', QuizMode.CHALLENGE)
            this.ModeCard('限时模式', '60 秒挑战', QuizMode.TIME_ATTACK)
          }
          .padding({ left: 4, right: 4 })
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Horizontal)
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 8, bottom: 12 })

      // 底部按钮
      Button('开始答题')
        .width('90%')
        .height(52)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .opacity(this.btnOpacity)
        .scale({ x: this.btnScale, y: this.btnScale })
        .animation({
          duration: 500,
          curve: Curve.EaseOut,
          delay: 300
        })
        .backgroundColor(this.selectedDifficulty ? this.theme.primary : this.theme.divider)
        .fontColor(this.theme.textOnPrimary)
        .borderRadius(26)
        .enabled(this.selectedDifficulty !== null)
        .margin({ bottom: 24 })
        .stateStyles({
          pressed: { .scale({ x: 0.97, y: 0.97 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .onClick(() => {
          if (this.selectedDifficulty) {
            this.pageStack.pushPath({
              name: 'Quiz',
              param: {
                topic: this.topic,
                difficulty: this.selectedDifficulty,
                mode: this.selectedMode
              } as QuizPageParams
            });
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  @Builder
  ModeCard(title: string, desc: string, mode: QuizMode) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.selectedMode === mode ? this.theme.textOnPrimary : this.theme.textPrimary)

      Text(desc)
        .fontSize(11)
        .fontColor(this.selectedMode === mode ? this.theme.textOnPrimaryMuted : this.theme.textSecondary)
        .margin({ top: 2 })
    }
    .width(96)
    .height(56)
    .padding(8)
    .backgroundColor(this.selectedMode === mode ? this.theme.primary : this.theme.card)
    .borderRadius(12)
    .border({
      width: this.selectedMode === mode ? 0 : 1,
      color: this.theme.divider
    })
    .justifyContent(FlexAlign.Center)
    .stateStyles({
      pressed: { .scale({ x: 0.95, y: 0.95 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => {
      this.selectedMode = mode;
    })
  }

  @Builder
  DifficultyCard(title: string, desc: string, color: string, difficulty: Difficulty | 'mixed') {
    Column() {
      Row() {
        Column() {
          Text(title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(color)

          Text(desc)
            .fontSize(12)
            .fontColor(this.theme.textSecondary)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        if (this.selectedDifficulty === difficulty) {
          Text('✓')
            .fontSize(22)
            .fontColor(color)
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .border({
      width: this.selectedDifficulty === difficulty ? 2 : 0,
      color: color
    })
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
    .onClick(() => {
      this.selectedDifficulty = difficulty;
    })
  }
}
