const pool = require('../config/db');

class ReviewService {
  async createReview({ user_id, content, target_type, target_id, parent_review_id, images, rating }) {
    if (!user_id || !content || !target_type || !target_id) throw new Error('Required fields missing');
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    try {
      const [result] = await pool.query(
        'INSERT INTO reviews (user_id, content, target_type, target_id, parent_review_id) VALUES (?, ?, ?, ?, ?)',
        [user_id, content, target_type, target_id, parent_review_id || null]
      );
      
      // 获取刚插入记录的真实创建时间
      const [createdReview] = await pool.query(
        'SELECT created_at FROM reviews WHERE review_id = ?',
        [result.insertId]
      );
      
      return {
        review_id: result.insertId,
        user_id,
        content,
        target_type,
        target_id,
        parent_review_id,
        images: images || [],
        rating: rating || null,
        created_at: createdReview[0].created_at  // 使用数据库的真实时间
      };
    } catch (error) {
      throw error;
    }
  }

  async getReviews(target_type, target_id) {
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    const [rows] = await pool.query(
      `SELECT 
        r.review_id, 
        r.user_id, 
        r.content, 
        r.target_type, 
        r.target_id, 
        r.parent_review_id, 
        r.created_at,
        u.username,
        u.avatar_url,
        JSON_ARRAY() as images,
        '' as rating,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'REVIEW' AND target_id = r.review_id) as like_count,
        CASE 
          WHEN r.target_type = 'POST' THEN (
            SELECT p.title
            FROM posts p WHERE p.post_id = r.target_id
          )
          WHEN r.target_type = 'SHOP' THEN (
            SELECT s.shop_name
            FROM shops s WHERE s.shop_id = r.target_id
          )
          WHEN r.target_type = 'DISH' THEN (
            SELECT d.dish_name
            FROM special_dishes d WHERE d.dish_id = r.target_id
          )
          ELSE NULL
        END as target_name,
        CASE 
          WHEN r.parent_review_id IS NOT NULL THEN (
            SELECT JSON_OBJECT(
              'review_id', pr.review_id,
              'content', pr.content,
              'username', pu.username,
              'created_at', pr.created_at
            )
            FROM reviews pr 
            JOIN users pu ON pr.user_id = pu.user_id 
            WHERE pr.review_id = r.parent_review_id
          )
          ELSE NULL
        END as parent_review
      FROM reviews r 
      JOIN users u ON r.user_id = u.user_id 
      WHERE r.target_type = ? AND r.target_id = ? 
      ORDER BY r.created_at DESC`,
      [target_type, target_id]
    );
    
    // 格式化数据以匹配前端接口
    return rows.map(row => ({
      review_id: row.review_id.toString(),
      user_id: row.user_id.toString(),
      content: row.content,
      created_at: row.created_at,
      target_type: row.target_type,
      target_id: row.target_id.toString(),
      parent_review_id: row.parent_review_id ? row.parent_review_id.toString() : undefined,
      username: row.username,
      avatar_url: row.avatar_url,
      images: row.images || [],
      rating: row.rating || '',
      target_name: row.target_name || '',
      like_count: row.like_count,
      parent_review: row.parent_review
    }));
  }

