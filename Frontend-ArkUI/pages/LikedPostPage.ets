// entry/src/main/ets/pages/LikedPostsPage.ets
import { router } from '@kit.ArkUI';
import { httpClient } from '../utils/HttpRequest';
import { UserStore } from '../models/UserStore';
import { LikedPost, LikedPostsResponse } from '../models/Interface';


@Entry
@Component
export struct LikedPostsPage {
  @State likedPosts: LikedPost[] = [];
  @State isLoading: boolean = true;

  aboutToAppear() {
    this.loadLikedPosts();
  }

  async loadLikedPosts() {
    try {
      const currentUserId = UserStore.getCurrentUserId(); // 实际应从用户状态获取
      const response = await httpClient.get<LikedPostsResponse>(`/users/${currentUserId}/liked-posts`);
      if (response.success) {
        this.likedPosts = response.data;
      }
    } catch (error) {
      console.error('加载点赞帖子失败:', error);
    } finally {
      this.isLoading = false;
    }
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

        Text('我的点赞')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 });

        Blank();
      }
      .width('100%')
      .height(56)
      .backgroundColor('#EDEDED');

      // 内容区域
      Scroll() {
        Column() {
          if (this.isLoading) {
            LoadingProgress()
              .height(60)
              .width(60)
              .margin({ top: 100 })
          } else if (this.likedPosts.length === 0) {
            Text('暂无点赞内容')
              .fontSize(16)
              .fontColor('#999')
              .margin({ top: 100 })
          } else {
            ForEach(this.likedPosts, (post: LikedPost) => {
              this.postCard(post)
            }, (post: LikedPost) => post.like_id.toString())
          }
        }
        .width('100%')
        .padding(12)
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  postCard(post: LikedPost) {
    Column() {
      // 作者信息
      Row() {
        Image(post.author_avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)

        Column() {
          Text(post.author_username)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)

          Text(this.formatDate(post.created_at))
            .fontSize(12)
            .fontColor('#999')
        }
        .margin({ left: 8 })
        .alignItems(HorizontalAlign.Start)

        Blank()
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 帖子内容
      Text(post.title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })

      Text(post.content)
        .fontSize(14)
        .lineHeight(20)
        .margin({ bottom: 12 })

      // 互动数据
      Row() {
        Image($r('app.media.icon_like'))
          .width(16)
          .height(16)
          .margin({ right: 4 })

        Text(post.like_count.toString())
          .fontSize(12)
          .fontColor('#666')
          .margin({ right: 12 })

        Image($r('app.media.icon_comment'))
          .width(16)
          .height(16)
          .margin({ right: 4 })

        Text(post.review_count.toString())
          .fontSize(12)
          .fontColor('#666')
      }
      .margin({ top: 8 })
    }
    .width('100%')
    .padding(16)
    .margin({ bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 2, color: '#10000000', offsetX: 0, offsetY: 2 })
  }

  private formatDate(dateString: string): string {
    const date = new Date(dateString);
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  }
}