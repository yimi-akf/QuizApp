import common from '@ohos.app.ability.common';
import { FavoriteStorage, FavoriteRecord } from '../data/FavoriteStorage';
import { findQuestionById } from '../data/QuestionBank';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { Question, QuizMode, Topic } from '../model/Question';
import { QuizPageParams } from './QuizPage';
import { EmptyState } from '../components/EmptyState';
import { topicLabel, topicShortLabel, difficultyLabel } from '../utils/FormatUtil';

class FavoriteItemData {
  public record: FavoriteRecord;
  public question: Question;

  constructor(record: FavoriteRecord, question: Question) {
    this.record = record;
    this.question = question;
  }
}

// 按题目主题（类型）分组的展示数据
class TopicGroupData {
  public topic: Topic;
  public label: string;
  public items: FavoriteItemData[];

  constructor(topic: Topic, label: string, items: FavoriteItemData[]) {
    this.topic = topic;
    this.label = label;
    this.items = items;
  }
}

// 收藏标签内容
@Component
export struct FavoriteTab {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];
  @State favorites: FavoriteRecord[] = [];
  @State favoriteItems: FavoriteItemData[] = [];
  @State topicGroups: TopicGroupData[] = [];
  @State headerOpacity: number = 0;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 40;
  @StorageLink('favoriteTabShowTrigger') @Watch('onFavoriteTabShow') favoriteTabShowTrigger: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadData(context);
    this.playEntranceAnimation();
  }

  onThemeIndexChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  onThemeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  onFavoriteTabShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadData(context);
  }

  playEntranceAnimation() {
    this.headerOpacity = 1;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  loadData(context: common.UIAbilityContext) {
    this.favorites = FavoriteStorage.loadRecords(context);
    this.refreshFilteredItems();
  }

  refreshFilteredItems() {
    const items: FavoriteItemData[] = [];
    this.favorites.forEach((record: FavoriteRecord) => {
      const q = this.findQuestion(record.questionId);
      if (q !== undefined) {
        items.push(new FavoriteItemData(record, q));
      }
    });
    this.favoriteItems = items;
    // 按 Topic（知识型 / 推理型 / 脑筋急转弯）分组
    const topicOrder = [Topic.KNOWLEDGE, Topic.REASONING, Topic.RIDDLE];
    const topicGroupList: TopicGroupData[] = [];
    topicOrder.forEach(t => {
      const groupItems = items.filter((item: FavoriteItemData) => item.question.topic === t);
      if (groupItems.length > 0) {
        topicGroupList.push(new TopicGroupData(t, topicLabel(t), groupItems));
      }
    });
    this.topicGroups = topicGroupList;
  }

  findQuestion(questionId: number): Question | undefined {
    return findQuestionById(questionId);
  }

  removeFavorite(questionId: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    FavoriteStorage.removeFavorite(context, questionId);
    this.loadData(context);
  }

  startFavoriteQuiz() {
    if (this.favoriteItems.length === 0) {
      return;
    }
    const ids: number[] = [];
    this.favoriteItems.forEach((item: FavoriteItemData) => {
      ids.push(item.record.questionId);
    });
    // 收藏练习使用 mixed 难度，避免 topic/difficulty 过滤导致题目丢失
    this.pageStack.pushPath({
      name: 'Quiz',
      param: {
        topic: Topic.KNOWLEDGE,
        difficulty: 'mixed',
        questionIds: ids,
        mode: QuizMode.NORMAL
      } as QuizPageParams
    });
  }

  @Builder
  FavoriteItem(item: FavoriteItemData) {
    Row() {
      Column() {
        Text(item.question.title)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .fontWeight(FontWeight.Medium)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(`${topicShortLabel(item.question.topic)} · ${difficultyLabel(item.question.difficulty)}`)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('★')
        .fontSize(22)
        .fontColor(this.theme.warning)
        .width(44)
        .height(44)
        .textAlign(TextAlign.Center)
        .padding({ top: 9 })
        .stateStyles({
          pressed: { .scale({ x: 0.85, y: 0.85 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .hitTestBehavior(HitTestMode.Block)
        .onClick(() => this.removeFavorite(item.record.questionId))
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
      pressed: { .scale({ x: 0.98, y: 0.98 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => {
      this.pageStack.pushPath({
        name: 'Quiz',
        param: {
          topic: Topic.KNOWLEDGE,
          difficulty: 'mixed',
          questionIds: [item.question.id],
          mode: QuizMode.NORMAL
        } as QuizPageParams
      });
    })
  }

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Text('我的收藏')
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

        Text(`共 ${this.favoriteItems.length} 道收藏题目`)
          .fontSize(15)
          .fontColor(this.theme.textOnPrimaryMuted)
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

      if (this.favorites.length === 0) {
        EmptyState({
          icon: '⭐',
          title: '还没有收藏题目',
          subtitle: '在答题时长按题目或点击收藏按钮，\n即可加入收藏',
          theme: this.theme
        })
      } else {
        Column({ space: 12 }) {
          Button('开始练习全部收藏')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.primary)
            .borderRadius(24)
            .stateStyles({
              pressed: { .scale({ x: 0.97, y: 0.97 }) },
              normal: { .scale({ x: 1, y: 1 }) }
            })
            .onClick(() => this.startFavoriteQuiz())

          // 题目列表：按类型分组渲染
          Scroll() {
            Column({ space: 16 }) {
              ForEach(this.topicGroups, (group: TopicGroupData) => {
                Column({ space: 10 }) {
                  Row() {
                    Text(group.label)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.theme.textPrimary)
                    Text(`(${group.items.length})`)
                      .fontSize(14)
                      .fontColor(this.theme.textSecondary)
                      .margin({ left: 6 })
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Bottom)

                  ForEach(group.items, (item: FavoriteItemData) => {
                    this.FavoriteItem(item)
                  }, (item: FavoriteItemData) => String(item.record.questionId))
                }
                .width('100%')
              }, (group: TopicGroupData) => group.topic)
            }
            .width('100%')
            .padding({ bottom: 20 })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 20, right: 20, top: 20, bottom: 20 })
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
