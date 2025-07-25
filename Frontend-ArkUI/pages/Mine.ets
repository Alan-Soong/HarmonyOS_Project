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

import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { BrowseHistory } from '../pages/BrowseHistory';
import { httpClient } from '../utils/HttpRequest';
import { image } from '@kit.ImageKit';
import { UserProfile } from '../models/UserProfile';
import { UserStore } from '../models/UserStore';
import {
  UserProfileResponse,
  UserProfileData,
  RecentActivity
} from '../models/UserProfile';
// 在原有import基础上新增
import { UserStats, UserStatsResponse } from '../models/UserStat';


@Component
export struct Mine {
  @State isLoggedIn: boolean = false;
  @State userProfile: UserProfile = {
    userId: UserStore.getCurrentUserId() || 0,
    username: UserStore.getCurrentUsername() ||'未登录',
    statistics: {
      posts_count: 0,
      reviews_count: 0,
      likes_count: 0,
      following_shops_count: 0,
      shop_ratings_count: 0,
      dish_ratings_count: 0,
      received_messages_count: 0,
      sent_messages_count: 0
    },
    posts: [],
    reviews: [],
    shopRatings: []
  };
  @State userStats: UserStats = {
    postCount: 0,
    followingShopsCount: 0,
    receivedLikesCount: 0
  };

  aboutToAppear() {
    this.checkLoginStatus();
  }

  // 修改 checkLoginStatus 方法
  async checkLoginStatus() {
    const userId = UserStore.getCurrentUserId();
    const userName = UserStore.getCurrentUsername();
    console.info('Current user ID:', userId);
    if (userId) {
      this.isLoggedIn = true;
      this.userProfile.userId = userId;
      this.userProfile.username = userName || '未知用户';
      this.userProfile.avatarUrl = UserStore.getAvatarUrl() || '';
      console.info('User is logged in:', { userId, username: this.userProfile.username, avatarUrl: this.userProfile.avatarUrl });
      await this.fetchUserStats(); // 新增：加载统计数据
      await this.fetchUserProfile();
      // console.info('User profile:', this.userStats);
    } else {
      console.info('No user logged in, redirecting to LoginPage');
      router.replaceUrl({ url: 'pages/LoginPage' });
    }
  }

  private mapApiResponseToUserProfile(response: UserProfileData): UserProfile {
    return {
      userId: response.user_id,
      username: response.username,
      avatarUrl: response.avatar_url,
      statistics: {
        posts_count: response.statistics.posts_count,
        reviews_count: response.statistics.reviews_count,
        likes_count: response.statistics.likes_count,
        following_shops_count: response.statistics.following_shops_count,
        shop_ratings_count: response.statistics.shop_ratings_count,
        dish_ratings_count: response.statistics.dish_ratings_count,
        received_messages_count: response.statistics.received_messages_count,
        sent_messages_count: response.statistics.sent_messages_count
      },
      posts: response.posts,
      reviews: response.reviews,
      shopRatings: response.shop_ratings
    };
  }

  async fetchUserProfile() {
    try {
      const response = await httpClient.get<UserProfileResponse>(
        `/users/${this.userProfile.userId}/profile`
      );
      if (response.success) {
        this.userProfile = this.mapApiResponseToUserProfile(response.data);
        console.info('Fetched user profile:', JSON.stringify(response.data));
      } else {
        throw new Error('Failed to fetch user profile');
      }
    } catch (error) {
      console.error('Failed to fetch user profile:', error);
      this.isLoggedIn = false;
      this.resetUserProfile();
      router.replaceUrl({ url: 'pages/LoginPage' });
    }
  }

  private resetUserProfile() {
    this.userProfile = {
      userId: UserStore.getCurrentUserId() || 0,
      username: UserStore.getCurrentUsername() || '未登录',
      statistics: {
        posts_count: 0,
        reviews_count: 0,
        likes_count: 0,
        following_shops_count: 0,
        shop_ratings_count: 0,
        dish_ratings_count: 0,
        received_messages_count: 0,
        sent_messages_count: 0
      },
      posts: [],
      reviews: [],
      shopRatings: []
    };
  }

  async fetchUserStats() {
    try {
      const response = await httpClient.get<UserStatsResponse>(
        `/users/${UserStore.getCurrentUserId()}/stats`
      );
      console.info('Fetched user stats:', JSON.stringify(response.data));
      if (response.success) {
        this.userStats = {
          postCount: response.data.post_count,
          followingShopsCount: response.data.following_shops_count,
          receivedLikesCount: response.data.received_likes_count
        };
      }
    } catch (error) {
      console.error('Failed to fetch user stats:', error);
    }
  }

  @Builder
  pageTransition() {
    BrowseHistory()
  }

  private navigateToDevelopingPage(pageName: string) {
    router.pushUrl({
      url: 'pages/DevelopingPage',
      params: { pageName: pageName }
    });
  }

