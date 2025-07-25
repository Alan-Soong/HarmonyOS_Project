/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import prompt from '@ohos.prompt';
import { UserStore } from '../models/UserStore';

@Entry
@Component
struct SettingPage {
  @State isLogin: boolean = UserStore.getCurrentUserId() !== undefined;
  @State notificationEnabled: boolean = true;
  @State darkMode: boolean = AppStorage.get('darkMode') || false;

  aboutToAppear() {
    // 初始化深色模式状态
    this.darkMode = AppStorage.get('darkMode') || false;
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

        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 });

        Blank();
      }
      .width('100%')
      .height(50)
      .backgroundColor(this.darkMode ? '#1A1A1A' : '#EDEDED');

      // 主内容区域
      Scroll() {
        Column() {
          // 账号管理
          Column() {
            Text('账号管理')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ left: 15, top: 12, bottom: 8 });

            if (this.isLogin) {
              this.buildClickableRow('退出登录', '#FF0000', () => {
                this.showLogoutConfirm();
              });
            } else {
              this.buildClickableRow('立即登录', '#07C160', () => {
                router.pushUrl({ url: 'pages/LoginPage' });
              });
            }
          }
          .width('90%')
          .margin({ top: 10 })
          .borderRadius(8)
          .backgroundColor(this.darkMode ? '#2A2A2A' : '#FFFFFF');

          // 通知与显示设置
          Column() {
            this.buildToggleItem('接收通知', this.notificationEnabled, (v: boolean) => {
              this.notificationEnabled = v;
            });

            Divider()
              .strokeWidth(0.5)
              .color(this.darkMode ? '#333333' : '#f0f0f0')
              .margin({ left: 15, right: 15 });

            this.buildToggleItem('深色模式', this.darkMode, (v: boolean) => {
              this.darkMode = v;
              this.applyTheme();
            });
          }
          .width('90%')
          .margin({ top: 10 })
          .borderRadius(8)
          .backgroundColor(this.darkMode ? '#2A2A2A' : '#FFFFFF');

          // 关于
          Column() {
            Text('关于')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ left: 15, top: 12, bottom: 8 });

            this.buildClickableRow('版本号', '#999', () => {
              router.pushUrl({ url: 'pages/AboutPage' });
            }, 'v1.0.0');
          }
          .width('90%')
          .margin({ top: 10, bottom: 20 })
          .borderRadius(8)
          .backgroundColor(this.darkMode ? '#2A2A2A' : '#FFFFFF');
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center);
      }
      .scrollBar(BarState.Off);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.darkMode ? '#121212' : '#F5F5F5');
  }

  @Builder
  buildClickableRow(text: string, color: string, onClick: () => void, subText?: string) {
    Row() {
      Text(text)
        .fontSize(15)
        .fontColor(color);

      if (subText) {
        Blank();
        Text(subText)
          .fontSize(15)
          .fontColor('#999');
      }

      Blank();

      Image($r('app.media.icon_arrow'))
        .width(16)
        .height(16);
    }
    .height(50)
    .width('100%')
    .padding({ left: 15, right: 15 })
    .onClick(onClick);
  }

  @Builder
  buildToggleItem(text: string, isOn: boolean, callback: (v: boolean) => void) {
    Row() {
      Text(text)
        .fontSize(15)
        .layoutWeight(1);

      Toggle({ type: ToggleType.Switch, isOn: isOn })
        .onChange((isChecked: boolean) => {
          callback(isChecked);
        });
    }
    .height(50)
    .padding({ left: 15, right: 15 });
  }

  private showLogoutConfirm() {
    prompt.showDialog({
      title: '提示',
      message: '确定要退出登录吗？',
      buttons: [
        {
          text: '取消',
          color: '#000000'
        },
        {
          text: '确定',
          color: '#FF0000',
        }
      ]
    }).then((result) => {
      if (result.index === 1) { // 点击了确定按钮
        // 清空用户信息
        UserStore.setCurrentUserId(undefined);
        UserStore.setCurrentUsername('');
        UserStore.setAvatarUrl('');

        // 更新登录状态
        this.isLogin = false;

        // 跳转到登录页面
        router.replaceUrl({ url: 'pages/LoginPage' });
      }
    });
  }

  private applyTheme() {
    // 保存深色模式状态到AppStorage
    AppStorage.setOrCreate('darkMode', this.darkMode);

    // 更新UI主题
    this.updateThemeStyles();

    prompt.showToast({
      message: this.darkMode ? '深色模式已启用' : '浅色模式已启用',
      duration: 1500
    });
  }

  private updateThemeStyles() {
    // 这里可以添加更多主题相关的样式更新逻辑
    // 例如通知其他组件主题已变更
  }
}