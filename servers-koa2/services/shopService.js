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
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at, image_url FROM Shops'
    );
    return rows;
  }

  async getShop(shopId) {
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at, image_url FROM Shops WHERE shop_id = ?',
      [shopId]
    );
    if (!rows.length) throw new Error('Shop not found');
    return rows[0];
  }

  async searchShops(keyword) {
    // 通用搜索：在店铺名称和地址中搜索关键字
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, created_at, follower_count, image_url FROM Shops WHERE shop_name LIKE ? OR address LIKE ?',
      [`%${keyword}%`, `%${keyword}%`]
    );
    return rows;
  }

  async searchShopsByName(name) {
    // 按店铺名称搜索
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at, image_url FROM Shops WHERE shop_name LIKE ?',
      [`%${name}%`]
    );
    return rows;
  }

  async searchShopsByAddress(address) {
    // 按地址搜索
    const [rows] = await pool.query(
      'SELECT shop_id, shop_name, address, latitude, longitude, business_hours, avg_price, discount_info, contact_phone, follower_count, created_at, image_url FROM Shops WHERE address LIKE ?',
      [`%${address}%`]
    );
    return rows;
  }
}

module.exports = new ShopService();