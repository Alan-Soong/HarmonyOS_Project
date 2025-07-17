const shopService = require('../services/shopService');

class ShopController {
  async createShop(ctx) {
    try {
      const shopData = ctx.request.body;
      const shop = await shopService.createShop(shopData);
      ctx.body = { success: true, data: shop };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShops(ctx) {
    try {
      const shops = await shopService.getShops();
      ctx.body = { success: true, data: shops };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShop(ctx) {
    try {
      const shop = await shopService.getShop(ctx.params.id);
      ctx.body = { success: true, data: shop };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new ShopController();