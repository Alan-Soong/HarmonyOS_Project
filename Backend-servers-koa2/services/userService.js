const pool = require('../config/db');

class UserService {
  async createUser({ username, password, avatar_url }) {
    if (!username) throw new Error('Username is required');
    if (!password) throw new Error('Password is required');
    try {
      const [result] = await pool.query(
        'INSERT INTO users (username, password, avatar_url) VALUES (?, ?, ?)',
        [username, password, avatar_url || null]
      );
      return { user_id: result.insertId, username, avatar_url, created_at: new Date(), last_login: null };
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('Username already exists');
      throw error;
    }
  }

  async getUser(userId) {
    const [rows] = await pool.query(
      'SELECT user_id, username, avatar_url, created_at, last_login FROM users WHERE user_id = ?',
      [userId]
    );
    if (!rows.length) throw new Error('User not found');
    return rows[0];
  }

  async updateUser(userId, { username, password, avatar_url }) {
    if (!username && !password && !avatar_url) throw new Error('No fields to update');
    try {
      const updates = [];
      const values = [];
      if (username) {
        updates.push('username = ?');
        values.push(username);
      }
      if (password) {
        updates.push('password = ?');
        values.push(password);
      }
      if (avatar_url) {
        updates.push('avatar_url = ?');
        values.push(avatar_url);
      }
      values.push(userId);
      const [result] = await pool.query(
        `UPDATE users SET ${updates.join(', ')} WHERE user_id = ?`,
        values
      );
      if (result.affectedRows === 0) throw new Error('User not found');
      return await this.getUser(userId);
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') throw new Error('Username already exists');
      throw error;
    }
  }

  async getUsers() {
    const [rows] = await pool.query(
      'SELECT user_id, username, avatar_url, created_at, last_login FROM users ORDER BY created_at DESC'
    );
    return rows;
  }

  async loginUser(username, password) {
    if (!username || !password) throw new Error('Username and password are required');
    const [rows] = await pool.query(
      'SELECT user_id, username, avatar_url, created_at, last_login FROM users WHERE username = ? AND password = ?',
      [username, password]
    );
    if (!rows.length) throw new Error('Invalid username or password');
    
    // 更新最后登录时间
    await pool.query(
      'UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?',
      [rows[0].user_id]
    );
    
    return rows[0];
  }

  async getUserProfile(userId) {
    try {
      // 获取用户基本信息
      const [userRows] = await pool.query(
        'SELECT user_id, username, avatar_url, created_at, last_login FROM users WHERE user_id = ?',
        [userId]
      );
      if (!userRows.length) throw new Error('User not found');
      
      const user = userRows[0];

      // 获取用户发布的帖子
      const [postRows] = await pool.query(
        'SELECT post_id, title, content, created_at, updated_at, visibility, images FROM posts WHERE user_id = ? ORDER BY created_at DESC',
        [userId]
      );

      // 获取用户的评价/评论
      const [reviewRows] = await pool.query(
        'SELECT review_id, content, created_at, target_type, target_id, parent_review_id FROM reviews WHERE user_id = ? ORDER BY created_at DESC',
        [userId]
      );

      // 获取用户的点赞记录
      const [likeRows] = await pool.query(
        'SELECT like_id, target_type, target_id, liked_at FROM likes WHERE user_id = ? ORDER BY liked_at DESC',
        [userId]
      );

      // 获取用户关注的店铺
      const [followingRows] = await pool.query(
        `SELECT fs.follow_id, fs.followed_at, s.shop_id, s.shop_name, s.address, s.avg_price 
         FROM following_shops fs 
         JOIN shops s ON fs.shop_id = s.shop_id 
         WHERE fs.user_id = ? 
         ORDER BY fs.followed_at DESC`,
        [userId]
      );

      // 获取用户的店铺评分
      const [shopRatingRows] = await pool.query(
        `SELECT sr.rating_id, sr.rating, sr.created_at, s.shop_id, s.shop_name 
         FROM shop_ratings sr 
         JOIN shops s ON sr.shop_id = s.shop_id 
         WHERE sr.user_id = ? 
         ORDER BY sr.created_at DESC`,
        [userId]
      );

      // 获取用户的菜品评分
      const [dishRatingRows] = await pool.query(
        `SELECT dr.rating_id, dr.rating, dr.created_at, d.dish_id, d.dish_name 
         FROM dish_ratings dr 
         JOIN special_dishes d ON dr.dish_id = d.dish_id 
         WHERE dr.user_id = ? 
         ORDER BY dr.created_at DESC`,
        [userId]
      );

      // 获取用户收到的消息数量（可选）
      const [messageCountRows] = await pool.query(
        'SELECT COUNT(*) as message_count FROM messages WHERE receiver_id = ?',
        [userId]
      );

      // 获取用户发送的消息数量（可选）
      const [sentMessageCountRows] = await pool.query(
        'SELECT COUNT(*) as sent_message_count FROM messages WHERE sender_id = ?',
        [userId]
      );

      // 组装完整的用户档案
      const userProfile = {
        ...user,
        statistics: {
          posts_count: postRows.length,
          reviews_count: reviewRows.length,
          likes_count: likeRows.length,
          following_shops_count: followingRows.length,
          shop_ratings_count: shopRatingRows.length,
          dish_ratings_count: dishRatingRows.length,
          received_messages_count: messageCountRows[0].message_count,
          sent_messages_count: sentMessageCountRows[0].sent_message_count
        },
        posts: postRows,
        reviews: reviewRows,
        likes: likeRows,
        following_shops: followingRows,
        shop_ratings: shopRatingRows,
        dish_ratings: dishRatingRows
      };

      return userProfile;
    } catch (error) {
      throw error;
    }
  }

