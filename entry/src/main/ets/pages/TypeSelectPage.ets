import common from '@ohos.app.ability.common';
import { Topic } from '../model/Question';
import { DifficultySelectParams } from './DifficultySelectPage';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';

// 题目类型选择页
@Component
export struct TypeSelectPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeIndexChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];
  @State selectedTopic: Topic | null = null;

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
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
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

          Text('☰')
            .fontSize(34)
            .fontColor(this.theme.textOnPrimary)
        }
        .margin({ bottom: 14 })

        Text('选择题目类型')
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

        Text('挑选你感兴趣的挑战方向')
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

      // 类型卡片列表
      Column({ space: 12 }) {
        this.TypeCard(
          '知识型问答',
          '百科 · 科学 · 历史 · 生活常识',
          '#2196F3',
          '💡',
          Topic.KNOWLEDGE
        )

        this.TypeCard(
          '脑筋急转弯',
          '谐音 · 反转 · 文字游戏',
          '#FF9800',
          '🧩',
          Topic.RIDDLE
        )

        this.TypeCard(
          '推理型问答',
          '逻辑 · 数列 · 情境推理',
          '#9C27B0',
          '🧠',
          Topic.REASONING
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

      // 底部按钮
      Button('下一步：选择难度')
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
          .backgroundColor(this.selectedTopic ? this.theme.primary : this.theme.divider)
          .fontColor(this.theme.textOnPrimary)
        .borderRadius(26)
        .enabled(this.selectedTopic !== null)
        .margin({ bottom: 24 })
        .stateStyles({
          pressed: { .scale({ x: 0.97, y: 0.97 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .onClick(() => {
          if (this.selectedTopic) {
            this.pageStack.pushPath({
              name: 'DifficultySelect',
              param: { topic: this.selectedTopic } as DifficultySelectParams
            });
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  @Builder
  TypeCard(title: string, desc: string, color: string, icon: string, topic: Topic) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(34)
          .margin({ right: 14 })

        Column() {
          Text(title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textPrimary)

          Text(desc)
            .fontSize(12)
            .fontColor(this.theme.textSecondary)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        if (this.selectedTopic === topic) {
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
      width: this.selectedTopic === topic ? 2 : 0,
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
      this.selectedTopic = topic;
    })
  }
}
