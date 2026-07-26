# 趣味问答 App 增强设计文档

## 1. 设计目标

在保持“纯血鸿蒙、单机运行、无网络请求”三大核心约束的前提下，把趣味问答从“能答题”升级为“愿意天天打开、有成长感、可回顾分享”的完整体验。

设计原则：
- 所有数据只使用 `@ohos.data.preferences` 本地存储
- 主界面（首页、类型选择、难度选择）继续采用非滚动单屏布局
- 视觉保持极简、圆角、 subtle 动画、按压反馈
- 不引入任何网络权限或第三方依赖

---

## 2. 本次新增功能清单

| 编号 | 功能 | 一句话说明 | 核心页面/模块 |
|---|---|---|---|
| 1 | 错题本 + 错题重练 | 自动收录答错题目，支持专门重练 | WrongBookStorage、QuizPage、ResultPage、新增 WrongBookPage |
| 2 | 成就系统 + 积分等级 | 答题获得积分，解锁成就与等级称号 | AchievementStorage、新增 AchievementPage、首页展示 |
| 3 | 统计看板 + 成绩分享卡片 | 多维度数据可视化，生成可保存/分享的成绩卡片 | StatsStorage、新增 StatsPage、ResultPage |
| 4 | 每日一题 / 每日挑战 | 每天随机一题，答对可打卡 | DailyChallengeStorage、首页入口、QuizPage（单题模式） |
| 5 | 题目反馈 | 用户可对题目标记“表述不清/答案有误/其他” | QuestionFeedbackStorage、QuizPage、SettingsPage |
| 6 | 更丰富的历史记录 | 历史页支持筛选、趋势图、详情查看 | HistoryStorage 扩展、HistoryPage |
| 7 | 数据备份与恢复 | 导出/导入本地 JSON 备份文件 | DataBackupManager、SettingsPage |
| 8 | 主题换肤 | 2~3 套配色主题，本地切换 | ThemeManager、全局颜色常量、SettingsPage |
| 9 | 答题页动画优化 | 题目切换卡片滑动/翻转、选项涟漪反馈 | QuizPage |
| 10 | 空状态插画 | 无历史/无错题/无收藏时的温馨引导 | 各列表页 |
| 11 | 启动页 | 1.5~2 秒品牌启动页 | 新增 SplashPage，调整 main_pages.json |
| 12 | 代码层面重构 | 抽离 ViewModel/工具函数，统一错误处理与日志 | data/ 与 utils/ 目录 |

---

## 3. 数据模型变更

### 3.1 错题记录（新增）

```typescript
export interface WrongRecord {
  questionId: number;
  wrongCount: number;          // 累计答错次数
  lastWrongAt: string;         // 最近一次答错时间
  mastered: boolean;           // 是否已掌握（连续答对多次）
}
```

存储键：`wrong_records`

行为：
- ResultPage 计算错题时，向错题本追加/更新记录
- 错题重练答对一次不立即移除，连续答对 2 次后标记 mastered，不再出现在“待练习”中
- 支持手动从错题本移除

### 3.2 成就与积分（新增）

```typescript
export interface Achievement {
  id: string;
  title: string;
  desc: string;
  icon: string;
  unlockedAt: string | null;
}

export interface UserStats {
  totalPoints: number;
  currentLevel: number;
  answeredCount: number;
  correctCount: number;
  streakDays: number;
  lastAnswerDate: string;
}
```

积分规则：
- 答对 1 题：+10 分
- 答错 1 题：+2 分（鼓励参与）
- 首次全对：+50 分
- 连续打卡：额外 +5 分/天

等级称号：
| 等级 | 称号 | 积分门槛 |
|---|---|---|
| 1 | 问答新手 | 0 |
| 2 | 知识学徒 | 100 |
| 3 | 推理达人 | 300 |
| 4 | 智慧大师 | 600 |
| 5 | 百科王者 | 1000 |

成就列表（示例）：
- 初次答题
- 首次全对
- 连续答对 10 题
- 累计答题 50/100/500 题
- 连续打卡 3/7/30 天
- 通关某主题全部难度

### 3.3 每日挑战（新增）

