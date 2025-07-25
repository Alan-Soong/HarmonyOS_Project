import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { prompt, promptAction, router } from '@kit.ArkUI';
import { HttpRequest, httpClient, HttpResponse, HttpError } from '../utils/HttpRequest';
import { NoteItem, ReviewItem, ReviewRequest, ReviewResponse, ReviewsResponse } from '../models/notes';
import { ShopItem, ShopItemResponse } from '../models/shops';
import { UserStore } from '../models/UserStore';
import { Dish } from '../models/dish';
import { JSON } from '@kit.ArkTS';
import { LikeDetail, ApiResponse, NoteItemResponseDetail, PostReviewCount, ReviewDetail, LikeCountResponse, LikeActionResponse, userID } from '../models/Interface';

interface LikeID {
  is_liked: boolean;
}

@Entry
@Component
export struct NotesPage {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @State searchText: string = '';
  @State notes: NoteItem[] = [];
  @State shops: ShopItem[] = [];
  @State isFetchingMore: boolean = false;
  @State hasMoreData: boolean = true;
  @State searchResults: ShopItem[] = [];
  @State isSearching: boolean = false;
  @State searchError: string = '';
  @State dishes: Dish[] = [];
  @State selectedDish: Dish | null = null;
  @State showDishDialog: boolean = false;
  @State showCommentDialog: boolean = false;
  @State currentNoteId: number = 0;
  @State noteReviews: ReviewItem[] = [];
  @State newReviewContent: string = '';
  @State isSubmittingReview: boolean = false;
  @State reviewError: string = '';
  @State replyingToReview: ReviewItem | null = null;
  @State likeError: string = '';
  @State likedPosts: Set<number> = new Set();
  @State isLiking: boolean = false;

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

  private async fetchLikeCount(postId: number): Promise<number> {
    try {
      const response = await httpClient.get<LikeCountResponse>(`/likes/count/POST/${postId}`);
      if (response.success) {
        console.info('获取点赞数成功:', response.data.count);
        return response.data.count || 0;
      } else {
        console.error('获取点赞数失败:');
        return 0;
      }
    } catch (error) {
      console.error('获取点赞数失败:', JSON.stringify(error));
      return 0;
    }
  }

  private async checkLikeStatus(postId: number): Promise<boolean> {
    const userId = UserStore.getCurrentUserId();
    if (!userId) return false;

    try {
      const response = await httpClient.get<LikeID>(`/posts/${postId}/likes/status?user_id=${userId}`);
      return response.is_liked || false;
    } catch (error) {
      console.error('检查点赞状态失败:', JSON.stringify(error));
      return false;
    }
  }

  private async toggleLike(postId: number): Promise<void> {
    if (this.isLiking) return;
    this.isLiking = true;
    this.likeError = '';

    const userId = UserStore.getCurrentUserId();
    if (!userId) {
      prompt.showToast({ message: '请先登录' });
      this.isLiking = false;
      return;
    }

    try {
      const isLiked = this.likedPosts.has(postId);
      if (isLiked) {
        const response = await httpClient.delete<LikeActionResponse>(
          `/posts/${postId}/likes?user_id=${userId}`
        );
        if (response.success) {
          this.likedPosts.delete(postId);
          this.updateNoteLikeCount(postId, -1);
          prompt.showToast({ message: '取消点赞成功' });
        } else {
          this.likeError = '取消点赞失败';
          prompt.showToast({ message: this.likeError });
        }
      } else {
        const response = await httpClient.post<LikeActionResponse>(
          `/posts/${postId}/likes`,
          { user_id: userId } as userID
        );
        if (response.success) {
          this.likedPosts.add(postId);
          this.updateNoteLikeCount(postId, 1);
          prompt.showToast({ message: '点赞成功' });
        } else {
          this.likeError = '点赞失败';
          prompt.showToast({ message: this.likeError });
        }
      }
    } catch (error) {
      this.likeError = error instanceof HttpError ? error.message : '网络请求失败';
      console.error('点赞操作失败:', JSON.stringify(error));
      prompt.showToast({ message: this.likeError });
    } finally {
      this.isLiking = false;
    }
  }

