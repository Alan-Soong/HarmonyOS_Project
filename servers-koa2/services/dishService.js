const pool = require('../config/db');

class DishService {
  async createDish({ dish_name, description, origin_region }) {
    if (!dish_name) throw new Error('Dish name is required');
    try {
      const [result] = await pool.query(
        'INSERT INTO Special_Dishes (dish_name, description, origin_region, popularity, image_url) VALUES (?, ?, ?, 0, ?)',
        [dish_name, description || null, origin_region || null, image_url || null]
      );
      return {
        dish_id: result.insertId,
        dish_name,
        description,
        origin_region,
        popularity: 0,
        created_at: new Date()
      };
    } catch (error) {
      throw error;
    }
  }

  async getDishes() {
    const [rows] = await pool.query(
      'SELECT dish_id, dish_name, description, origin_region, popularity, created_at, image_url FROM Special_Dishes'
    );
    return rows;
  }

  async getDish(dishId) {
    const [rows] = await pool.query(
      'SELECT dish_id, dish_name, description, origin_region, popularity, created_at, image_url FROM Special_Dishes WHERE dish_id = ?',
      [dishId]
    );
    if (!rows.length) throw new Error('Dish not found');
    return rows[0];
  }
}

module.exports = new DishService();