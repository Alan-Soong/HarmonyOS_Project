import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';

@Entry
@Component
export struct MapPage {
  build() {
    Column() {
      Image($r('app.media.bg_tianjin_food'))
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .objectFit(ImageFit.Cover)

      Column() {
        Button('天津美食地图')
          .fontSize(24)
          .margin(50)
          .backgroundColor('#FF8C00')
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Map'
            }).catch((err: Error) => {
              console.error('跳转失败: ' + JSON.stringify(err));
            });
          })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .position({ x: 0, y: 0 })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}