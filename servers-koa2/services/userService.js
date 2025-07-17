const pool = require('../config/db');

class UserService {
  async createUser({ username, avatar_url }) {
    if (!username) throw new Error('Username is required');
    try {
      const [result] = await pool.query(
        'INSERT INTO Users (username, avatar_url) VALUES (?, ?)',
        [username, avatar_url || null]
      );
      return { user_id: result.insertId, username, avatar_url, created_at: new Date(), last_login: null };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('Username already exists');
      throw error;
    }
  }

  async getUser(userId) {
    const [rows] = await pool.query(
      'SELECT user_id, username, avatar_url, created_at, last_login FROM Users WHERE user_id = ?',
      [userId]
    );
    if (!rows.length) throw new Error('User not found');
    return rows[0];
  }

  async updateUser(userId, { username, avatar_url }) {
    if (!username && !avatar_url) throw new Error('No fields to update');
    try {
      const updates = [];
      const values = [];
      if (username) {
        updates.push('username = ?');
        values.push(username);
      }
      if (avatar_url) {
        updates.push('avatar_url = ?');
        values.push(avatar_url);
      }
      values.push(userId);
      const [result] = await pool.query(
        `UPDATE Users SET ${updates.join(', ')} WHERE user_id = ?`,
        values
      );
      if (result.affectedRows === 0) throw new Error('User not found');
      return await this.getUser(userId);
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('Username already exists');
      throw error;
    }
  }
}

module.exports = new UserService();