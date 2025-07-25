// src/models/rating.ts

// 评分请求接口
export interface RatingRequest {
  shop_id: number;
  user_id: number;
  rating: number; // 1-5星
}

// 评分记录接口
export interface RatingRecord {
  rating_id: number;
  shop_id: number;
  user_id: number;
  rating: number;
  created_at: string;
  updated_at?: string;
}

// 单个评分响应数据结构
interface RatingResponseData {
  rating_id: number;
  shop_id: number;
  user_id: number;
  rating: number;
  created_at: string;
  updated_at?: string;
  action?: 'created' | 'updated';
}

// 单个评分响应接口
export interface SingleRatingResponse {
  success: boolean;
  data: RatingResponseData;
  message?: string;
}

// 评分列表响应接口
export interface RatingListResponse {
  success: boolean;
  data: RatingRecord[];
  message?: string;
}

// 评分分布项
interface RatingDistributionItem {
  rating: number;
  count: number;
}

// 评分统计接口
export interface RatingStats {
  rating_id: number;
  shop_id: number;
  user_id: number;
  rating: number;
  average_rating: number;
  // rating_distribution: RatingDistributionItem[];
  create_at: string;
  update_at: string;
  action: string;
}

export interface RatingStatsResponse {
  success: boolean;
  data: RatingStats;
}

// 用户评分映射接口
export interface UserRatings {
  ratings: Map<number, number>;
}