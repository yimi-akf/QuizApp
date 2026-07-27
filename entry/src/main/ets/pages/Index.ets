import common from '@ohos.app.ability.common';
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
import { PrivacyStorage } from '../data/PrivacyStorage';
import { PRIVACY_URL, APP_NAME } from '../data/AppConstants';
import hilog from '@ohos.hilog';

// 应用主入口：底部导航 + 页面栈
@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State currentTabIndex: number = 0;
  // 首次启动隐私政策弹窗
  @State showPrivacyDialog: boolean = false;
  private tabsController: TabsController = new TabsController();

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    // 检查是否已同意隐私政策，未同意则弹窗
    const agreed = PrivacyStorage.isPrivacyAgreed(context);
    if (!agreed) {
      this.showPrivacyDialog = true;
    }
  }

  onPageShow() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  // 同意隐私政策
  agreePrivacy() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    PrivacyStorage.setPrivacyAgreed(context, true);
    this.showPrivacyDialog = false;
  }

  // 不同意隐私政策，退出应用
  disagreePrivacy() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      context.terminateSelf();
    } catch (e) {
      hilog.error(0x0000, 'Index', 'terminateSelf failed');
    }
  }

  // 打开完整隐私政策
  openFullPrivacyPolicy() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      context.startAbility({
        action: 'ohos.want.action.viewData',
        uri: PRIVACY_URL
      });
    } catch (e) {
      hilog.error(0x0000, 'Index', 'open privacy policy failed');
    }
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
    Column({ space: 2 }) {
      Text(icon)
        .fontSize(22)
        .fontColor(this.currentTabIndex === index ? this.theme.primary : '#9E9E9E')
        .scale({ x: this.currentTabIndex === index ? 1.1 : 1, y: this.currentTabIndex === index ? 1.1 : 1 })
        .animation({ duration: 200, curve: Curve.EaseOut })

      Text(title)
        .fontSize(10)
        .fontColor(this.currentTabIndex === index ? this.theme.primary : '#9E9E9E')
        .fontWeight(this.currentTabIndex === index ? FontWeight.Medium : FontWeight.Normal)
    }
    .width(86)
    .height(56)
    .justifyContent(FlexAlign.Center)
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
    .backgroundColor('rgba(255,255,255,0.55)')
    .borderRadius(30)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT
    })
    .border({ width: 1, color: 'rgba(255,255,255,0.65)' })
    .shadow({
      radius: 30,
      color: 'rgba(0,0,0,0.12)',
      offsetX: 0,
      offsetY: 8
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
        .padding({ bottom: 80 })
        .onChange((index: number) => {
          this.currentTabIndex = index;
        })

        this.FloatingTabBar()

        // 首次启动隐私政策弹窗
        if (this.showPrivacyDialog) {
          this.PrivacyDialog()
        }
      }
      .width('100%')
      .height('100%')
    }
    .navDestination(this.pageMap)
    .hideTitleBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }

  @Builder
  PrivacyDialog() {
    Column() {
      Column() {
        Text('🔒')
          .fontSize(40)
          .margin({ bottom: 12 })

        Text('隐私政策')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textPrimary)
          .margin({ bottom: 16 })

        Text(`欢迎使用${APP_NAME}！在使用本应用前，请阅读并同意我们的隐私政策。`)
          .fontSize(14)
          .fontColor(this.theme.textPrimary)
          .lineHeight(22)
          .margin({ bottom: 12 })

        Text(`本应用为离线应用，不会收集您的任何个人信息。所有答题数据、收藏记录、设置等仅保存在您的设备本地，不会上传到服务器。点击下方链接可查看完整隐私政策。`)
          .fontSize(13)
          .fontColor(this.theme.textSecondary)
          .lineHeight(20)
          .margin({ bottom: 16 })

        Text('查看完整隐私政策')
          .fontSize(14)
          .fontColor(this.theme.primary)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 20 })
          .onClick(() => this.openFullPrivacyPolicy())

        Row({ space: 12 }) {
          Button('不同意')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(this.theme.background)
            .fontColor(this.theme.textSecondary)
            .borderRadius(22)
            .onClick(() => this.disagreePrivacy())

          Button('同意')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(this.theme.primary)
            .fontColor(this.theme.textOnPrimary)
            .borderRadius(22)
            .onClick(() => this.agreePrivacy())
        }
        .width('100%')
      }
      .width('85%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('rgba(0,0,0,0.5)')
  }
}
