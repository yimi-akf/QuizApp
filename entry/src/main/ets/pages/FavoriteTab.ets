import common from '@ohos.app.ability.common';
import { FavoriteStorage, FavoriteRecord } from '../data/FavoriteStorage';
import { questionBank } from '../data/QuestionBank';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES } from '../model/AppTheme';
import { Question, Topic } from '../model/Question';
import { QuizPageParams } from './QuizPage';
import { EmptyState } from '../components/EmptyState';

class FavoriteItemData {
  record: FavoriteRecord;
  question: Question;

  constructor(record: FavoriteRecord, question: Question) {
    this.record = record;
    this.question = question;
  }
}

// 收藏标签内容
@Component
export struct FavoriteTab {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State favorites: FavoriteRecord[] = [];
  @State favoriteItems: FavoriteItemData[] = [];
  @State headerOpacity: number = 0;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 40;
  @StorageLink('favoriteTabShowTrigger') @Watch('onFavoriteTabShow') favoriteTabShowTrigger: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
    this.playEntranceAnimation();
  }

  onPageShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  onFavoriteTabShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
  }

  playEntranceAnimation() {
    this.headerOpacity = 1;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  loadData(context: common.UIAbilityContext) {
    this.favorites = FavoriteStorage.loadRecords(context);
    this.favoriteItems = this.favorites
      .map((record: FavoriteRecord) => new FavoriteItemData(record, this.findQuestion(record.questionId)!))
      .filter((item) => item.question !== undefined);
  }

  topicLabel(topic: Topic): string {
    switch (topic) {
      case Topic.KNOWLEDGE: return '知识';
      case Topic.RIDDLE: return '脑筋急转弯';
      case Topic.REASONING: return '推理';
      default: return '';
    }
  }

  findQuestion(questionId: number): Question | undefined {
    return questionBank.find(q => q.id === questionId);
  }

  removeFavorite(questionId: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    FavoriteStorage.removeFavorite(context, questionId);
    this.loadData(context);
  }

  startFavoriteQuiz() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const ids = FavoriteStorage.getFavoriteQuestionIds(context);
    if (ids.length === 0) {
      return;
    }
    const first = this.findQuestion(ids[0]);
    if (!first) {
      return;
    }
    this.pageStack.pushPath({
      name: 'Quiz',
      param: {
        topic: first.topic,
        difficulty: first.difficulty,
        questionIds: ids,
        mode: 'normal'
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

        Text(`${this.topicLabel(item.question.topic)} · ${item.question.difficulty}`)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Button('★')
        .fontSize(18)
        .fontColor(this.theme.warning)
        .backgroundColor('transparent')
        .width(40)
        .height(40)
        .stateStyles({
          pressed: { .scale({ x: 0.85, y: 0.85 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
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
          topic: item.question.topic,
          difficulty: item.question.difficulty,
          questionIds: [item.question.id],
          mode: 'normal'
        } as QuizPageParams
      });
    })
  }

  build() {
    Stack() {
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

          Text(`共 ${this.favorites.length} 道收藏题目`)
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

            Scroll() {
              Column({ space: 12 }) {
                ForEach(this.favoriteItems, (item: FavoriteItemData) => {
                  this.FavoriteItem(item)
                }, (item: FavoriteItemData) => String(item.record.questionId))
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
          .backgroundColor('#FFFFFF')
          .opacity(this.contentOpacity)
          .translate({ y: this.contentOffset })
          .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
    }
  }
}