```typescript
export interface DailyChallenge {
  date: string;        // yyyy-MM-dd
  questionId: number;
  answered: boolean;
  correct: boolean;
}
```

每日首次进入首页时生成/读取当日题目。题库变化时若旧题找不到，则重新随机。

### 3.4 题目反馈（新增）

```typescript
export interface QuestionFeedback {
  questionId: number;
  type: 'unclear' | 'wrong_answer' | 'typo' | 'other';
  remark: string;
  createdAt: string;
}
```

存储键：`question_feedback`，上限 100 条，超出时移除最旧记录。

### 3.5 历史记录扩展

`HistoryRecord` 增加：
```typescript
export interface HistoryRecord {
  // 原有字段保持不变
  // 新增：
  wrongQuestionIds?: number[];
}
```

用于统计错题趋势。

---

## 4. 存储规划

继续使用 `@ohos.data.preferences`，新增以下 Preferences：

| Preferences 名称 | 用途 |
|---|---|
| quiz_wrong_book | 错题本 |
| quiz_achievement | 成就、积分、等级、连续打卡 |
| quiz_daily | 每日一题状态 |
| quiz_feedback | 题目反馈 |
| quiz_stats | 累计统计（用于快速计算看板） |
| quiz_theme | 当前主题索引 |

---

## 5. 页面与导航变更

### 5.1 新增页面

| 页面 | 说明 | 入口 |
|---|---|---|
| SplashPage | 启动页 | main_pages.json 首个页面 |
| WrongBookPage | 错题本 | 首页卡片 / 设置页 |
| AchievementPage | 成就与等级 | 首页卡片 / 设置页 |
| StatsPage | 统计看板 | 首页卡片 / 设置页 |
| DailyChallengePage | 每日一题 | 首页卡片 |

### 5.2 Index 首页调整

在“开始游戏”上方增加 2x2 功能卡片网格：
- 继续上次进度（原有）
- 最近成绩（原有）
- 每日一题
- 错题重练
- 成就等级
- 统计看板

由于首页需要保持非滚动单屏，将功能卡片做成横向 2 列的小卡片，放在“开始游戏”按钮上方，整体仍使用 `Column + layoutWeight` 自适应。

### 5.3 SettingsPage 调整

新增设置项：
- 主题换肤
- 数据备份
- 数据恢复
- 题目反馈（查看已提交）

### 5.4 QuizPage 调整

- 支持单题模式（每日一题）
- 支持错题重练模式
- 题目切换增加滑动动画
- 选项增加选中/正确/错误颜色反馈与缩放动画
- 增加“举报本题”浮动按钮

### 5.5 ResultPage 调整

- 增加“生成成绩卡片”按钮
- 增加“查看错题本”入口
- 自动触发成就/积分更新

---

## 6. 主题系统

定义 3 套主题：

```typescript
export interface AppTheme {
  name: string;
  primary: string;
  primaryLight: string;
  background: string;
  surface: string;
  textPrimary: string;
  textSecondary: string;
  success: string;
  error: string;
}

export const THEMES: AppTheme[] = [
  {
    name: '天空蓝',
    primary: '#1976D2',
    primaryLight: '#42A5F5',
    background: '#F5F5F5',
    surface: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    success: '#4CAF50',
    error: '#E53935'
  },
  {
    name: '暗夜紫',
    primary: '#5E35B1',
    primaryLight: '#7E57C2',
    background: '#1A1A2E',
    surface: '#16213E',
    textPrimary: '#EAEAEA',
    textSecondary: '#A0A0A0',
    success: '#66BB6A',
    error: '#EF5350'
  },
  {
    name: '清新绿',
    primary: '#2E7D32',
    primaryLight: '#66BB6A',
    background: '#F1F8E9',
    surface: '#FFFFFF',
    textPrimary: '#212121',
    textSecondary: '#757575',
    success: '#43A047',
    error: '#E53935'
  }
];
```

实现方式：
- 通过 `ThemeManager` 读取当前主题索引
- 页面通过 `@State theme: AppTheme` 在 `aboutToAppear` 中初始化
- 所有硬编码颜色逐步替换为主题变量

