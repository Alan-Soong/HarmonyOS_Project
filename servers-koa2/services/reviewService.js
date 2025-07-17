const pool = require('../config/db');

class ReviewService {
  async createReview({ user_id, content, target_type, target_id, parent_review_id }) {
    if (!user_id || !content || !target_type || !target_id) throw new Error('Required fields missing');
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [result] = await pool.query(
        'INSERT INTO Reviews (user_id, content, target_type, target_id, parent_review_id) VALUES (?, ?, ?, ?, ?)',
        [user_id, content, target_type, target_id, parent_review_id || null]
      );
      return {
        review_id: result.insertId,
        user_id,
        content,
        target_type,
        target_id,
        parent_review_id,
        created_at: new Date()
      };
    } catch (error) {
      throw error;
    }
  }

  async getReviews(target_type, target_id) {
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    const [rows] = await pool.query(
      'SELECT review_id, user_id, content, target_type, target_id, parent_review_id, created_at FROM Reviews WHERE target_type = ? AND target_id = ? ORDER BY created_at DESC',
      [target_type, target_id]
    );
    return rows;
  }
}

module.exports = new ReviewService();