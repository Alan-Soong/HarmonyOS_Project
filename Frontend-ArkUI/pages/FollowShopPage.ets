// entry/src/main/ets/pages/FollowedShopsPage.ets
import { router } from '@kit.ArkUI';
import { httpClient } from '../utils/HttpRequest';
import { UserStore } from '../models/UserStore';
import prompt from '@ohos.prompt';
import { FollowedShop, FollowedShopsResponse, UnfollowResponse } from '../models/Interface';

@Entry
@Component
export struct FollowedShopsPage {
  @State followedShops: FollowedShop[] = [];
  @State isLoading: boolean = true;
  @State isUnfollowing: boolean = false; // 防止重复点击

  aboutToAppear() {
    this.loadFollowedShops();
  }

  async loadFollowedShops() {
    try {
      const currentUserId = UserStore.getCurrentUserId(); // 实际应从用户状态获取
      const response = await httpClient.get<FollowedShopsResponse>(`/following/shops/${currentUserId}`);
      if (response.success) {
        this.followedShops = response.data;
      }
    } catch (error) {
      console.error('加载收藏店铺失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 新增取消收藏方法
  async unfollowShop(shopId: number) {
    if (this.isUnfollowing) return;

    this.isUnfollowing = true;
    try {
      const currentUserId = UserStore.getCurrentUserId();
      const response = await httpClient.delete<UnfollowResponse>(
        `/following/shops/${currentUserId}/${shopId}`
      );

      if (response.success) {
        prompt.showToast({ message: '已取消收藏' });
        // 从列表中移除
        this.followedShops = this.followedShops.filter(shop => shop.shop_id !== shopId);
      } else {
        prompt.showToast({ message: response.message || '取消收藏失败' });
      }
    } catch (error) {
      console.error('取消收藏出错:', error);
      prompt.showToast({ message: '取消收藏失败' });
    } finally {
      this.isUnfollowing = false;
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .onClick(() => {
            router.back();
          });

        Text('我的收藏')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 });

        Blank();
      }
      .width('100%')
      .height(56)
      .backgroundColor('#EDEDED');

      // 内容区域
      Scroll() {
        Column() {
          if (this.isLoading) {
            LoadingProgress()
              .height(60)
              .width(60)
              .margin({ top: 100 })
          } else if (this.followedShops.length === 0) {
            Text('暂无收藏店铺')
              .fontSize(16)
              .fontColor('#999')
              .margin({ top: 100 })
          } else {
            ForEach(this.followedShops, (shop: FollowedShop) => {
              this.shopCard(shop)
            }, (shop: FollowedShop) => shop.shop_id.toString())
          }
        }
        .width('100%')
        .padding(12)
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  shopCard(shop: FollowedShop) {
    Column() {
      // 店铺名称和关注数

      Row() {
        Text(shop.shop_name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('取消收藏')
          .fontSize(14)
          .fontColor('#FF4D4F')
          .width(80)
          .height(32)
          .backgroundColor('#FFF2F0')
          .borderRadius(16)
          .onClick(() => {
            this.unfollowShop(shop.shop_id);
          })
          .stateEffect(true)

        Row() {
          Image($r('app.media.icon_follow'))
            .width(16)
            .height(16)
            .margin({ right: 4 })

          Text(shop.follower_count.toString())
            .fontSize(14)
            .fontColor('#666')
        }
      }
      .margin({ bottom: 12 })

      // 店铺信息
      // 店铺信息 - 图片在左，信息在右
      Row() {
        // 左侧：店铺图片
        Image(shop.image_url)
          .width(60)
          .height(60)
          .borderRadius(10)
          .margin({ right: 15 })
          .objectFit(ImageFit.Cover)

        // 右侧：店铺信息（使用Column垂直排列）
        Column() {
          // 地址
          Row() {
            Image($r('app.media.icon_location'))
              .width(16)
              .height(16)
              .margin({ right: 8 })

            Text(shop.address)
              .fontSize(14)
              .fontColor('#666')
          }
          .margin({ bottom: 8 })

          // 营业时间
          Row() {
            Image($r('app.media.icon_time'))
              .width(16)
              .height(16)
              .margin({ right: 8 })

            Text(shop.business_hours)
              .fontSize(14)
              .fontColor('#666')
          }
          .margin({ bottom: 8 })

          // 平均价格
          Row() {
            Image($r('app.media.icon_price'))
              .width(16)
              .height(16)
              .margin({ right: 8 })

            Text(`人均 ¥${shop.avg_price}`)
              .fontSize(14)
              .fontColor('#666')
          }
        }
        .alignItems(HorizontalAlign.Start) // 左对齐
        .layoutWeight(1) // 占据剩余空间
      }
    }
    .width('100%')
    .padding(16)
    .margin({ bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 2, color: '#10000000', offsetX: 0, offsetY: 2 })
  }
}