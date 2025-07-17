const pool = require('../config/db');

class RatingService {
  async createShopRating({ shop_id, user_id, rating }) {
    if (!shop_id || !user_id || !rating) throw new Error('Required fields missing');
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    try {
      const [result] = await pool.query(
        'INSERT INTO Shop_Ratings (shop_id, user_id, rating) VALUES (?, ?, ?)',
        [shop_id, user_id, rating]
      );
      return { rating_id: result.insertId, shop_id, user_id, rating, created_at: new Date() };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('User has already rated this shop');
      throw error;
    }
  }

  async createDishRating({ dish_id, user_id, rating }) {
    if (!dish_id || !user_id || !rating) throw new Error('Required fields missing');
    if (rating < 1 || rating > 5) throw new Error('Rating must be between 1 and 5');
    try {
      const [result] = await pool.query(
        'INSERT INTO Dish_Ratings (dish_id, user_id, rating) VALUES (?, ?, ?)',
        [dish_id, user_id, rating]
      );
      return { rating_id: result.insertId, dish_id, user_id, rating, created_at: new Date() };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('User has already rated this dish');
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
}

module.exports = new RatingService();