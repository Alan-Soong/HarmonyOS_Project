export interface NoteItem {
  // is_liked: boolean;
  post_id: number;                // 与数据库 int 一致
  user_id: number;                // 与数据库 int 一致
  title: string;
  content: string;
  created_at: string;             // 前端用字符串接收 timestamp
  updated_at: string;             // 新增字段，用于接收更新时间
  visibility: 'PUBLIC' | 'PRIVATE' | 'FRIENDS_ONLY'; // 新增字段，与 enum 一致
  images: string[] | null;         // json -> string[] 或 Record[]
  username: string;
  avatar_url?: string;
  likes_count?: number;
  comments_count?: number;
  images_url?: string[];
  image_url: string;
}

// 在 models/notes.ts 中添加评论相关接口
interface pr {
  content: string;
  username: string;
  review_id: number;
  created_at: string;
}

export interface ReviewItem {
  review_id: number;
  user_id: number;
  content: string;
  created_at: string;
  target_type: string;
  target_id: number;
  parent_review_id?: number;
  username: string;
  avatar_url?: string;
  images?: string[];
  like_count: number;
  replies?: ReviewItem[]; // 新增回复列表
  parent_review?: pr;
}

export interface ReviewRequest {
  user_id: number;
  content: string;
  target_type: string;
  target_id: number;
  parent_review_id?: number;
  images?: string[];
}

export interface ReviewResponse {
  success: boolean;
  data: ReviewItem;
}

export interface ReviewsResponse {
  success: boolean;
  data: ReviewItem[];
  message: string;
}
