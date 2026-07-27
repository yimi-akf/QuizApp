import common from '@ohos.app.ability.common';
import { HistoryStorage, HistoryRecord } from '../data/HistoryStorage';
import { StatsStorage, QuizStats, TopicProgress, DailyStat } from '../data/StatsStorage';
import { AppTheme, THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { EmptyState } from '../components/EmptyState';
import { formatTime } from '../utils/FormatUtil';
import { popSafe } from '../utils/NavUtil';

// 统计看板页
@Component
export struct StatsPage {
  @Consume('pageStack') pageStack: NavPathStack
  @State theme: AppTheme = THEMES[0];
  @State stats: QuizStats = {
    totalQuizzes: 0,
    totalQuestions: 0,
    totalAnswered: 0,
    totalCorrect: 0,
    averageScore: 0,
    bestScore: 0,
    totalTimeSeconds: 0,
    topicProgress: [],
    dailyStats: []
  };
  @State records: HistoryRecord[] = [];
  @State headerOpacity: number = 0;
  @State headerOffset: number = -30;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 40;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = ThemeManager.getCurrentTheme(context);
    this.loadData();

    this.headerOpacity = 1;
    this.headerOffset = 0;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  onPageShow() {
    this.loadData();
  }

  loadData() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const records = HistoryStorage.loadRecords(context);
    const stats = StatsStorage.computeStats(records);
    stats.topicProgress = StatsStorage.loadTopicProgress(context);
    this.records = records;
    this.stats = stats;
  }

  goBack() {
    popSafe(this.pageStack);
  }

  accuracyValue(): number {
    return this.stats.totalAnswered > 0
      ? Math.round((this.stats.totalCorrect / this.stats.totalAnswered) * 100)
      : 0;
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

            Text('统计看板')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 8 })
          .alignItems(VerticalAlign.Center)

          Text(`${this.accuracyValue()}%`)
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textOnPrimary)
            .margin({ top: 16, bottom: 4 })

          Text('总正确率')
            .fontSize(14)
            .fontColor(this.theme.textOnPrimaryMuted)
            .margin({ bottom: 16 })
        }
        .width('100%')
        .padding({ top: 12, bottom: 24, left: 16, right: 16 })
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

        if (this.records.length === 0) {
          EmptyState({
            icon: '📊',
            title: '还没有答题记录',
            subtitle: '去完成一次答题，\n这里会展示你的学习数据',
            theme: this.theme
          })
        } else {
          Scroll() {
            Column({ space: 16 }) {
              // 关键数据卡片
              Row({ space: 12 }) {
                this.StatCard('📋', `${this.stats.totalQuizzes}`, '答题次数')
                this.StatCard('📝', `${this.stats.totalAnswered}`, '总题数')
                this.StatCard('⏱️', formatTime(this.stats.totalTimeSeconds), '总用时')
              }
              .width('100%')

              Row({ space: 12 }) {
                this.StatCard('✅', `${this.stats.totalCorrect}`, '答对题数')
                this.StatCard('📈', `${this.stats.averageScore}`, '平均分')
                this.StatCard('🏆', `${this.stats.bestScore}`, '最高分')
              }
              .width('100%')

              // 主题通关进度
              Column() {
                Text('主题通关进度')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.theme.textPrimary)
                  .width('100%')
                  .margin({ bottom: 12 })

                ForEach(this.stats.topicProgress, (p: TopicProgress) => {
                  this.TopicProgressItem(p)
                }, (p: TopicProgress) => p.topic)
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

              // 最近趋势
              if (this.stats.dailyStats.length > 0) {
                Column() {
                  Text('每日正确率趋势')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(this.theme.textPrimary)
                    .width('100%')
                    .margin({ bottom: 12 })

                  ForEach(this.stats.dailyStats.slice(-7), (item: DailyStat) => {
                    this.DailyStatItem(item)
                  }, (item: DailyStat) => item.date)
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
            .width('100%')
            .padding({ left: 24, right: 24, top: 16, bottom: 24 })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .backgroundColor(this.theme.background)
          .opacity(this.contentOpacity)
          .translate({ y: this.contentOffset })
          .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
        }
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
        .fontSize(22)
        .margin({ bottom: 6 })

      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme.textPrimary)
        .margin({ bottom: 2 })

      Text(label)
        .fontSize(11)
        .fontColor(this.theme.textSecondary)
    }
    .layoutWeight(1)
    .padding(12)
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
  TopicProgressItem(p: TopicProgress) {
    Row() {
      Text(p.topic === 'knowledge' ? '知识型问答' : p.topic === 'reasoning' ? '推理型问答' : '脑筋急转弯')
        .fontSize(15)
        .fontColor(this.theme.textPrimary)
        .layoutWeight(1)

      Row({ space: 4 }) {
        this.DifficultyBadge('入门', p.entryCompleted)
        this.DifficultyBadge('进阶', p.advancedCompleted)
        this.DifficultyBadge('挑战', p.challengeCompleted)
      }
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }

  @Builder
  DifficultyBadge(label: string, completed: boolean) {
    Text(label)
      .fontSize(11)
      .fontColor(completed ? this.theme.textOnPrimary : this.theme.textSecondary)
      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
      .backgroundColor(completed ? this.theme.success : this.theme.background)
      .borderRadius(10)
  }

  @Builder
  DailyStatItem(item: DailyStat) {
    Row() {
      Text(item.date.slice(5))
        .fontSize(13)
        .fontColor(this.theme.textSecondary)
        .width(60)

      Stack({ alignContent: Alignment.Start }) {
        Row()
          .width('100%')
          .height(8)
          .backgroundColor(this.theme.background)
          .borderRadius(4)

        Row()
          .width(item.total > 0 ? `${Math.round((item.correct / item.total) * 100)}%` : '0%')
          .height(8)
          .backgroundColor(this.theme.primary)
          .borderRadius(4)
      }
      .layoutWeight(1)
      .height(8)

      Text(`${item.correct}/${item.total}`)
        .fontSize(13)
        .fontColor(this.theme.textPrimary)
        .width(50)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}
