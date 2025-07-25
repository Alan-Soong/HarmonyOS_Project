// 定义本地接口
export interface ApiResponse<T> {
  success: boolean;
  data: T;
}

export interface RouterParams {
  id: string;
  username: string;
  content: string;
  time: string;
  unread: boolean;
}

export interface ChatMessage {
  sender: 'user' | 'other';
  content: string;
  sent_at: string;
}

export interface RequestParams {
  current_user_id: string;
}
