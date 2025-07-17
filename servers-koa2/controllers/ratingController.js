const ratingService = require('../services/ratingService');

class RatingController {
  async createShopRating(ctx) {
    try {
      const ratingData = ctx.request.body;
      const rating = await ratingService.createShopRating(ratingData);
      ctx.body = { success: true, data: rating };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async createDishRating(ctx) {
    try {
      const ratingData = ctx.request.body;
      const rating = await ratingService.createDishRating(ratingData);
      ctx.body = { success: true, data: rating };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShopRatings(ctx) {
    try {
      const { shop_id } = ctx.params;
      const ratings = await ratingService.getShopRatings(shop_id);
      ctx.body = { success: true, data: ratings };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDishRatings(ctx) {
    try {
      const { dish_id } = ctx.params;
      const ratings = await ratingService.getDishRatings(dish_id);
      ctx.body = { success: true, data: ratings };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new RatingController();