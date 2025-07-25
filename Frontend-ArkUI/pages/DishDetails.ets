// entry\src\main\ets\pages\DishDetails.ets
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { DishHead, DishSideBar } from '../view/DishInformation';
import { DishDetailsView } from '../view/DishDetailsView';
import { DishComments } from '../view/DishComments';
import { CommonConstants } from '../constants/CommonConstants';
import { httpClient } from '../utils/HttpRequest'; // 导入httpClient
import { DishItem } from '../models/dish'; // 导入DishItem接口
import { ReviewItem } from '../models/review'; // 导入ReviewItem接口
import router from '@ohos.router';

interface dishItemResponseDetail {
  success: boolean;
  data: DishItem;
}

interface DishItemResponseDetail {
  success: boolean;
  data: ReviewItem[];
}

// @Entry
@Component
export struct DishDetails {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @StorageLink('windowTop') windowTop: number = 0;
  @StorageLink('windowBottom') windowBottom: number = 0;
  @Consume('ifShowSides') ifShowSides: boolean;
  @State ifPictureExpansion: Boolean = false;
  @State imageHeightExtension: number = 0;
  @State imageHeightFold: number = 0;
  @State imageHeight: number = 0;
  private informationScroller: Scroller = new Scroller();
  private detailScroller: Scroller = new Scroller();

  @State dishDetails: DishItem | null = null; // 菜品详情数据
  @State dishComments: ReviewItem[] = []; // 菜品评论数据
  private dishId: string = ''; // 从路由参数获取菜品ID

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['dishId']) {
      this.dishId = params['dishId'];
      this.loadDishDetails(this.dishId);
      this.loadDishComments(this.dishId);
    }
  }

  async loadDishDetails(dishId: string) {
    try {
      const response = await httpClient.get<dishItemResponseDetail>(`/dishes/${dishId}`);
      if (response.success) {
        this.dishDetails = response.data;
        console.log('Dish Details:', this.dishDetails);
      } else {
        console.error('Failed to load dish details:', response);
      }
    } catch (error) {
      console.error('Error loading dish details:', error);
    }
  }

  async loadDishComments(dishId: string) {
    try {
      const response = await httpClient.get<DishItemResponseDetail>(`/dishes/${dishId}/reviews`);
      if (response.success) {
        this.dishComments = response.data;
        console.log('Dish Comments:', this.dishComments);
      } else {
        console.error('Failed to load dish comments:', response);
      }
    } catch (error) {
      console.error('Error loading dish comments:', error);
    }
  }

  build() {
    NavDestination() {
      Scroll(this.informationScroller) {
        GridRow({
          columns: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ?
          BreakpointConstants.GRID_ROW_COLUMNS[2] : 1
        }) {
          GridCol({
            span: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ?
            BreakpointConstants.GRID_COLUMN_SPANS[7] : 1
          }) {
            if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG || this.ifShowSides) {
              DishHead({
                ifPictureExpansion: this.ifPictureExpansion,
                imageHeightExtension: this.imageHeightExtension,
                imageHeightFold: this.imageHeightFold,
                imageHeight: this.imageHeight
              })
            } else {
              DishSideBar()
            }
          }

          GridCol({
            span: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ?
            BreakpointConstants.GRID_COLUMN_SPANS[7] : 1
          }) {
            Scroll(this.detailScroller) {
              DishDetailsView() // 如果DishDetailsView需要菜品数据，可以通过@Prop传递
            }
            .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ?
            CommonConstants.FULL_PERCENT : CommonConstants.SELF_ADAPTING)
            .width(CommonConstants.FULL_PERCENT)
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.PARENT_FIRST
            })
            .scrollBar(BarState.Off)
          }

          if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_LG) {
            GridCol({
              span: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ? 0 : 1
            }) {
              DishComments({ commentsDataList: this.dishComments }) // 传递评论数据
                .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG && !this.ifShowSides ?
                CommonConstants.FULL_PERCENT : CommonConstants.SELF_ADAPTING)
            }
          }
        }
      }
      .scrollBar(BarState.Off)
      .scrollBarWidth(0)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('app.color.dish_detail_background'))
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        if (!this.ifPictureExpansion && offset < 0) {
          this.imageHeight = this.imageHeightExtension;
          this.ifPictureExpansion = true;
          return { offsetRemain: 0 };
        } else if (this.ifPictureExpansion && offset > 0) {
          this.imageHeight = this.imageHeightFold;
          this.ifPictureExpansion = false;
          return { offsetRemain: 0 };
        } else {
          return { offsetRemain: offset };
        }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideTitleBar(true)
  }
}