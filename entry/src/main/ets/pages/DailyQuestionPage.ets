import common from '@ohos.app.ability.common';
import { findQuestionById } from '../data/QuestionBank';
import { DailyStorage } from '../data/DailyStorage';
import { HistoryStorage } from '../data/HistoryStorage';
import { formatDateTime } from '../utils/DateUtil';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { Question, QuestionType, Difficulty, Topic } from '../model/Question';

const EMPTY_QUESTION: Question = {
  id: 0,
  type: QuestionType.SINGLE_CHOICE,
  difficulty: Difficulty.ENTRY,
  topic: Topic.KNOWLEDGE,
  title: '暂无题目',
  options: [],
  correctIndex: -1,
  explanation: '今天没有每日一题，请明天再来吧。'
};

@Component
export struct DailyQuestionPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onThemeChange') darkMode: boolean = false;
  @State theme: AppTheme = THEMES[0];
  @State question: Question = EMPTY_QUESTION;
  @State hasAnswered: boolean = false;
  @State selectedIndex: number = -1;
  @State isCorrect: boolean = false;
  @State isCompleted: boolean = false;
  @State headerOpacity: number = 0;
  @State cardOpacity: number = 0;
  @State cardOffset: number = 30;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.loadQuestion();
    this.headerOpacity = 1;
    this.cardOpacity = 1;
    this.cardOffset = 0;
  }

  onThemeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  loadQuestion() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const questionId = DailyStorage.getTodayQuestionId(context);
    const q = findQuestionById(questionId);
    this.question = q !== undefined ? q : EMPTY_QUESTION;
    // 检查今天是否已完成，避免退出重进后重新显示题目
    this.isCompleted = DailyStorage.isCompletedToday(context);
  }

  onOptionClick(index: number) {
    if (this.hasAnswered) {
      return;
    }
    this.selectedIndex = index;
    this.isCorrect = index === this.question.correctIndex;
    this.hasAnswered = true;
  }

  markDone() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    DailyStorage.markCompletedToday(context);
    this.isCompleted = true;

    // 保存到历史记录，让热力图统计包含每日一题
    HistoryStorage.saveRecord(context, {
      id: Date.now(),
      topic: this.question.topic,
      difficulty: this.question.difficulty,
      score: this.isCorrect ? 100 : 0,
      correctCount: this.isCorrect ? 1 : 0,
      total: 1,
      answeredCount: 1,
      elapsedSeconds: 0,
      date: formatDateTime(new Date())
    });
  }

  goBack() {
    try {
      this.pageStack.pop();
    } catch (e) {
      // ignore
    }
  }

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Text('✦')
          .fontSize(44)
          .fontColor(this.theme.textOnPrimary)
          .margin({ bottom: 8 })

        Text('每日一题')
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

        Text('每天一道精选题目')
          .fontSize(15)
          .fontColor(this.theme.textOnPrimaryMuted)
      }
      .width('100%')
      .height(200)
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

      if (this.isCompleted) {
        // 完成页面
        Column({ space: 20 }) {
          Text('🎉')
            .fontSize(80)

          Text('今日打卡完成！')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textPrimary)

          Text('明天再来继续挑战吧')
            .fontSize(16)
            .fontColor(this.theme.textSecondary)

          Button('返回首页')
            .width(200)
            .height(52)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(this.theme.primary)
            .fontColor(this.theme.textOnPrimary)
            .borderRadius(26)
            .margin({ top: 20 })
            .onClick(() => this.goBack())
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .opacity(this.cardOpacity)
        .animation({ duration: 500, curve: Curve.EaseOut, delay: 200 })
        .backgroundColor(this.theme.background)
      } else {
        // 题目区
        Scroll() {
          Column() {
            Column() {
              Text(this.question.title)
                .fontSize(22)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.theme.textPrimary)
                .width('100%')
                .margin({ bottom: 24 })

              if (this.question.type === QuestionType.SHORT_ANSWER) {
                if (!this.hasAnswered) {
                  Button('查看答案')
                    .width(200)
                    .height(52)
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .backgroundColor(this.theme.primary)
                    .fontColor(this.theme.textOnPrimary)
                    .borderRadius(26)
                    .margin({ top: 8 })
                    .stateStyles({
                      pressed: { .scale({ x: 0.96, y: 0.96 }) },
                      normal: { .scale({ x: 1, y: 1 }) }
                    })
                    .onClick(() => {
                      this.hasAnswered = true;
                    })
                } else {
                  Column() {
                    Text('参考答案')
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.theme.success)
                      .width('100%')
                      .margin({ bottom: 8 })

                    Text(this.question.explanation)
                      .fontSize(15)
                      .fontColor(this.theme.textPrimary)
                      .width('100%')
                      .lineHeight(24)
                  }
                  .width('100%')
                  .padding(16)
                  .backgroundColor(this.theme.answerBg)
                  .borderRadius(20)
                }
              } else {
                ForEach(this.question.options, (option: string, index: number) => {
                  this.OptionItem(option, index)
                }, (option: string, index: number) => 'opt' + index)
              }

              if (this.hasAnswered && this.question.type !== QuestionType.SHORT_ANSWER) {
                Column() {
                  Row() {
                    Text('解析')
                      .fontSize(15)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.theme.success)
                  }
                  .width('100%')
                  .margin({ bottom: 8 })

                  Text(this.question.explanation)
                    .fontSize(15)
                    .fontColor(this.theme.textPrimary)
                    .width('100%')
                    .lineHeight(24)
                }
                .width('100%')
                .padding(16)
                .backgroundColor(this.theme.answerBg)
                .borderRadius(20)
                .margin({ top: 12 })
              }
            }
            .width('100%')
            .padding(24)
            .backgroundColor(this.theme.card)
            .borderRadius(16)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 4, bottom: 20 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .backgroundColor(this.theme.background)
        .opacity(this.cardOpacity)
        .translate({ y: this.cardOffset })
        .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })

        // 底部按钮
        Row({ space: 12 }) {
          if (!this.hasAnswered) {
            // 还未作答，无按钮
          } else if (this.hasAnswered && !this.isCompleted) {
            Button('完成打卡 ›')
              .layoutWeight(1)
              .height(52)
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.theme.success)
              .fontColor(this.theme.textOnPrimary)
              .borderRadius(26)
              .onClick(() => this.markDone())
          }
        }
        .width('100%')
        .padding(20)
        .backgroundColor(this.theme.card)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  @Builder
  OptionItem(option: string, index: number) {
    Row() {
      Text(this.optionLabel(index))
        .width(32)
        .height(32)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.optionLabelColor(index))
        .backgroundColor(this.optionCircleColor(index))
        .borderRadius(16)
        .textAlign(TextAlign.Center)
        .border({
          width: this.hasAnswered ? 0 : 1.5,
          color: this.hasAnswered ? 'rgba(0,0,0,0)' : this.theme.primary
        })

      Text(option)
        .fontSize(17)
        .fontColor(this.optionTextColor(index))
        .layoutWeight(1)
        .margin({ left: 12 })

      if (this.hasAnswered) {
        if (index === this.question.correctIndex) {
          Text('✓')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.success)
        } else if (index === this.selectedIndex) {
          Text('✗')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.error)
        }
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.optionBgColor(index))
    .borderRadius(12)
    .border({
      width: this.hasAnswered && (index === this.question.correctIndex || index === this.selectedIndex) ? 1.5 : 1,
      color: this.optionBorderColor(index)
    })
    .margin({ bottom: 12 })
    .stateStyles({
      pressed: { .scale({ x: 0.96, y: 0.96 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => this.onOptionClick(index))
  }

  optionLabel(index: number): string {
    return ['A', 'B', 'C', 'D', 'E', 'F'][index] || String(index + 1);
  }

  optionBgColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.optionDefaultBg;
    }
    if (index === this.question.correctIndex) {
      return this.theme.optionCorrectBg;
    }
    if (index === this.selectedIndex) {
      return this.theme.optionWrongBg;
    }
    return this.theme.optionDefaultBg;
  }

  optionBorderColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.divider;
    }
    if (index === this.question.correctIndex) {
      return this.theme.success;
    }
    if (index === this.selectedIndex) {
      return this.theme.error;
    }
    return this.theme.divider;
  }

  optionLabelColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.primary;
    }
    if (index === this.question.correctIndex || index === this.selectedIndex) {
      return this.theme.textOnPrimary;
    }
    return this.theme.primary;
  }

  optionTextColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.textPrimary;
    }
    if (index === this.question.correctIndex) {
      return this.theme.success;
    }
    if (index === this.selectedIndex) {
      return this.theme.error;
    }
    return this.theme.textSecondary;
  }

  optionCircleColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.optionDefaultBg;
    }
    if (index === this.question.correctIndex) {
      return this.theme.success;
    }
    if (index === this.selectedIndex) {
      return this.theme.error;
    }
    return this.theme.optionDefaultBg;
  }
}