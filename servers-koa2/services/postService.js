const pool = require('../config/db');

class PostService {
  async createPost({ user_id, title, content, visibility }) {
    if (!user_id || !title || !content) throw new Error('Required fields missing');
    if (visibility && !['PUBLIC', 'PRIVATE', 'FRIENDS_ONLY'].includes(visibility)) {
      throw new Error('Invalid visibility value');
    }
    try {
      const [result] = await pool.query(
        'INSERT INTO Posts (user_id, title, content, visibility) VALUES (?, ?, ?, ?)',
        [user_id, title, content, visibility || 'PUBLIC']
      );
      return {
        post_id: result.insertId,
        user_id,
        title,
        content,
        visibility: visibility || 'PUBLIC',
        created_at: new Date(),
        updated_at: new Date()
      };
    } catch (error) {
      throw error;
    }
  }

  async getPosts() {
    const [rows] = await pool.query(
      'SELECT post_id, user_id, title, content, visibility, created_at, updated_at FROM Posts WHERE visibility = "PUBLIC"'
    );
    return rows;
  }

  async getPost(postId) {
    const [rows] = await pool.query(
      'SELECT post_id, user_id, title, content, visibility, created_at, updated_at FROM Posts WHERE post_id = ?',
      [postId]
    );
    if (!rows.length) throw new Error('Post not found');
    return rows[0];
  }
}

module.exports = new PostService();