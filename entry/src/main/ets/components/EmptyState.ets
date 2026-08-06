import { AppTheme, THEMES } from '../model/AppTheme';

@Component
export struct EmptyState {
  @Prop icon: string = '📭';
  @Prop title: string = '暂无内容';
  @Prop subtitle: string = '这里会展示你的相关记录';
  @Prop theme: AppTheme = THEMES[0];

  build() {
    Column() {
      Text(this.icon)
        .fontSize(64)
        .margin({ bottom: 16 })

      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme.textPrimary)
        .margin({ bottom: 8 })

      Text(this.subtitle)
        .fontSize(14)
        .fontColor(this.theme.textSecondary)
        .textAlign(TextAlign.Center)
        .width('80%')
        .lineHeight(22)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .opacity(0.9)
    .translate({ y: 20 })
    .animation({
      duration: 600,
      curve: Curve.EaseOut
    })
  }
}
