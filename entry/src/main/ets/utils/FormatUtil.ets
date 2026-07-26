// 格式化与标签工具函数

import { Difficulty, Topic, QuestionType } from '../model/Question';

export function topicLabel(topic: Topic): string {
  switch (topic) {
    case Topic.KNOWLEDGE: return '知识型问答';
    case Topic.RIDDLE: return '脑筋急转弯';
    case Topic.REASONING: return '推理型问答';
    default: return '';
  }
}

export function topicShortLabel(topic: Topic): string {
  switch (topic) {
    case Topic.KNOWLEDGE: return '知识';
    case Topic.RIDDLE: return '脑筋急转弯';
    case Topic.REASONING: return '推理';
    default: return '';
  }
}

export function difficultyLabel(difficulty: Difficulty | 'mixed'): string {
  switch (difficulty) {
    case Difficulty.ENTRY: return '入门';
    case Difficulty.ADVANCED: return '进阶';
    case Difficulty.CHALLENGE: return '挑战';
    case 'mixed': return '混合乱序';
    default: return '';
  }
}

export function difficultyColor(difficulty: Difficulty | 'mixed'): string {
  switch (difficulty) {
    case Difficulty.ENTRY: return '#4CAF50';
    case Difficulty.ADVANCED: return '#FF9800';
    case Difficulty.CHALLENGE: return '#F44336';
    case 'mixed': return '#9C27B0';
    default: return '#757575';
  }
}

export function typeLabel(type: QuestionType): string {
  switch (type) {
    case QuestionType.SINGLE_CHOICE: return '单选题';
    case QuestionType.TRUE_FALSE: return '判断题';
    case QuestionType.SHORT_ANSWER: return '简答题';
    default: return '';
  }
}

export function formatTime(seconds: number): string {
  const total = seconds;
  const minutes = Math.floor(total / 60);
  const secs = total % 60;
  const pad = (n: number): string => (n < 10 ? '0' + n : String(n));
  return `${pad(minutes)}:${pad(secs)}`;
}
