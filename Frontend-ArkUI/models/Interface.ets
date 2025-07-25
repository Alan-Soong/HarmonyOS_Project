import { ChatMessage } from './message';
import {NoteItem, ReviewItem} from './notes'

export interface Mess {
  message: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
}

// interface GTL {
export interface NoteItemResponseDetail {
  success: boolean;
  data: NoteItem[];
}

// interface GTLIn {
export interface PostReviewCount {
  post_id: number;
  review_count: number;
}

export interface ReviewDetail {
  user_id: number;
  content: string;
  target_type: string;
  target_id: number;
  parent_review_id: number | undefined;
}

export interface LikeDetail {
  like_id: number;
  user_id: number;
  target_type: string;
  target_id: number;
  liked_at: string;
}

interface LikeResponse {
  success: boolean;
  data: LikeDetail;
}

interface UnlikeResponse {
  success: boolean;
}

export interface LikeCountResponse {
  success: boolean;
  data: Count;
}

interface Count {
  count: number;
}

export interface noteItemResponseDetail {
  success: boolean;
  data: NoteItem;
}

export interface noteItemDetail {
  user_id: number;
  title: string;
  content: string;
  visibility: string;
  images: string[];
}

export interface UnfollowResponse {
  success: boolean;
  message: string;
}

export interface FollowedShop {
  shop_id: number;
  shop_name: string;
  address: string;
  latitude: string;
  longitude: string;
  business_hours: string;
  avg_price: number;
  discount_info: string | null;
  contact_phone: string;
  follower_count: number;
  created_at: string;
  image_url: string;
}

export interface FollowedShopsResponse {
  success: boolean;
  data: FollowedShop[];
}

export interface LikedPost {
  like_id: number;
  liked_at: string;
  post_id: number;
  title: string;
  content: string;
  visibility: string;
  created_at: string;
  updated_at: string;
  author_username: string;
  author_avatar: string;
  like_count: number;
  review_count: number;
}

export interface LikedPostsResponse {
  success: boolean;
  data: LikedPost[];
}

export interface userID {
  user_id: number;
}

export interface ChatRecord {
  user_id: number;
  chatMessages: ChatMessage[];
}

export interface ReviewItemResponseDetail {
  success: boolean;
  data: ReviewItem[];
}

export interface RouteParams {
  shopId: string;
}

export interface RatingRequest {
  shop_id: number;
  user_id: number;
  rating: number;
}

export interface ReviewRequest {
  user_id: number;
  content: string;
  target_type: string;
  target_id: number;
  parent_review_id?: number;
  images?: string[];
  rating?: number;
}

export interface ReviewResponse {
  success: boolean;
  data: ReviewItem;
}

// 用户评分响应接口
export interface UserRating {
  rating_id: number;
  shop_id: number;
  user_id: number;
  rating: number;
  created_at: string;
}

export interface UserRatingResponse {
  success: boolean;
  data: UserRating | null;
}

// 添加接口类型定义
export interface FollowID {
  follow_id: number;
  user_id: number;
  shop_id: number;
  followed_at: string;
}

export interface FollowResponse {
  success: boolean;
  data: FollowID;
}

// 在类型定义部分添加
export interface FollowRequest {
  user_id: number;
  shop_id: number;
}

interface LikeActionData {
  like_id: number;
  user_id: number;
  target_type: string;
  target_id: string;
  liked_at: string;
}

export interface LikeActionResponse {
  success: boolean;
  data?: LikeActionData;
}