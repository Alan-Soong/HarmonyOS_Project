const dishService = require('../services/dishService');

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
}

module.exports = new DishController();