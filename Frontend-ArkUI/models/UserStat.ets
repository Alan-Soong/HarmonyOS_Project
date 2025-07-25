// src/main/ets/models/UserStats.ts
interface pfr {
  post_count: number;
  following_shops_count: number;
  received_likes_count: number;
}

export interface UserStatsResponse {
  success: boolean;
  data: pfr;
}

export interface UserStats {
  postCount: number;
  followingShopsCount: number;
  receivedLikesCount: number;
}