  async getReviewsByUserId(userId) {
    const [rows] = await pool.query(
      `SELECT 
        r.review_id, 
        r.user_id, 
        r.content, 
        r.target_type, 
        r.target_id, 
        r.parent_review_id, 
        r.created_at,
        u.username,
        u.avatar_url,
        JSON_ARRAY() as images,
        '' as rating,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'REVIEW' AND target_id = r.review_id) as like_count,
        CASE 
          WHEN r.target_type = 'POST' THEN (
            SELECT p.title
            FROM posts p WHERE p.post_id = r.target_id
          )
          WHEN r.target_type = 'SHOP' THEN (
            SELECT s.shop_name
            FROM shops s WHERE s.shop_id = r.target_id
          )
          WHEN r.target_type = 'DISH' THEN (
            SELECT d.dish_name
            FROM special_dishes d WHERE d.dish_id = r.target_id
          )
          ELSE NULL
        END as target_name,
        CASE 
          WHEN r.target_type = 'POST' THEN (
            SELECT JSON_OBJECT(
              'post_id', p.post_id,
              'title', p.title,
              'content', LEFT(p.content, 100)
            )
            FROM posts p WHERE p.post_id = r.target_id
          )
          WHEN r.target_type = 'SHOP' THEN (
            SELECT JSON_OBJECT(
              'shop_id', s.shop_id,
              'shop_name', s.shop_name,
              'address', s.address
            )
            FROM shops s WHERE s.shop_id = r.target_id
          )
          WHEN r.target_type = 'DISH' THEN (
            SELECT JSON_OBJECT(
              'dish_id', d.dish_id,
              'dish_name', d.dish_name,
              'description', LEFT(d.description, 100)
            )
            FROM special_dishes d WHERE d.dish_id = r.target_id
          )
          ELSE NULL
        END as target_info,
        CASE 
          WHEN r.parent_review_id IS NOT NULL THEN (
            SELECT JSON_OBJECT(
              'review_id', pr.review_id,
              'content', pr.content,
              'username', pu.username,
              'created_at', pr.created_at
            )
            FROM reviews pr 
            JOIN users pu ON pr.user_id = pu.user_id 
            WHERE pr.review_id = r.parent_review_id
          )
          ELSE NULL
        END as parent_review
      FROM reviews r 
      JOIN users u ON r.user_id = u.user_id 
      WHERE r.user_id = ? 
      ORDER BY r.created_at DESC`,
      [userId]
    );
    
    // 格式化数据以匹配前端接口
    return rows.map(row => ({
      review_id: row.review_id.toString(),
      user_id: row.user_id.toString(),
      content: row.content,
      created_at: row.created_at,
      target_type: row.target_type,
      target_id: row.target_id.toString(),
      parent_review_id: row.parent_review_id ? row.parent_review_id.toString() : undefined,
      username: row.username,
      avatar_url: row.avatar_url,
      images: row.images || [],
      rating: row.rating || '',
      target_name: row.target_name || '',
      like_count: row.like_count,
      target_info: row.target_info,
      parent_review: row.parent_review
    }));
  }

  async getReview(reviewId) {
    const [rows] = await pool.query(
      `SELECT 
        r.review_id, 
        r.user_id, 
        r.content, 
        r.target_type, 
        r.target_id, 
        r.parent_review_id, 
        r.created_at,
        u.username,
        u.avatar_url,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'REVIEW' AND target_id = r.review_id) as like_count,
        CASE 
          WHEN r.target_type = 'POST' THEN (
            SELECT JSON_OBJECT(
              'post_id', p.post_id,
              'title', p.title,
              'content', p.content,
              'author', pu.username
            )
            FROM posts p 
            JOIN users pu ON p.user_id = pu.user_id
            WHERE p.post_id = r.target_id
          )
          WHEN r.target_type = 'SHOP' THEN (
            SELECT JSON_OBJECT(
              'shop_id', s.shop_id,
              'shop_name', s.shop_name,
              'address', s.address,
              'avg_price', s.avg_price,
              'business_hours', s.business_hours
            )
            FROM shops s WHERE s.shop_id = r.target_id
          )
          WHEN r.target_type = 'DISH' THEN (
            SELECT JSON_OBJECT(
              'dish_id', d.dish_id,
              'dish_name', d.dish_name,
              'description', d.description,
              'origin_region', d.origin_region
            )
            FROM special_dishes d WHERE d.dish_id = r.target_id
          )
          ELSE NULL
        END as target_info,
        CASE 
          WHEN r.parent_review_id IS NOT NULL THEN (
            SELECT JSON_OBJECT(
              'review_id', pr.review_id,
              'content', pr.content,
              'username', pu.username,
              'avatar_url', pu.avatar_url,
              'created_at', pr.created_at
            )
            FROM reviews pr 
            JOIN users pu ON pr.user_id = pu.user_id 
            WHERE pr.review_id = r.parent_review_id
          )
          ELSE NULL
        END as parent_review
      FROM reviews r 
      JOIN users u ON r.user_id = u.user_id 
      WHERE r.review_id = ?`,
      [reviewId]
    );
    if (!rows.length) throw new Error('Review not found');
    return rows[0];
  }