  async getUserLikedPosts(userId) {
    try {
      const [rows] = await pool.query(
        `SELECT 
          l.like_id,
          l.liked_at,
          p.post_id,
          p.title,
          p.content,
          p.visibility,
          p.created_at,
          p.updated_at,
          u.username as author_username,
          u.avatar_url as author_avatar,
          (SELECT COUNT(*) FROM likes WHERE target_type = 'POST' AND target_id = p.post_id) as like_count,
          (SELECT COUNT(*) FROM reviews WHERE target_type = 'POST' AND target_id = p.post_id) as review_count
        FROM likes l
        JOIN posts p ON l.target_id = p.post_id AND l.target_type = 'POST'
        JOIN users u ON p.user_id = u.user_id
        WHERE l.user_id = ? AND p.visibility = 'PUBLIC'
        ORDER BY l.liked_at DESC`,
        [userId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  }

  async getUserStats(userId) {
    try {
      // 获取用户帖子数量（笔记数量）
      const [postCountRows] = await pool.query(
        'SELECT COUNT(*) as post_count FROM posts WHERE user_id = ?',
        [userId]
      );

      // 获取用户关注店铺数量
      const [followingCountRows] = await pool.query(
        'SELECT COUNT(*) as following_shops_count FROM following_shops WHERE user_id = ?',
        [userId]
      );

      // 获取用户获得的总点赞数（用户的帖子被点赞的数量）
      const [receivedLikesRows] = await pool.query(
        `SELECT COUNT(*) as received_likes_count 
         FROM likes l
         JOIN posts p ON l.target_id = p.post_id AND l.target_type = 'POST'
         WHERE p.user_id = ?`,
        [userId]
      );

      // 获取用户评论被点赞的数量
      const [reviewLikesRows] = await pool.query(
        `SELECT COUNT(*) as review_likes_count 
         FROM likes l
         JOIN reviews r ON l.target_id = r.review_id AND l.target_type = 'REVIEW'
         WHERE r.user_id = ?`,
        [userId]
      );

      const totalReceivedLikes = receivedLikesRows[0].received_likes_count + reviewLikesRows[0].review_likes_count;

      return {
        post_count: postCountRows[0].post_count,
        following_shops_count: followingCountRows[0].following_shops_count,
        received_likes_count: totalReceivedLikes
      };
    } catch (error) {
      throw error;
    }
  }

  async searchUsersByUsername(username) {
    try {
      const [rows] = await pool.query(
        `SELECT user_id, username, avatar_url, created_at, last_login 
         FROM users 
         WHERE username LIKE ? 
         ORDER BY username ASC`,
        [`%${username}%`]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  }

  async getUserByUsername(username) {
    try {
      const [rows] = await pool.query(
        `SELECT user_id, username, avatar_url, created_at, last_login 
         FROM users 
         WHERE username = ?`,
        [username]
      );
      if (!rows.length) throw new Error('User not found');
      return rows[0];
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new UserService();