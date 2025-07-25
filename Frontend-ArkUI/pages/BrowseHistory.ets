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

import { router } from '@kit.ArkUI';

interface HistoryItem {
  id: string;
  type: 'note' | 'post';
  title: string;
  content: string;
  time: string;
  image?: Resource;
}

@Component
export struct BrowseHistory {
  @State currentTab: number = 0;
  @State historyList: HistoryItem[] = [];
  @State isLoading: boolean = true;

  aboutToAppear() {
    // 模拟数据加载
    setTimeout(() => {
      this.historyList = this.getDemoData();
      this.isLoading = false;
    }, 800);
  }

  private getDemoData(): HistoryItem[] {
    return [
      {
        id: '1',
        type: 'note',
        title: '夏日美食节体验分享',
        content: '参加了上周的夏日美食节，发现了很多美味的小吃...',
        time: '2023-07-10',
        // image: $r('app.media.recommended5')
      },
      {
        id: '2',
        type: 'post',
        title: '新开火锅店探店报告',
        content: '这家新开的火锅店汤底非常正宗，食材新鲜...',
        time: '2023-07-08'
      }
    ];
  }

  get filteredList(): HistoryItem[] {
    const list = this.historyList || [];
    switch (this.currentTab) {
      case 1: return list.filter(item => item.type === 'note');
      case 2: return list.filter(item => item.type === 'post');
      default: return list;
    }
  }

  build() {
    Column() {
      // 标题栏 (与截图完全一致)
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .onClick(() => router.back())

        Text('浏览记录')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 })

        Blank()
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#FFFFFF')

      // 分类标签 (与截图样式一致)
      Row() {
        Text('全部')
          .fontSize(14)
          .fontColor(this.currentTab === 0 ? '#FFA500' : '#666666')
          .onClick(() => this.currentTab = 0)

        Text('笔记')
          .fontSize(14)
          .fontColor(this.currentTab === 1 ? '#FFA500' : '#666666')
          .margin({ left: 20 })
          .onClick(() => this.currentTab = 1)

        Text('帖子')
          .fontSize(14)
          .fontColor(this.currentTab === 2 ? '#FFA500' : '#666666')
          .margin({ left: 20 })
          .onClick(() => this.currentTab = 2)
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#FFFFFF')

      // 内容区域 (适配截图中的空白状态)
      Column() {
        if (this.isLoading) {
          LoadingProgress()
            .width(50)
            .height(50)
        } else if (!this.filteredList||this.filteredList.length === 0) {
          this.buildEmptyView()
        } else {
          this.buildHistoryList()
        }
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  private buildEmptyView() {
    Column() {
      Image($r('app.media.icon'))
        .width(120)
        .height(120)
      Text('暂无浏览记录')
        .fontSize(16)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  private buildHistoryList() {
    List({ space: 12 }) {
      ForEach(this.filteredList, (item: HistoryItem) => {
        ListItem() {
          Column() {
            // 标题行
            Row() {
              Text(item.title)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .layoutWeight(1)

              Text(item.type === 'note' ? '笔记' : '帖子')
                .fontSize(12)
                .padding(4)
                .backgroundColor(item.type === 'note' ? '#FFD700' : '#FF4500')
                .borderRadius(4)
                .fontColor('#FFFFFF')
            }
            .width('100%')
            .margin({ bottom: 8 })

            // 内容预览
            Text(item.content)
              .fontSize(14)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: 8 })

            // 图片（如果有）
            if (item.image) {
              Image(item.image)
                .width('100%')
                .height(120)
                .objectFit(ImageFit.Cover)
                .borderRadius(8)
                .margin({ bottom: 8 })
            }

            // 时间
            Row() {
              Blank()
              Text(item.time)
                .fontSize(12)
                .fontColor('#999999')
            }
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
        }
        .shadow({ radius: 2, color: '#F0F0F0', offsetX: 1, offsetY: 1 })
      })
    }
    .width('100%')
    .padding(10)
  }
}