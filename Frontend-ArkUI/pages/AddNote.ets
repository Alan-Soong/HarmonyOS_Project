// AddNote.ets
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

// entry\src\main\ets\pages\AddNote.ets
import router from '@ohos.router';
import picker from '@ohos.file.picker';
// import http from '@ohos.net.http'; // 移除直接使用http模块
import { httpClient } from '../utils/HttpRequest'; // 导入httpClient
import { NoteItem } from '../models/notes'; // 导入NoteItem接口
import promptAction from '@ohos.promptAction';
import { UserStore } from '../models/UserStore';
import { noteItemDetail, noteItemResponseDetail } from '../models/Interface';

@Entry
@Component
struct AddNote {
  @State title: string = '';
  @State content: string = '';
  @State selectedImages: string[] = [];
  @StorageLink('notes') notes: NoteItem[] = [];

  async openImagePicker() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 9;

      const photoPicker = new picker.PhotoViewPicker();
      const result = await photoPicker.select(photoSelectOptions);

      if (result && result.photoUris) {
        this.selectedImages = result.photoUris;
      }
    } catch (err) {
      console.error(`Failed to select photos: ${err}`);
    }
  }

  async publishNote() {
    if (!this.title.trim()) {
      console.warn('标题不能为空');
      promptAction.showToast({
        message: '标题不能为空',
        duration: 2000 // 显示时长，单位毫秒
      });
      return;
    }

    // 动态获取当前用户ID
    const currentUserId = UserStore.getCurrentUserId();
    if (!currentUserId) {
      console.error('无法获取当前用户ID，请确保用户已登录');
      promptAction.showToast({
        message: '请先登录后再发布笔记',
        duration: 2000 // 显示时长，单位毫秒
      });
      return;
    }

    const newNoteData: noteItemDetail = {
      user_id: currentUserId, // 使用动态获取的用户ID
      title: this.title,
      content: this.content,
      visibility: 'PUBLIC',
      images: this.selectedImages // 将图片URI数组发送给后端
    };

    try {
      const response = await httpClient.post<noteItemResponseDetail>('/posts', newNoteData);
      if (response.success) {
        // 成功发布后，更新本地数据或刷新列表
        console.log('笔记发布成功:', response.data);
        this.notes = [...this.notes, response.data]; // 如果需要立即更新本地列表
        promptAction.showToast({
          message: '发布成功',
          duration: 2000 // 显示时长，单位毫秒
        });
        router.replaceUrl({ url: 'pages/Index'});
      } else {
        console.error('发布失败:', response);
      }
    } catch (error) {
      console.error(`请求失败: ${error}`);
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .onClick(() => {
            router.back();
          });

        Text('添加新笔记')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 })
      }
      .width('100%')
      .padding({ top: 15, bottom: 15 })
      .backgroundColor('#FFA500')

      Scroll() {
        Column() {
          TextInput({ placeholder: '输入标题（必填）', text: this.title })
            .onChange((value: string) => {
              this.title = value;
            })
            .width('90%')
            .height(50)
            .margin({ top: 20 })
            .fontSize(16)

          TextArea({ placeholder: '输入内容', text: this.content })
            .onChange((value: string) => {
              this.content = value;
            })
            .width('90%')
            .height(150)
            .margin({ top: 20 })
            .fontSize(14)

          Column() {
            Column() {
              Button('添加图片（最多9张）', { type: ButtonType.Capsule })
                .width(180)
                .height(40)
                .margin({ top: 20 })
                .onClick(() => {
                  this.openImagePicker();
                })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)

            if (this.selectedImages.length > 0) {
              Grid() {
                ForEach(this.selectedImages, (imageUri: string) => {
                  GridItem() {
                    Column() {
                      Image(imageUri)
                        .width('80%')
                        .height(150)
                        .objectFit(ImageFit.Cover)
                        .borderRadius(8)

                      Button($r('app.media.icon_delete'))
                        .width(24)
                        .height(24)
                        .margin({ top: 5 })
                        .onClick(() => {
                          this.selectedImages = this.selectedImages.filter(uri => uri !== imageUri);
                        })
                    }
                    .alignItems(HorizontalAlign.Center)
                    .justifyContent(FlexAlign.Center)
                  }
                }, (imageUri: string) => imageUri)
              }
              .columnsTemplate('1fr 1fr 1fr')
              .rowsGap(10)
              .columnsGap(10)
              .width('90%')
              .margin({ top: 15 })
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          Button('发布笔记', { type: ButtonType.Capsule })
            .width('60%')
            .height(40)
            .margin({ top: 30, bottom: 20 })
            .onClick(() => {
              this.publishNote();
            })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}