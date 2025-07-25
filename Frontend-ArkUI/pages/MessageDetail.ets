import router from '@ohos.router';
import { ApiResponse, httpClient, HttpError, RequestParams } from '../utils/HttpRequest';
import { MessageItem, RouterParams, ChatMessage } from '../models/message';
import { UserStore } from '../models/UserStore';
import { userID } from '../models/Interface';


@Entry
@Component
struct MessageDetail {
  @State message: MessageItem = {
    message_id: 0,
    sender_username: '',
    receiver_username: '',
    content: '',
    sent_at: '',
    is_read: 0,
    sender_id: 0,
    receiver_id: 0,
    avatar_url: '',
    sender_avatar_url: '',
    receiver_avatar_url: '',
    display_username: '',
    display_avatar_url: '',
    display_partner_id: 0,
  };
  @State chatList: ChatMessage[] = [];
  @State inputText: string = '';
  @State errorMessage: string = '';
  private scroller: Scroller = new Scroller();

  private currentUserId = UserStore.getCurrentUserId();
  private otherUserId: number = 0;

  onPageShow() {
    const params = router.getParams() as RouterParams;

    if (params && params.receiver_id) {
      this.currentUserId = UserStore.getCurrentUserId();
      this.otherUserId = Number(params.receiver_id);

      // 初始化消息对象
      this.message = {
        message_id: params.message_id ? Number(params.message_id) : 0,
        sender_id: params.sender_id ? Number(params.sender_id) : this.currentUserId,
        receiver_id: this.otherUserId,
        sender_username: params.sender_username || UserStore.getCurrentUsername() || '',
        receiver_username: params.receiver_username || '',
        content: params.content || '',
        sent_at: params.sent_at || new Date().toISOString(),
        is_read: params.is_read ? Number(params.is_read) : 0,
        avatar_url: params.avatar_url || '',
        sender_avatar_url: params.sender_avatar_url,
        receiver_avatar_url: params.receiver_avatar_url,
        display_username: params.display_username || '',
        display_avatar_url: params.display_avatar_url || '',
        display_partner_id: params.display_partner_id || 0,
      };

      console.info('message:', this.message.sender_avatar_url)

      // 加载聊天历史
      this.loadChatHistory().then(() => {
        this.scrollToBottom();
      });
    } else {
      this.errorMessage = '缺少必要参数';
    }
  }

  async loadChatHistory() {
    try {
      const params: RequestParams = {
        user_id: this.currentUserId,
        sender_id: this.message.sender_id,
        receiver_id: this.message.receiver_id,
        content: this.message.content
      };
      const response = await httpClient.get<ApiResponse<MessageItem[]>>(
        `/messages/chat/${this.otherUserId}/${this.currentUserId}`,
        params
      );
      console.log('loadChatHistory response:', response);
      console.info('双方的图片：', response.data[0].sender_avatar_url, response.data[1].receiver_avatar_url)
      if (response.success) {
        this.chatList = response.data.map((msg: MessageItem): ChatMessage => {
          const isMine = msg.sender_id === this.currentUserId;
          return {
            message_id: msg.message_id,
            sender_username: msg.sender_username || '',
            receiver_username: msg.receiver_username || '',
            content: msg.content,
            sent_at: new Date(msg.sent_at).toLocaleTimeString([], {
              hour: '2-digit',
              minute: '2-digit'
            }),
            isMine: isMine,
            sender_id: msg.sender_id,
            receiver_id: msg.receiver_id,
            sender_avatar_url: msg.sender_avatar_url,
            receiver_avatar_url: msg.receiver_avatar_url
          };
        });
      } else {
        this.errorMessage = response.message || 'Failed to load chat history';
      }
    } catch (error) {
      this.errorMessage = error instanceof HttpError ? error.message : 'Unknown error';
      console.error('Error loading chat history:', error);
    }
  }

  async markAsRead() {
    try {
      await httpClient.post<ApiResponse<void>>(
        `/messages/${this.message.message_id}`,
        { user_id: this.currentUserId } as userID
      );
      this.message.is_read = 1;
    } catch (error) {
      this.errorMessage = error instanceof HttpError ? error.message : 'Failed to mark message as read';
      console.error('Error marking message as read:', error);
    }
  }

  async sendMessage() {
    if (this.inputText.trim()) {
      const messageData: RequestParams = {
        user_id: this.currentUserId,
        sender_id: this.currentUserId,
        receiver_id: this.otherUserId,
        content: this.inputText
      };

      try {
        const response = await httpClient.post<ApiResponse<MessageItem>>('/messages', messageData);
        if (response.success) {
          const now = new Date();
          const formattedTime = now.toLocaleTimeString([], {
            hour: '2-digit',
            minute: '2-digit'
          });

          // 添加新消息到聊天列表
          this.chatList.push({
            message_id: response.data.message_id,
            sender_username: UserStore.getCurrentUsername(),
            receiver_username: this.message.receiver_username,
            content: this.inputText,
            sent_at: formattedTime,
            isMine: true, // 标记为当前用户发送的消息
            sender_id: this.currentUserId,
            receiver_id: this.otherUserId,
            sender_avatar_url: this.message.sender_avatar_url,
            receiver_avatar_url: this.message.receiver_avatar_url
          });

          this.inputText = '';
          this.scrollToBottom();
        } else {
          this.errorMessage = response.message || '发送消息失败';
        }
      } catch (error) {
        this.errorMessage = error instanceof HttpError
          ? error.message
          : '发送消息时发生未知错误';
        console.error('Send message error:', error);
      }
    } else {
      this.errorMessage = '消息内容不能为空';
    }
  }