  async getReviewWithLikeStatus(reviewId, userId = null) {
    const [rows] = await pool.query(
      `SELECT 
        r.review_id, 
        r.user_id, 
        r.content, 
        r.target_type, 
        r.target_id, 
        r.parent_review_id, 
        r.created_at,
        u.username,
        u.avatar_url,
        (SELECT COUNT(*) FROM likes WHERE target_type = 'REVIEW' AND target_id = r.review_id) as like_count,
        ${userId ? `(SELECT COUNT(*) > 0 FROM likes WHERE target_type = 'REVIEW' AND target_id = r.review_id AND user_id = ?) as is_liked,` : '0 as is_liked,'}
        CASE 
          WHEN r.target_type = 'POST' THEN (
            SELECT JSON_OBJECT(
              'post_id', p.post_id,
              'title', p.title,
              'content', p.content,
              'author', pu.username
            )
            FROM posts p 
            JOIN users pu ON p.user_id = pu.user_id
            WHERE p.post_id = r.target_id
          )
          WHEN r.target_type = 'SHOP' THEN (
            SELECT JSON_OBJECT(
              'shop_id', s.shop_id,
              'shop_name', s.shop_name,
              'address', s.address,
              'avg_price', s.avg_price,
              'business_hours', s.business_hours
            )
            FROM shops s WHERE s.shop_id = r.target_id
          )
          WHEN r.target_type = 'DISH' THEN (
            SELECT JSON_OBJECT(
              'dish_id', d.dish_id,
              'dish_name', d.dish_name,
              'description', d.description,
              'origin_region', d.origin_region
            )
            FROM special_dishes d WHERE d.dish_id = r.target_id
          )
          ELSE NULL
        END as target_info,
        CASE 
          WHEN r.parent_review_id IS NOT NULL THEN (
            SELECT JSON_OBJECT(
              'review_id', pr.review_id,
              'content', pr.content,
              'username', pu.username,
              'avatar_url', pu.avatar_url,
              'created_at', pr.created_at
            )
            FROM reviews pr 
            JOIN users pu ON pr.user_id = pu.user_id 
            WHERE pr.review_id = r.parent_review_id
          )
          ELSE NULL
        END as parent_review
      FROM reviews r 
      JOIN users u ON r.user_id = u.user_id 
      WHERE r.review_id = ?`,
      userId ? [userId, reviewId] : [reviewId]
    );
    if (!rows.length) throw new Error('Review not found');
    return rows[0];
  }

  // 获取指定目标的评论数
  async getReviewCount(target_type, target_id) {
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    const [rows] = await pool.query(
      'SELECT COUNT(*) as review_count FROM reviews WHERE target_type = ? AND target_id = ?',
      [target_type, target_id]
    );
    return rows[0].review_count;
  }

  // 获取指定目标的评论统计信息
  async getReviewStats(target_type, target_id) {
    if (!['SHOP', 'POST', 'DISH'].includes(target_type)) throw new Error('Invalid target type');
    const [rows] = await pool.query(
      `SELECT 
        COUNT(*) as total_reviews,
        COUNT(CASE WHEN parent_review_id IS NULL THEN 1 END) as main_reviews,
        COUNT(CASE WHEN parent_review_id IS NOT NULL THEN 1 END) as reply_reviews,
        MIN(created_at) as first_review_time,
        MAX(created_at) as latest_review_time
      FROM reviews 
      WHERE target_type = ? AND target_id = ?`,
      [target_type, target_id]
    );
    
    return {
      target_type,
      target_id: parseInt(target_id),
      total_reviews: rows[0].total_reviews,
      main_reviews: rows[0].main_reviews,
      reply_reviews: rows[0].reply_reviews,
      first_review_time: rows[0].first_review_time,
      latest_review_time: rows[0].latest_review_time
    };
  }
}

module.exports = new ReviewService();