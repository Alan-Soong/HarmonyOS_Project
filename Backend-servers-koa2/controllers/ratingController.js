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

  // 获取用户对店铺的评分
  async getUserShopRating(ctx) {
    try {
      const { shop_id, user_id } = ctx.params;
      const rating = await ratingService.getUserShopRating(shop_id, user_id);
      ctx.body = { success: true, data: rating };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 获取用户对菜品的评分
  async getUserDishRating(ctx) {
    try {
      const { dish_id, user_id } = ctx.params;
      const rating = await ratingService.getUserDishRating(dish_id, user_id);
      ctx.body = { success: true, data: rating };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 更新店铺评分
  async updateShopRating(ctx) {
    try {
      const { shop_id, user_id } = ctx.params;
      const { rating } = ctx.request.body;
      const updatedRating = await ratingService.updateShopRating(shop_id, user_id, rating);
      ctx.body = { success: true, data: updatedRating, message: 'Rating updated successfully' };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 更新菜品评分
  async updateDishRating(ctx) {
    try {
      const { dish_id, user_id } = ctx.params;
      const { rating } = ctx.request.body;
      const updatedRating = await ratingService.updateDishRating(dish_id, user_id, rating);
      ctx.body = { success: true, data: updatedRating, message: 'Rating updated successfully' };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 删除店铺评分
  async deleteShopRating(ctx) {
    try {
      const { shop_id, user_id } = ctx.params;
      const result = await ratingService.deleteShopRating(shop_id, user_id);
      ctx.body = { success: true, data: result };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 删除菜品评分
  async deleteDishRating(ctx) {
    try {
      const { dish_id, user_id } = ctx.params;
      const result = await ratingService.deleteDishRating(dish_id, user_id);
      ctx.body = { success: true, data: result };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 获取店铺评分统计
  async getShopRatingStats(ctx) {
    try {
      const { shop_id } = ctx.params;
      const stats = await ratingService.getShopRatingStats(shop_id);
      ctx.body = { success: true, data: stats };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  // 获取菜品评分统计
  async getDishRatingStats(ctx) {
    try {
      const { dish_id } = ctx.params;
      const stats = await ratingService.getDishRatingStats(dish_id);
      ctx.body = { success: true, data: stats };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new RatingController();