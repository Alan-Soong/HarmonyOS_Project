const pool = require('../config/db');

class PostService {
  async createPost({ user_id, title, content, visibility, images }) {
    if (!user_id || !title || !content) {
      throw new Error('Required fields missing');
    }
    if (visibility && !['PUBLIC', 'PRIVATE', 'FRIENDS_ONLY'].includes(visibility)) {
      throw new Error('Invalid visibility value');
    }

    try {
      const [result] = await pool.query(
        'INSERT INTO posts (user_id, title, content, visibility, images) VALUES (?, ?, ?, ?, ?)',
        [user_id, title, content, visibility || 'PUBLIC', JSON.stringify(images || [])]
      );

      return {
        post_id: result.insertId,
        user_id,
        title,
        content,
        visibility: visibility || 'PUBLIC',
        images: images || [],
        created_at: new Date(),
        updated_at: new Date()
      };
    } catch (error) {
      throw error;
    }
  }


  async getPosts() {
    const [rows] = await pool.query(
      `SELECT 
        p.post_id, 
        p.user_id, 
        p.title, 
        p.content, 
        p.visibility, 
        p.created_at, 
        p.updated_at,
        u.username,
        u.avatar_url,
        p.image_url,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'POST' AND target_id = p.post_id) as like_count
      FROM posts p 
      JOIN users u ON p.user_id = u.user_id 
      WHERE p.visibility = "PUBLIC" 
      ORDER BY p.created_at DESC`
    );
    return rows;
  }

  async getPostsByUserId(userId) {
    const [rows] = await pool.query(
      `SELECT 
        p.post_id, 
        p.user_id, 
        p.title, 
        p.content, 
        p.visibility, 
        p.created_at, 
        p.updated_at,
        u.username,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'POST' AND target_id = p.post_id) as like_count
      FROM posts p 
      JOIN users u ON p.user_id = u.user_id 
      WHERE p.user_id = ? 
      ORDER BY p.created_at DESC`,
      [userId]
    );
    return rows;
  }

  async getPost(postId) {
    const [rows] = await pool.query(
      `SELECT 
        p.post_id, 
        p.user_id, 
        p.title, 
        p.content, 
        p.visibility, 
        p.created_at, 
        p.updated_at,
        u.username,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'POST' AND target_id = p.post_id) as like_count
      FROM posts p 
      JOIN users u ON p.user_id = u.user_id 
      WHERE p.post_id = ?`,
      [postId]
    );
    if (!rows.length) throw new Error('Post not found');
    return rows[0];
  }

  async getPostWithLikeStatus(postId, userId = null) {
    const [rows] = await pool.query(
      `SELECT 
        p.post_id, 
        p.user_id, 
        p.title, 
        p.content, 
        p.visibility, 
        p.created_at, 
        p.updated_at,
        u.username,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'POST' AND target_id = p.post_id) as like_count,
        ${userId ? `(SELECT COUNT(*) > 0 FROM likes WHERE target_type = 'POST' AND target_id = p.post_id AND user_id = ?) as is_liked` : '0 as is_liked'}
      FROM posts p 
      JOIN users u ON p.user_id = u.user_id 
      WHERE p.post_id = ?`,
      userId ? [userId, postId] : [postId]
    );
    if (!rows.length) throw new Error('Post not found');
    return rows[0];
  }
}

module.exports = new PostService();