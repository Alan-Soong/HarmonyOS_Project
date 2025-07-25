// models/Dish.ets
export interface DishItem {
  dish_id: string;
  dish_name: string;
  description: string;
  origin_region?: string;
  popularity?: number;
  created_at?: string;
  average_rating?: number;
}

export interface Dish {
  dish_id: number;
  dish_name: string;
  description: string;
  origin_region: string;
  popularity: number;
  created_at: string;
  image_url: string;
}