  private updateNoteLikeCount(postId: number, delta: number): void {
    this.notes = this.notes.map(note => {
      if (note.post_id === postId) {
        return {
          post_id: note.post_id,
          user_id: note.user_id,
          title: note.title,
          content: note.content,
          created_at: note.created_at,
          updated_at: note.updated_at,
          visibility: note.visibility,
          images: note.images,
          username: note.username,
          avatar_url: note.avatar_url,
          likes_count: (note.likes_count || 0) + delta,
          comments_count: note.comments_count,
          images_url: note.images_url,
          image_url: note.image_url
        };
      }
      return note;
    });
  }

  private async loadNotes(page: number = 1): Promise<void> {
    if (!this.hasMoreData || this.isFetchingMore) return;

    this.isFetchingMore = true;
    const url = `/posts?page=${page}`;

    try {
      const response = await httpClient.get<NoteItemResponseDetail>(url);

      if (response.success) {
        const notePromises = response.data.map(async (item: NoteItem) => {
          // 移除解构赋值
          const results = await Promise.all([
            this.fetchLikeCount(item.post_id),
            this.checkLikeStatus(item.post_id)
          ]);
          const likeCount = results[0];
          const isLiked = results[1];

          if (isLiked) {
            this.likedPosts.add(item.post_id);
          }

          // 显式转换 visibility 为联合类型
          let visibility: 'PUBLIC' | 'PRIVATE' | 'FRIENDS_ONLY' = 'PUBLIC';
          if (item.visibility === 'PRIVATE') {
            visibility = 'PRIVATE';
          } else if (item.visibility === 'FRIENDS_ONLY') {
            visibility = 'FRIENDS_ONLY';
          }

          console.info('number' + likeCount)
          return {
            post_id: Number(item.post_id) || 0,
            user_id: Number(item.user_id) || 0,
            title: String(item.title || ''),
            content: String(item.content || ''),
            created_at: String(item.created_at || ''),
            updated_at: String(item.updated_at || ''),
            visibility: visibility,
            images: Array.isArray(item.images) ? item.images : null,
            username: String(item.username || ''),
            avatar_url: item.avatar_url ? String(item.avatar_url) : undefined,
            likes_count: likeCount,
            comments_count: await this.fetchCommentsCount(item.post_id),
            images_url: Array.isArray(item.images_url) ? item.images_url : undefined,
            image_url: item.image_url
          } as NoteItem; // 类型断言确保符合 NoteItem
        });

        const newNotes: NoteItem[] = await Promise.all(notePromises);
        this.notes = this.notes.concat(newNotes as NoteItem[]);
        this.hasMoreData = response.data.length >= 10;

        console.log('笔记加载完成，最新数据:', JSON.stringify(this.notes.slice(0, 1)));
      } else {
        prompt.showToast({ message: '加载笔记失败' });
      }
    } catch (error) {
      console.error('加载笔记失败:', error);
      prompt.showToast({ message: '加载失败，请重试' });
    } finally {
      this.isFetchingMore = false;
    }
  }

  private async searchShops(keyword: string): Promise<void> {
    if (!keyword.trim()) {
      this.searchError = '搜索关键字不能为空';
      return;
    }

    this.isSearching = true;
    this.searchError = '';

    try {
      const response = await httpClient.get<ApiResponse<ShopItem[]>>(
        `/shops/search?keyword=${encodeURIComponent(keyword)}`
      );
      console.info('Search results:', JSON.stringify(response.data));
      if (response.success && Array.isArray(response.data)) {
        this.searchResults = response.data.map((item: ShopItem) => {
          const shop: ShopItem = {
            shop_id: item.shop_id || 0,
            shop_name: item.shop_name || '未知店铺',
            address: item.address || '未知地址',
            latitude: item.latitude || 0,
            longitude: item.longitude || 0,
            business_hours: item.business_hours || '未提供营业时间',
            avg_price: item.avg_price || 0,
            discount_info: item.discount_info || '无优惠信息',
            contact_phone: item.contact_phone || '暂无联系方式',
            follower_count: item.follower_count || 0,
            created_at: item.created_at || new Date().toISOString(),
            average_rating: item.average_rating || 0,
            image_url: item.image_url || '',
          };
          return shop;
        });
      } else {
        this.searchError = response.message || '搜索失败';
      }
    } catch (error) {
      this.searchError = error instanceof HttpError ? error.message : '网络请求失败';
      console.error('搜索失败:', error);
    } finally {
      this.isSearching = false;
    }
  }

