import common from '@ohos.app.ability.common';
import curves from '@ohos.curves';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES } from '../model/AppTheme';
import { TypeSelectPage } from './TypeSelectPage';
import { DifficultySelectPage, DifficultySelectParams } from './DifficultySelectPage';
import { QuizPage, QuizPageParams } from './QuizPage';
import { ResultPage, ResultPageParams } from './ResultPage';
import { HistoryPage } from './HistoryPage';
import { WrongBookPage } from './WrongBookPage';
import { AchievementPage } from './AchievementPage';
import { StatsPage } from './StatsPage';
import { HomeTab } from './HomeTab';
import { FavoriteTab } from './FavoriteTab';
import { MineTab } from './MineTab';

// 应用主入口：底部导航 + 页面栈
@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State currentTabIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  onPageShow() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  @Builder
  pageMap(name: string, param: Object) {
    if (name === 'TypeSelect') {
      NavDestination() {
        TypeSelectPage()
      }
      .hideTitleBar(true)
    } else if (name === 'DifficultySelect') {
      NavDestination() {
        DifficultySelectPage({ topic: (param as DifficultySelectParams).topic })
      }
      .hideTitleBar(true)
    } else if (name === 'Quiz') {
      NavDestination() {
        QuizPage({ param: param as QuizPageParams })
      }
      .hideTitleBar(true)
    } else if (name === 'Result') {
      NavDestination() {
        ResultPage({ param: param as ResultPageParams })
      }
      .hideTitleBar(true)
    } else if (name === 'History') {
      NavDestination() {
        HistoryPage()
      }
      .hideTitleBar(true)
    } else if (name === 'WrongBook') {
      NavDestination() {
        WrongBookPage()
      }
      .hideTitleBar(true)
    } else if (name === 'Achievement') {
      NavDestination() {
        AchievementPage()
      }
      .hideTitleBar(true)
    } else if (name === 'Stats') {
      NavDestination() {
        StatsPage()
      }
      .hideTitleBar(true)
    }
  }

  @Builder
  TabBarBuilder(title: string, icon: string, index: number) {
    Column()
      .width('100%')
      .height(56)
  }

  @Builder
  FloatingTabItem(title: string, icon: string, index: number) {
    Column({ space: 3 }) {
      Text(icon)
        .fontSize(22)
        .fontColor(this.currentTabIndex === index ? this.theme.primary : this.theme.tabInactive)
        .scale({ x: this.currentTabIndex === index ? 1.15 : 1, y: this.currentTabIndex === index ? 1.15 : 1 })
        .animation({ duration: 300, curve: curves.springMotion(0.3, 0.9) })

      Text(title)
        .fontSize(10)
        .fontColor(this.currentTabIndex === index ? this.theme.primary : this.theme.tabInactive)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .opacity(this.currentTabIndex === index ? 1 : 0.7)
        .animation({ duration: 300, curve: curves.springMotion(0.3, 0.9) })
    }
    .width(86)
    .height(56)
    .justifyContent(FlexAlign.Center)
    .stateStyles({
      pressed: { .scale({ x: 0.88, y: 0.88 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => {
      this.currentTabIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  @Builder
  FloatingTabBar() {
    Row({ space: 0 }) {
      this.FloatingTabItem('首页', '🏠', 0)
      this.FloatingTabItem('收藏', '⭐', 1)
      this.FloatingTabItem('我的', '👤', 2)
    }
    .width(280)
    .height(60)
    .backgroundColor('rgba(255,255,255,0.48)')
    .borderRadius(30)
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT
    })
    .border({ width: 1.5, color: 'rgba(255,255,255,0.75)' })
    .shadow({
      radius: 40,
      color: 'rgba(0,0,0,0.10)',
      offsetX: 0,
      offsetY: 12
    })
    .margin({ bottom: 18 })
  }

  build() {
    Navigation(this.pageStack) {
      Stack({ alignContent: Alignment.Bottom }) {
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
          TabContent() {
            HomeTab()
          }
          .tabBar(this.TabBarBuilder('首页', '🏠', 0))
          .onWillShow(() => {
            AppStorage.setOrCreate('homeTabShowTrigger', Date.now());
          })

          TabContent() {
            FavoriteTab()
          }
          .tabBar(this.TabBarBuilder('收藏', '⭐', 1))
          .onWillShow(() => {
            AppStorage.setOrCreate('favoriteTabShowTrigger', Date.now());
          })

          TabContent() {
            MineTab()
          }
          .tabBar(this.TabBarBuilder('我的', '👤', 2))
          .onWillShow(() => {
            AppStorage.setOrCreate('mineTabShowTrigger', Date.now());
          })
        }
        .barMode(BarMode.Fixed)
        .barHeight(0)
        .backgroundColor(Color.Transparent)
        .padding({ bottom: 92 })
        .onChange((index: number) => {
          this.currentTabIndex = index;
        })

        this.FloatingTabBar()
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .navDestination(this.pageMap)
    .hideTitleBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }
}
