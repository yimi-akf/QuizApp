import common from '@ohos.app.ability.common';
import { AchievementStorage, Achievement, UserStats } from '../data/AchievementStorage';
import { AppTheme, THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { popSafe } from '../utils/NavUtil';

// 成就页
@Component
export struct AchievementPage {
  @Consume('pageStack') pageStack: NavPathStack
  @State theme: AppTheme = THEMES[0];
  @State userStats: UserStats = { answeredCount: 0, correctCount: 0, streakDays: 0, lastAnswerDate: '' };
  @State achievements: Achievement[] = [];
  @State headerOpacity: number = 0;
  @State headerOffset: number = -30;
  @State listOpacity: number = 0;
  @State listOffset: number = 40;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = ThemeManager.getCurrentTheme(context);
    this.loadData();

    this.headerOpacity = 1;
    this.headerOffset = 0;
    this.listOpacity = 1;
    this.listOffset = 0;
  }

  onPageShow() {
    this.loadData();
  }

  loadData() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.userStats = AchievementStorage.loadUserStats(context);
    this.achievements = AchievementStorage.loadAchievements(context);
  }

  goBack() {
    popSafe(this.pageStack);
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
              .backgroundColor('rgba(255,255,255,0.15)')
              .onClick(() => this.goBack())

            Blank()

            Text('成就')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 8 })
          .alignItems(VerticalAlign.Center)

          // 累计数据
          Column() {
            Text(`${this.userStats.answeredCount}`)
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .margin({ bottom: 4 })

            Text('累计答题')
              .fontSize(16)
              .fontColor(this.theme.textOnPrimaryMuted)
          }
          .width('100%')
          .padding({ top: 16, bottom: 20 })
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .padding({ top: 12, bottom: 20, left: 16, right: 16 })
        .backgroundColor(this.theme.primary)
        .borderRadius({ bottomLeft: 28, bottomRight: 28 })
        .shadow({
          radius: 12,
          color: 'rgba(0,0,0,0.12)',
          offsetX: 0,
          offsetY: 6
        })
        .opacity(this.headerOpacity)
        .translate({ y: this.headerOffset })
        .animation({ duration: 600, curve: Curve.EaseOut })

        // 统计小卡片
        Row({ space: 12 }) {
          this.StatCard('📚', `${this.userStats.answeredCount}`, '累计答题')
          this.StatCard('✅', `${this.userStats.correctCount}`, '答对题数')
          this.StatCard('🔥', `${this.userStats.streakDays}`, '连续打卡')
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 16 })

        // 成就列表
        Scroll() {
          Column({ space: 12 }) {
            Text('成就列表')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .margin({ bottom: 4 })

            ForEach(this.achievements, (item: Achievement) => {
              this.AchievementItem(item)
            }, (item: Achievement) => item.id)
          }
          .width('100%')
          .padding({ left: 24, right: 24, bottom: 24 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .backgroundColor(this.theme.background)
        .opacity(this.listOpacity)
        .translate({ y: this.listOffset })
        .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)
    }
  }

  @Builder
  StatCard(icon: string, value: string, label: string) {
    Column() {
      Text(icon)
        .fontSize(24)
        .margin({ bottom: 6 })

      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme.textPrimary)
        .margin({ bottom: 2 })

      Text(label)
        .fontSize(12)
        .fontColor(this.theme.textSecondary)
    }
    .layoutWeight(1)
    .padding(14)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 4
    })
  }

  @Builder
  AchievementItem(item: Achievement) {
    Row() {
      Text(item.icon)
        .fontSize(36)
        .margin({ right: 14 })
        .opacity(item.unlockedAt ? 1 : 0.4)

      Column() {
        Text(item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(item.unlockedAt ? this.theme.textPrimary : this.theme.textSecondary)

        Text(item.desc)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 4 })

        if (item.unlockedAt) {
          Text(`解锁于 ${item.unlockedAt}`)
            .fontSize(11)
            .fontColor(this.theme.primary)
            .margin({ top: 4 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text(item.unlockedAt ? '✓' : '🔒')
        .fontSize(24)
        .fontColor(item.unlockedAt ? this.theme.success : this.theme.divider)
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
  }
}
