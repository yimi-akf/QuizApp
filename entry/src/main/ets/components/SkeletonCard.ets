import { AppTheme } from '../model/AppTheme';

// 骨架屏卡片组件 - 数据加载时显示
@Component
export struct SkeletonCard {
  @Prop theme: AppTheme;
  @State shimmerOpacity: number = 0.4;
  private timerId: number = -1;

  aboutToAppear() {
    this.timerId = setInterval(() => {
      this.shimmerOpacity = this.shimmerOpacity === 0.4 ? 0.8 : 0.4;
    }, 800);
  }

  aboutToDisappear() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  @Builder
  SkeletonLine(widthValue: Length, heightValue: Length) {
    Column()
      .width(widthValue)
      .height(heightValue)
      .borderRadius(4)
      .backgroundColor(this.theme.divider)
      .opacity(this.shimmerOpacity)
      .animation({ duration: 800, curve: Curve.EaseInOut })
  }

  build() {
    Column({ space: 16 }) {
      // 标题骨架
      Row() {
        this.SkeletonLine(200, 24)
      }
      .width('100%')

      // 标签骨架
      Row({ space: 8 }) {
        this.SkeletonLine(60, 20)
        this.SkeletonLine(60, 20)
        this.SkeletonLine(60, 20)
      }

      // 进度条骨架
      Column()
        .width('100%')
        .height(4)
        .borderRadius(2)
        .backgroundColor(this.theme.divider)
        .opacity(this.shimmerOpacity)
        .animation({ duration: 800, curve: Curve.EaseInOut })

      // 题目卡片骨架
      Column({ space: 12 }) {
        this.SkeletonLine('100%', 28)
        this.SkeletonLine('80%', 20)
        this.SkeletonLine('60%', 20)
      }
      .width('100%')
      .padding(20)
      .backgroundColor(this.theme.card)
      .borderRadius(16)

      // 选项骨架
      Column({ space: 12 }) {
        Row() {
          Column().width(32).height(32).borderRadius(16).backgroundColor(this.theme.divider).opacity(this.shimmerOpacity)
            .animation({ duration: 800, curve: Curve.EaseInOut })
          Column().width('80%').height(20).borderRadius(4).backgroundColor(this.theme.divider)
            .margin({ left: 12 }).opacity(this.shimmerOpacity).animation({ duration: 800, curve: Curve.EaseInOut })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.theme.card)
        .borderRadius(12)
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
  }
}
