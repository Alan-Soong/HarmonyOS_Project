export interface Post {
  postId: number;
  title: string;
  content: string;
  createdAt: string;
  updatedAt: string;
  visibility: string;
  images: string[];
}

export interface Review {
  reviewId: number;
  content: string;
  createdAt: string;
  targetType: string;
  targetId: number;
  parentReviewId: number | null;
}

export interface ShopRating {
  ratingId: number;
  rating: number;
  createdAt: string;
  shopId: number;
  shopName: string;
}

export interface UserProfile {
  userId: number;
  username: string;
  avatarUrl?: string;
  statistics: UserStatistics;
  posts: Post[];
  reviews: Review[];
  shopRatings: ShopRating[];
}

// types.ts
export interface RecentActivity {
  id: string;
  title: string;
  time: string;
}

export interface Post {
  post_id: number;
  title: string;
  content: string;
  created_at: string;
  updated_at: string;
  visibility: string;
  images: string[];
}

export interface ShopRating {
  rating_id: number;
  rating: number;
  created_at: string;
  shop_id: number;
  shop_name: string;
}

export interface Review {
  review_id: number;
  content: string;
  created_at: string;
  target_type: string;
  target_id: number;
  parent_review_id: number | null;
}

export interface UserStatistics {
  posts_count: number;
  reviews_count: number;
  likes_count: number;
  following_shops_count: number;
  shop_ratings_count: number;
  dish_ratings_count: number;
  received_messages_count: number;
  sent_messages_count: number;
}

export interface UserProfileData {
  user_id: number;
  username: string;
  avatar_url?: string;
  created_at: string;
  last_login: string;
  statistics: UserStatistics;
  posts: Post[];
  reviews: Review[];
  shop_ratings: ShopRating[];
}

export interface UserProfileResponse {
  success: boolean;
  data: UserProfileData;
}