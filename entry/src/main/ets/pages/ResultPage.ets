import common from '@ohos.app.ability.common';
import { questionBank } from '../data/QuestionBank';
import { HistoryStorage, createHistoryRecord } from '../data/HistoryStorage';
import { WrongBookStorage } from '../data/WrongBookStorage';
import { AchievementStorage } from '../data/AchievementStorage';
import { StatsStorage } from '../data/StatsStorage';
import { Difficulty, Question, QuestionType, Topic, QuizMode } from '../model/Question';
import { AppTheme, THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { formatTime } from '../utils/FormatUtil';
import hilog from '@ohos.hilog';

@Styles
function resultButtonPressedStyle() {
  .scale({ x: 0.97, y: 0.97 })
}

@Styles
function resultButtonNormalStyle() {
  .scale({ x: 1, y: 1 })
}

export interface ResultPageParams {
  topic: Topic;
  difficulty: Difficulty | 'mixed';
  answers: number[];
  questionIds: number[];
  selfAssessments?: ('pending' | 'correct' | 'wrong')[];
  elapsedSeconds?: number;
  mode?: QuizMode;
}

// 结果页：展示得分、错题回顾、再玩一次
@Component
export struct ResultPage {
  @Consume('pageStack') pageStack: NavPathStack
  public param: ResultPageParams = {
    topic: Topic.KNOWLEDGE,
    difficulty: Difficulty.ENTRY,
    answers: [],
    questionIds: []
  }
  @State theme: AppTheme = THEMES[0];
  @State userAnswers: number[] = [];
  @State currentQuestions: Question[] = [];
  @State selfAssessments: ('pending' | 'correct' | 'wrong')[] = [];
  @State correctCount: number = 0;
  @State score: number = 0;
  @State displayScore: number = 0;
  @State comment: string = '';
  @State wrongQuestions: Question[] = [];
  @State elapsedSeconds: number = 0;
  @State answeredCount: number = 0;
  @State topic: Topic = Topic.KNOWLEDGE;
  @State difficulty: Difficulty | 'mixed' = Difficulty.ENTRY;
  @State quizMode: QuizMode = QuizMode.NORMAL;
  // 入场动画
  @State headerOpacity: number = 0;
  @State headerScale: number = 0.9;
  @State statsOpacity: number = 0;
  @State statsOffset: number = 40;
  @State listOpacity: number = 0;
  // 分数计数动画定时器
  private scoreAnimTimerId: number = -1;
  // 页面跳转 setTimeout 句柄，页面销毁时统一清理
  private navTimerId1: number = -1;
  private navTimerId2: number = -1;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = ThemeManager.getCurrentTheme(context);
    const params = this.param;
    const topic = (params && params.topic) ? params.topic : Topic.KNOWLEDGE;
    const difficulty = (params && params.difficulty) ? params.difficulty : Difficulty.ENTRY;
    const answers = (params && params.answers) ? params.answers : [];
    const questionIds = (params && params.questionIds) ? params.questionIds : [];
    const selfAssessments = (params && params.selfAssessments) ? params.selfAssessments : [];
    const elapsed = (params && params.elapsedSeconds !== undefined) ? params.elapsedSeconds : 0;

    this.topic = topic;
    this.difficulty = difficulty;
    this.quizMode = (params && params.mode) ? params.mode : QuizMode.NORMAL;
    this.userAnswers = answers;
    this.selfAssessments = selfAssessments;
    this.elapsedSeconds = elapsed;

    const foundQuestions: Question[] = [];
    for (let i = 0; i < questionIds.length; i++) {
      const q = questionBank.find(item => item.id === questionIds[i]);
      if (q !== undefined) {
        foundQuestions.push(q);
      }
    }
    this.currentQuestions = foundQuestions;

    let count = 0;
    let answered = 0;
    const wrongs: Question[] = [];
    for (let i = 0; i < this.currentQuestions.length; i++) {
      const q = this.currentQuestions[i];
      let isAnswered = false;
      let isCorrect = false;
      if (q.type === QuestionType.SHORT_ANSWER) {
        isAnswered = this.selfAssessments[i] !== 'pending';
        isCorrect = this.selfAssessments[i] === 'correct';
      } else {
        isAnswered = this.userAnswers[i] !== -1;
        isCorrect = this.userAnswers[i] === q.correctIndex;
      }
      if (isAnswered) {
        answered++;
      }
      if (isCorrect) {
        count++;
      } else if (isAnswered) {
        wrongs.push(q);
      }
    }

    this.correctCount = count;
    this.answeredCount = answered;
    const totalForScore = this.quizMode === QuizMode.CHALLENGE || this.quizMode === QuizMode.TIME_ATTACK
      ? Math.max(1, answered)
      : this.currentQuestions.length;
    this.score = totalForScore > 0
      ? Math.round((count / totalForScore) * 100)
      : 0;
    this.wrongQuestions = wrongs;

    if (this.quizMode === QuizMode.CHALLENGE) {
      this.comment = count === this.currentQuestions.length
        ? '闯关成功！全部答对！'
        : `闯关结束，连续答对 ${count} 题`;
    } else if (this.quizMode === QuizMode.TIME_ATTACK) {
      this.comment = `限时挑战结束，答对 ${count} 题`;
    } else if (this.score === 100) {
      this.comment = '太厉害了！全部答对！';
    } else if (this.score >= 80) {
      this.comment = '很棒！知识储备丰富！';
    } else if (this.score >= 60) {
      this.comment = '不错，继续努力！';
    } else {
      this.comment = '加油，多多学习！';
    }

    // 保存答题历史记录（普通/闯关/限时模式）
    const isScoringMode = this.quizMode === QuizMode.NORMAL ||
      this.quizMode === QuizMode.CHALLENGE ||
      this.quizMode === QuizMode.TIME_ATTACK;
    if (isScoringMode) {
      this.saveHistoryRecord();
    }

    // 保存成就、错题本、主题通关等数据
    this.saveExtendedResults();

    // 触发入场动画与分数计数动画
    this.headerOpacity = 1;
    this.headerScale = 1;
    this.statsOpacity = 1;
    this.statsOffset = 0;
    this.listOpacity = 1;
    // 分数计数动画：从 0 逐步递增到最终分数，触发 displayScore 中间状态变化
    this.startScoreAnimation();
  }

  // 分数计数动画：在约 1 秒内从 0 递增到 score
  private startScoreAnimation() {
    this.displayScore = 0;
    if (this.score <= 0) {
      return;
    }
    const steps = Math.min(this.score, 20);
    const stepValue = Math.ceil(this.score / steps);
    const interval = Math.max(20, Math.floor(1000 / steps));
    let current = 0;
    this.scoreAnimTimerId = setInterval(() => {
      current += stepValue;
      if (current >= this.score) {
        this.displayScore = this.score;
        this.stopScoreAnimation();
      } else {
        this.displayScore = current;
      }
    }, interval);
  }

  private stopScoreAnimation() {
    if (this.scoreAnimTimerId !== -1) {
      clearInterval(this.scoreAnimTimerId);
      this.scoreAnimTimerId = -1;
    }
  }

  aboutToDisappear() {
    this.stopScoreAnimation();
    this.clearNavTimers();
  }

  // 清理页面跳转定时器，避免回调已销毁组件
  private clearNavTimers() {
    if (this.navTimerId1 !== -1) {
      clearTimeout(this.navTimerId1);
      this.navTimerId1 = -1;
    }
    if (this.navTimerId2 !== -1) {
      clearTimeout(this.navTimerId2);
      this.navTimerId2 = -1;
    }
  }

  // 格式化已用时间为 mm:ss
  formatElapsedTime(): string {
    return formatTime(this.elapsedSeconds);
  }

  // 保存本次答题记录到本地历史
  saveHistoryRecord() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // total 保存本次出题总数；answeredCount 保存实际已答题数，分别用于“总题数”与“正确率”统计
    const record = createHistoryRecord(
      this.topic,
      this.difficulty,
      this.score,
      this.correctCount,
      this.currentQuestions.length,
      this.answeredCount,
      this.elapsedSeconds
    );
    try {
      HistoryStorage.saveRecord(context, record);
    } catch (e) {
      hilog.error(0x0000, 'ResultPage', 'saveHistoryRecord failed');
    }
  }

  // 保存成就、错题本、主题通关等扩展数据
  saveExtendedResults() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    try {
      const wrongCount = this.answeredCount - this.correctCount;

      if (this.currentQuestions.length > 0) {
        // 计算本次最大连续答对
        let maxStreak = 0;
        let currentStreak = 0;
        for (let i = 0; i < this.currentQuestions.length; i++) {
          const q = this.currentQuestions[i];
          const isCorrect = q.type === QuestionType.SHORT_ANSWER
            ? this.selfAssessments[i] === 'correct'
            : this.userAnswers[i] === q.correctIndex;
          if (isCorrect) {
            currentStreak++;
            if (currentStreak > maxStreak) {
              maxStreak = currentStreak;
            }
          } else {
            currentStreak = 0;
          }
        }
        // 更新成就与连续打卡（错题本也计入）
        AchievementStorage.recordQuizResult(context, this.correctCount, wrongCount, this.score, maxStreak);

        // 仅普通模式标记主题通关进度
        if (this.quizMode === QuizMode.NORMAL && this.difficulty !== 'mixed') {
          StatsStorage.markDifficultyCompleted(context, this.topic, this.difficulty);
          const progress = StatsStorage.loadTopicProgress(context);
          const item = progress.find(p => p.topic === this.topic);
          if (item && item.entryCompleted && item.advancedCompleted && item.challengeCompleted) {
            AchievementStorage.recordTopicMastery(context, this.topic);
          }
        }
      }

    } catch (e) {
      hilog.error(0x0000, 'ResultPage', 'saveExtendedResults failed');
    }
  }

  build() {
    Column() {
      // 顶部得分区域
      Column() {
        Text(this.quizMode === QuizMode.CHALLENGE ? '闯关结束' : this.quizMode === QuizMode.TIME_ATTACK ? '挑战结束' : '答题完成')
          .fontSize(18)
          .fontColor('rgba(255,255,255,0.85)')
          .margin({ top: 50, bottom: 8 })

        Row() {
          Text(this.displayScore.toString())
            .fontSize(64)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textOnPrimary)
            .animation({
              duration: 1000,
              curve: Curve.EaseOut,
              delay: 200
            })
          Text('分')
            .fontSize(24)
            .fontColor('rgba(255,255,255,0.85)')
            .margin({ left: 4, bottom: 12 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Text(this.comment)
          .fontSize(18)
          .fontColor(this.theme.textOnPrimary)
          .margin({ top: 8 })
      }
      .width('100%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.theme.primary)
      .borderRadius({ bottomLeft: 28, bottomRight: 28 })
      .shadow({
        radius: 12,
        color: 'rgba(0,0,0,0.12)',
        offsetX: 0,
        offsetY: 6
      })
      .opacity(this.headerOpacity)
      .scale({ x: this.headerScale, y: this.headerScale })
      .animation({
        duration: 600,
        curve: Curve.EaseOut
      })

      // 统计数据条
      Row() {
        this.StatItem(`${this.correctCount}`, '答对')
        Divider().vertical(true).height(40).color(this.theme.divider)
        this.StatItem(`${this.answeredCount - this.correctCount}`, '答错')
        Divider().vertical(true).height(40).color(this.theme.divider)
        this.StatItem(
          `${this.answeredCount}`,
          this.quizMode === QuizMode.CHALLENGE || this.quizMode === QuizMode.TIME_ATTACK ? '已答' : '总题数'
        )
        Divider().vertical(true).height(40).color(this.theme.divider)
        this.StatItem(this.formatElapsedTime(), '用时')
      }
      .width('90%')
      .height(80)
      .backgroundColor(this.theme.card)
      .borderRadius(16)
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .margin({ top: -30 })
      .opacity(this.statsOpacity)
      .translate({ y: this.statsOffset })
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 200
      })

      // 错题回顾区域
      Scroll() {
        Column() {
          if (this.wrongQuestions.length === 0) {
            Column() {
              Text('全部答对！')
                .fontSize(18)
                .fontColor(this.theme.success)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .padding(40)
            .alignItems(HorizontalAlign.Center)
          } else {
            Text(`错题回顾（${this.wrongQuestions.length} 题）`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .margin({ bottom: 12 })

            ForEach(this.wrongQuestions, (q: Question) => {
              this.WrongItem(q, this.findQuestionIndex(q))
            }, (q: Question) => q.id.toString())
          }
        }
        .width('100%')
        .padding(20)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .opacity(this.listOpacity)
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 350
      })

      // 底部按钮
      Row({ space: 12 }) {
        Button('返回首页')
          .layoutWeight(1)
          .height(52)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.card)
          .fontColor(this.theme.primary)
          .border({ width: 2, color: this.theme.primary })
          .borderRadius(26)
          .stateStyles({
            pressed: resultButtonPressedStyle,
            normal: resultButtonNormalStyle
          })
          .onClick(() => {
            this.navTimerId1 = setTimeout(() => {
              this.navTimerId1 = -1;
              try {
                this.pageStack.clear();
              } catch (e) {
                hilog.error(0x0000, 'ResultPage', 'clear stack failed');
              }
            }, 50);
          })

        Button('再玩一次')
          .layoutWeight(1)
          .height(52)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.primary)
          .fontColor(this.theme.textOnPrimary)
          .borderRadius(26)
          .stateStyles({
            pressed: resultButtonPressedStyle,
            normal: resultButtonNormalStyle
          })
          .onClick(() => {
            this.navTimerId1 = setTimeout(() => {
              this.navTimerId1 = -1;
              try {
                this.pageStack.clear();
              } catch (e) {
                hilog.error(0x0000, 'ResultPage', 'clear stack failed');
              }
            }, 50);
            this.navTimerId2 = setTimeout(() => {
              this.navTimerId2 = -1;
              try {
                this.pageStack.pushPath({ name: 'TypeSelect' });
              } catch (e) {
                hilog.error(0x0000, 'ResultPage', 'push TypeSelect failed');
              }
            }, 150);
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor(this.theme.card)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  @Builder
  StatItem(num: string, label: string) {
    Column() {
      Text(num)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme.primary)
      Text(label)
        .fontSize(13)
        .fontColor(this.theme.textSecondary)
        .margin({ top: 2 })
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
  }

  // 根据错题查找它在本次答题中的原始题号
  findQuestionIndex(q: Question): number {
    for (let i = 0; i < this.currentQuestions.length; i++) {
      if (this.currentQuestions[i].id === q.id) {
        return i;
      }
    }
    return -1;
  }

  @Builder
  WrongItem(q: Question, index: number) {
    if (index >= 0 && index < this.currentQuestions.length) {
      Column() {
        Row() {
          Text(`第 ${index + 1} 题`)
            .fontSize(14)
            .fontColor(this.theme.textSecondary)
          Text(q.type === QuestionType.SINGLE_CHOICE ? '单选题' : q.type === QuestionType.TRUE_FALSE ? '判断题' : '简答题')
            .fontSize(14)
            .fontColor(this.theme.textSecondary)
            .margin({ left: 8 })
        }
        .width('100%')
        .margin({ bottom: 8 })

        Text(q.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme.textPrimary)
          .width('100%')
          .margin({ bottom: 12 })

        if (q.type === QuestionType.SHORT_ANSWER) {
          Row() {
            Text('你的自评：')
              .fontSize(14)
              .fontColor(this.theme.textSecondary)
            Text(this.selfAssessments[index] === 'correct' ? '答对' : '答错')
              .fontSize(14)
              .fontColor(this.selfAssessments[index] === 'correct' ? this.theme.success : this.theme.error)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .margin({ bottom: 4 })

          Row() {
            Text('参考答案：')
              .fontSize(14)
              .fontColor(this.theme.textSecondary)
            Text(q.explanation)
              .fontSize(14)
              .fontColor(this.theme.success)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 8 })
        } else {
          Row() {
            Text('你的答案：')
              .fontSize(14)
              .fontColor(this.theme.textSecondary)
            Text(index >= 0 && this.userAnswers[index] !== -1 ? q.options[this.userAnswers[index]] : '未作答')
              .fontSize(14)
              .fontColor(this.theme.error)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .margin({ bottom: 4 })

          Row() {
            Text('正确答案：')
              .fontSize(14)
              .fontColor(this.theme.textSecondary)
            Text(q.options[q.correctIndex])
              .fontSize(14)
              .fontColor(this.theme.success)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .margin({ bottom: 8 })
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.theme.card)
      .borderRadius(12)
      .margin({ bottom: 12 })
    } else {
      Blank()
    }
  }
}
