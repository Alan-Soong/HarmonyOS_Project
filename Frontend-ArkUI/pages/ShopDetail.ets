import { BreakpointConstants } from '../constants/BreakpointConstants';
import { BreakpointType } from '../utils/BreakpointType';
import { CommonConstants } from '../constants/CommonConstants';
import { httpClient } from '../utils/HttpRequest';
import { prompt, promptAction, router } from '@kit.ArkUI';
import { ShopItem, ShopItemResponse } from '../models/shops';
import { ReviewItem, ReviewsResponse } from '../models/review';
import { RatingRequest, RatingStatsResponse } from '../models/rating';
import { UserStore } from '../models/UserStore';
import { FollowRequest,
  FollowResponse,
  ReviewRequest, ReviewResponse, RouteParams,
  UnfollowResponse,
  UserRatingResponse } from '../models/Interface';


@Component
struct UserRatingStars {
  @Prop review: ReviewItem;
  @State userRating: number = 0;
  private starSize: number = 16;

  async aboutToAppear() {
    this.userRating = await this.loadUserRating(this.review.user_id);
  }

  private async loadUserRating(userId: number): Promise<number> {
    try {
      const response = await httpClient.get<UserRatingResponse>(
        `/ratings/shops/${this.review.target_id}/users/${userId}`
      );
      return response.data?.rating || 0;
    } catch (error) {
      console.error('Failed to load user rating:', error);
      return 0;
    }
  }

  build() {
    Row() {
      ForEach(Array.from({ length: 5 }), (item: undefined, index: number) => {
        Image(index < Math.floor(this.userRating) ?
        $r('app.media.icon_collectionblack') :
        $r('app.media.icon_collection'))
          .width(this.starSize)
          .height(this.starSize)
          .margin({ right: 2 })
      })

      Text(`${this.userRating}`)
        .fontSize(this.starSize - 4)
        .margin({ left: 4 })
        .fontColor('#FF6D00')
    }
    .alignItems(VerticalAlign.Center)
  }
}

interface G {
  success: boolean;
}

@Entry
@Component
export struct ShopDetail {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @StorageLink('windowTop') windowTop: number = 0;
  @StorageLink('windowBottom') windowBottom: number = 0;

  @State userRating: number = 0;
  @State isRating: boolean = false;
  @State ratingError: string = '';

  @State shopDetail: ShopItem = {
    shop_id: 0,
    shop_name: '',
    address: '',
    latitude: 0,
    longitude: 0,
    image_url: '',
    business_hours: '',
    avg_price: 0,
    discount_info: '',
    contact_phone: '',
    created_at: '',
    follower_count: 0,
    average_rating: 0,
  };

  @State reviews: ReviewItem[] = [];
  @State isLoading: boolean = true;
  @State error: string = '';
  @State activeTab: string = 'info';
  private shopId: string = '';

  @State newComment: string = '';
  @State replyingTo: ReviewItem | null = null;
  @State isSubmittingComment: boolean = false;
  @State commentError: string = '';

  @State isFollowing: boolean = false;
  @State isFollowingLoading: boolean = false;
  @State followError: string = '';

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

