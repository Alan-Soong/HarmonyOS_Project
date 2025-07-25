// entry\src\main\ets\pages\ReviewDetailPage.ets
import { router } from '@kit.ArkUI';
import { httpClient } from '../utils/HttpRequest'; // 导入httpClient
import { ShopInfo, PostInfo, DishInfo, ReviewItem, ShopRatingResponse } from '../models/review'; // 导入ReviewItem接口
import {UserStore} from '../models/UserStore'

interface ReviewItemResponseDetails {
  success: boolean;
  data: ReviewItem[];
}

@Entry
@Component
struct MyReviewsPage {
  @State reviews: ReviewItem[] = []; // 修改为ReviewItem类型，并初始化为空数组
  @State shopRatings: Map<number, number> = new Map(); // key: shop_id, value: rating


  private formatDate(dateString: string): string {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000);

    if (diffInSeconds < 60) {
      return `${diffInSeconds}秒前`;
    } else if (diffInSeconds < 3600) {
      return `${Math.floor(diffInSeconds / 60)}分钟前`;
    } else if (diffInSeconds < 86400) {
      return `${Math.floor(diffInSeconds / 3600)}小时前`;
    } else if (diffInSeconds < 2592000) {
      return `${Math.floor(diffInSeconds / 86400)}天前`;
    } else {
      return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`;
    }
  }

  aboutToAppear() {
    this.loadMyReviews();
  }

  async loadMyReviews() {
    // 假设当前用户ID为1，实际应用中应从用户认证模块获取
    const currentUserId = UserStore.getCurrentUserId();
    try {
      const response = await httpClient.get<ReviewItemResponseDetails>(`/users/${currentUserId}/reviews`);
      if (response.success) {
        this.reviews = response.data;
        console.info('My Reviews:', response.data)
      } else {
        console.error('Failed to load my reviews:', response);
      }
    } catch (error) {
      console.error('Error loading my reviews:', error);
    }
  }

  async loadShopRatings(reviews: ReviewItem[], userId: number) {
    const shopReviews = reviews.filter(review => review.target_type === 'SHOP');

    for (const review of shopReviews) {
      try {
        const response = await httpClient.get<ShopRatingResponse>(
          `/ratings/shops/${review.target_id}/users/${userId}`
        );

        if (response.success && response.data) {
          this.shopRatings.set(response.data.shop_id, response.data.rating);
          console.info(`Loaded rating for shop ${review.target_id}:`, response.data);
        }
      } catch (error) {
        console.error(`Error loading rating for shop ${review.target_id}:`, error);
      }
    }
  }


  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
          .margin({ right: 15 })

        Text('我的评价')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
      }
      .width('100%')
      .padding(15)
      .backgroundColor('#FFA500')

      Scroll() {
        Column() {
          ForEach(this.reviews, (review: ReviewItem) => {
            this.reviewItem(review)
          }, (review: ReviewItem) => review.review_id.toString())
        }
        .width('100%')
        .padding(10)
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }

  @Builder
  reviewItem(review: ReviewItem) {
    Column() {
      // 顶部行：名称/标题 + 日期
      Row() {
        // 根据 target_type 显示不同的 target_info 字段
        if (review.target_type === 'SHOP') {
          Column() {
            Text((review.target_info as ShopInfo).shop_name || '未知店铺')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)

            // // 添加用户历史评分显示（仅对商店类型）
            // if (this.shopRatings.has(review.target_id)) {
            //   Row() {
            //     Text('我的评分:')
            //       .fontSize(12)
            //       .fontColor('#666')
            //     Text(`${this.shopRatings.values()}/5`)
            //       .fontSize(14)
            //       .fontColor('#FF8C00')
            //       .margin({ left: 4 })
            //   }
            //   .margin({ top: 4 })
            // }
          }
          .layoutWeight(1)
        } else if (review.target_type === 'POST') {
          Text((review.target_info as PostInfo).title || '未知帖子')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
        } else if (review.target_type === 'DISH') {
          Text((review.target_info as DishInfo).dish_name || '未知菜品')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
        }

        Text(this.formatDate(review.created_at))
          .fontSize(12)
          .fontColor('#999')
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 评分和内容部分
      Column() {
        // 当前评价的评分
        Row() {
          Text('本次评分:')
            .fontSize(12)
            .fontColor('#666')
          Text(`${review.rating || 'N/A'}/5`)
            .fontSize(14)
            .fontColor('#FF8C00')
            .margin({ left: 4 })
        }
        .margin({ bottom: 8 })

        // 评价内容
        Text(review.content)
          .fontSize(14)
          .lineHeight(20)
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .margin({ bottom: 10 })

      // 图片部分
      if (review.images && review.images.length > 0) {
        Grid() {
          ForEach(review.images, (image: string) => {
            GridItem() {
              Image(image)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
                .borderRadius(8)
            }
          }, (item: string) => item)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(5)
        .columnsGap(5)
        .width('100%')
        .height(100)
        .margin({ bottom: 10 })
      }

      Divider()
        .color('#eee')
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#fff')
    .borderRadius(8)
    .shadow({ radius: 1, color: '#ddd', offsetX: 1, offsetY: 1 })
  }

}