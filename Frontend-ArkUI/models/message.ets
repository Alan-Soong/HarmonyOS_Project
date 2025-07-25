// models/message.ets
export interface MessageItem {
  message_id: number; // 保持 string，API 可能返回字符串
  sender_username: string; // 保持兼容
  receiver_username: string;
  sender_id: number; // 改为 number，与数据库一致
  receiver_id: number;
  content: string;
  sent_at: string;
  is_read: number;
  // sender_username?: string;
  avatar_url: string;
  sender_avatar_url: string;
  receiver_avatar_url: string;
  display_username: string; // 新增：显示对方用户名
  display_avatar_url: string; // 新增：显示对方头像
  display_partner_id: number; // 新增：对方用户ID
}

export interface RouterParams {
  display_partner_id: number;
  display_avatar_url: string;
  display_username: string;
  message_id: number;
  sender_username: string; // 保持兼容
  receiver_username: string;
  content: string;
  sent_at: string;
  is_read: number;
  sender_id: number; // 路由参数可能是字符串
  receiver_id: number;
  avatar_url: string;
  sender_avatar_url: string;
  receiver_avatar_url: string;
}

export interface ChatMessage {
  message_id: number;
  sender_username: string;
  receiver_username: string;
  content: string;
  sent_at: string;  // 原始时间字符串
  // displayDate: string; // 添加这个字段，用于显示日期（如"2023-10-15"）
  // displayTime: string; // 添加这个字段，用于显示时间（如"14:30"）
  isMine: boolean;
  sender_id: number;
  receiver_id: number;
  sender_avatar_url: string;
  receiver_avatar_url: string;
}