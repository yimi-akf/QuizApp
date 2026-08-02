import common from '@ohos.app.ability.common';
import { questionBank, findQuestionById } from '../data/QuestionBank';
import { ProgressStorage, ProgressInfo } from '../data/ProgressStorage';
import { Difficulty, Question, QuestionType, Topic, QuizMode } from '../model/Question';
import { ResultPageParams } from './ResultPage';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { ThemeManager } from '../data/ThemeManager';
import { WrongBookStorage } from '../data/WrongBookStorage';
import { FavoriteStorage } from '../data/FavoriteStorage';
import { formatTime, topicShortLabel, difficultyLabel as utilDifficultyLabel, difficultyColor } from '../utils/FormatUtil';
import { shuffleArray } from '../utils/ArrayUtil';
import { SkeletonCard } from '../components/SkeletonCard';
import hilog from '@ohos.hilog';

const EMPTY_QUESTION: Question = {
  id: 0,
  type: QuestionType.SINGLE_CHOICE,
  difficulty: Difficulty.ENTRY,
  topic: Topic.KNOWLEDGE,
  title: '暂无题目',
  options: [],
  correctIndex: -1,
  explanation: '该分类下暂时没有题目，请选择其他类型或难度。'
};

const TIME_ATTACK_TOTAL_SECONDS = 60;

@Styles
function optionPressedStyle() {
  .scale({ x: 0.96, y: 0.96 })
  .opacity(0.85)
}

@Styles
function optionNormalStyle() {
  .scale({ x: 1, y: 1 })
  .opacity(1)
}

@Styles
function quizButtonPressedStyle() {
  .scale({ x: 0.97, y: 0.97 })
  .opacity(0.9)
}

@Styles
function quizButtonNormalStyle() {
  .scale({ x: 1, y: 1 })
}

export interface QuizPageParams {
  topic: Topic;
  difficulty: Difficulty | 'mixed';
  shouldContinue?: boolean;
  questionIds?: number[];
  mode?: QuizMode;
}

// 答题页：按选择的类型和难度加载题目，逐题作答
@Component
export struct QuizPage {
  @Consume('pageStack') pageStack: NavPathStack
  @State theme: AppTheme = THEMES[0];
  @StorageLink('quizThemeIndex') @Watch('onDarkModeChange') themeIndex: number = 0;
  @StorageLink('quizDarkMode') @Watch('onDarkModeChange') darkMode: boolean = false;
  public param: QuizPageParams = { topic: Topic.KNOWLEDGE, difficulty: Difficulty.ENTRY }
  // 当前轮次题目
  @State currentQuestions: Question[] = [];
  // 当前选择的主题与难度（用于存档 key）
  @State selectedTopic: Topic = Topic.KNOWLEDGE;
  @State selectedDifficulty: Difficulty | 'mixed' = Difficulty.ENTRY;
  // 答题模式
  @State quizMode: QuizMode = QuizMode.NORMAL;
  // 限时模式剩余秒数
  @State timeAttackRemaining: number = TIME_ATTACK_TOTAL_SECONDS;
  private timeAttackTimerId: number = -1;
  // 限时/闯关模式是否已结束
  @State isSpecialModeFinished: boolean = false;
  // 当前题目索引（从 0 开始）
  @State currentIndex: number = 0;
  // 用户每道题的选择，-1 表示未作答
  @State userAnswers: number[] = [];
  // 当前题是否已作答
  @State hasAnswered: boolean = false;
  // 简答题自评结果：pending / correct / wrong
  @State selfAssessments: ('pending' | 'correct' | 'wrong')[] = [];
  // 简答题是否已经查看过答案
  @State viewedAnswers: boolean[] = [];
  // 简答题答案卡片动画
  @State answerCardOpacity: number = 0;
  // 简答题反馈动画
  @State feedbackOpacity: number = 0;
  @State feedbackScale: number = 0.8;
  // 答题计时
  @State elapsedSeconds: number = 0;
  private timerId: number = -1;
  // 题目切换动画与自动下一题的 setTimeout 句柄，页面销毁时统一清理
  private animationTimerId: number = -1;
  private autoNextTimerId: number = -1;
  // 题目切换动画
  @State cardOpacity: number = 1;
  @State cardOffset: number = 0;
  // 入场动画
  @State headerOpacity: number = 0;
  @State headerOffset: number = -20;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 30;
  // 当前题目收藏状态
  @State isFavorite: boolean = false;
  @State isLoading: boolean = true;
  // 长按收藏触发后短期锁定选项点击，防止松手时误触发 onOptionClick
  private longPressLockUntil: number = 0;

