import { httpClient } from '../utils/HttpRequest';
import { HttpError, ApiResponse } from '../utils/HttpRequest';
import { ShopItem } from '../models/shops';
import { BreakpointConstants} from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { FoodListConstants } from '../constants/FoodListConstants';
import { BreakpointType } from '../utils/BreakpointType';
import router from '@ohos.router';

@Component
export struct FoodListHeader {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @StorageLink('pageShow') pageShow: string = 'button';
  @Consume('ifShowSides') ifShowSides: boolean;
  @State searchText: string = '';
  @State isSearching: boolean = false;
  @State searchError: string = '';
  @State searchResults: ShopItem[] = [];
  @State showSearchResults: boolean = false;

  private async searchShops(): Promise<void> {
    if (!this.searchText.trim()) {
      this.searchError = '搜索关键字不能为空';
      this.showSearchResults = false;
      return;
    }

    this.isSearching = true;
    this.searchError = '';
    this.showSearchResults = true;

    try {
      const response = await httpClient.get<ApiResponse<ShopItem[]>>(
        `/shops/search?keyword=${encodeURIComponent(this.searchText)}`
      );

      if (response.success && Array.isArray(response.data)) {
        this.searchResults = response.data.map((item: ShopItem) => {
          const shop: ShopItem = {
            shop_id: item.shop_id || 0,
            shop_name: item.shop_name || '未知店铺',
            address: item.address || '未知地址',
            latitude: item.latitude || 0,
            longitude: item.longitude || 0,
            business_hours: item.business_hours || '未提供营业时间',
            avg_price: item.avg_price || 0,
            discount_info: item.discount_info || '无优惠信息',
            contact_phone: item.contact_phone || '暂无联系方式',
            follower_count: item.follower_count || 0,
            created_at: item.created_at || new Date().toISOString(),
            average_rating: item.average_rating || 0,
            image_url: item.image_url || '',
            // user_rating: item.user_rating || 0
          };
          return shop;
        });
      } else {
        this.searchError = response.message || '搜索失败';
      }
    } catch (error) {
      this.searchError = error instanceof HttpError ? error.message : '网络请求失败';
      console.error('搜索失败:', error);
    } finally {
      this.isSearching = false;
    }
  }

  private clearSearch(): void {
    this.searchText = '';
    this.searchResults = [];
    this.searchError = '';
    this.isSearching = false;
    this.showSearchResults = false;
  }

