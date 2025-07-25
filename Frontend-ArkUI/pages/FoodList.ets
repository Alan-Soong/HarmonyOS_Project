import { ShopDisplay } from './ShopDisplay';
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { FoodListHeader, FoodListTab } from '../view/FoodListHeader';
import { BreakpointType } from '../utils/BreakpointType';
import { ShopItem } from '../models/shops';
import { CommonConstants } from '../constants/CommonConstants';
import { promptAction, router } from '@kit.ArkUI';
import { httpClient } from '../utils/HttpRequest';
import { RatingStatsResponse } from '../models/rating';

interface ShopListResponse {
  success: boolean;
  data: ShopItem[];
}

@Entry
@Component
export struct FoodList {
  @StorageLink('currentBreakpoint') @Watch('changeBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink('windowTop') windowTop: number = 0;
  @StorageLink('windowBottom') windowBottom: number = 0;
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @Provide('ifShowSides') ifShowSides: boolean = false;
  @Provide('ifShowShopDisplay') ifShowShopDisplay: boolean = false;
  @State shopList: ShopItem[] = [];
  @State displayedShops: ShopItem[] = []; // 新增：当前显示的店铺列表
  @State isLoading: boolean = true;
  @State isLoadingMore: boolean = false; // 新增：是否正在加载更多
  private scroller: Scroller = new Scroller();
  private batchSize: number = 10; // 新增：每批加载10条
  private currentIndex: number = 0; // 新增：当前已加载的店铺索引

  aboutToAppear() {
    this.loadShopList();
  }

  async loadShopList() {
    this.isLoading = true;
    try {
      const response = await httpClient.get<ShopListResponse>('/shops');
      if (response.success) {
        this.shopList = response.data;
        // 初始加载前10条
        this.displayedShops = this.shopList.slice(0, this.batchSize);
        this.currentIndex = this.batchSize;
        await this.loadRatingsForShops(this.displayedShops);
      } else {
        console.error('Failed to load shop list:', response);
      }
    } catch (error) {
      console.error('Error loading shop list:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async loadMoreShops() {
    if (this.currentIndex >= this.shopList.length || this.isLoadingMore) {
      return; // 没有更多数据或正在加载
    }
    this.isLoadingMore = true;
    try {
      // 加载下一批数据
      const nextBatch = this.shopList.slice(this.currentIndex, this.currentIndex + this.batchSize);
      await this.loadRatingsForShops(nextBatch);
      this.displayedShops = [...this.displayedShops, ...nextBatch];
      this.currentIndex += this.batchSize;
    } catch (error) {
      console.error('Error loading more shops:', error);
    } finally {
      this.isLoadingMore = false;
    }
  }

  async loadRatingsForShops(shops: ShopItem[]): Promise<void> {
    const ratingPromises: Array<Promise<void>> = shops.map(async (shop: ShopItem) => {
      try {
        const ratingResponse = await httpClient.get<RatingStatsResponse>(`/ratings/shops/${shop.shop_id}/stats`);
        if (ratingResponse.success && ratingResponse.data) {
          shop.average_rating = ratingResponse.data.average_rating;
        }
      } catch (error) {
        console.error(`Error loading rating for shop ${shop.shop_id}:`, error);
      }
    });
    await Promise.all(ratingPromises);
    this.displayedShops = [...this.displayedShops]; // 触发UI更新
  }

  @Builder
  PageMap() {
    ShopDisplay();
  }

  onBackPress(): boolean | void {
    this.pageInfo.pop();
  }

  changeBreakpoint() {
    if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
      this.ifShowSides = false;
    }
  }

  private getRoundedRating(rating: number = 0) {
    return Math.round(rating);
  }

  @Builder
  RatingStars(rating: number = 0) {
    Row() {
      ForEach(Array.from({ length: 5 }), (item: undefined, index: number) => {
        Image(index < this.getRoundedRating(rating) ? $r('app.media.icon_collectionblack') : $r('app.media.icon_collection'))
          .width(14)
          .height(14)
          .margin({ right: 2 })
      })
      Text(rating.toFixed(1))
        .fontSize(12)
        .margin({ left: 4 })
        .fontColor('#FF9500')
    }
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  ShopCard(shop: ShopItem, index: number) {
    Column() {
      Row() {
        Column() {
          if (shop.image_url) {
            Image(shop.image_url)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
              .onError(() => {
                console.error('图片加载失败:', shop.image_url);
                promptAction.showToast({
                  message: '图片加载失败'
                });
              })
          } else {
            Image($r('app.media.icon_empty_shop'))
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
          }
        }
        .width(100)
        .height(100)
        .borderRadius(8)
        .backgroundColor('#E0E0E0')
        .margin({ right: 12 })

        Column() {
          Row() {
            Text(shop.shop_name)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            this.RatingStars(shop.average_rating || 0)
          }
          .margin({ bottom: 6 })

          Row() {
            Image($r('app.media.icon_location'))
              .width(12)
              .height(12)
              .margin({ right: 4 })
            Text(shop.address)
              .fontSize(12)
              .fontColor('#666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .margin({ bottom: 6 })

          Row() {
            Row() {
              Image($r('app.media.icon_time'))
                .width(12)
                .height(12)
                .margin({ right: 4 })
              Text(shop.business_hours || '营业时间未知')
                .fontSize(12)
                .fontColor('#666')
            }
            .layoutWeight(1)
            Text(`人均 ¥${shop.avg_price || '--'}`)
              .fontSize(12)
              .fontColor('#FF6D00')
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFF')
      .borderRadius(8)
      .shadow({ radius: 4, color: '#10000000', offsetX: 1, offsetY: 1 })
    }
    .margin({ bottom: 12 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ShopDetail',
        params: {
          shopId: shop.shop_id,
          shopName: shop.shop_name,
          averageRating: shop.average_rating?.toString() || '0'
        }
      });
    })
  }

  build() {
    Row() {
      Navigation(this.pageInfo) {
        Column() {
          FoodListHeader()
            .padding({
              left: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                $r('app.float.common_padding')).getValue(this.currentBreakpoint),
              right: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                $r('app.float.common_padding')).getValue(this.currentBreakpoint)
            })

          if (this.isLoading) {
            Column() {
              LoadingProgress()
                .width(50)
                .height(50)
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
          } else if (this.displayedShops.length === 0) {
            Column() {
              Text('暂无商家数据')
                .fontSize(16)
                .margin({ top: 12 })
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
          } else {
            Scroll(this.scroller) {
              Column() {
                ForEach(this.displayedShops, (shop: ShopItem, index: number) => {
                  this.ShopCard(shop, index)
                })
                if (this.isLoadingMore) {
                  Column() {
                    LoadingProgress()
                      .width(30)
                      .height(30)
                  }
                  .width('100%')
                  .padding(10)
                  .justifyContent(FlexAlign.Center)
                }
              }
              .padding({
                left: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                  $r('app.float.common_padding')).getValue(this.currentBreakpoint),
                right: new BreakpointType($r('app.float.padding_small'), $r('app.float.padding_food_md'),
                  $r('app.float.common_padding')).getValue(this.currentBreakpoint),
                top: 12,
                bottom: 12
              })
            }
            .scrollBarWidth(0)
            .layoutWeight(1)
            .onScrollEdge((edge: Edge) => {
              if (edge === Edge.Bottom && !this.isLoadingMore && this.currentIndex < this.shopList.length) {
                this.loadMoreShops();
              }
            })
          }
        }
        .padding({
          top: this.windowTop
        })
        .width('100%')
      }
      .height(CommonConstants.FULL_PERCENT)
      .hideTitleBar(true)
    }
    .height(CommonConstants.FULL_PERCENT)
    .width('100%')
    .backgroundColor('#F5F5F5')
  }
}