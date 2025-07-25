const dishService = require('../services/dishService');
const reviewService = require('../services/reviewService');
const likeService = require('../services/likeService');

class DishController {
  async createDish(ctx) {
    try {
      const dishData = ctx.request.body;
      const dish = await dishService.createDish(dishData);
      ctx.body = { success: true, data: dish };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDishes(ctx) {
    try {
      const dishes = await dishService.getDishes();
      ctx.body = { success: true, data: dishes };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDish(ctx) {
    try {
      const dish = await dishService.getDish(ctx.params.id);
      ctx.body = { success: true, data: dish };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDishReviews(ctx) {
    try {
      const reviews = await reviewService.getReviews('DISH', ctx.params.id);
      ctx.body = { success: true, data: reviews };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDishLikes(ctx) {
    try {
      const likes = await likeService.getLikes('DISH', ctx.params.id);
      ctx.body = { success: true, data: likes };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async likeDish(ctx) {
    try {
      const { user_id } = ctx.request.body;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      const like = await likeService.createLike({
        user_id: user_id,
        target_type: 'DISH',
        target_id: ctx.params.id
      });
      
      ctx.body = { success: true, data: like };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async unlikeDish(ctx) {
    try {
      const { user_id } = ctx.query;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      await likeService.deleteLike(user_id, 'DISH', ctx.params.id);
      ctx.body = { success: true };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getDishReviewCount(ctx) {
    try {
      const dish_id = ctx.params.id;
      const count = await reviewService.getReviewCount('DISH', dish_id);
      ctx.body = { 
        success: true, 
        data: { 
          dish_id: parseInt(dish_id), 
          review_count: count 
        } 
      };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new DishController();