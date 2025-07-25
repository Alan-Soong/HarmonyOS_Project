const pool = require('../config/db');

class RatingService {
  async createShopRating({ shop_id, user_id, rating }) {
    if (!shop_id || !user_id || !rating) throw new Error('Required fields missing');
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    try {
      const [result] = await pool.query(
        'INSERT INTO Shop_Ratings (shop_id, user_id, rating) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE rating = VALUES(rating), created_at = CURRENT_TIMESTAMP',
        [shop_id, user_id, rating]
      );
      
      // 检查是否是插入还是更新
      if (result.affectedRows === 1) {
        // 新插入
        return { rating_id: result.insertId, shop_id, user_id, rating, created_at: new Date(), action: 'created' };
      } else {
        // 更新操作，需要获取rating_id
        const [existingRating] = await pool.query(
          'SELECT rating_id, created_at FROM Shop_Ratings WHERE shop_id = ? AND user_id = ?',
          [shop_id, user_id]
        );
        return { 
          rating_id: existingRating[0].rating_id, 
          shop_id, 
          user_id, 
          rating, 
          created_at: existingRating[0].created_at,
          updated_at: new Date(),
          action: 'updated' 
        };
      }
    } catch (error) {
      throw error;
    }
  }

  async createDishRating({ dish_id, user_id, rating }) {
    if (!dish_id || !user_id || !rating) throw new Error('Required fields missing');
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    try {
      const [result] = await pool.query(
        'INSERT INTO Dish_Ratings (dish_id, user_id, rating) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE rating = VALUES(rating), created_at = CURRENT_TIMESTAMP',
        [dish_id, user_id, rating]
      );
      
      // 检查是否是插入还是更新
      if (result.affectedRows === 1) {
        // 新插入
        return { rating_id: result.insertId, dish_id, user_id, rating, created_at: new Date(), action: 'created' };
      } else {
        // 更新操作，需要获取rating_id
        const [existingRating] = await pool.query(
          'SELECT rating_id, created_at FROM Dish_Ratings WHERE dish_id = ? AND user_id = ?',
          [dish_id, user_id]
        );
        return { 
          rating_id: existingRating[0].rating_id, 
          dish_id, 
          user_id, 
          rating, 
          created_at: existingRating[0].created_at,
          updated_at: new Date(),
          action: 'updated' 
        };
      }
    } catch (error) {
      throw error;
    }
  }

  async getShopRatings(shop_id) {
    const [rows] = await pool.query(
      'SELECT rating_id, shop_id, user_id, rating, created_at FROM Shop_Ratings WHERE shop_id = ?',
      [shop_id]
    );
    return rows;
  }

  async getDishRatings(dish_id) {
    const [rows] = await pool.query(
      'SELECT rating_id, dish_id, user_id, rating, created_at FROM Dish_Ratings WHERE dish_id = ?',
      [dish_id]
    );
    return rows;
  }

  // 获取用户对店铺的评分
  async getUserShopRating(shop_id, user_id) {
    const [rows] = await pool.query(
      'SELECT rating_id, shop_id, user_id, rating, created_at FROM Shop_Ratings WHERE shop_id = ? AND user_id = ?',
      [shop_id, user_id]
    );
    return rows[0] || null;
  }

  // 获取用户对菜品的评分
  async getUserDishRating(dish_id, user_id) {
    const [rows] = await pool.query(
      'SELECT rating_id, dish_id, user_id, rating, created_at FROM Dish_Ratings WHERE dish_id = ? AND user_id = ?',
      [dish_id, user_id]
    );
    return rows[0] || null;
  }

  // 更新店铺评分
  async updateShopRating(shop_id, user_id, rating) {
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    
    const [result] = await pool.query(
      'UPDATE Shop_Ratings SET rating = ?, created_at = CURRENT_TIMESTAMP WHERE shop_id = ? AND user_id = ?',
      [rating, shop_id, user_id]
    );
    
    if (result.affectedRows === 0) {
      throw new Error('Rating not found or user has not rated this shop');
    }
    
    return await this.getUserShopRating(shop_id, user_id);
  }

  // 更新菜品评分
  async updateDishRating(dish_id, user_id, rating) {
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    
    const [result] = await pool.query(
      'UPDATE Dish_Ratings SET rating = ?, created_at = CURRENT_TIMESTAMP WHERE dish_id = ? AND user_id = ?',
      [rating, dish_id, user_id]
    );
    
    if (result.affectedRows === 0) {
      throw new Error('Rating not found or user has not rated this dish');
    }
    
    return await this.getUserDishRating(dish_id, user_id);
  }

  // 删除店铺评分
  async deleteShopRating(shop_id, user_id) {
    const [result] = await pool.query(
      'DELETE FROM Shop_Ratings WHERE shop_id = ? AND user_id = ?',
      [shop_id, user_id]
    );
    
    if (result.affectedRows === 0) {
      throw new Error('Rating not found or user has not rated this shop');
    }
    
    return { success: true, message: 'Rating deleted successfully' };
  }

  // 删除菜品评分
  async deleteDishRating(dish_id, user_id) {
    const [result] = await pool.query(
      'DELETE FROM Dish_Ratings WHERE dish_id = ? AND user_id = ?',
      [dish_id, user_id]
    );
    
    if (result.affectedRows === 0) {
      throw new Error('Rating not found or user has not rated this dish');
    }
    
    return { success: true, message: 'Rating deleted successfully' };
  }

  // 获取店铺平均评分和评分统计
  async getShopRatingStats(shop_id) {
    const [avgResult] = await pool.query(
      'SELECT AVG(rating) as average_rating, COUNT(*) as total_ratings FROM Shop_Ratings WHERE shop_id = ?',
      [shop_id]
    );
    
    const [distribution] = await pool.query(
      'SELECT rating, COUNT(*) as count FROM Shop_Ratings WHERE shop_id = ? GROUP BY rating ORDER BY rating',
      [shop_id]
    );
    
    return {
      shop_id: parseInt(shop_id),
      average_rating: parseFloat(avgResult[0].average_rating) || 0,
      total_ratings: avgResult[0].total_ratings,
      rating_distribution: distribution
    };
  }

  // 获取菜品平均评分和评分统计
  async getDishRatingStats(dish_id) {
    const [avgResult] = await pool.query(
      'SELECT AVG(rating) as average_rating, COUNT(*) as total_ratings FROM Dish_Ratings WHERE dish_id = ?',
      [dish_id]
    );
    
    const [distribution] = await pool.query(
      'SELECT rating, COUNT(*) as count FROM Dish_Ratings WHERE dish_id = ? GROUP BY rating ORDER BY rating',
      [dish_id]
    );
    
    return {
      dish_id: parseInt(dish_id),
      average_rating: parseFloat(avgResult[0].average_rating) || 0,
      total_ratings: avgResult[0].total_ratings,
      rating_distribution: distribution
    };
  }
}

module.exports = new RatingService();