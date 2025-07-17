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
}

module.exports = new ReviewController();