  @Builder
  userProfileHeader() {
    Column() {
      Row() {
        if (this.userProfile.avatarUrl) {
          Image(this.userProfile.avatarUrl)
            .width(80)
            .height(80)
            .borderRadius(40)
            .margin({ right: 15 })
            .objectFit(ImageFit.Cover)
            .onError(() => {
              console.error('Failed to load avatar image');
            });
        } else {
          Column()
            .width(80)
            .height(80)
            .borderRadius(40)
            .backgroundColor('#ddd')
            .margin({ right: 15 });
        }

        Column() {
          Text(this.userProfile.username)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })

          Row() {
            Text('等级待定')
              .fontSize(12)
              .padding({
                left: 8,
                right: 8,
                top: 2,
                bottom: 2
              })
              .backgroundColor('#FFD700')
              .borderRadius(4)
              .margin({ right: 8 })

            Text('VIP会员')
              .fontSize(12)
              .padding({
                left: 8,
                right: 8,
                top: 2,
                bottom: 2
              })
              .backgroundColor('#FF4500')
              .borderRadius(4)
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding(20)

      Row() {
        Column() {
          Text(this.userStats.postCount.toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })
          Text('笔记')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)

        Column() {
          Text(this.userStats.followingShopsCount.toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })
          Text('关注')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)

        Column() {
          Text(this.userStats.receivedLikesCount.toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })
          Text('点赞')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)
      }
      .width('90%')
      .padding({ top: 8, bottom: 5 })
      .borderRadius(8)
      .backgroundColor('#fff')
      .shadow({
        radius: 1,
        color: '#eee',
        offsetX: 1,
        offsetY: 1
      })
      .margin({ top: -10, bottom: 5 })
    }
    .width('100%')
    .backgroundColor('#FFA500')
    .padding({ bottom: 2 })
  }

  @Builder
  functionEntrances() {
    Column() {
      Row() {
        Column() {
          Image($r('app.media.icon_liu'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('浏览记录')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          this.navigateToDevelopingPage('浏览记录')
        })

        Column() {
          Image($r('app.media.icon_fan'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('反馈')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          this.navigateToDevelopingPage('反馈')
        })

        Column() {
          Image($r('app.media.icon_she'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('设置')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SettingPage' });
        })

        Column() {
          Image($r('app.media.icon_ke'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('客服')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          this.navigateToDevelopingPage('客服')
        })
      }
      .height(80)
      .justifyContent(FlexAlign.Center)
      .padding({ top: 10, bottom: 15 })
    }
    .width('90%')
    .margin({ top: 20 })
    .borderRadius(10)
    .backgroundColor('#fff')
    .shadow({
      radius: 2,
      color: '#eee',
      offsetX: 1,
      offsetY: 1
    })
  }

  @Builder
  myContentSection() {
    Column() {
      Row() {
        Text('我的内容')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('全部 >')
          .fontSize(12)
          .fontColor('#666')
      }
      .width('100%')
      .padding(15)

      Row() {
        Column() {
          Image($r('app.media.icon_bi'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('笔记')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/MyNotes',
            params: {
              posts: JSON.stringify(this.userProfile.posts)
            }
          });
        })

        Column() {
          Image($r('app.media.icon_ping'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('评价')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          router.pushUrl({ url: 'pages/ReviewDetailPage' });
        })

        Column() {
          Image($r('app.media.icon_wen'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('点赞')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          // this.navigateToDevelopingPage('问答')
          router.pushUrl({ url: 'pages/LikedPostPage' });
        })

        Column() {
          Image($r('app.media.icon_shou'))
            .width(24)
            .height(24)
            .margin({ bottom: 5 })
          Text('收藏')
            .fontSize(12)
        }
        .layoutWeight(1)
        .onClick(() => {
          // this.navigateToDevelopingPage('收藏')
          router.pushUrl({ url: 'pages/FollowShopPage' });
        })
      }
      .padding({ bottom: 15 })

      // Scroll() {
      //   Column() {
      //     ForEach(this.userProfile.posts, (post: Post) => {
      //       Column() {
      //         Text(post.title)
      //           .fontSize(16)
      //           .fontWeight(FontWeight.Bold)
      //           .margin({ bottom: 5 })
      //         Text(post.content)
      //           .fontSize(14)
      //           .margin({ bottom: 5 })
      //         Text(new Date(post.created_at).toLocaleDateString())
      //           .fontSize(12)
      //           .fontColor('#999')
      //       }
      //       .padding(10)
      //       .borderRadius(8)
      //       .backgroundColor('#fff')
      //       .margin({ bottom: 10 })
      //       .onClick(() => {
      //         router.pushUrl({
      //           url: 'pages/NoteDetailPage',
      //           params: {
      //             postId: post.post_id.toString(),
      //             title: post.title,
      //             content: post.content,
      //             createdAt: post.created_at
      //           }
      //         });
      //       })
      //     })
      //   }
      // }
      // .scrollable(ScrollDirection.Vertical)
      // .width('100%')
      // .height(200)
    }
    .width('90%')
    .margin({ top: 15, bottom: 20 })
    .borderRadius(10)
    .backgroundColor('#fff')
    .shadow({
      radius: 2,
      color: '#eee',
      offsetX: 1,
      offsetY: 1
    })
  }

  private getRecentActivities(): RecentActivity[] {
    return [
      { id: '1', title: '参加了"夏日美食节"活动', time: '2023-07-10' },
      { id: '2', title: '获得了"美食达人"徽章', time: '2023-06-28' },
      { id: '3', title: '完成了5家餐厅打卡', time: '2023-06-15' }
    ];
  }

  build() {
    Column() {
      this.userProfileHeader()
      this.functionEntrances()
      this.myContentSection()
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor('#f5f5f5')
  }
}