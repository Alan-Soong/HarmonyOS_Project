const pool = require('../config/db');

class FollowingShopsService {
  async followShop({ user_id, shop_id }) {
    if (!user_id || !shop_id) throw new Error('Required fields missing');
    try {
      const [result] = await pool.query(
        'INSERT INTO Following_Shops (user_id, shop_id) VALUES (?, ?)',
        [user_id, shop_id]
      );
      await pool.query(
        'UPDATE Shops SET follower_count = follower_count + 1 WHERE shop_id = ?',
        [shop_id]
      );
      return { follow_id: result.insertId, user_id, shop_id, followed_at: new Date() };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('User already follows this shop');
      throw error;
    }
  }

  async unfollowShop(user_id, shop_id) {
    try {
      const [result] = await pool.query(
        'DELETE FROM Following_Shops WHERE user_id = ? AND shop_id = ?',
        [user_id, shop_id]
      );
      if (result.affectedRows === 0) throw new Error('Follow relationship not found');
      await pool.query(
        'UPDATE Shops SET follower_count = follower_count - 1 WHERE shop_id = ? AND follower_count > 0',
        [shop_id]
      );
    } catch (error) {
      throw error;
    }
  }

  async getFollowedShops(user_id) {
    const [rows] = await pool.query(
      'SELECT s.shop_id, s.shop_name, s.address, s.latitude, s.longitude, s.business_hours, s.avg_price, s.discount_info, s.contact_phone, s.follower_count, s.created_at ' +
      'FROM Shops s JOIN Following_Shops fs ON s.shop_id = fs.shop_id WHERE fs.user_id = ?',
      [user_id]
    );
    return rows;
  }
}

module.exports = new FollowingShopsService();