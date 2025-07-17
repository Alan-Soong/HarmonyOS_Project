const pool = require('../config/db');

class ShopService {
  async createShop({ shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone }) {
    if (!shop_name || !address || !latitude || !longitude) throw new Error('Required fields missing');
    try {
      const [result] = await pool.query(
        'INSERT INTO Shops (shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)',
        [shop_name, address, latitude, longitude, business_hours || null, avg_price || null, discount_info || null, contact_phone || null]
      );
      return {
        shop_id: result.insertId,
        shop_name,
        address,
        latitude,
        longitude,
        business_hours,
        avg_price,
        discount_info,
        contact_phone,
        follower_count: 0,
        created_at: new Date()
      };
    } catch (error) {
      throw error;
    }
  }

  async getShops() {
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at FROM Shops'
    );
    return rows;
  }

  async getShop(shopId) {
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at FROM Shops WHERE shop_id = ?',
      [shopId]
    );
    if (!rows.length) throw new Error('Shop not found');
    return rows[0];
  }
}

module.exports = new ShopService();