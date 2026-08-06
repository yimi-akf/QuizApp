import common from '@ohos.app.ability.common';
import { ProgressStorage, LastProgressSummary } from '../data/ProgressStorage';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { QuizPageParams } from './QuizPage';
import { APP_NAME, APP_SLOGAN } from '../data/AppConstants';
import { topicLabel, difficultyLabel } from '../utils/FormatUtil';
import { DailyStorage } from '../data/DailyStorage';

// 首页标签内容
@Component
export struct HomeTab {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeIndexChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];
  @State headerOpacity: number = 0
  @State headerOffset: number = -30
  @State contentOpacity: number = 0
  @State contentOffset: number = 40
  @State lastProgress: LastProgressSummary | null = null
  @State lastHomeModule: string = ''
  @State isDailyCompleted: boolean = false;
  @StorageLink('homeTabShowTrigger') @Watch('onHomeTabShow') homeTabShowTrigger: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadData(context);
    this.playEntranceAnimation();
  }

  onPageShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadData(context);
  }

  onHomeTabShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadData(context);
  }

  onThemeIndexChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  playEntranceAnimation() {
    this.headerOpacity = 1
    this.headerOffset = 0
    this.contentOpacity = 1
    this.contentOffset = 0
  }

  loadData(context: common.UIAbilityContext) {
    this.lastProgress = ProgressStorage.loadLastProgress(context)
    this.lastHomeModule = ProgressStorage.loadLastHomeModule(context)
    this.isDailyCompleted = DailyStorage.isCompletedToday(context);
  }

  saveLastHomeModule(module: string) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ProgressStorage.saveLastHomeModule(context, module);
    this.lastHomeModule = module;
  }

  continueLastProgress() {
    if (!this.lastProgress) {
      return;
    }
    this.pageStack.pushPath({
      name: 'Quiz',
      param: {
        topic: this.lastProgress.topic,
        difficulty: this.lastProgress.difficulty,
        shouldContinue: true
      } as QuizPageParams
    });
  }

  goToDailyQuestion() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.pageStack.pushPath({ name: 'DailyQuestion' });
  }

  @Builder
  FunctionCard(icon: string, title: string, subtitle: string, module: string, onClick: () => void) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(28)
          .margin({ right: 12 })

        Column() {
          Text(title)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textPrimary)

          if (subtitle) {
            Text(subtitle)
              .fontSize(12)
              .fontColor(this.theme.textSecondary)
              .margin({ top: 4 })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(this.theme.card)
    .borderRadius(20)
    .border({
      width: this.lastHomeModule === module ? 2 : 0,
      color: this.theme.primary
    })
    .shadow({
      radius: 10,
      color: this.lastHomeModule === module ? `${this.theme.primary}33` : this.theme.cardShadow,
      offsetX: 0,
      offsetY: this.lastHomeModule === module ? 8 : 4
    })
    .stateStyles({
      pressed: { .scale({ x: 0.97, y: 0.97 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => {
      this.saveLastHomeModule(module);
      onClick();
    })
  }

  build() {
    Column() {
      // 顶部主题色标题区
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          Text(APP_NAME)
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

          Text(APP_SLOGAN)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimaryMuted)
        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height(180)
      .padding({ top: 0, bottom: 0, left: 20, right: 20 })
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
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      // 白色背景的功能入口区
      Column({ space: 16 }) {
        // 继续上次进度
        if (this.lastProgress) {
          Column() {
            Row() {
              Text('🕘')
                .fontSize(28)
                .margin({ right: 12 })

              Column() {
                Text('继续上次进度')
                  .fontSize(14)
                  .fontColor(this.theme.primary)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 4 })

                Text(`${topicLabel(this.lastProgress.topic)} · ${difficultyLabel(this.lastProgress.difficulty)} · 第 ${this.lastProgress.currentIndex + 1} / ${this.lastProgress.total} 题`)
                  .fontSize(15)
                  .fontColor(this.theme.textPrimary)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('›')
                .fontSize(24)
                .fontColor(this.theme.primary)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .padding(14)
          .backgroundColor(this.theme.card)
          .borderRadius(20)
          .shadow({
            radius: 10,
            color: this.theme.cardShadow,
            offsetX: 0,
            offsetY: 4
          })
          .stateStyles({
            pressed: { .scale({ x: 0.98, y: 0.98 }) },
            normal: { .scale({ x: 1, y: 1 }) }
          })
          .onClick(() => this.continueLastProgress())
        }

        // 功能入口网格
        Grid() {
          GridItem() {
            this.FunctionCard('🎮', '开始答题', '选择类型与难度', 'quiz', () => {
              this.pageStack.pushPath({ name: 'TypeSelect' });
            })
          }

          GridItem() {
            this.FunctionCard('📚', '错题本', '错题重练与复习', 'wrong_book', () => {
              this.pageStack.pushPath({ name: 'WrongBook' });
            })
          }

          GridItem() {
            this.FunctionCard('🏆', '成就', '解锁答题勋章', 'achievement', () => {
              this.pageStack.pushPath({ name: 'Achievement' });
            })
          }

          GridItem() {
            this.FunctionCard('📊', '统计看板', '答题数据与趋势', 'stats', () => {
              this.pageStack.pushPath({ name: 'Stats' });
            })
          }

          GridItem() {
            this.FunctionCard('📜', '答题历史', '查看过往成绩', 'history', () => {
              this.pageStack.pushPath({ name: 'History' });
            })
          }

          GridItem() {
            this.FunctionCard('✦', '每日一题', '每天一道精选题目', 'daily', () => {
              this.goToDailyQuestion()
            })
          }
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .backgroundColor(this.theme.background)
      .opacity(this.contentOpacity)
      .translate({ y: this.contentOffset })
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 150
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }
}