  async aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params?.shopId) {
      this.shopId = params.shopId;
      await this.loadData();
      await this.checkFollowStatus(); // 新增：加载关注状态
    } else {
      this.error = '缺少店铺参数';
      this.isLoading = false;
    }
  }

  async loadData() {
    this.isLoading = true;
    this.error = '';

    try {
      const shopResponse = await httpClient.get<ShopItemResponse>(`/shops/${this.shopId}`);
      const shopStr = JSON.stringify(shopResponse.data);
      const shopDict: ShopItem = JSON.parse(shopStr);

      if (shopResponse.success) {
        this.shopDetail = shopDict;
      } else {
        throw new Error(shopResponse.message || '获取店铺信息失败');
      }

      const reviewsResponse = await httpClient.get<ReviewsResponse>(
        `/reviews?target_type=SHOP&target_id=${parseInt(this.shopId)}`
      );

      if (reviewsResponse.success) {
        this.reviews = reviewsResponse.data.map((review: ReviewItem): ReviewItem => {
          return {
            review_id: review.review_id,
            user_id: review.user_id,
            content: review.content,
            created_at: review.created_at,
            target_type: review.target_type,
            target_id: review.target_id,
            parent_review_id: review.parent_review_id,
            username: review.username,
            avatar_url: review.avatar_url,
            images: review.images || [],
            rating: review.rating || 0,
            target_info: review.target_info,
            like_count: review.like_count,
            parent_review: review.parent_review
          };
        });

        await this.loadUserRating();
      } else {
        throw new Error(reviewsResponse.message || '获取评论失败');
      }
    } catch (err) {
      console.error('Error loading data:', err);
      this.error = err.message || '加载数据失败，请稍后重试';
    } finally {
      this.isLoading = false;
    }
  }

  async loadUserRating() {
    try {
      const response = await httpClient.get<UserRatingResponse>(
        `/ratings/shops/${this.shopId}/users/${UserStore.getCurrentUserId()}`
      );

      if (response.success) {
        this.userRating = response.data?.rating || 0;
      }
    } catch (error) {
      console.error('Failed to load user rating:', error);
    }
  }

  async submitRating(rating: number) {
    this.isRating = true;
    this.ratingError = '';

    try {
      const requestData: RatingRequest = {
        shop_id: parseInt(this.shopId),
        user_id: UserStore.getCurrentUserId(),
        rating: rating
      };

      const response = await httpClient.post<RatingStatsResponse>('/ratings/shops', requestData);

      if (response.success) {
        this.userRating = rating;
        promptAction.showToast({
          message: `评分${response.data.action === 'created' ? '成功' : '更新成功'}`
        });
        await Promise.all([this.loadData(), this.loadUserRating()]);
      } else {
        throw new Error('评分失败');
      }
    } catch (error) {
      console.error('Rating error:', error);
      this.ratingError = '评分失败，请重试';
    } finally {
      this.isRating = false;
    }
  }

  async submitComment() {
    if (!this.newComment.trim()) {
      this.commentError = '评论内容不能为空';
      return;
    }

    this.isSubmittingComment = true;
    this.commentError = '';

    try {
      const requestData: ReviewRequest = {
        user_id: UserStore.getCurrentUserId(),
        content: this.newComment,
        target_type: 'SHOP',
        target_id: parseInt(this.shopId),
        parent_review_id: this.replyingTo?.review_id,
        rating: this.userRating > 0 ? this.userRating : undefined
      };

      const response = await httpClient.post<ReviewResponse>('/reviews', requestData);

      if (response.success) {
        this.newComment = '';
        this.replyingTo = null;
        promptAction.showToast({ message: '评论成功' });
        await this.loadData();
      } else {
        throw new Error('评论失败');
      }
    } catch (error) {
      console.error('Comment error:', error);
      this.commentError = error.message || '评论失败，请重试';
    } finally {
      this.isSubmittingComment = false;
    }
  }

  cancelReply() {
    this.replyingTo = null;
    this.newComment = '';
  }

  // 检查用户是否已关注该店铺
  async checkFollowStatus() {
    try {
      const currentUserId = UserStore.getCurrentUserId();
      const response = await httpClient.get<G>(
        `/following/shops/check/${currentUserId}/${this.shopId}`
      );
      this.isFollowing = response.success;
    } catch (error) {
      console.error('检查关注状态失败:', error);
    }
  }

  // 关注店铺
  async followShop() {
    if (this.isFollowingLoading) return;

    this.isFollowingLoading = true;
    this.followError = '';

    try {
      const currentUserId = UserStore.getCurrentUserId();
      const requestData: FollowRequest = {
        user_id: currentUserId,
        shop_id: parseInt(this.shopId)
      };

      const response = await httpClient.post<FollowResponse>(
        '/following/shops',
        requestData
      );

      if (response.success) {
        this.isFollowing = true;
        this.shopDetail.follower_count += 1;
        prompt.showToast({ message: '已关注该店铺' });
      }
    } catch (error) {
      console.error('关注失败:', error);
      this.followError = '关注失败，请重试';
    } finally {
      this.isFollowingLoading = false;
    }
  }

  // 取消关注店铺
  async unfollowShop() {
    if (this.isFollowingLoading) return;

    this.isFollowingLoading = true;
    this.followError = '';

    try {
      const currentUserId = UserStore.getCurrentUserId();
      const response = await httpClient.delete<UnfollowResponse>(
        `/following/shops/${currentUserId}/${this.shopId}`
      );

      if (response.success) {
        this.isFollowing = false;
        this.shopDetail.follower_count -= 1;
        prompt.showToast({ message: '已取消关注' });
      }
    } catch (error) {
      console.error('取消关注失败:', error);
      this.followError = '取消关注失败，请重试';
    } finally {
      this.isFollowingLoading = false;
    }
  }


  @Builder
  InfoSection(icon: Resource, title: string, content: string) {
    Row() {
      Image(icon)
        .width(16)
        .height(16)
        .margin({ right: 8 })
      Text(title + '：')
        .fontSize(14)
        .fontColor('#666')
        .margin({ right: 4 })
      Text(content)
        .fontSize(14)
        .fontColor('#333')
        .layoutWeight(1)
        .lineHeight(20)
    }
    .padding({ top: 4, bottom: 4 })
    .width('100%')
  }

  // 新增顶部栏组件
  @Builder
  TopBar() {
    Row() {
      Button() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(Color.Transparent)
      .onClick(() => router.back())

      // // 可以在这里添加其他顶部栏元素，如标题等
      // Blank()
      //   .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#FFFFFF') // 可根据需要调整背景色
    .zIndex(1) // 确保顶部栏在最上层
  }

  @Builder
  DetailHeader() {
    Column() {
     this.TopBar()

      Stack() {
        if (this.shopDetail.image_url) {
          Image(this.shopDetail.image_url)
            .width('100%')
            .height(
              400)
            .objectFit(ImageFit.Cover)
        } else {
          Image($r('app.media.icon_empty_shop'))
            .width('100%')
            .height(250)
            .objectFit(ImageFit.Cover)
        }
      }
      .width('100%')
      .height(180)
      .margin({ bottom: 120 })

      Column() {
        Row() {
          Text(this.shopDetail.shop_name || '未知店铺')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

            .layoutWeight(1)
          // 关注/取消关注按钮
          Button(this.isFollowing ? '已关注' : '关注')
            .fontSize(14)
            .width(80)
            .height(32)
            .backgroundColor(this.isFollowing ? '#F5F5F5' : '#FF6D00')
            .fontColor(this.isFollowing ? '#666' : '#FFFFFF')
            .borderRadius(16)
            .onClick(() => {
              if (this.isFollowing) {
                this.unfollowShop();
              } else {
                this.followShop();
              }
            })
            .stateEffect(true)
            .enabled(!this.isFollowingLoading)
        }
        .width('100%')
        .margin({ bottom: 8 })


        if (this.shopDetail.average_rating) {
          Row() {
            Row() {
              ForEach(Array.from({ length: 5 }), (item: undefined, index: number) => {
                Image(index < Math.floor(this.shopDetail.average_rating) ?
                $r('app.media.icon_collectionblack') :
                $r('app.media.icon_collection'))
                  .width(16)
                  .height(16)
                  .margin({ right: 2 })
              })
            }
            Text(`(${this.reviews.length}条评价)`)
              .fontSize(14)
              .fontColor('#666')
              .margin({ left: 8 })
          }
          .margin({ bottom: 12 })
          .width('100%')
        }

        Column() {
          Text('我的评分')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            ForEach(Array.from({ length: 5 }), (item: undefined, index: number) => {
              Image(index < this.userRating ?
              $r('app.media.icon_collectionblack') :
              $r('app.media.icon_collection'))
                .width(24)
                .height(24)
                .margin({ right: 8 })
                .onClick(() => {
                  this.submitRating(index + 1);
                })
            })
          }
          .margin({ bottom: 12 })

          if (this.ratingError) {
            Text(this.ratingError)
              .fontSize(12)
              .fontColor('#FF0000')
              .margin({ bottom: 8 })
          }
        }
        .padding(12)
        .width('100%')
        .backgroundColor('#FAFAFA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        Column() {
          if (this.shopDetail.business_hours) {
            this.InfoSection($r('app.media.icon_time'), '营业时间', this.shopDetail.business_hours)
          }

          if (this.shopDetail.contact_phone) {
            this.InfoSection($r('app.media.icon_phone'), '联系电话', this.shopDetail.contact_phone)
          }

          if (this.shopDetail.avg_price) {
            this.InfoSection($r('app.media.icon_price'), '人均消费', `¥${this.shopDetail.avg_price}`)
          }

          this.InfoSection($r('app.media.icon_location'), '地址', this.shopDetail.address || '地址未知')
        }
        .padding(12)
        .width('100%')
        .backgroundColor('#FAFAFA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        if (this.shopDetail.follower_count) {
          Row() {
            Image($r('app.media.icon_follow'))
              .width(14)
              .height(14)
              .margin({ right: 4 })
            Text(`${this.shopDetail.follower_count}人关注`)
              .fontSize(12)
              .fontColor('#999')
          }
          .margin({ top: 4 })
        }
      }
      .padding(16)
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(8)
      .margin({ top: -20 })
      .shadow({ radius: 4, color: '#10000000', offsetX: 1, offsetY: 1 })
    }
  }

  @Builder
  ReviewItem(review: ReviewItem) {
    Column() {
      Row() {
        if (review.avatar_url) {
          Image(review.avatar_url)
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
        } else {
          Image($r('app.media.icon_empty_shop'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 })
        }

        Column() {
          Text(review.username || '匿名用户')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text(this.formatDate(review.created_at))
            .fontSize(12)
            .fontColor('#999')
        }
        .layoutWeight(1)

        Column() {
          UserRatingStars({ review: review })
          Text('用户评分')
            .fontSize(10)
            .fontColor('#999')
        }
        .margin({ left: 8 })
      }
      .margin({ bottom: 8 })

      Text(review.content)
        .fontSize(14)
        .margin({ bottom: 8 })

      if (review.images && review.images.length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(review.images, (image: string) => {
            Image(image)
              .width(80)
              .height(80)
              .margin({ right: 8, bottom: 8 })
              .borderRadius(4)
          })
        }
        .margin({ bottom: 8 })
        .width('100%')
      }

      Row() {
        Image($r('app.media.icon_like'))
          .width(16)
          .height(16)
          .margin({ right: 4 })
        Text(review.like_count.toString())
          .fontSize(12)
          .fontColor('#999')
          .margin({ right: 16 })

        Row() {
          Image($r('app.media.icon_comment'))
            .width(16)
            .height(16)
            .margin({ right: 4 })
          Text('回复')
            .fontSize(12)
            .fontColor('#999')
        }
        .onClick(() => {
          this.replyingTo = review;
        })
      }

      if (review.parent_review) {
        Column() {
          Text(`回复：${review.parent_review.username}`)
            .fontSize(12)
            .fontColor('#666')
            .margin({ bottom: 4 })
          Text(review.parent_review.content)
            .fontSize(12)
            .fontColor('#999')
            .padding(8)
            .backgroundColor('#F5F5F5')
            .borderRadius(4)
            .width('100%')
        }
        .margin({ top: 8 })
      }
    }
    .padding(16)
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 12 })
  }

  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  ErrorView() {
    Column() {
      Image($r('app.media.icon_error'))
        .width(100)
        .height(100)
        .margin({ bottom: 16 })
      Text(this.error || '加载失败')
        .fontSize(16)
        .margin({ bottom: 16 })
      Button('重试')
        .width(120)
        .height(40)
        .onClick(() => this.loadData())
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      if (this.isLoading) {
        this.LoadingView()
      } else if (this.error) {
        this.ErrorView()
      } else {
        Scroll() {
          Column() {
            this.DetailHeader()

            Text('用户评价')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ left: 16, top: 16, bottom: 8 })
              .width('100%')

            Column() {
              if (this.replyingTo) {
                Row() {
                  Text(`回复：${this.replyingTo.username}`)
                    .fontSize(12)
                    .fontColor('#666')
                    .layoutWeight(1)

                  Image($r('app.media.icon_error'))
                    .width(16)
                    .height(16)
                    .onClick(() => this.cancelReply())
                }
                .padding(8)
                .backgroundColor('#FAFAFA')
                .borderRadius(4)
                .margin({ bottom: 8 })
              }

              TextInput({ placeholder: '写下你的评论...' })
                .height(80)
                .width('100%')
                .backgroundColor('#FFF')
                .borderRadius(8)
                .padding(12)
                .onChange((value: string) => {
                  this.newComment = value;
                })

              Row() {
                Button('提交评论')
                  .width(120)
                  .height(40)
                  .backgroundColor('#FF6D00')
                  .fontColor(Color.White)
                  .borderRadius(20)
                  .onClick(() => this.submitComment())
                  .enabled(!this.isSubmittingComment)

                if (this.isSubmittingComment) {
                  LoadingProgress()
                    .width(20)
                    .height(20)
                    .margin({ left: 8 })
                }
              }
              .justifyContent(FlexAlign.End)
              .margin({ top: 8 })

              if (this.commentError) {
                Text(this.commentError)
                  .fontSize(12)
                  .fontColor('#FF0000')
                  .margin({ top: 4 })
              }
            }
            .padding(16)
            .width('100%')
            .backgroundColor('#FFF')
            .borderRadius(8)
            .margin({ bottom: 12 })

            if (this.reviews.length === 0) {
              Column() {
                Image($r('app.media.icon_nocomment'))
                  .width(100)
                  .height(100)
                  .margin({ bottom: 16 })
                Text('暂无评论')
                  .fontSize(16)
                  .fontColor('#999')
              }
              .width('100%')
              .height(200)
              .justifyContent(FlexAlign.Center)
            } else {
              Column() {
                ForEach(this.reviews, (review: ReviewItem) => {
                  this.ReviewItem(review)
                })
              }
              .padding({
                left: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                  $r('app.float.common_padding')).getValue(this.currentBreakpoint),
                right: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                  $r('app.float.common_padding')).getValue(this.currentBreakpoint),
                bottom: 12
              })
            }
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .padding({ top: this.windowTop })
  }
}