// 格式化与标签工具函数

import { Difficulty, Topic, QuestionType } from '../model/Question';
import { AppTheme } from '../model/AppTheme';

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

export function difficultyColor(theme: AppTheme, difficulty: Difficulty | 'mixed'): string {
  switch (difficulty) {
    case Difficulty.ENTRY: return theme.success;
    case Difficulty.ADVANCED: return theme.warning;
    case Difficulty.CHALLENGE: return theme.error;
    case 'mixed': return theme.difficultyMixedColor;
    default: return theme.primary;
  }
}

export function difficultyTagBgColor(difficulty: Difficulty | 'mixed', theme: AppTheme): string {
  switch (difficulty) {
    case Difficulty.ENTRY: return theme.optionCorrectBg;
    case Difficulty.ADVANCED: return theme.feedbackWrongBg;
    case Difficulty.CHALLENGE: return theme.optionWrongBg;
    case 'mixed': return theme.answerBg;
    default: return theme.divider;
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
  if (!Number.isFinite(seconds) || seconds < 0) {
    seconds = 0;
  }
  seconds = Math.floor(seconds);
  const minutes = Math.floor(seconds / 60);
  const secs = seconds % 60;
  const pad = (n: number): string => (n < 10 ? '0' + n : String(n));
  return `${pad(minutes)}:${pad(secs)}`;
}