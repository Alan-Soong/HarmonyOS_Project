const reviewService = require('../services/reviewService');

class ReviewController {
  async createReview(ctx) {
    try {
      const reviewData = ctx.request.body;
      const review = await reviewService.createReview(reviewData);
      ctx.body = { success: true, data: review };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getReviews(ctx) {
    try {
      const { target_type, target_id } = ctx.query;
      const reviews = await reviewService.getReviews(target_type, target_id);
      ctx.body = { success: true, data: reviews };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getReview(ctx) {
    try {
      const { user_id } = ctx.query; // 可选的用户ID参数
      let review;
      
      if (user_id) {
        // 如果提供了用户ID，获取带有点赞状态的评论
        review = await reviewService.getReviewWithLikeStatus(ctx.params.id, user_id);
      } else {
        // 否则获取普通评论信息
        review = await reviewService.getReview(ctx.params.id);
      }
      
      ctx.body = { success: true, data: review };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getReviewCount(ctx) {
    try {
      const { target_type, target_id } = ctx.query;
      if (!target_type || !target_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'target_type and target_id are required' };
        return;
      }
      const count = await reviewService.getReviewCount(target_type, target_id);
      ctx.body = { 
        success: true, 
        data: { 
          target_type, 
          target_id: parseInt(target_id), 
          review_count: count 
        } 
      };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getReviewStats(ctx) {
    try {
      const { target_type, target_id } = ctx.query;
      if (!target_type || !target_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'target_type and target_id are required' };
        return;
      }
      const stats = await reviewService.getReviewStats(target_type, target_id);
      ctx.body = { success: true, data: stats };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new ReviewController();