  private clearSearch(): void {
    this.searchText = '';
    this.searchResults = [];
    this.searchError = '';
    this.isSearching = false;
  }

  private async loadDishes() {
    try {
      const response = await httpClient.get<ApiResponse<Dish[]>>('/dishes');
      if (response.success && Array.isArray(response.data)) {
        const mappedDishes: Dish[] = response.data.map((dish: Dish): Dish => ({
          dish_id: dish.dish_id || 0,
          dish_name: dish.dish_name || '未知菜品',
          description: dish.description || '暂无描述',
          origin_region: dish.origin_region || '未知产地',
          popularity: dish.popularity || 0,
          created_at: dish.created_at || new Date().toISOString(),
          image_url: dish.image_url || ''
        }));

        console.info('mappedDishes: ', JSON.stringify(mappedDishes, null, 2));

        const shuffled = [...mappedDishes].sort(() => 0.5 - Math.random());
        this.dishes = shuffled.slice(0, 6);
      } else {
        console.error('获取菜品失败:', response.message);
      }
    } catch (error) {
      console.error('请求菜品失败:', error);
    }
  }

  private async loadNoteReviews(noteId: number): Promise<void> {
    try {
      const response = await httpClient.get<ReviewsResponse>(
        `/posts/${noteId}/reviews`
      );

      if (response.success) {
        this.noteReviews = this.buildCommentTree(response.data);
      } else {
        throw new Error(response.message || '获取评论失败');
      }
    } catch (error) {
      console.error('加载评论失败:', error);
      this.reviewError = error.message || '加载评论失败';
    }
  }

  private buildCommentTree(reviews: ReviewItem[]): ReviewItem[] {
    const commentMap = new Map<number, ReviewItem>();
    const rootComments: ReviewItem[] = [];

    reviews.forEach(review => {
      const newReview: ReviewItem = {
        review_id: review.review_id,
        user_id: review.user_id,
        content: review.content,
        created_at: review.created_at,
        target_type: review.target_type,
        target_id: review.target_id,
        parent_review_id: review.parent_review_id,
        username: review.username,
        avatar_url: review.avatar_url,
        images: review.images,
        like_count: review.like_count,
        replies: [],
        parent_review: review.parent_review
      };
      commentMap.set(review.review_id, newReview);
    });

    reviews.forEach(review => {
      const comment = commentMap.get(review.review_id);
      if (review.parent_review_id) {
        const parent = commentMap.get(review.parent_review_id);
        if (parent && comment) {
          parent.replies!.push(comment);
        }
      } else if (comment) {
        rootComments.push(comment);
      }
    });

    return rootComments;
  }

