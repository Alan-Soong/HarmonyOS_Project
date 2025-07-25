import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { HttpRequest, httpClient, HttpResponse } from '../utils/HttpRequest';
import { MessageItem } from '../models/message';
import { UserStore } from '../models/UserStore';
import { JSON } from '@kit.ArkTS';
import { Mess, ApiResponse } from '../models/Interface';

@Entry
@Component
export struct MessagesPage {
  @State messages: MessageItem[] = [];
  @State isRefreshing: boolean = false;

  private loadMessages(refresh: boolean = false): void {
    if (refresh) {
      this.isRefreshing = true;
    }

    const userId = UserStore.getCurrentUserId();
    const timestamp = refresh ? `?timestamp=${new Date().getTime()}` : '';

    Promise.allSettled([
      this.fetchMessagesFromApi(`/messages/sender/${userId}${timestamp}`),
      this.fetchMessagesFromApi(`/messages/receiver/${userId}${timestamp}`)
    ]).then((results: PromiseSettledResult<MessageItem[]>[]) => {
      const validMessages: MessageItem[] = [];

      for (const result of results) {
        if (result.status === 'fulfilled') {
          validMessages.push(...result.value);
        }
      }

      const allMessages = validMessages.sort((a, b) => {
        return new Date(b.sent_at).getTime() - new Date(a.sent_at).getTime();
      });

      this.messages = allMessages;

      if (refresh) {
        console.log('消息已刷新');
      }
    }).catch((error: string) => {
      console.error('消息加载失败:', error);
    }).finally(() => {
      if (refresh) {
        this.isRefreshing = false;
      }
    });
  }

  private fetchMessagesFromApi(url: string): Promise<MessageItem[]> {
    return new Promise((resolve, reject) => {
      httpClient.get<HttpResponse<MessageItem[]>>(url).then((response: HttpResponse<MessageItem[]>) => {
        console.info('接口返回数据:', JSON.stringify(response));
        console.log('Received messages:', response.data[0] ? response.data[0].sender_avatar_url : '', response.data[0] ? response.data[0].receiver_avatar_url : '');

        if (Array.isArray(response.data)) {
          const messages: MessageItem[] = response.data.map((item: MessageItem) => {
            return {
              message_id: item.message_id,
              sender_username: item.sender_username,
              receiver_username: item.receiver_username,
              sender_id: item.sender_id,
              receiver_id: item.receiver_id,
              content: item.content,
              sent_at: item.sent_at,
              is_read: item.is_read,
              avatar_url: item.avatar_url,
              sender_avatar_url: item.sender_avatar_url,
              receiver_avatar_url: item.receiver_avatar_url,
              display_username: item.display_username,
              display_avatar_url: item.display_avatar_url,
              display_partner_id: item.display_partner_id,
            } as MessageItem;
          });
          console.log('处理后的消息数据:', messages[0] ? messages[0].receiver_avatar_url : '');
          resolve(messages);
        } else {
          reject(response.message || '数据格式错误');
        }
      }).catch((error: Mess) => {
        reject(error.message || '网络请求失败');
      });
    });
  }

  private getUniqueMessages(messages: MessageItem[]): MessageItem[] {
    const messageMap = new Map<string, MessageItem>();
    const currentUserId = UserStore.getCurrentUserId();

    messages.forEach(msg => {
      const conversationKey = [msg.sender_id, msg.receiver_id]
        .sort()
        .join('_');

      const isCurrentUserSender = msg.sender_id === currentUserId;
      const partnerUsername = isCurrentUserSender ? msg.receiver_username : msg.sender_username;
      const partnerAvatarUrl = isCurrentUserSender ? msg.receiver_avatar_url : msg.sender_avatar_url;
      const partnerId = isCurrentUserSender ? msg.receiver_id : msg.sender_id;

      const displayMessage: MessageItem = {
        message_id: msg.message_id,
        sender_id: msg.sender_id,
        receiver_id: msg.receiver_id,
        content: msg.content,
        sent_at: msg.sent_at,
        is_read: msg.is_read,
        sender_username: msg.sender_username,
        receiver_username: msg.receiver_username,
        sender_avatar_url: msg.sender_avatar_url,
        receiver_avatar_url: msg.receiver_avatar_url,
        avatar_url: msg.avatar_url,
        display_username: partnerUsername,
        display_avatar_url: partnerAvatarUrl,
        display_partner_id: partnerId
      };

      if (!messageMap.has(conversationKey) ||
        new Date(msg.sent_at).getTime() > new Date(messageMap.get(conversationKey)!.sent_at).getTime()) {
        messageMap.set(conversationKey, displayMessage);
      }
    });

    return Array.from(messageMap.values());
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

  aboutToAppear(): void {
    this.loadMessages();
  }

  build() {
    Column() {
      Row() {
        Text('消息')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 15 })
      }
      .width('100%')
      .padding({ top: 10, bottom: 10 })
      .backgroundColor('#FFA500')

      Refresh({ refreshing: $$this.isRefreshing }) {
        Scroll() {
          Column() {
            if (this.messages.length > 0) {
              ForEach(this.getUniqueMessages(this.messages), (msg: MessageItem) => {
                this.messageItem(msg)
              }, (msg: MessageItem) => msg.message_id.toString())
            } else {
              Text('暂无消息')
                .fontSize(16)
                .fontColor('#999')
                .width('100%')
                .margin({ top: 20 })
            }
          }
          .width('100%')
          .padding({ bottom: 60 })
        }
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        if (refreshStatus === RefreshStatus.Refresh) {
          this.loadMessages(true);
        }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 0 })
  }

  @Builder
  messageItem(msg: MessageItem) {
    Row() {
      Column() {
        Image(msg.display_avatar_url || msg.receiver_avatar_url)
          .width(60)
          .height(60)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)
          .margin({ left: -15, right: 20 })
      }

      Column({ space: 4 }) {
        Row() {
          Text(msg.display_username || msg.receiver_username)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)

          // if (msg.is_read === 0) {
          //   Column()
          //     .width(8)
          //     .height(8)
          //     .backgroundColor('#FF0000')
          //     .borderRadius(4)
          //     .margin({ right: 8 })
          // }

          Text(this.formatDate(msg.sent_at))
            .fontSize(12)
            .fontColor('#999')
        }
        .width('100%')

        Text(msg.content)
          .fontSize(14)
          .fontColor('#555')
          .width('100%')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .padding({ bottom: 8 })
    }
    .width('92%')
    .padding(12)
    .backgroundColor('#ffffff')
    .borderRadius(10)
    .margin({ top: 5, bottom: 5, left: '4%', right: '4%' })
    .shadow({ radius: 2, color: '#eee', offsetX: 1, offsetY: 1 })
    .onClick(() => {
      const currentUserId = UserStore.getCurrentUserId();
      router.pushUrl({
        url: 'pages/MessageDetail',
        params: {
          message_id: msg.message_id,
          sender_id: msg.sender_id,
          receiver_id: msg.receiver_id,
          content: msg.content,
          sent_at: msg.sent_at,
          is_read: msg.is_read,
          receiver_username: msg.display_username || msg.receiver_username,
          partner_id: msg.display_partner_id || (msg.sender_id === currentUserId ? msg.receiver_id : msg.sender_id)
        }
      });
    })
  }
}