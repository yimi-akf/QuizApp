import common from '@ohos.app.ability.common';
import { HistoryStorage, HistoryRecord } from '../data/HistoryStorage';
import { AppTheme, THEMES, DARK_THEMES } from '../model/AppTheme';
import { popSafe } from '../utils/NavUtil';

// 学习热力图页面 — 日历风格打卡记录
@Component
export struct HeatmapPage {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizDarkMode') @Watch('onThemeChange') darkMode: boolean = false;
  @StorageLink('quizThemeIndex') @Watch('onThemeChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State private currentYear: number = 0;
  @State private currentMonth: number = 0;
  @State private monthLabel: string = '';
  @State private gridCells: GridCell[] = [];
  @State private maxCount: number = 0;
  @State private totalActiveDays: number = 0;
  @State private gridKey: number = 0;
  @State private headerOpacity: number = 0;
  @State private headerOffset: number = -30;
  @State private contentOpacity: number = 0;
  @State private contentOffset: number = 40;
  @State private levelColors: string[] = [];

  private readonly WEEKDAY_LABELS: string[] = ['一', '二', '三', '四', '五', '六', '日'];
  private readonly MIN_YEAR = 2026;

  private context: common.UIAbilityContext | null = null;

  // 将主题色 hex 转为带透明度的 rgba 字符串
  private hexToRgba(hex: string, alpha: number): string {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return `rgba(${r},${g},${b},${alpha})`;
  }

  // 根据当前主题动态生成热力图等级色板
  private buildLevelColors(): string[] {
    return [
      this.theme.divider,
      this.hexToRgba(this.theme.primary, 0.2),
      this.hexToRgba(this.theme.primary, 0.4),
      this.hexToRgba(this.theme.primary, 0.6),
      this.hexToRgba(this.theme.primary, 0.85)
    ];
  }

  private resetToCurrentMonth() {
    const now = new Date();
    this.currentYear = Math.max(this.MIN_YEAR, now.getFullYear());
    this.currentMonth = now.getMonth() + 1;
  }

  aboutToAppear() {
    this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.levelColors = this.buildLevelColors();
    this.resetToCurrentMonth();
    this.loadData();
    this.headerOpacity = 1;
    this.headerOffset = 0;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  onThemeChange() {
    this.theme = this.darkMode ? (DARK_THEMES[this.themeIndex] ?? DARK_THEMES[0]) : (THEMES[this.themeIndex] ?? THEMES[0]);
    this.levelColors = this.buildLevelColors();
  }

  onPageShow() {
    // 仅刷新数据，不重置月份位置（保留用户查看的月份）
    this.loadData();
  }

  loadData() {
    if (!this.context) return;
    const records = HistoryStorage.loadRecords(this.context);
    const counts = new Map<string, number>();
    let max = 0;

    records.forEach((r: HistoryRecord) => {
      const date = r.date.split(' ')[0];
      const current = (counts.get(date) || 0) + (r.answeredCount ?? r.total);
      counts.set(date, current);
      if (current > max) {
        max = current;
      }
    });

    this.maxCount = max;
    this.totalActiveDays = counts.size;
    this.buildGrid(counts);
  }

  // 构建扁平网格数据：前7个是星期表头，后面是所有日期
  buildGrid(dailyCounts: Map<string, number>) {
    const year = this.currentYear;
    const month = this.currentMonth;
    this.monthLabel = `${year}年${month}月`;
    this.gridKey++;

    // 1. 计算当月第一天是星期几（周一=0, 周日=6）
    // JS getDay(): 0=周日, 1=周一, ..., 6=周六
    const firstDay = new Date(year, month - 1, 1);
    const lastDay = new Date(year, month, 0);
    const daysInMonth = lastDay.getDate();
    let firstWeekday = firstDay.getDay(); // 0=周日, 1=周一, ..., 6=周六
    firstWeekday = firstWeekday === 0 ? 6 : firstWeekday - 1; // 转为 0=周一, 6=周日

    // 2. 构建扁平数组
    const cells: GridCell[] = [];

    // 2a. 星期表头（7个）
    for (let i = 0; i < 7; i++) {
      cells.push({ kind: 'header', label: this.WEEKDAY_LABELS[i] });
    }

    // 2b. 第一周前面的空白格
    for (let i = 0; i < firstWeekday; i++) {
      cells.push({ kind: 'empty' });
    }

    // 2c. 当月日期
    for (let d = 1; d <= daysInMonth; d++) {
      const dateStr = `${year}-${this.pad(month)}-${this.pad(d)}`;
      const count = dailyCounts.get(dateStr) || 0;
      const level = this.getLevel(count);
      cells.push({ kind: 'date', day: d, level });
    }

    // 2d. 最后一行补全空白（凑满 7 的倍数）
    const dateOnlyCount = cells.length - 7; // 减去表头
    const remainder = dateOnlyCount % 7;
    if (remainder !== 0) {
      for (let i = 0; i < 7 - remainder; i++) {
        cells.push({ kind: 'empty' });
      }
    }

    this.gridCells = cells;
  }

  private pad(n: number): string {
    return n < 10 ? '0' + n : String(n);
  }

  getLevel(count: number): number {
    if (count === 0) return 0;
    if (this.maxCount <= 0) return 1;
    const ratio = count / this.maxCount;
    if (ratio > 0.6) return 4;
    if (ratio > 0.3) return 3;
    if (ratio > 0.1) return 2;
    return 1;
  }

  prevMonth() {
    if (this.currentMonth === 1) {
      if (this.currentYear > this.MIN_YEAR) {
        this.currentYear--;
        this.currentMonth = 12;
      } else {
        return;
      }
    } else {
      this.currentMonth--;
    }
    this.loadData();
  }

  nextMonth() {
    // 不允许导航到未来月份（当前月份为上限）
    const now = new Date();
    const curYear = now.getFullYear();
    const curMonth = now.getMonth() + 1;
    if (this.currentYear > curYear || (this.currentYear === curYear && this.currentMonth >= curMonth)) {
      return;
    }
    if (this.currentMonth === 12) {
      this.currentYear++;
      this.currentMonth = 1;
    } else {
      this.currentMonth++;
    }
    this.loadData();
  }

  goBack() {
    popSafe(this.pageStack);
  }

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Row() {
          Text('‹')
            .fontSize(32)
            .fontColor(this.theme.textOnPrimary)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 8, right: 8 })
            .stateStyles({
              pressed: { .scale({ x: 0.85, y: 0.85 }) },
              normal: { .scale({ x: 1, y: 1 }) }
            })
            .onClick(() => this.goBack())

          Column() {
            Text('学习热力图')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .textShadow({
                radius: 8,
                color: this.theme.cardShadow,
                offsetX: 0,
                offsetY: 3
              })

            Text(`${this.totalActiveDays} 天有打卡记录`)
              .fontSize(13)
              .fontColor(this.theme.textOnPrimaryMuted)
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .margin({ left: 4 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ left: 12, right: 20, top: 12, bottom: 16 })
      }
      .width('100%')
      .padding({ top: 40 })
      .linearGradient({
        angle: 135,
        colors: [[this.theme.primaryGradientStart, 0.0], [this.theme.primaryGradientEnd, 1.0]]
      })
      .borderRadius({ bottomLeft: 28, bottomRight: 28 })
      .shadow({
        radius: 12,
        color: this.theme.cardShadow,
        offsetX: 0,
        offsetY: 6
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      .opacity(this.headerOpacity)
      .translate({ y: this.headerOffset })
      .animation({ duration: 500, curve: Curve.EaseOut })

      // 内容区
      Scroll() {
        Column({ space: 20 }) {
          // 日历卡片
          Column({ space: 16 }) {
            // 月份导航
            Row() {
              Text('◀')
                .fontSize(16)
                .fontColor(this.theme.primary)
                .padding(8)
                .borderRadius(10)
                .stateStyles({
                  pressed: { .scale({ x: 0.85, y: 0.85 }) },
                  normal: { .scale({ x: 1, y: 1 }) }
                })
                .onClick(() => this.prevMonth())

              Text(this.monthLabel)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.theme.textPrimary)
                .layoutWeight(1)
                .textAlign(TextAlign.Center)

              Text('▶')
                .fontSize(16)
                .fontColor(this.theme.primary)
                .padding(8)
                .borderRadius(10)
                .stateStyles({
                  pressed: { .scale({ x: 0.85, y: 0.85 }) },
                  normal: { .scale({ x: 1, y: 1 }) }
                })
                .onClick(() => this.nextMonth())
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            // 日历网格：扁平数组 + 单个 ForEach，7 列模板
            Grid() {
              ForEach(this.gridCells, (cell: GridCell) => {
                GridItem() {
                  if (cell.kind === 'header') {
                    Text(cell.label!)
                      .fontSize(12)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.theme.textSecondary)
                      .width('100%')
                      .height(24)
                      .textAlign(TextAlign.Center)
                  } else if (cell.kind === 'empty') {
                    Column()
                      .width('100%')
                      .height(36)
                  } else {
                    Column() {
                      Text(String(cell.day))
                        .fontSize(13)
                        .fontColor(cell.level! > 0 ? this.theme.textOnPrimary : this.theme.textPrimary)
                        .fontWeight(cell.level! > 0 ? FontWeight.Medium : FontWeight.Normal)
                    }
                    .width('100%')
                    .height(36)
                    .borderRadius(8)
                    .backgroundColor(cell.level! > 0 ? this.levelColors[cell.level!] : Color.Transparent)
                    .justifyContent(FlexAlign.Center)
                  }
                }
              }, (cell: GridCell, i: number) => this.gridKey + '_' + i)
            }
            .width('100%')
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
            .rowsGap(4)
            .columnsGap(0)
            .gesture(
              PanGesture({ direction: PanDirection.Horizontal, distance: 20 })
                .onActionEnd((event: GestureEvent) => {
                  if (event.offsetX > 30) {
                    this.prevMonth();
                  } else if (event.offsetX < -30) {
                    this.nextMonth();
                  }
                })
            )
          }
          .width('100%')
          .padding(16)
          .backgroundColor(this.theme.card)
          .borderRadius(16)

          // 图例
          Row() {
            Text('少')
              .fontSize(11)
              .fontColor(this.theme.textSecondary)
              .margin({ right: 6 })

            Row({ space: 3 }) {
              ForEach(this.levelColors, (color: string) => {
                Column()
                  .width(14)
                  .height(14)
                  .borderRadius(3)
                  .backgroundColor(color)
              }, (color: string) => color)
            }

            Text('多')
              .fontSize(11)
              .fontColor(this.theme.textSecondary)
              .margin({ left: 6 })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)

          // 说明文字
          Text('格子颜色越深，表示当天答题量越多')
            .fontSize(12)
            .fontColor(this.theme.textSecondary)
            .width('100%')
            .textAlign(TextAlign.Center)
            .opacity(0.7)
        }
        .width('100%')
        .padding(20)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor(this.theme.background)
      .opacity(this.contentOpacity)
      .translate({ y: this.contentOffset })
      .animation({ duration: 500, curve: Curve.EaseOut, delay: 150 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.background)
  }
}

interface GridCell {
  kind: 'header' | 'empty' | 'date';
  label?: string;
  day?: number;
  level?: number;
}