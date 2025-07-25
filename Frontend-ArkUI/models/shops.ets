// models/Shop.ets
export interface ShopItem {
  shop_id: number;
  shop_name: string;
  address: string;
  latitude: number;
  longitude: number;
  business_hours: string;
  avg_price: number;
  discount_info: string;
  contact_phone: string;
  created_at: string;
  follower_count: number;
  average_rating: number;
  image_url: string;
  // user_rating: number;
}


export interface ShopItemResponse {
  success: boolean;
  data: ShopItem[];
  message: string;
}

// // 定义 SearchDetailItem 接口
// export interface SearchDetailItem {
//   shop_id: number;  // 根据API返回数据改为number类型
//   shop_name: string;
//   address: string;
//   latitude: string; // API返回的是字符串格式
//   longitude: string;
//   business_hours: string;
//   avg_price: number;
//   discount_info: string | null; // 允许null值
//   contact_phone: string;
//   follower_count: number;
//   created_at: string;
//   average_rating?: number; // 可选字段，API返回中没有
//   image_url?: string;      // 可选字段，API返回中没有
// }
