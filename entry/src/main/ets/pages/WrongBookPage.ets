import common from '@ohos.app.ability.common';
import { questionBank } from '../data/QuestionBank';
import { WrongBookStorage, WrongRecord } from '../data/WrongBookStorage';
import { Question, QuestionType, Topic, QuizMode } from '../model/Question';
import { AppTheme, THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { EmptyState } from '../components/EmptyState';
import { typeLabel } from '../utils/FormatUtil';
import { popSafe } from '../utils/NavUtil';
import { QuizPageParams } from './QuizPage';

// 错题本页
@Component
export struct WrongBookPage {
  @Consume('pageStack') pageStack: NavPathStack
  @State theme: AppTheme = THEMES[0];
  @State records: WrongRecord[] = [];
  @State unmasteredQuestions: Question[] = [];
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
    this.records = WrongBookStorage.loadRecords(context);
    const unmasteredIds = WrongBookStorage.getUnmasteredQuestionIds(context);
    const questions: Question[] = [];
    unmasteredIds.forEach(id => {
      const q = questionBank.find(item => item.id === id);
      if (q) {
        questions.push(q);
      }
    });
    this.unmasteredQuestions = questions;
  }

  goBack() {
    popSafe(this.pageStack);
  }

  startWrongPractice() {
    const ids = this.unmasteredQuestions.map(q => q.id);
    if (ids.length === 0) {
      return;
    }
    this.pageStack.pushPath({
      name: 'Quiz',
      param: {
        topic: Topic.KNOWLEDGE,
        difficulty: 'mixed',
        questionIds: ids,
        mode: QuizMode.WRONG_BOOK
      } as QuizPageParams
    });
  }

  removeQuestion(q: Question) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    WrongBookStorage.removeRecord(context, q.id);
    this.loadData();
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

            Text('错题本')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 8 })
          .alignItems(VerticalAlign.Center)

          Row() {
            Column() {
              Text(`${this.unmasteredQuestions.length}`)
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.theme.textOnPrimary)

              Text('待练习')
                .fontSize(13)
                .fontColor(this.theme.textOnPrimaryMuted)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)

            Column() {
              Text(`${this.records.length}`)
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.theme.textOnPrimary)

              Text('总收录')
                .fontSize(13)
                .fontColor(this.theme.textOnPrimaryMuted)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)
          }
          .width('100%')
          .padding({ top: 24, bottom: 16 })
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

        // 列表区
        if (this.unmasteredQuestions.length === 0) {
          EmptyState({
            icon: '📚',
            title: '错题本空空如也',
            subtitle: '答错的题目会自动收录到这里，\n连续答对两次后自动移除',
            theme: this.theme
          })
        } else {
          Column({ space: 12 }) {
            Row() {
              Text('待练习题目')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.theme.textPrimary)
                .layoutWeight(1)

              Button('开始重练')
                .height(36)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .backgroundColor(this.theme.primary)
                .fontColor(this.theme.textOnPrimary)
                .borderRadius(18)
                .onClick(() => this.startWrongPractice())
            }
            .width('100%')
            .padding({ left: 24, right: 24, top: 16 })

            Scroll() {
              Column({ space: 12 }) {
                ForEach(this.unmasteredQuestions, (q: Question) => {
                  this.QuestionItem(q)
                }, (q: Question) => q.id.toString())
              }
              .width('100%')
              .padding({ left: 24, right: 24, bottom: 24 })
            }
            .layoutWeight(1)
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor(this.theme.background)
          .opacity(this.listOpacity)
          .translate({ y: this.listOffset })
          .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)
    }
  }

  @Builder
  QuestionItem(q: Question) {
    Row() {
      Column() {
        Row() {
          Text(typeLabel(q.type))
            .fontSize(12)
            .fontColor(this.theme.primary)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .backgroundColor(`${this.theme.primary}14`)
            .borderRadius(8)

          Blank()

          Text('移除')
            .fontSize(13)
            .fontColor(this.theme.textSecondary)
            .onClick(() => this.removeQuestion(q))
        }
        .width('100%')
        .margin({ bottom: 8 })

        Text(q.title)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .width('100%')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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
      color: 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 4
    })
  }
}
