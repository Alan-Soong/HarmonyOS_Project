export interface ShopInfo {
  address?: string;
  shop_id?: number;
  shop_name?: string;
  title?: string;
  content?: string;
  post_id?: number;
  dish_id?: number;
}

export interface PostInfo {
  post_id: number;
  title: string;
  content: string;
}

export interface DishInfo {
  dish_id: number;
  dish_name: string;
  price: number;
}

type TargetInfo = ShopInfo | PostInfo | DishInfo;

export interface ReviewItem {
  review_id: number;       // 修改为 number
  user_id: number;         // 修改为 number
  content: string;
  created_at: string;
  target_type: 'SHOP' | 'POST' | 'DISH';
  target_id: number;       // 修改为 number
  parent_review_id: number | null; // 明确支持 null
  username?: string;
  avatar_url?: string;
  images: string[];        // 接口未返回，前端默认赋值 []
  rating: number;          // 接口未返回，可能为空字符串
  target_info: TargetInfo;
  like_count: number;
  parent_review?: ParentReview;      // 可根据实际类型细化
}

export interface ReviewsResponse {
  success: boolean;
  data: ReviewItem[];
  message: string;
}

interface ParentReview {
  content: string;
  username: string;
  review_id: number;
  created_at: string;
}

export interface ShopUserRating {
  rating_id: number;
  shop_id: number;
  user_id: number;
  rating: number;
  created_at: string;
}

export interface ShopRatingResponse {
  success: boolean;
  data: ShopUserRating;
}