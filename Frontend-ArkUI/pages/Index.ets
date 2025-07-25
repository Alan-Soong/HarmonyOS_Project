import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { UserStore } from '../models/UserStore';
import { NotesPage } from './NotesPage';
import { MapPage } from './MapPage';
import { MessagesPage } from './MessagePage';
import { Mine } from './Mine';

@Entry
@Component
struct Index {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @State selectedTab: number = 0;

  aboutToAppear(): void {
    if (!AppStorage.has('currentUserId')) {
      AppStorage.setOrCreate('currentUserId', '');
    }
    if (!AppStorage.has('currentUsername')) {
      AppStorage.setOrCreate('currentUsername', '');
    }

    const userId = UserStore.getCurrentUserId();
    console.info('Current user ID from AppStorage:', userId);
    if (!userId) {
      console.info('No user logged in, clearing invalid data and redirecting to LoginPage');
      UserStore.setCurrentUserId(0);
      UserStore.setCurrentUsername('');
      router.replaceUrl({ url: 'pages/LoginPage' });
      return;
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          if (this.selectedTab === 0) {
            NotesPage()
          } else if (this.selectedTab === 1) {
            MapPage()
          } else if (this.selectedTab === 3) {
            MessagesPage()
          } else if (this.selectedTab === 4) {
            Mine()
          }
        }
      }
      .scrollBar(BarState.Off)
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)

      this.bottomTabs()
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }

  @Builder
  bottomTabs() {
    Row() {
      Column() {
        Image(this.selectedTab === 0 ? $r('app.media.icon_1_select') : $r('app.media.icon_1'))
          .width(24)
          .height(24)
          .fillColor(this.selectedTab === 0 ? '#FF0000' : '#666')
        Text('首页')
          .fontSize(12)
          .fontColor(this.selectedTab === 0 ? '#FFFFFF' : '#666')
      }
      .onClick(() => { this.selectedTab = 0 })
      .layoutWeight(1)
      .padding(5)

      Column() {
        Image(this.selectedTab === 1 ? $r('app.media.icon_2_select') : $r('app.media.icon_2'))
          .width(24)
          .height(24)
          .fillColor(this.selectedTab === 1 ? '#FF0000' : '#666')
        Text('地图')
          .fontSize(12)
          .fontColor(this.selectedTab === 1 ? '#FFFFFF' : '#666')
      }
      .onClick(() => {
        this.selectedTab = 1;
        router.pushUrl({
          url: 'pages/Map'
        }).catch((err: Error) => {
          console.error('跳转失败: ' + JSON.stringify(err));
        });
      })
      .layoutWeight(1)
      .padding(5)

      Column() {
        Image(this.selectedTab === 2 ? $r('app.media.icon_3_select') : $r('app.media.icon_3'))
          .width(32)
          .height(32)
          .fillColor(this.selectedTab === 2 ? '#FFFFFF' : '#666')
      }
      .onClick(() => {
        router.pushUrl({ url: 'pages/AddNote' });
      })
      .layoutWeight(1)
      .padding(5)
      .margin({ bottom: 10 })

      Column() {
        Image(this.selectedTab === 3 ? $r('app.media.icon_4_select') : $r('app.media.icon_4'))
          .width(24)
          .height(24)
          .fillColor(this.selectedTab === 3 ? '#FF0000' : '#666')
        Text('消息')
          .fontSize(12)
          .fontColor(this.selectedTab === 3 ? '#FFFFFF' : '#666')
      }
      .onClick(() => { this.selectedTab = 3 })
      .layoutWeight(1)
      .padding(5)

      Column() {
        Image(this.selectedTab === 4 ? $r('app.media.icon_5_select') : $r('app.media.icon_5'))
          .width(24)
          .height(24)
          .fillColor(this.selectedTab === 4 ? '#FF0000' : '#666')
        Text('我的')
          .fontSize(12)
          .fontColor(this.selectedTab === 4 ? '#FFFFFF' : '#666')
      }
      .onClick(() => { this.selectedTab = 4 })
      .layoutWeight(1)
      .padding(5)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(60)
    .border({ width: { top: 1 }, color: '#eee' })
    .backgroundColor('#FFA500')
    .position({ bottom: -28 })
  }
}