  private scrollToBottom() {
    this.scroller.scrollTo({ xOffset: 0, yOffset: Number.MAX_VALUE });
  }

  build() {
    Column() {
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(16)
          .fontColor(Color.Red)
          .margin({ bottom: 10 });
      }
      Column() {
        Scroll(this.scroller) {
          Column() {
            this.buildDateDivider();
            Column() {
              ForEach(this.chatList, (item: ChatMessage) => {
                this.buildMessageBubble(item);
              }, (item: ChatMessage) => item.sent_at + item.content);
            }
            .width('100%');
          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
        .padding({ bottom: 60 });
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
      .margin({ top: 0 });

      this.buildHeader();
      this.buildInputArea();
    }
    .width('100%')
    .height('100%');
  }

  @Builder
  buildHeader() {
    Row() {
      Image($r('app.media.icon_back'))
        .width(24)
        .height(24)
        .margin({ left: 12 })
        .onClick(() => {
          router.back();
        });

      Text(this.message.receiver_username)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 10 });
    }
    .width('100%')
    .height(50)
    .backgroundColor('#EDEDED')
    .position({ top: 0 })
    .zIndex(1);
  }

  @Builder
  buildDateDivider() {
    Row() {
      Blank();
      Text('今天')
        .fontSize(12)
        .fontColor('#999')
        .padding(8)
        .borderRadius(10)
        .backgroundColor('#F0F0F0');
      Blank();
    }
    .width('100%')
    .margin({ top: 10, bottom: 10 });
  }

  @Builder
  buildMessageBubble(item: ChatMessage) {
    Column() {
      if (item.isMine) { // 当前用户发送的消息（右对齐）
        Row() {
          Blank().layoutWeight(1) // 推动内容右对齐

          // 消息气泡容器
          Column() {
            Column() {
              Text(item.content)
                .fontSize(16)
                .fontColor('#FFFFFF')
                .padding({ left: 12, right: 12, top: 8, bottom: 0 })
                .constraintSize({ maxWidth: '70%' })

              Row() {
                Blank()
                Text(item.sent_at)
                  .fontSize(10)
                  .fontColor('#FFFFFF')
                  .opacity(0.8)
                  .margin({ right: 8, bottom: 8, top: 2 })
              }
            }
            .borderRadius(8)
            .backgroundColor('#07C160')
            .width('auto')
          }
          .constraintSize({ maxWidth: '70%' })
          .margin({ right: 8 })

          // 当前用户头像（右对齐）
          Column() {
            // Text(item.sender_username.charAt(0).toUpperCase())
            //   .fontSize(18)
            //   .fontColor('#FFFFFF')
            //   .width(40)
            //   .height(40)
            //   .borderRadius(20)
            //   .backgroundColor('#333333')
            //   .textAlign(TextAlign.Center)
            Image(item.sender_avatar_url) // 使用真实头像或默认头像
              .width(40)
              .height(40)
              .borderRadius(20) // 保持圆形
              .objectFit(ImageFit.Cover) // 确保图片填充完整
          }
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin({ right: 12 })
        }
        .margin({ top: 8, bottom: 8 })
      } else { // 对方发送的消息（左对齐）
        Row() {
          // 对方头像（左对齐）
          Column() {
            // Text(item.sender_username.charAt(0).toUpperCase())
            //   .fontSize(18)
            //   .fontColor('#FFFFFF')
            //   .width(40)
            //   .height(40)
            //   .borderRadius(20)
            //   .backgroundColor('#333333')
            //   .textAlign(TextAlign.Center)
            //   .margin({ left: 12, right: 8 })
            Image(item.sender_avatar_url) // 使用真实头像或默认头像
              .width(40)
              .height(40)
              .borderRadius(20) // 保持圆形
              .objectFit(ImageFit.Cover) // 确保图片填充完整
          }
          .width(40)
          .height(40)
          .borderRadius(20)
          .backgroundColor('#DDDDDD')
          .margin({ left: 12, right: 8 })

          // 消息气泡容器
          Column() {
            Column() {
              Text(item.content)
                .fontSize(16)
                .fontColor('#000')
                .padding({ left: 12, right: 12, top: 8, bottom: 0 })
                .constraintSize({ maxWidth: '70%' })
                .textAlign(TextAlign.Start)

              Row() {
                Blank()
                Text(item.sent_at)
                  .fontSize(10)
                  .fontColor('#999')
                  .margin({ right: 8, bottom: 8, top: 2 })
              }
            }
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .border({ width: 0.5, color: '#E5E5E5' })
            .width('auto')
            .alignItems(HorizontalAlign.Start)
          }
          .constraintSize({ maxWidth: '70%' })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .margin({ top: 8, bottom: 8 })
        .alignItems(VerticalAlign.Top)
      }
    }
    .width('100%')
  }


  @Builder
  buildInputArea() {
    Column() {
      Row() {
        TextInput({ placeholder: '输入消息...', text: this.inputText })
          .onChange((value: string) => {
            this.inputText = value;
          })
          .placeholderColor('#999')
          .fontSize(16)
          .width('75%')
          .height(40)
          .borderRadius(20)
          .backgroundColor('#FFFFFF')
          .padding({ left: 15 });

        Button('发送')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .width(60)
          .height(40)
          .backgroundColor('#07C160')
          .borderRadius(20)
          .margin({ left: 8 })
          .onClick(() => {
            this.sendMessage();
          });
      }
      .padding({ left: 12, right: 12, bottom: 8, top: 8 })
      .backgroundColor('#EDEDED');
    }
    .width('100%');
  }
}