  @Builder
  private searchResultsView() {
    if (this.showSearchResults) {
      Column() {
        if (this.isSearching) {
          Column() {
            // 更美观的加载动画
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#FFA500')

            Text('正在搜索中...')
              .fontSize(16)
              .fontColor('#666')
              .margin({ top: 12 })
          }
          .width('100%')
          .height(200)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else if (this.searchError) {
          Column() {
            Image($r('app.media.icon_error'))
              .width(60)
              .height(60)
              .margin({ bottom: 16 })

            Text(this.searchError)
              .fontSize(16)
              .fontColor(Color.Red)
              .width('80%')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 24 })

            Button('返回')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .width(120)
              .height(40)
              .backgroundColor('#FFA500')
              .borderRadius(20)
              .onClick(() => {
                this.clearSearch();
              })
          }
          .width('100%')
          .height(200)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else if (this.searchResults.length > 0) {
          Column() {
            Row() {
              Text('搜索结果')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333')
                .layoutWeight(1)

              Button() {
                Text('返回')
                  .fontSize(14)
                  .fontColor('#FFA500')
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .height('100%')
              }
              .width(60)
              .height(30)
              .backgroundColor(Color.White)
              .borderRadius(15)
              .border({ width: 1, color: '#FFA500' })
              .onClick(() => {
                this.showSearchResults = false;
              })
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 16, bottom: 12 })

            List() {
              ForEach(this.searchResults, (item: ShopItem) => {
                ListItem() {
                  this.searchResultItem(item)
                }
              }, (item: ShopItem) => item.shop_id.toString())
            }
            .width('100%')
            .height('100%')
            .divider({ strokeWidth: 0.5, color: '#f0f0f0' })
          }
        } else {
          Column() {
            Image($r('app.media.icon_empty_search'))
              .width(100)
              .height(100)
              .margin({ bottom: 16 })

            Text('没有找到相关店铺')
              .fontSize(18)
              .fontColor('#666')
              .margin({ bottom: 8 })

            Text('换个关键词试试吧')
              .fontSize(14)
              .fontColor('#999')
              .margin({ bottom: 24 })

            Button('返回')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .width(120)
              .height(40)
              .backgroundColor('#FFA500')
              .borderRadius(20)
              .onClick(() => {
                this.showSearchResults = false;
              })
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .position({ x: 0, y: 0 })
      .zIndex(999)
    }
  }

  @Builder
  private searchResultItem(item: ShopItem) {
    Column() {
      Row() {
        // 店铺图片 - 添加圆角和阴影
        if (item.image_url) {
          Image(item.image_url)
            .width(90)
            .height(90)
            .borderRadius(12)
            .objectFit(ImageFit.Cover)
            .margin({ right: 12 })
            .shadow({ radius: 4, color: '#20000000', offsetX: 1, offsetY: 1 })
        } else {
          Image($r('app.media.icon_empty_shop'))
            .width(90)
            .height(90)
            .borderRadius(12)
            .margin({ right: 12 })
            .shadow({ radius: 4, color: '#20000000', offsetX: 1, offsetY: 1 })
        }

        // 店铺信息 - 优化布局和样式
        Column() {
          Row() {
            Text(item.shop_name)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333')
              .margin({ bottom: 6 })
              .layoutWeight(1)

            // // 评分星星
            // Row() {
            //   ForEach(new Array<number>(Math.floor(item.average_rating || 0)), (_) => {
            //     Image($r('app.media.icon_collectionblack'))
            //       .width(14)
            //       .height(14)
            //       .margin({ right: 2 })
            //   })
            //
            //   if (item.average_rating && item.average_rating % 1 > 0) {
            //     Image($r('app.media.icon_star_half'))
            //       .width(14)
            //       .height(14)
            //       .margin({ right: 2 })
            //   }
            //
            //   ForEach(new Array(5 - Math.ceil(item.average_rating || 0)), (_, index) => {
            //     Image($r('app.media.icon_collection'))
            //       .width(14)
            //       .height(14)
            //       .margin({ right: 2 })
            //   })
            //
            //   Text(item.average_rating?.toFixed(1) || '0.0')
            //     .fontSize(12)
            //     .fontColor('#FFA500')
            //     .margin({ left: 4 })
            // }
          }
          .width('100%')
          .margin({ bottom: 4 })

          Row() {
            Image($r('app.media.icon_location'))
              .width(12)
              .height(12)
              .margin({ right: 4 })

            Text(item.address)
              .fontSize(12)
              .fontColor('#666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 6 })

          Row() {
            Image($r('app.media.icon_price'))
              .width(12)
              .height(12)
              .margin({ right: 4 })

            Text(`人均 ¥${item.avg_price}`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ right: 12 })

            Image($r('app.media.icon_time'))
              .width(12)
              .height(12)
              .margin({ right: 4 })

            Text(item.business_hours)
              .fontSize(12)
              .fontColor('#666')
          }
          .width('100%')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(12)

      // 分割线
      Divider()
        .strokeWidth(0.5)
        .color('#f0f0f0')
        .margin({ left: 12, right: 12 })
    }
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ top: 8, left: 16, right: 16 })
    .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ShopDetail',
        params: {
          shopId: item.shop_id.toString(),
          shopName: item.shop_name
        }
      });
    })
  }

  build() {
    Stack() {
      Row() {
        Image($r('app.media.icon_back'))
          .width($r('app.float.common_image'))
          .aspectRatio(1)
          .margin({
            right: $r('app.float.back_image_right')
          })
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })

        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: $r('app.string.food_name'), text: this.searchText })
            .height($r('app.float.food_name_height'))
            .placeholderFont({
              size: $r('app.float.food_data_font'),
              weight: FontWeight.Normal
            })
            .backgroundColor(Color.White)
            .width(CommonConstants.FULL_PERCENT)
            .border({
              width: $r('app.float.food_border_width'),
              color: $r('app.color.food_border_color'),
              radius: $r('app.float.food_border_radius')
            })
            .padding({
              left: $r('app.float.food_padding_left'),
              right: $r('app.float.food_padding_right'),
              top: $r('app.float.food_padding_tb'),
              bottom: $r('app.float.food_padding_tb')
            })
            .enableKeyboardOnFocus(false)
            .onChange((value: string) => {
              this.searchText = value;
            })

          Image($r('app.media.icon_search'))
            .width($r('app.float.search_width'))
            .aspectRatio(1)
            .position({
              x: $r('app.float.search_position_x'),
              y: $r('app.float.search_position_y')
            })
            .onClick(() => {
              this.searchShops();
            })

          Image($r('app.media.icon_voice'))
            .width($r('app.float.voice_width'))
            .offset({
              x: $r('app.float.voice_offset')
            })
        }
        .height($r('app.float.food_height'))
        .width($r('app.float.food_width'))
        .layoutWeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM || this.ifShowSides ? 1 : 0)

        Button('搜索')
          .fontSize(14)
          .fontColor('#FFA500')
          .width(60)
          .height(30)
          .backgroundColor(Color.White)
          .borderRadius(15)
          .onClick(() => {
            this.searchShops();
          })
      }
      .height($r('app.float.food_stack_height'))
      .width(CommonConstants.FULL_PERCENT)

      // 搜索结果视图
      this.searchResultsView()
    }
  }

  @Builder
  RatingStars(rating: number = 0) {
    Row() {
      ForEach(Array.from({ length: 5 }), (item: undefined, index: number) => {
        Image(index < Math.floor(rating) ? $r('app.media.icon_collectionblack') : $r('app.media.icon_collection'))
          .width(14)
          .height(14)
          .margin({ right: 2 })
      })
      Text(rating.toFixed(1))
        .fontSize(12)
        .margin({ left: 4 })
    }
  }
}

@Component
export struct FoodListTab {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;

  build() {
    List() {
      ForEach(FoodListConstants.TABS_LIST, (item: string) => {
        ListItem() {
          Text(item)
            .fontSize($r('app.float.tabs_font'))
            .fontWeight(FontWeight.Normal)
            .padding({
              top: $r('app.float.tabs_padding_tb'),
              bottom: $r('app.float.tabs_padding_tb'),
              left: $r('app.float.twelves_padding'),
              right: $r('app.float.twelves_padding')
            })
            .margin({
              right: $r('app.float.tabs_margin_right')
            })
            .backgroundColor($r('app.color.five_white'))
            .height($r('app.float.tabs_list_height'))
            .borderRadius($r('app.float.tabs_list_radius'))
        }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .listDirection(Axis.Horizontal)
    .height($r('app.float.tabs_height'))
    .padding({
      top: $r('app.float.twelves_padding'),
      bottom: $r('app.float.twelves_padding'),
      left: new BreakpointType($r('app.float.padding_small'), $r('app.float.tabs_list_padding_left'),
        $r('app.float.common_padding')).getValue(this.currentBreakpoint)
    })
    .scrollBarWidth(0)
  }
}