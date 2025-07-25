// entry\src\main\ets\pages\MyNotes.ets
import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { httpClient } from '../utils/HttpRequest'; // 导入httpClient
import { NoteItem } from '../models/notes'; // 导入NoteItem接口
import { UserStore } from '../models/UserStore';
import { NoteItemResponseDetail } from '../models/Interface';


@Entry
@Component
struct MyNotes {
  @State notes: NoteItem[] = []; // 修改为NoteItem类型，并初始化为空数组

  aboutToAppear() {
    this.loadMyNotes();
  }

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

  async loadMyNotes() {
    // 动态获取当前用户ID
    const currentUserId = UserStore.getCurrentUserId();
    if (!currentUserId) {
        console.error('No user logged in, cannot load notes.');
        return;
    }

    try {
        const response = await httpClient.get<NoteItemResponseDetail>(`/users/${currentUserId}/posts`);
        if (response.success) {
            this.notes = response.data;
        } else {
            console.error('Failed to load my notes:', response);
        }
    } catch (error) {
        console.error('Error loading my notes:', error);
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

        Text('我的笔记')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(15)
      .backgroundColor('#FFA500')

      Scroll() {
        Column() {
          ForEach(this.notes, (note: NoteItem) => {
            this.noteItem(note)
          }, (note: NoteItem) => note.post_id.toString())
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor('#f5f5f5')
  }

  @Builder
  noteItem(note: NoteItem) {
    Column() {
      Row() {
        Text(note.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text(this.formatDate(note.created_at))
          .fontSize(12)
          .fontColor('#999')
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(note.content)
        .fontSize(14)
        .width('100%')
        .margin({ bottom: 10 })

      if (note.images) {
        Grid() {
          ForEach(note.images_url, (image: string) => {
            GridItem()
              .width('100%')
              .aspectRatio(1)
              .borderRadius(8)
              .backgroundColor('#ddd') // 使用纯色代替实际图片，如果后端返回图片URL，这里可以替换为Image(image)
          }, (image: string) => image)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(5)
        .columnsGap(5)
        .width('100%')
        .height(100)
        .margin({ bottom: 10 })
      }

      Row() {
        Row() {
          Image($r('app.media.icon_like'))
            .width(16)
            .height(16)
            .margin({ right: 5 })
          // Text(note.likes_count?.toString() || '0') // 使用likes_count
          //   .fontSize(12)
        }
        .margin({ right: 20 })

        Row() {
          Image($r('app.media.icon_comment'))
            .width(16)
            .height(16)
            .margin({ right: 5 })
          // Text(note.comments_count?.toString() || '0') // 使用comments_count
          //   .fontSize(12)
        }
      }
      .width('100%')
      .margin({ top: 5, bottom: 5 })

      Divider()
        .color('#eee')
    }
    .width('90%')
    .padding(15)
    .margin({ top: 10 })
    .borderRadius(10)
    .backgroundColor('#fff')
    .shadow({ radius: 2, color: '#eee', offsetX: 1, offsetY: 1 })
  }
}