  aboutToAppear() {
    const params = this.param;
    const topic = params && params.topic ? params.topic : Topic.KNOWLEDGE;
    const difficulty = params && params.difficulty ? params.difficulty : Difficulty.ENTRY;
    const isContinue = !!(params && params.shouldContinue);
    const providedIds = params && params.questionIds ? params.questionIds : [];
    const mode = params && params.mode ? params.mode : QuizMode.NORMAL;
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;

    this.theme = ThemeManager.getCurrentTheme(context);
    this.selectedTopic = topic;
    this.selectedDifficulty = difficulty;
    this.quizMode = mode;

    // 按类型和难度过滤
    let filtered = questionBank.filter(q => q.topic === topic);
    if (difficulty !== 'mixed') {
      filtered = filtered.filter(q => q.difficulty === difficulty);
    }

    if (mode === QuizMode.WRONG_BOOK || providedIds.length > 0) {
      // 错题本/收藏等：使用指定题目 ID
      const restored: Question[] = [];
      for (let i = 0; i < providedIds.length; i++) {
        const q = findQuestionById(providedIds[i]);
        if (q !== undefined) {
          restored.push(q);
        }
      }
      this.currentQuestions = restored.length > 0 ? restored : shuffleArray(filtered);
      this.userAnswers = new Array(this.currentQuestions.length).fill(-1);
      this.selfAssessments = new Array(this.currentQuestions.length).fill('pending');
      this.viewedAnswers = new Array(this.currentQuestions.length).fill(false);
    } else if (isContinue) {
      // 继续上次进度
      const saved = ProgressStorage.loadProgress(context, topic, difficulty);
      if (saved && saved.questionIds && saved.questionIds.length > 0) {
        // 按存档中的题目 ID 顺序恢复题目列表，保证答案对应关系正确
        const restored: Question[] = [];
        for (let i = 0; i < saved.questionIds.length; i++) {
          const q = filtered.find(item => item.id === saved.questionIds[i]);
          if (q !== undefined) {
            restored.push(q);
          }
        }
        // 如果恢复失败则回退到重新洗牌
        this.currentQuestions = restored.length > 0 ? restored : shuffleArray(filtered);
        const normalized = this.normalizeSavedProgress(saved, this.currentQuestions);
        this.currentIndex = normalized.currentIndex;
        this.userAnswers = normalized.userAnswers;
        this.selfAssessments = normalized.selfAssessments;
        this.viewedAnswers = normalized.viewedAnswers;
        this.syncAnswerState();
      } else if (saved) {
        // 旧版存档没有 questionIds，回退到重新洗牌并保留进度
        this.currentQuestions = shuffleArray(filtered);
        const normalized = this.normalizeSavedProgress(saved, this.currentQuestions);
        this.currentIndex = normalized.currentIndex;
        this.userAnswers = normalized.userAnswers;
        this.selfAssessments = normalized.selfAssessments;
        this.viewedAnswers = normalized.viewedAnswers;
        this.syncAnswerState();
      } else {
        // 没有存档则重新开始
        this.currentQuestions = shuffleArray(filtered);
        this.userAnswers = new Array(this.currentQuestions.length).fill(-1);
        this.selfAssessments = new Array(this.currentQuestions.length).fill('pending');
        this.viewedAnswers = new Array(this.currentQuestions.length).fill(false);
        ProgressStorage.clearProgress(context, topic, difficulty);
      }
    } else {
      // 新游戏：打乱顺序并清空旧存档
      this.currentQuestions = shuffleArray(filtered);
      this.userAnswers = new Array(this.currentQuestions.length).fill(-1);
      this.selfAssessments = new Array(this.currentQuestions.length).fill('pending');
      this.viewedAnswers = new Array(this.currentQuestions.length).fill(false);
      ProgressStorage.clearProgress(context, topic, difficulty);
    }

    // 启动答题计时器
    this.startTimer();

    // 限时模式启动倒计时
    if (this.quizMode === QuizMode.TIME_ATTACK) {
      this.timeAttackRemaining = TIME_ATTACK_TOTAL_SECONDS;
      this.startTimeAttackTimer();
    }

    // 触发入场动画
    this.headerOpacity = 1;
    this.headerOffset = 0;
    this.contentOpacity = 1;
    this.contentOffset = 0;

    // 初始化收藏状态
    this.loadFavoriteState();
    this.isLoading = false;
  }

  onDarkModeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
  }

  // 加载当前题目的收藏状态
  loadFavoriteState() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const q = this.currentQuestion();
    if (!context || q.id <= 0) {
      this.isFavorite = false;
      hilog.warn(0x0001, 'QuizPage', `loadFavoriteState skipped, context=${!!context}, id=${q.id}`);
      return;
    }
    this.isFavorite = FavoriteStorage.isFavorite(context, q.id);
    hilog.info(0x0001, 'QuizPage', `loadFavoriteState id=${q.id}, favorite=${this.isFavorite}`);
  }

  // 切换当前题目收藏状态
  toggleFavorite() {
    const q = this.currentQuestion();
    if (q.id <= 0) {
      hilog.warn(0x0001, 'QuizPage', `toggleFavorite skipped, invalid id=${q.id}`);
      return;
    }
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    if (!context) {
      hilog.error(0x0001, 'QuizPage', 'toggleFavorite failed: context is null');
      return;
    }
    this.isFavorite = FavoriteStorage.toggleFavorite(context, q.id);
    hilog.info(0x0001, 'QuizPage', `toggleFavorite id=${q.id}, favorite=${this.isFavorite}`);
  }

  // 启动计时器
  startTimer() {
    this.stopTimer();
    this.timerId = setInterval(() => {
      this.elapsedSeconds++;
    }, 1000);
  }

  // 停止计时器
  stopTimer() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  // 启动限时模式倒计时
  startTimeAttackTimer() {
    this.stopTimeAttackTimer();
    this.timeAttackTimerId = setInterval(() => {
      this.timeAttackRemaining--;
      if (this.timeAttackRemaining <= 0) {
        this.finishTimeAttack();
        return;
      }
    }, 1000);
  }

  // 停止限时模式倒计时
  stopTimeAttackTimer() {
    if (this.timeAttackTimerId !== -1) {
      clearInterval(this.timeAttackTimerId);
      this.timeAttackTimerId = -1;
    }
  }

  // 限时模式结束
  finishTimeAttack() {
    if (this.isSpecialModeFinished) {
      return;
    }
    this.isSpecialModeFinished = true;
    this.stopTimeAttackTimer();
    this.stopTimer();
    try {
      this.pageStack.pushPath({
        name: 'Result',
        param: {
          topic: this.selectedTopic,
          difficulty: this.selectedDifficulty,
          answers: this.userAnswers,
          questionIds: this.currentQuestions.map(q => q.id),
          selfAssessments: this.selfAssessments,
          elapsedSeconds: TIME_ATTACK_TOTAL_SECONDS - this.timeAttackRemaining,
          mode: this.quizMode
        } as ResultPageParams
      });
    } catch (e) {
      hilog.error(0x0001, 'QuizPage', 'navigate to Result failed: %{public}s', JSON.stringify(e));
    }
  }

  // 格式化已用时间为 mm:ss
  formatElapsedTime(): string {
    return `已用 ${formatTime(this.elapsedSeconds)}`;
  }

  // 限时模式倒计时颜色：剩余 10 秒以内使用 error 色提示
  timeAttackColor(): string {
    if (this.quizMode === QuizMode.TIME_ATTACK && this.timeAttackRemaining <= 10) {
      return this.theme.error;
    }
    return this.theme.primary;
  }

  timerBgColor(): string {
    if (this.quizMode === QuizMode.TIME_ATTACK && this.timeAttackRemaining <= 10) {
      return this.theme.timerWarningBg;
    }
    return this.theme.timerBg;
  }

  // 当前题目自评结果
  selfAssessment(): 'pending' | 'correct' | 'wrong' {
    if (this.currentIndex < 0 || this.currentIndex >= this.selfAssessments.length) {
      return 'pending';
    }
    return this.selfAssessments[this.currentIndex] ?? 'pending';
  }

  // 当前题目自评反馈颜色
  selfAssessmentColor(): string {
    return this.selfAssessment() === 'correct' ? this.theme.success : this.theme.warning;
  }

  // 下一题/结束按钮文案
  nextButtonText(): string {
    if (this.currentIndex < this.currentQuestions.length - 1) {
      return '下一题';
    }
    return this.quizMode === QuizMode.TIME_ATTACK ? '结束挑战' : '查看结果';
  }

  // 页面销毁时停止计时
  aboutToDisappear() {
    this.stopTimer();
    this.stopTimeAttackTimer();
    this.clearAnimationTimers();
    // 通知主页刷新"继续上次进度"卡片（Tab 未切换时 onWillShow 不触发）
    AppStorage.setOrCreate('homeTabShowTrigger', Date.now());
  }

  // 清理题目切换与自动下一题的 setTimeout，避免回调已销毁组件
  clearAnimationTimers() {
    if (this.animationTimerId !== -1) {
      clearTimeout(this.animationTimerId);
      this.animationTimerId = -1;
    }
    if (this.autoNextTimerId !== -1) {
      clearTimeout(this.autoNextTimerId);
      this.autoNextTimerId = -1;
    }
  }

  // 调度限时模式自动下一题：先清理旧 timer 再设置新 timer，防止并发覆盖导致悬挂回调
  private scheduleAutoNext(delay: number) {
    if (this.autoNextTimerId !== -1) {
      clearTimeout(this.autoNextTimerId);
      this.autoNextTimerId = -1;
    }
    this.autoNextTimerId = setTimeout((): void => {
      this.autoNextTimerId = -1;
      this.autoNext();
    }, delay);
  }

  // 校验恢复后的进度数据，防止题库变化导致数组越界
  private normalizeSavedProgress(saved: ProgressInfo, questions: Question[]): ProgressInfo {
    const total = questions.length;
    let currentIndex = saved.currentIndex;
    if (currentIndex < 0) {
      currentIndex = 0;
    } else if (currentIndex >= total) {
      currentIndex = total > 0 ? total - 1 : 0;
    }

    const padAnswers = (arr: number[], defaultValue: number): number[] => {
      if (arr.length === total) {
        return arr.slice();
      }
      const result: number[] = new Array(total).fill(defaultValue);
      for (let i = 0; i < Math.min(arr.length, total); i++) {
        result[i] = arr[i];
      }
      return result;
    };

    const padAssessments = (arr: ('pending' | 'correct' | 'wrong')[]): ('pending' | 'correct' | 'wrong')[] => {
      if (arr.length === total) {
        return arr.slice();
      }
      const result: ('pending' | 'correct' | 'wrong')[] = new Array(total).fill('pending');
      for (let i = 0; i < Math.min(arr.length, total); i++) {
        result[i] = arr[i];
      }
      return result;
    };

    const padBoolean = (arr: boolean[]): boolean[] => {
      if (arr.length === total) {
        return arr.slice();
      }
      const result: boolean[] = new Array(total).fill(false);
      for (let i = 0; i < Math.min(arr.length, total); i++) {
        result[i] = arr[i];
      }
      return result;
    };

    return {
      topic: saved.topic,
      difficulty: saved.difficulty,
      currentIndex: currentIndex,
      questionIds: saved.questionIds,
      userAnswers: padAnswers(saved.userAnswers, -1),
      selfAssessments: padAssessments(saved.selfAssessments),
      viewedAnswers: padBoolean(saved.viewedAnswers)
    };
  }

  // 获取当前题目
  currentQuestion(): Question {
    if (this.currentQuestions.length === 0
      || this.currentIndex < 0
      || this.currentIndex >= this.currentQuestions.length) {
      return EMPTY_QUESTION;
    }
    return this.currentQuestions[this.currentIndex];
  }

  // 点击选项
  onOptionClick(optionIndex: number) {
    if (this.hasAnswered || this.currentQuestions.length === 0) {
      return;
    }
    // 长按收藏触发后短期锁定，防止松手时误触发选项点击
    if (this.longPressLockUntil > 0 && Date.now() < this.longPressLockUntil) {
      return;
    }
    // 用新数组替换触发 @State 刷新，避免直接修改数组元素不刷新
    const newAnswers = [...this.userAnswers];
    newAnswers[this.currentIndex] = optionIndex;
    this.userAnswers = newAnswers;
    this.hasAnswered = true;
    this.recordAnswerResult(optionIndex === this.currentQuestion().correctIndex);
    this.persistProgress();
  }

  // 简答题点击“查看答案”
  onShortAnswerClick() {
    if (this.viewedAnswers[this.currentIndex]) {
      return;
    }
    const newViewed = [...this.viewedAnswers];
    newViewed[this.currentIndex] = true;
    this.viewedAnswers = newViewed;
    this.hasAnswered = true;
    this.answerCardOpacity = 1;
    this.persistProgress();
  }

  // 简答题自评：答对
  onSelfCorrect() {
    if (this.selfAssessments[this.currentIndex] !== 'pending') {
      return;
    }
    const newAssessments = [...this.selfAssessments];
    newAssessments[this.currentIndex] = 'correct';
    this.selfAssessments = newAssessments;
    this.feedbackOpacity = 1;
    this.feedbackScale = 1;
    this.recordAnswerResult(true);
    this.persistProgress();
    // 限时模式自评后自动跳下一题
    if (this.quizMode === QuizMode.TIME_ATTACK) {
      this.scheduleAutoNext(800);
    }
  }

  // 简答题自评：答错
  onSelfWrong() {
    if (this.selfAssessments[this.currentIndex] !== 'pending') {
      return;
    }
    const newAssessments = [...this.selfAssessments];
    newAssessments[this.currentIndex] = 'wrong';
    this.selfAssessments = newAssessments;
    this.feedbackOpacity = 1;
    this.feedbackScale = 1;
    this.recordAnswerResult(false);
    this.persistProgress();
    // 限时模式自评后自动跳下一题
    if (this.quizMode === QuizMode.TIME_ATTACK) {
      this.scheduleAutoNext(800);
    }
  }

  // 记录答题结果（错题本、闯关、限时、练习）
  private recordAnswerResult(isCorrect: boolean) {
    if (this.currentQuestions.length === 0) {
      return;
    }
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const q = this.currentQuestion();
    // 普通模式、闯关模式、限时模式答错：加入错题本
    if ((this.quizMode === QuizMode.NORMAL || this.quizMode === QuizMode.CHALLENGE || this.quizMode === QuizMode.TIME_ATTACK) && !isCorrect) {
      WrongBookStorage.addWrong(context, q.id);
    }
    // 错题本模式答对：累计连续答对次数
    if (this.quizMode === QuizMode.WRONG_BOOK && isCorrect) {
      WrongBookStorage.addCorrect(context, q.id);
    }
    // 错题本模式答错：重置连续答对次数
    if (this.quizMode === QuizMode.WRONG_BOOK && !isCorrect) {
      WrongBookStorage.addWrong(context, q.id);
    }
    // 闯关模式答错：立即结束
    if (this.quizMode === QuizMode.CHALLENGE && !isCorrect) {
      this.finishChallenge();
      return;
    }
    // 限时模式：答对自动进入下一题（简答题在自评方法中处理），答错也自动跳过
    if (this.quizMode === QuizMode.TIME_ATTACK) {
      if (q.type !== QuestionType.SHORT_ANSWER) {
        const delay = isCorrect ? 600 : 1000;
        this.scheduleAutoNext(delay);
      }
    }
  }

  // 闯关模式结束
  finishChallenge() {
    if (this.isSpecialModeFinished) {
      return;
    }
    this.isSpecialModeFinished = true;
    this.stopTimer();
    this.stopTimeAttackTimer();
    try {
      this.pageStack.pushPath({
        name: 'Result',
        param: {
          topic: this.selectedTopic,
          difficulty: this.selectedDifficulty,
          answers: this.userAnswers,
          questionIds: this.currentQuestions.map(q => q.id),
          selfAssessments: this.selfAssessments,
          elapsedSeconds: this.elapsedSeconds,
          mode: this.quizMode
        } as ResultPageParams
      });
    } catch (e) {
      hilog.error(0x0001, 'QuizPage', 'navigate to Result failed: %{public}s', JSON.stringify(e));
    }
  }

  // 自动进入下一题（用于限时模式）
  private autoNext() {
    if (this.isSpecialModeFinished) {
      return;
    }
    if (this.currentQuestions.length === 0) {
      return;
    }
    if (this.currentIndex < this.currentQuestions.length - 1) {
      this.changeQuestion(this.currentIndex + 1, 1);
    } else {
      // 已答完所有题目，提前结束限时模式
      this.finishTimeAttack();
    }
  }

  // 是否可以进入下一题（简答题需要完成自评）
  canGoNext(): boolean {
    if (this.currentQuestions.length === 0) {
      return true;
    }
    if (!this.hasAnswered) {
      return false;
    }
    if (this.currentQuestion().type === QuestionType.SHORT_ANSWER) {
      return this.selfAssessments[this.currentIndex] !== 'pending';
    }
    return true;
  }

  // 持久化当前进度
  persistProgress() {
    if (this.currentQuestions.length === 0 || this.quizMode !== QuizMode.NORMAL) {
      return;
    }
    // 收藏练习通过 questionIds 传入题目，与普通模式存档键相同，跳过持久化避免覆盖普通模式进度
    if (this.param.questionIds && this.param.questionIds.length > 0) {
      return;
    }
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ProgressStorage.saveProgress(context, {
      topic: this.selectedTopic,
      difficulty: this.selectedDifficulty,
      currentIndex: this.currentIndex,
      questionIds: this.currentQuestions.map(q => q.id),
      userAnswers: this.userAnswers,
      selfAssessments: this.selfAssessments,
      viewedAnswers: this.viewedAnswers
    });
  }

  // 同步当前题目的作答状态与动画
  syncAnswerState() {
    if (this.currentQuestions.length === 0) {
      this.hasAnswered = false;
      this.answerCardOpacity = 0;
      this.feedbackOpacity = 0;
      this.feedbackScale = 0.8;
      return;
    }
    if (this.currentQuestion().type === QuestionType.SHORT_ANSWER) {
      this.hasAnswered = this.viewedAnswers[this.currentIndex];
      if (this.hasAnswered) {
        this.answerCardOpacity = 1;
        if (this.selfAssessments[this.currentIndex] !== 'pending') {
          this.feedbackOpacity = 1;
          this.feedbackScale = 1;
        } else {
          this.feedbackOpacity = 0;
          this.feedbackScale = 0.8;
        }
      } else {
        this.answerCardOpacity = 0;
        this.feedbackOpacity = 0;
        this.feedbackScale = 0.8;
      }
    } else {
      this.hasAnswered = this.userAnswers[this.currentIndex] !== -1;
      this.answerCardOpacity = 0;
      this.feedbackOpacity = 0;
      this.feedbackScale = 0.8;
    }
  }

  // 上一题
  onPrevious() {
    if (this.currentIndex > 0) {
      this.changeQuestion(this.currentIndex - 1, -1);
    }
  }

  // 下一题或查看结果
  onNext() {
    // 限时/闯关模式已结束时不再跳转，防止重复弹出结果页
    if (this.isSpecialModeFinished) {
      return;
    }
    if (this.currentQuestions.length === 0) {
      // 空题库：跳转结果页显示"暂无题目"提示，而非无声息地返回首页
      this.stopTimer();
      this.stopTimeAttackTimer();
      this.clearAnimationTimers();
      try {
        this.pageStack.pushPath({
          name: 'Result',
          param: {
            topic: this.selectedTopic,
            difficulty: this.selectedDifficulty,
            answers: [],
            questionIds: [],
            selfAssessments: [],
            elapsedSeconds: this.elapsedSeconds,
            mode: this.quizMode,
            isEmptyQuiz: true
          } as ResultPageParams
        });
      } catch (e) {
        hilog.error(0x0001, 'QuizPage', 'navigate to Result (empty) failed: %{public}s', JSON.stringify(e));
      }
      return;
    }
    if (this.currentIndex < this.currentQuestions.length - 1) {
      this.changeQuestion(this.currentIndex + 1, 1);
    } else {
      // 答题完成，停止计时并清除本局进度
      // 标记限时/闯关模式已结束，防止挂起的 autoNext 定时器再次触发 finishTimeAttack 导致结果页重复弹出
      if (this.quizMode === QuizMode.TIME_ATTACK || this.quizMode === QuizMode.CHALLENGE) {
        this.isSpecialModeFinished = true;
      }
      // 清理可能挂起的 autoNext / 题目切换定时器，避免回调已导航的页面
      this.clearAnimationTimers();
      this.stopTimer();
      this.stopTimeAttackTimer();
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      if (this.quizMode === QuizMode.NORMAL && !(this.param.questionIds && this.param.questionIds.length > 0)) {
        ProgressStorage.clearProgress(context, this.selectedTopic, this.selectedDifficulty);
        // 同时清除首页“继续上次进度”卡片，避免完成后仍显示旧进度
        ProgressStorage.clearLastProgress(context);
      }
      try {
        this.pageStack.pushPath({
          name: 'Result',
          param: {
            topic: this.selectedTopic,
            difficulty: this.selectedDifficulty,
            answers: this.userAnswers,
            questionIds: this.currentQuestions.map(q => q.id),
            selfAssessments: this.selfAssessments,
            elapsedSeconds: this.elapsedSeconds,
            mode: this.quizMode
          } as ResultPageParams
        });
      } catch (e) {
        hilog.error(0x0001, 'QuizPage', 'navigate to Result failed: %{public}s', JSON.stringify(e));
      }
    }
  }

  // 带动画的题目切换
  changeQuestion(targetIndex: number, direction: number) {
    this.clearAnimationTimers();
    this.cardOpacity = 0;
    this.cardOffset = direction * 25;
    this.animationTimerId = setTimeout(() => {
      this.animationTimerId = -1;
      this.currentIndex = targetIndex;
      this.syncAnswerState();
      this.persistProgress();
      this.loadFavoriteState();
      this.cardOffset = -direction * 10;
      this.animationTimerId = setTimeout(() => {
        this.animationTimerId = -1;
        this.cardOffset = 0;
        this.cardOpacity = 1;
      }, 40);
    }, 200);
  }

  build() {
    Column() {
      if (this.isLoading) {
        SkeletonCard({ theme: this.theme })
      } else {
      this.ProgressBar()

      Scroll() {
        Column() {
          this.QuestionCard()
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding(20)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .opacity(this.contentOpacity)
      .translate({ y: this.contentOffset })
      .animation({
        duration: 600,
        curve: Curve.EaseOut,
        delay: 150
      })
      .gesture(
        SwipeGesture({ speed: 0.3, direction: SwipeDirection.Horizontal })
          .onAction((event: GestureEvent) => {
            // angle 与水平正方向夹角，左滑约±180°，右滑约0°
            if (Math.abs(event.angle) > 90) {
              // 向左滑 → 下一题
              if (this.canGoNext()) {
                this.onNext();
              }
            } else {
              // 向右滑 → 上一题
              this.onPrevious();
            }
          })
      )

      this.BottomButton()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }

  @Builder
  ProgressBar() {
    Column() {
      Row() {
        Text(`第 ${this.currentIndex + 1} / ${this.currentQuestions.length} 题`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.textPrimary)

        Row({ space: 8 }) {
          Text(this.topicLabel(this.currentQuestion().topic))
            .fontSize(12)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.primary)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .borderRadius(8)

          Text(this.difficultyLabel(this.currentQuestion().difficulty))
            .fontSize(12)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(difficultyColor(this.theme, this.currentQuestion().difficulty))
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .borderRadius(8)

          Text(this.typeLabel(this.currentQuestion().type))
            .fontSize(12)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.textSecondary)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .borderRadius(8)

          Text(this.quizMode === QuizMode.TIME_ATTACK ? `剩余 ${this.timeAttackRemaining}s` : this.formatElapsedTime())
            .fontSize(12)
            .fontColor(this.timeAttackColor())
            .fontWeight(FontWeight.Medium)
            .backgroundColor(this.timerBgColor())
            .padding({ left: 10, right: 10, top: 4, bottom: 4 })
            .borderRadius(10)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Progress({
        value: this.currentIndex + (this.hasAnswered ? 1 : 0),
        total: this.currentQuestions.length,
        type: ProgressType.Linear
      })
        .width('100%')
        .color(this.theme.primary)
        .backgroundColor(this.theme.divider)
        .margin({ top: 12 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor(this.theme.card)
    .opacity(this.headerOpacity)
    .translate({ y: this.headerOffset })
    .animation({
      duration: 500,
      curve: Curve.EaseOut
    })
  }

  @Builder
  QuestionCard() {
    Column() {
      // 收藏按钮：放在题目卡片右上角，醒目且易于点击
      Row() {
        Blank()

        Button() {
          Row({ space: 4 }) {
            Text(this.isFavorite ? '★' : '☆')
              .fontSize(16)
              .fontColor(this.isFavorite ? this.theme.warning : this.theme.textSecondary)

            Text(this.isFavorite ? '已收藏' : '收藏')
              .fontSize(13)
              .fontColor(this.isFavorite ? this.theme.warning : this.theme.textSecondary)
          }
        }
        .height(32)
        .backgroundColor('transparent')
        .stateStyles({
          pressed: { .scale({ x: 0.92, y: 0.92 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .onClick(() => this.toggleFavorite())
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(this.currentQuestion().title)
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.theme.textPrimary)
        .width('100%')
        .margin({ bottom: 24, top: 8 })

      if (this.currentQuestion().type === QuestionType.SHORT_ANSWER) {
        this.ShortAnswerCard()
      } else {
        ForEach(this.currentQuestion().options, (option: string, index: number) => {
          this.OptionItem(option, index)
        }, (option: string, index: number) => 'q' + this.currentIndex + '-' + index)

        if (this.hasAnswered && this.currentQuestions.length > 0) {
          this.ExplanationCard()
        }
      }
    }
    .width('100%')
    .padding(24)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .opacity(this.cardOpacity)
    .translate({ y: this.cardOffset })
    .animation({
      duration: 250,
      curve: Curve.EaseOut
    })
    .gesture(
      LongPressGesture({ duration: 500 })
        .onAction(() => {
          hilog.info(0x0001, 'QuizPage', 'long press toggle favorite');
          this.toggleFavorite();
          // 长按触发后锁定 400ms，防止松手时误触发选项 onClick
          this.longPressLockUntil = Date.now() + 400;
        })
    )
  }

  @Builder
  ExplanationCard() {
    Column() {
      Row() {
        Text('解析')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.success)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(this.currentQuestion().explanation)
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

  @Builder
  ShortAnswerCard() {
    Column() {
      if (!this.hasAnswered) {
        Button('查看答案')
          .width('100%')
          .height(52)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.theme.primary)
          .fontColor(this.theme.textOnPrimary)
          .borderRadius(26)
          .onClick(() => this.onShortAnswerClick())
      } else {
        Column() {
          Row() {
            Text('答案')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.success)
          }
          .width('100%')
          .margin({ bottom: 8 })

          Text(this.currentQuestion().explanation)
            .fontSize(15)
            .fontColor(this.theme.textPrimary)
            .width('100%')
            .lineHeight(24)
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.theme.answerBg)
        .borderRadius(20)
        .opacity(this.answerCardOpacity)
        .animation({
          duration: 400,
          curve: Curve.EaseOut
        })

        if (this.selfAssessments[this.currentIndex] === 'pending') {
          Row({ space: 12 }) {
            Button('我答对了！')
              .layoutWeight(1)
              .height(46)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.theme.success)
              .fontColor(this.theme.textOnPrimary)
              .borderRadius(23)
              .onClick(() => this.onSelfCorrect())

            Button('我答错了')
              .layoutWeight(1)
              .height(46)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .backgroundColor(this.theme.error)
              .fontColor(this.theme.textOnPrimary)
              .borderRadius(23)
              .onClick(() => this.onSelfWrong())
          }
          .width('100%')
          .margin({ top: 16 })
          .opacity(this.answerCardOpacity)
          .animation({
            duration: 400,
            curve: Curve.EaseOut,
            delay: 150
          })
        } else {
          Column() {
            Text(this.selfAssessment() === 'correct' ? '恭喜 🎉' : '再接再厉 💪')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.selfAssessment() === 'correct' ? this.theme.success : this.theme.warning)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(this.selfAssessment() === 'correct' ? this.theme.feedbackCorrectBg : this.theme.feedbackWrongBg)
          .borderRadius(20)
          .margin({ top: 16 })
          .opacity(this.feedbackOpacity)
          .scale({ x: this.feedbackScale, y: this.feedbackScale })
          .animation({
            duration: 400,
            curve: Curve.EaseOut
          })
        }
      }
    }
    .width('100%')
  }

  @Builder
  OptionItem(option: string, index: number) {
    Row() {
      Text(this.OptionLabel(index))
        .width(32)
        .height(32)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.OptionLabelColor(index))
        .backgroundColor(this.OptionCircleColor(index))
        .borderRadius(16)
        .textAlign(TextAlign.Center)
        .border({
          width: this.OptionCircleBorderWidth(index),
          color: this.OptionCircleBorderColor(index)
        })

      Text(option)
        .fontSize(17)
        .fontColor(this.OptionAnswerTextColor(index))
        .layoutWeight(1)
        .margin({ left: 12 })

      if (this.hasAnswered) {
        if (index === this.currentQuestion().correctIndex) {
          Text('✓')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.success)
        } else if (index === this.userAnswers[this.currentIndex]) {
          Text('✗')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.error)
        }
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.OptionBgColor(index))
    .borderRadius(12)
    .border({
      width: this.OptionBorderWidth(index),
      color: this.OptionBorderColor(index)
    })
    .margin({ bottom: 12 })
    .stateStyles({
      pressed: optionPressedStyle,
      normal: optionNormalStyle
    })
    .onClick(() => this.onOptionClick(index))
  }

  OptionBgColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.optionDefaultBg;
    }
    if (index === this.currentQuestion().correctIndex) {
      return this.theme.optionCorrectBg;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return this.theme.optionWrongBg;
    }
    return this.theme.optionDefaultBg;
  }

  OptionBorderWidth(index: number): number {
    if (!this.hasAnswered) {
      return 1;
    }
    if (index === this.currentQuestion().correctIndex) {
      return 1.5;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return 1.5;
    }
    return 1;
  }

  OptionBorderColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.divider;
    }
    if (index === this.currentQuestion().correctIndex) {
      return this.theme.success;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return this.theme.error;
    }
    return this.theme.divider;
  }

  OptionCircleBorderWidth(index: number): number {
    if (!this.hasAnswered) {
      return 1.5;
    }
    return 0;
  }

  OptionCircleBorderColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.primary;
    }
    return 'rgba(0,0,0,0)';
  }

  OptionLabelColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.primary;
    }
    if (index === this.currentQuestion().correctIndex) {
      return this.theme.textOnPrimary;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return this.theme.textOnPrimary;
    }
    return this.theme.primary;
  }

  OptionAnswerTextColor(index: number): string {
    if (!this.hasAnswered) {
      return this.theme.textPrimary;
    }
    if (index === this.currentQuestion().correctIndex) {
      return this.theme.success;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return this.theme.error;
    }
    return this.theme.textSecondary;
  }

  OptionCircleColor(index: number): string {
    if (!this.hasAnswered) {
      return '#FFFFFF';
    }
    if (index === this.currentQuestion().correctIndex) {
      return this.theme.success;
    }
    if (index === this.userAnswers[this.currentIndex]) {
      return this.theme.error;
    }
    return '#FFFFFF';
  }

  OptionLabel(index: number): string {
    const labels = ['A', 'B', 'C', 'D', 'E', 'F'];
    return labels[index] || String(index + 1);
  }

  topicLabel(topic: Topic): string {
    return topicShortLabel(topic);
  }

  difficultyLabel(difficulty: Difficulty): string {
    return utilDifficultyLabel(difficulty);
  }

  typeLabel(type: QuestionType): string {
    switch (type) {
      case QuestionType.SINGLE_CHOICE: return '选择';
      case QuestionType.TRUE_FALSE: return '判断';
      case QuestionType.SHORT_ANSWER: return '简答';
      default: return '';
    }
  }

  @Builder
  BottomButton() {
    Row({ space: 12 }) {
      Button('上一题')
        .layoutWeight(1)
        .height(52)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.currentIndex > 0 ? this.theme.card : this.theme.background)
        .fontColor(this.currentIndex > 0 ? this.theme.primary : this.theme.divider)
        .border({ width: 2, color: this.currentIndex > 0 ? this.theme.primary : this.theme.divider })
        .borderRadius(26)
        .enabled(this.currentIndex > 0)
        .stateStyles({
          pressed: quizButtonPressedStyle,
          normal: quizButtonNormalStyle
        })
        .onClick(() => this.onPrevious())

      Button(this.nextButtonText())
        .layoutWeight(1)
        .height(52)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.canGoNext() ? this.theme.primary : this.theme.divider)
        .fontColor(this.theme.textOnPrimary)
        .borderRadius(26)
        .enabled(this.canGoNext())
        .stateStyles({
          pressed: quizButtonPressedStyle,
          normal: quizButtonNormalStyle
        })
        .onClick(() => this.onNext())
    }
    .width('100%')
    .padding(20)
    .backgroundColor(this.theme.card)
  }
}
