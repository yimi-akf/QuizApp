// 题目类型枚举
export enum QuestionType {
  SINGLE_CHOICE = 'single',  // 单选题
  TRUE_FALSE = 'judge',      // 判断题
  SHORT_ANSWER = 'short'     // 疑问题（简答/思考题）
}

// 难度枚举
export enum Difficulty {
  ENTRY = 'entry',         // 入门
  ADVANCED = 'advanced',   // 进阶
  CHALLENGE = 'challenge'  // 挑战
}

// 答题模式枚举
export enum QuizMode {
  NORMAL = 'normal',           // 普通模式
  WRONG_BOOK = 'wrong_book',   // 错题本
  CHALLENGE = 'challenge',     // 闯关模式（答错即结束）
  TIME_ATTACK = 'time_attack'  // 限时模式（60 秒）
}

// 主题枚举
export enum Topic {
  KNOWLEDGE = 'knowledge', // 知识型问答
  RIDDLE = 'riddle',       // 脑筋急转弯
  REASONING = 'reasoning'  // 推理型问答
}

// 题目数据结构
export interface Question {
  id: number;              // 题目编号
  type: QuestionType;      // 题目类型
  difficulty: Difficulty;  // 难度
  topic: Topic;            // 主题
  title: string;           // 题干
  options: string[];       // 选项列表（判断题固定为 ['对', '错']，疑问题为空）
  correctIndex: number;    // 正确答案在 options 中的索引（疑问题为 -1）
  explanation: string;     // 答案解析
}
