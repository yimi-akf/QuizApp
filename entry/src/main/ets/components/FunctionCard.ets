import { AppTheme } from '../model/AppTheme';

@Component
export struct FunctionCard {
  @Prop icon: string = '⭐';
  @Prop title: string = '功能';
  @Prop subtitle: string = '';
  @Prop theme: AppTheme;
  @Prop primary: boolean = false;
  onClick?: () => void;

  build() {
    Column() {
      Row() {
        Text(this.icon)
          .fontSize(this.primary ? 36 : 28)
          .margin({ right: this.primary ? 16 : 12 })

        Column() {
          Text(this.title)
            .fontSize(this.primary ? 18 : 15)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.primary ? this.theme.textOnPrimary : this.theme.textPrimary)

          if (this.subtitle) {
            Text(this.subtitle)
              .fontSize(12)
              .fontColor(this.primary ? 'rgba(255,255,255,0.85)' : this.theme.textSecondary)
              .margin({ top: 4 })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor(this.primary ? this.theme.primary : this.theme.card)
    .borderRadius(20)
    .shadow({
      radius: 10,
      color: this.primary ? 'rgba(0,0,0,0.15)' : 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 4
    })
    .stateStyles({
      pressed: {
        .scale({ x: 0.97, y: 0.97 })
      },
      normal: {
        .scale({ x: 1, y: 1 })
      }
    })
    .onClick(() => {
      if (this.onClick) {
        this.onClick();
      }
    })
  }
}
