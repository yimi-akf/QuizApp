# 趣味问答

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-blue)](https://developer.huawei.com/consumer/cn/harmonyos/)
[![API](https://img.shields.io/badge/API-23-green)](https://developer.huawei.com/consumer/cn/harmonyos/)
[![License](https://img.shields.io/badge/license-MIT-orange)](./LICENSE)

> 知识 · 推理 · 脑筋急转弯 —— 一款纯本地离线的趣味问答应用

## 功能特性

### 答题模式
- **三类题目**：知识型、推理型、脑筋急转弯
- **三种难度**：入门、进阶、挑战，支持混合乱序
- **多种玩法**：普通练习、闯关模式、限时模式、错题练习
- **每日一题**：每天一道精选题目，坚持打卡
- **收藏练习**：收藏的题目独立练习

### 学习辅助
- **错题本**：自动收录错题，支持重练和复习
- **答题历史**：查看过往每一次答题成绩
- **统计看板**：柱状图展示每日正确率趋势、答题总量等数据
- **学习热力图**：GitHub 风格日历网格，可视化每日打卡记录，左右滑动切换月份
- **成就系统**：解锁多种答题勋章
- **继续进度**：中途退出自动保存，下次继续

### 个性化
- **6 套浅色主题**：天空蓝、清新绿、浅紫色、暖橙色、玫瑰红、深空灰
- **6 套深色主题**：对应浅色主题的深色版本
- **深色模式**：一键切换深色/浅色，底部导航栏同步适配
- **液态玻璃导航栏**：毛玻璃效果，通透美观

### 数据管理
- **纯本地离线**：所有数据存储在本地，无需网络
- **数据备份恢复**：支持导出/导入 JSON 备份文件，含版本校验与导入前清理
- **一键清除数据**：随时重置所有记录（含进度、历史、错题、收藏、成就、每日一题、主题）

## 技术栈

| 技术 | 说明 |
|------|------|
| 平台 | HarmonyOS NEXT (API 23) |
| 语言 | ArkTS |
| UI 框架 | ArkUI (声明式) |
| 数据存储 | @ohos.data.preferences |
| 构建工具 | Hvigor |
| 题库规模 | 500+ 题 |

## 项目结构

```
QuizApp/
├── AppScope/                    # 应用全局配置
├── entry/
│   └── src/main/
│       ├── ets/
│       │   ├── components/      # 通用组件 (EmptyState, SkeletonCard)
│       │   ├── data/            # 数据层 (Storage, Theme, QuestionBank...)
│       │   ├── entryability/    # 应用入口
│       │   ├── model/           # 数据模型 (Question, AppTheme)
│       │   ├── pages/           # 页面 (12个页面 + 3个Tab)
│       │   └── utils/           # 工具函数
│       ├── resources/           # 资源文件
│       └── module.json5         # 模块配置
├── build-profile.json5          # 构建配置
└── hvigor/                      # Hvigor 构建工具配置
```

## 构建与运行

### 环境要求
- DevEco Studio 5.0+
- HarmonyOS NEXT SDK (API 23)
- HarmonyOS 设备或模拟器

### 构建步骤

```bash
# 1. 克隆仓库
git clone https://github.com/yimi-akf/QuizApp.git
cd QuizApp

# 2. 用 DevEco Studio 打开项目
# 3. 连接设备或启动模拟器
# 4. 点击 Run 或执行：

# 命令行构建
hvigorw assembleHap -p product=default

# 安装到设备
hdc install entry/build/default/outputs/default/entry-default-signed.hap
```

## 版本历史

- **v1.0.0** — 首版发布：答题、错题本、成就、统计、6套主题
- **v1.0.1** — 深色主题、每日一题、统计图表优化、底部导航栏适配
- **v1.0.2** — 学习热力图、每日一题打卡计入统计、深色模式切换优化
- **v1.0.3** — 数据处理页面（导出/导入/清除）、返回键弹窗拦截、数组越界防护、全项目硬编码颜色消除、主题色板动态生成

## 许可

MIT License © 2026 个人开发者