  private async submitReview(): Promise<void> {
    if (!this.newReviewContent.trim()) {
      this.reviewError = '评论内容不能为空';
      return;
    }

    this.isSubmittingReview = true;
    this.reviewError = '';

    try {
      const requestData: ReviewDetail = {
        user_id: UserStore.getCurrentUserId(),
        content: this.newReviewContent,
        target_type: 'POST',
        target_id: this.currentNoteId,
        parent_review_id: this.replyingToReview?.review_id
      };

      const response = await httpClient.post<ReviewResponse>('/reviews', requestData);

      if (response.success) {
        this.newReviewContent = '';
        this.replyingToReview = null;
        promptAction.showToast({ message: '评论成功' });

        const results = await Promise.all([
          this.loadNoteReviews(this.currentNoteId),
          this.fetchCommentsCount(this.currentNoteId)
        ]);
        const reviews = results[0];
        const count = results[1];

        this.notes = this.notes.map(note => {
          if (note.post_id === this.currentNoteId) {
            const updatedNote: NoteItem = {
              post_id: note.post_id,
              user_id: note.user_id,
              title: note.title,
              content: note.content,
              created_at: note.created_at,
              updated_at: note.updated_at,
              visibility: note.visibility,
              images: note.images,
              username: note.username,
              avatar_url: note.avatar_url,
              likes_count: note.likes_count,
              comments_count: count,
              images_url: note.images_url,
              image_url: note.image_url
            };
            return updatedNote;
          }
          return note;
        });
      } else {
        throw new Error('评论失败');
      }
    } catch (error) {
      console.error('评论失败:', error);
      this.reviewError = error.message || '评论失败，请重试';
    } finally {
      this.isSubmittingReview = false;
    }
  }

  private async openCommentDialog(noteId: number): Promise<void> {
    this.currentNoteId = noteId;
    this.showCommentDialog = true;

    const results = await Promise.all([
      this.loadNoteReviews(this.currentNoteId),
      this.fetchCommentsCount(this.currentNoteId)
    ]);
    const reviews = results[0];
    const count = results[1];
    console.info('评论数:', count);

    this.notes = this.notes.map(note => {
      if (note.post_id === noteId) {
        const updatedNote: NoteItem = {
          post_id: note.post_id,
          user_id: note.user_id,
          title: note.title,
          content: note.content,
          created_at: note.created_at,
          updated_at: note.updated_at,
          visibility: note.visibility,
          images: note.images,
          username: note.username,
          avatar_url: note.avatar_url,
          likes_count: note.likes_count,
          comments_count: count,
          images_url: note.images_url,
          image_url: note.image_url
        };
        return updatedNote;
      }
      return note;
    });
  }

  private closeCommentDialog(): void {
    this.showCommentDialog = false;
    this.newReviewContent = '';
    this.replyingToReview = null;
    this.reviewError = '';
  }

  private async fetchCommentsCount(postId: number): Promise<number> {
    try {
      const response = await httpClient.get<ApiResponse<PostReviewCount>>(`/posts/${postId}/reviews/count`);
      if (response.success) {
        return response.data.review_count;
      }
      throw new Error(response.message || '获取评论数失败');
    } catch (error) {
      console.error('获取评论数失败:', error);
      return 0;
    }
  }

  aboutToAppear(): void {
    this.loadNotes();
    this.loadDishes();
  }