注意：为了保持主界面非滚动和视觉一致性，渐变角度、圆角大小、阴影参数不变，只改变色值。

---

## 7. 动画与交互

### 7.1 启动页

- 显示应用图标 + 应用名 + slogan
- 入场：图标从 0.8 放大到 1.0，文字淡入
- 停留 1.5 秒后自动跳转到首页
- 仅首次启动显示，后续可通过 preferences 跳过（保留开关）

### 7.2 答题页切换动画

- 题目卡片整体左右滑动切换
- 使用 `translate + opacity` 配合 `transition`
- 方向：下一题向右滑入，上一题向左滑入

### 7.3 选项反馈

- 点击时缩放 0.98
- 答对：背景色从 `#E8F5E9` 淡入，对勾缩放弹出
- 答错：背景色从 `#FFEBEE` 淡入，错误选项轻微震动（translate 左右 2px）

### 7.4 空状态

- 使用大号 emoji + 主标题 + 副标题 + 操作按钮
- 空状态入场时整体从下方淡入

---

## 8. 成绩分享卡片

在 ResultPage 增加“生成成绩卡片”按钮，生成内容：
- 背景：主题主色渐变
- 中间：大分数 + 评语
- 底部：题型、难度、用时、日期
- 底部 slogan：趣味问答 · 知识 · 推理 · 脑筋急转弯

实现：使用 HarmonyOS 的 `OffscreenCanvas` 或纯 `Column` 截图能力（若 ArkUI 支持），若不支持则先做成精美的本地预览卡片，用户可截图分享。

---

## 9. 数据备份与恢复

### 9.1 导出

- 读取所有 preferences 数据
- 合并为 JSON 对象：`{ version: 1, exportedAt: '...', data: { ... } }`
- 使用 `@kit.CoreFileKit` 写入应用私有目录 `/files/backup/quiz_backup_YYYYMMDD_HHmmss.json`
- 弹窗告知用户文件路径

### 9.2 导入

- 读取上述目录下的备份文件列表
- 用户选择后解析 JSON
- 校验 version 字段
- 覆盖写入各 preferences
- 刷新页面数据

---

## 10. 代码重构方向

1. **新增 `utils/` 目录**
   - `DateUtil.ets`：日期格式化、是否同一天判断
   - `ColorUtil.ets`：主题相关工具
   - `ArrayUtil.ets`：洗牌、去重

2. **新增 `viewmodel/` 目录**
   - `QuizViewModel.ets`：封装答题状态管理，减少 QuizPage 体积

3. **统一标签常量**
   - 在 `AppConstants.ets` 中集中管理页面名称、存储键名、主题列表

4. **减少页面重复代码**
   - 把 `topicLabel`、`difficultyLabel`、`formatTime` 等抽成公共工具函数

---

## 11. 合规性保证

- 继续仅使用 `@ohos.data.preferences`，不引入网络、位置、相机等敏感权限
- 备份功能只读写应用私有目录
- 所有日志使用 `@ohos.hilog`，不出现 `console`
- 主题/动画不调用任何已废弃 API
- 保持 `Navigation + NavPathStack` 路由

---

## 12. 实施顺序建议

按依赖关系分四批：

**第一批（基础设施）**
- 主题系统（功能 8）
- 代码重构 / 公共工具（功能 12）
- 启动页（功能 11）

**第二批（数据与记录）**
- 错题本（功能 1）
- 历史记录增强（功能 6）
- 题目反馈（功能 5）

**第三批（成长体系）**
- 成就与积分等级（功能 2）
- 统计看板（功能 3）
- 每日一题（功能 4）

**第四批（体验与分享）**
- 答题页动画优化（功能 9）
- 空状态插画（功能 10）
- 成绩分享卡片（功能 3 的分享部分）
- 数据备份恢复（功能 7）

---

## 13. 需要用户确认的事项

1. 首页功能卡片布局是否接受 2x2 网格？
2. 是否接受“暗夜紫”深色主题？（上架截图可能需要同时提供深浅色）
3. 成绩分享卡片是先生成本地预览（用户手动截图），还是必须生成图片文件？
4. 数据备份路径放在应用私有目录是否足够？还是希望能导出到系统下载目录？
