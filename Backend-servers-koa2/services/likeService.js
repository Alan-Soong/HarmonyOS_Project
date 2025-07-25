const pool = require('../config/db');

class LikeService {
  async createLike({ user_id, target_type, target_id }) {
    if (!user_id || !target_type || !target_id) throw new Error('Required fields missing');
    if (!['POST', 'REVIEW', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [result] = await pool.query(
        'INSERT INTO Likes (user_id, target_type, target_id) VALUES (?, ?, ?)',
        [user_id, target_type, target_id]
      );
      return { like_id: result.insertId, user_id, target_type, target_id, liked_at: new Date() };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('User has already liked this item');
      throw error;
    }
  }

  async deleteLike(user_id, target_type, target_id) {
    if (!['POST', 'REVIEW', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [result] = await pool.query(
        'DELETE FROM Likes WHERE user_id = ? AND target_type = ? AND target_id = ?',
        [user_id, target_type, target_id]
      );
      if (result.affectedRows === 0) throw new Error('Like not found');
    } catch (error) {
      throw error;
    }
  }

  async getLikeCount(target_type, target_id) {
    if (!['POST', 'REVIEW', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [rows] = await pool.query(
        'SELECT COUNT(*) as count FROM Likes WHERE target_type = ? AND target_id = ?',
        [target_type, target_id]
      );
      return rows[0].count;
    } catch (error) {
      throw error;
    }
  }

  async getLikes(target_type, target_id) {
    if (!['POST', 'REVIEW', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [rows] = await pool.query(
        `SELECT l.like_id, l.user_id, l.liked_at, u.username, u.avatar_url 
         FROM Likes l 
         JOIN users u ON l.user_id = u.user_id 
         WHERE l.target_type = ? AND l.target_id = ? 
         ORDER BY l.liked_at DESC`,
        [target_type, target_id]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  }

  async getLikeStatus(user_id, target_type, target_id) {
    if (!['POST', 'REVIEW', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [rows] = await pool.query(
        'SELECT COUNT(*) as count FROM Likes WHERE user_id = ? AND target_type = ? AND target_id = ?',
        [user_id, target_type, target_id]
      );
      return rows[0].count > 0;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new LikeService();