  build() {
    Scroll() {
      Column() {
        this.searchBar();
        if (this.searchResults.length > 0 || this.isSearching || this.searchError) {
          this.searchResultsSection();
        } else {
          this.foodButton();
          this.notesSection();
        }
        this.dishDetailDialog();
        this.commentDialog();
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
  }

  @Builder
  searchBar() {
    Row() {
      Image($r('app.media.icon_search'))
        .width(20)
        .height(20)
        .margin({ left: 15, right: 10 })
        .fillColor('#999');

      TextInput({ placeholder: '搜索美食、地点', text: this.searchText })
        .placeholderColor('#bbb')
        .fontSize(14)
        .width('65%')
        .height(36)
        .backgroundColor('#ffffff')
        .borderRadius(8)
        .padding({ left: 8, right: 8 })
        .margin({ right: 8 })
        .onChange((value: string) => {
          this.searchText = value;
        });

      Button('搜索')
        .fontSize(14)
        .fontColor('#FFA500')
        .width(60)
        .height(30)
        .backgroundColor(Color.White)
        .borderRadius(15)
        .onClick(() => {
          this.searchShops(this.searchText);
        });
    }
    .width('94%')
    .height(44)
    .backgroundColor('#FFA500')
    .borderRadius(22)
    .margin({ top: 10, left: '3%', right: '3%' })
    .shadow({ color: '#aaa', radius: 3, offsetX: 0, offsetY: 1 })
    .alignItems(VerticalAlign.Center);
  }

  @Builder
  foodButton() {
    Button({ type: ButtonType.Capsule }) {
      Row() {
        Image($r('app.media.icon_food'))
          .width(40)
          .height(40)
          .margin({ right: 8 })
          .fillColor('#333333');

        Text('查看美食')
          .fontSize(16)
          .fontColor('#333333');
      }
      .justifyContent(FlexAlign.Center);
    }
    .width('40%')
    .height(40)
    .backgroundColor('#FFFFFF')
    .borderColor('#DDDDDD')
    .borderWidth(1)
    .margin({ top: 20 })
    .onClick(() => {
      router.pushUrl({ url: 'pages/FoodList' });
    });
  }

  @Builder
  notesSection() {
    this.dishSwiper();
    Column() {
      Divider()
        .color('#FFA500')
        .strokeWidth(1)
        .margin({ top: 20, left: 16, right: 16 });

      Text('热门笔记')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333')
        .margin({ top: 8, left: 16, bottom: 8 });

      Divider()
        .color('#FFA500')
        .strokeWidth(1)
        .margin({ left: 16, right: 16, bottom: 12 });

      Scroll() {
        Column() {
          ForEach(this.notes, (item: NoteItem) => {
            this.noteItem(item);
          }, (item: NoteItem) => item.post_id ? item.post_id.toString() : '');

          if (this.isFetchingMore) {
            Row() {
              LoadingProgress()
                .width(20)
                .height(20)
                .margin({ right: 8 });
              Text('正在加载更多...')
                .fontSize(14)
                .fontColor('#999');
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .margin({ top: 16, bottom: 16 });
          }

          if (!this.hasMoreData && !this.isFetchingMore) {
            Text('没有更多内容了')
              .fontSize(14)
              .fontColor('#999')
              .margin({ top: 16, bottom: 32 })
              .width('100%')
              .textAlign(TextAlign.Center);
          }
        }
        .width('100%');
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
      .onReachEnd(() => {
        if (!this.isFetchingMore && this.hasMoreData) {
          this.loadNotes(Math.ceil(this.notes.length / 10) + 1);
        }
      });
    }
    .width('100%')
    .margin({ bottom: 400 });
  }

  @Builder
  noteItem(item: NoteItem) {
    Column() {
      Row() {
        Stack() {
          Column() {
            Image(item.avatar_url)
              .width(40)
              .height(40)
              .borderRadius(10)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover);
          }
          .width(44)
          .height(44)
          .borderRadius(22)
          .backgroundColor('#f5f5f5');
        }
        .width(44)
        .height(44)
        .margin({ right: 12 });

        Column() {
          Text(item.username)
            .fontSize(16)
            .fontColor('#333')
            .fontWeight(FontWeight.Medium);

          Text(this.formatDate(item.created_at))
            .fontSize(12)
            .fontColor('#999')
            .margin({ top: 2 });
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start);
      }
      .width('100%')
      .margin({ bottom: 12 })
      .onClick(() => {
        const currentUserId = UserStore.getCurrentUserId();
        if (item.user_id && item.user_id !== currentUserId) {
          router.pushUrl({
            url: 'pages/MessageDetail',
            params: {
              message_id: 0,
              sender_id: currentUserId,
              receiver_id: item.user_id,
              sender_username: UserStore.getCurrentUsername() || '',
              receiver_username: item.username,
              content: '',
              sent_at: new Date().toISOString(),
              is_read: 0,
              display_partner_id: item.user_id,
              display_username: item.username,
              display_avatar_url: item.avatar_url || ''
            }
          });
        } else {
          console.log('不能给自己发消息');
          prompt.showToast({ message: '不能给自己发消息' });
        }
      });

      Column() {
        if (item.title) {
          Text(item.title)
            .fontSize(18)
            .fontColor('#1a1a1a')
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 });
        }

        Text(item.content)
          .fontSize(15)
          .fontColor('#444')
          .lineHeight(20);
      }
      .width('100%')
      .margin({ bottom: 12 })
      .alignItems(HorizontalAlign.Start);

      Image(item.image_url)
        .width('100%')
        .height(200)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .margin({ top: 8, bottom: 8 });

      Row() {
        Blank().layoutWeight(1);

        Row() {
          Row() {
            Image($r('app.media.ic_like'))
              .width(18)
              .height(18)
              .margin({ right: 4 })
              .fillColor(this.likedPosts.has(item.post_id) ? '#FFA500' : '#666')
              .onClick(() => {
                this.toggleLike(item.post_id);
              });
            Text(item.likes_count?.toString() || '0')
              .fontSize(14)
              .fontColor(this.likedPosts.has(item.post_id) ? '#FFA500' : '#666');
          }
          .margin({ right: 16 });

          Row() {
            Image($r('app.media.ic_comment'))
              .width(18)
              .height(18)
              .margin({ right: 4 });
            Text(item.comments_count?.toString())
              .fontSize(14)
              .fontColor('#666');
          }
          .onClick(() => {
            this.openCommentDialog(item.post_id);
          });
        }
      }
      .width('100%')
      .margin({ bottom: 8 });

      if (this.likeError) {
        Text(this.likeError)
          .fontSize(12)
          .fontColor(Color.Red)
          .margin({ top: 4 });
      }

      Divider()
        .strokeWidth(0.5)
        .color('#f0f0f0');
    }
    .padding({ left: 16, right: 16, top: 16, bottom: 12 })
    .backgroundColor('#ffffff')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .shadow({ radius: 6, color: '#10000000', offsetX: 0, offsetY: 2 });
  }

  @Builder
  dishSwiper() {
    Column() {
      if (this.dishes.length === 0) {
        Text('暂无推荐菜品')
          .fontSize(16)
          .fontColor('#999')
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 20, bottom: 20 });
      } else {
        Swiper() {
          ForEach(this.dishes, (dish: Dish) => {
            Stack({ alignContent: Alignment.Bottom }) {
              Image(dish.image_url || $r('app.media.icon_empty_shop'))
                .width('100%')
                .height(200)
                .objectFit(ImageFit.Cover)
                .borderRadius(16)
                .onClick(() => {
                  this.selectedDish = dish;
                  this.showDishDialog = true;
                });

              Column() {
                Text(dish.dish_name)
                  .fontSize(18)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Bold)
                  .textShadow({ radius: 2, color: Color.Black, offsetX: 1, offsetY: 1 })
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ bottom: 6 });
              }
              .width('auto')
              .padding(12)
              .alignItems(HorizontalAlign.Start);
            }
            .width('95%')
            .height(160)
            .margin({ right: 12 })
            .shadow({ radius: 8, color: '#40000000', offsetX: 2, offsetY: 4 });
          }, (dish: Dish) => dish.dish_id.toString());
        }
        .width('100%')
        .height(200)
        .margin({ top: 16, bottom: 12 })
        .indicator(true)
        .indicatorStyle({
          color: '#FFFFFF88',
          selectedColor: '#FF8C00',
          size: 6,
          mask: true
        })
        .autoPlay(true)
        .loop(true)
        .interval(3000)
        .duration(800)
        .itemSpace(0)
        .displayCount(1.2)
        .curve(Curve.EaseOut);
      }
    }
    .width('100%')
    .padding({ left: 8, right: 8 });
  }

  @Builder
  dishDetailDialog() {
    if (this.showDishDialog && this.selectedDish) {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.6)')
          .onClick(() => {
            this.showDishDialog = false;
          });

        Column() {
          Row() {
            Text(this.selectedDish!.dish_name)
              .fontSize(18)
              .fontWeight(FontWeight.Bold);
            Blank();
            Image($r('app.media.icon_error'))
              .width(20)
              .height(20)
              .onClick(() => {
                this.showDishDialog = false;
              });
          }
          .width('100%')
          .margin({ top: 10, left: 15, right: 15 });

          Divider();

          Image(this.selectedDish!.image_url)
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Cover);

          Scroll() {
            Column({ space: 8 }) {
              Text(`产地：${this.selectedDish!.origin_region}`)
                .fontSize(14)
                .fontColor('#555');

              Text(`人气：${this.selectedDish!.popularity}`)
                .fontSize(14)
                .fontColor('#555');

              Text(`描述：${this.selectedDish!.description}`)
                .fontSize(14)
                .fontColor('#333');
            }
            .padding(15);
          }
          .width('100%')
          .height(150);
        }
        .width('90%')
        .backgroundColor('#FFFFFF')
        .borderRadius(10)
        .padding(10)
        .shadow({ radius: 10, color: '#33333333' })
        .transition({
          type: TransitionType.All,
          opacity: 0.9,
          scale: { x: 0.9, y: 0.9 },
          translate: { x: 0, y: 50 }
        });
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 });
    }
  }

  @Builder
  commentDialog() {
    if (this.showCommentDialog) {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.5)')
          .onClick(() => this.closeCommentDialog());

        Column() {
          Row() {
            Text('评论')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1);

            Image($r('app.media.icon_error'))
              .width(20)
              .height(20)
              .onClick(() => this.closeCommentDialog());
          }
          .width('100%')
          .margin({ bottom: 12 });

          Scroll() {
            Column() {
              if (this.noteReviews.length === 0) {
                Text('暂无评论')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20 });
              } else {
                ForEach(this.noteReviews, (review: ReviewItem) => {
                  this.reviewItem(review);
                });
              }
            }
            .width('100%');
          }
          .layoutWeight(1)
          .width('100%')
          .margin({ bottom: 12 });

          if (this.replyingToReview) {
            Row() {
              Text(`回复：${this.replyingToReview.username}`)
                .fontSize(12)
                .fontColor('#666')
                .layoutWeight(1);

              Image($r('app.media.icon_error'))
                .width(16)
                .height(16)
                .onClick(() => this.replyingToReview = null);
            }
            .padding(8)
            .backgroundColor('#f5f5f5')
            .borderRadius(4)
            .margin({ bottom: 8 });
          }

          Row() {
            TextInput({ placeholder: '写下你的评论...', text: this.newReviewContent })
              .height(80)
              .layoutWeight(1)
              .onChange((value: string) => {
                this.newReviewContent = value;
              });

            Button('发送')
              .width(60)
              .height(36)
              .margin({ left: 8 })
              .backgroundColor('#FFA500')
              .fontColor(Color.White)
              .borderRadius(18)
              .onClick(() => this.submitReview())
              .enabled(!this.isSubmittingReview);
          }
          .width('100%');

          if (this.reviewError) {
            Text(this.reviewError)
              .fontSize(12)
              .fontColor(Color.Red)
              .margin({ top: 8 });
          }
        }
        .width('90%')
        .height('70%')
        .backgroundColor(Color.White)
        .borderRadius(12)
        .padding(16)
        .position({ x: '5%', y: '15%' });
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 });
    }
  }

  @Builder
  reviewItem(review: ReviewItem, level: number = 0) {
    Column() {
      Row() {
        if (review.avatar_url) {
          Image(review.avatar_url)
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ right: 12 });
        } else {
          Column()
            .width(40)
            .height(40)
            .borderRadius(20)
            .backgroundColor('#f0f0f0')
            .margin({ right: 12 })
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center);
        }

        Column() {
          Text(review.username)
            .fontSize(14)
            .fontWeight(FontWeight.Medium);
          Text(this.formatDate(review.created_at))
            .fontSize(12)
            .fontColor('#999');
        }
        .layoutWeight(1);
      }
      .width('100%')
      .margin({ bottom: 8 });

      Text(review.content)
        .fontSize(14)
        .margin({ bottom: 8 });

      if (review.parent_review) {
        Column() {
          Text(`回复：${review.parent_review.username}`)
            .fontSize(12)
            .fontColor('#666')
            .margin({ bottom: 4 });
          Text(review.parent_review.content)
            .fontSize(12)
            .fontColor('#999')
            .padding(8)
            .backgroundColor('#f5f5f5')
            .borderRadius(4)
            .width('100%');
        }
        .margin({ top: 8 });
      }

      Row() {
        Row() {
          Image($r('app.media.ic_like'))
            .width(16)
            .height(16)
            .margin({ right: 4 });
          Text(review.like_count.toString())
            .fontSize(12)
            .fontColor('#666');
        }
        .margin({ right: 16 });

        Row() {
          Image($r('app.media.ic_comment'))
            .width(16)
            .height(16)
            .margin({ right: 4 });
          Text('回复')
            .fontSize(12)
            .fontColor('#666');
        }
        .onClick(() => {
          this.replyingToReview = review;
        });
      }
      .margin({ top: 8 });

      if (review.replies && review.replies.length > 0) {
        Row() {
          Column()
            .width(2)
            .height('100%')
            .backgroundColor('#f0f0f0')
            .margin({ right: 8 });

          Column() {
            ForEach(review.replies, (reply: ReviewItem) => {
              this.reviewItem(reply, level + 1);
            });
          }
          .width('100%');
        }
        .margin({ left: 16 })
        .width('100%');
      }

      if (level === 0) {
        Divider()
          .strokeWidth(0.5)
          .color('#f0f0f0')
          .margin({ top: 12, bottom: 8 });
      }
    }
    .width('100%')
    .padding({ top: 12, bottom: 8 });
  }

  @Builder
  searchResultsSection() {
    Column() {
      if (this.isSearching) {
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
            .margin({ right: 8 });
          Text('正在搜索...')
            .fontSize(14)
            .fontColor('#999');
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ top: 20, bottom: 20 });
      } else if (this.searchError) {
        Column() {
          Text(this.searchError)
            .fontSize(14)
            .fontColor(Color.Red)
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 16 });

          Button('返回首页')
            .fontSize(14)
            .fontColor('#FFA500')
            .width(60)
            .height(30)
            .backgroundColor(Color.White)
            .borderRadius(15)
            .onClick(() => {
              this.clearSearch();
            });
        }
        .width('100%')
        .margin({ top: 20, bottom: 20 })
        .justifyContent(FlexAlign.Center);
      } else if (this.searchResults.length > 0) {
        Row() {
          Text('搜索结果')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1);

          Button('返回')
            .fontSize(14)
            .fontColor('#FFA500')
            .width(60)
            .height(30)
            .backgroundColor(Color.White)
            .borderRadius(15)
            .onClick(() => {
              this.clearSearch();
            });
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 20, bottom: 10 });

        Column() {
          ForEach(this.searchResults, (item: ShopItem) => {
            this.searchResultItem(item);
          }, (item: ShopItem) => item.shop_id.toString());
        }
        .width('100%')
        .margin({ bottom: 60 });
      }
    }
  }

  @Builder
  searchResultItem(item: ShopItem) {
    Column() {
      Row() {
        if (item.image_url) {
          Image(item.image_url)
            .width(80)
            .height(80)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
            .margin({ right: 12 });
        } else {
          Image($r('app.media.icon_empty_shop'))
            .width(80)
            .height(80)
            .borderRadius(8)
            .margin({ right: 12 });
        }

        Column() {
          Text(item.shop_name)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 4 });

          Row() {
            Text(`关注人数：(${item.follower_count})`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ left: 4 });
          }
          .margin({ bottom: 4 });

          Text('地址：' + item.address)
            .fontSize(12)
            .fontColor('#666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 4 });

          Row() {
            Text(`人均 ¥${item.avg_price}`)
              .fontSize(12)
              .fontColor('#666')
              .margin({ right: 8 });

            Text(item.business_hours)
              .fontSize(12)
              .fontColor('#666');
          }
        }
        .layoutWeight(1);
      }
      .width('100%')
      .padding(12);
    }
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ top: 8, left: 16, right: 16 })
    .shadow({ radius: 4, color: '#10000000', offsetX: 1, offsetY: 1 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ShopDetail',
        params: {
          shopId: item.shop_id.toString(),
          shopName: item.shop_name
        }
      });
    });
  }
}