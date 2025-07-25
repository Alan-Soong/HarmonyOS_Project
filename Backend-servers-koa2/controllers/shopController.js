const shopService = require('../services/shopService');
const reviewService = require('../services/reviewService');
const likeService = require('../services/likeService');

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

  async searchShops(ctx) {
    try {
      const { keyword, name, address } = ctx.query;
      let shops;
      
      if (keyword) {
        // 通用搜索：在店铺名称和地址中搜索关键字
        shops = await shopService.searchShops(keyword);
      } else if (name) {
        // 按店铺名称搜索
        shops = await shopService.searchShopsByName(name);
      } else if (address) {
        // 按地址搜索
        shops = await shopService.searchShopsByAddress(address);
      } else {
        // 如果没有提供搜索参数，返回所有店铺
        shops = await shopService.getShops();
      }
      
      ctx.body = { success: true, data: shops };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShopReviews(ctx) {
    try {
      const reviews = await reviewService.getReviews('SHOP', ctx.params.id);
      ctx.body = { success: true, data: reviews };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShopLikes(ctx) {
    try {
      const likes = await likeService.getLikes('SHOP', ctx.params.id);
      ctx.body = { success: true, data: likes };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async likeShop(ctx) {
    try {
      const { user_id } = ctx.request.body;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      const like = await likeService.createLike({
        user_id: user_id,
        target_type: 'SHOP',
        target_id: ctx.params.id
      });
      
      ctx.body = { success: true, data: like };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async unlikeShop(ctx) {
    try {
      const { user_id } = ctx.query;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      await likeService.deleteLike(user_id, 'SHOP', ctx.params.id);
      ctx.body = { success: true };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getShopReviewCount(ctx) {
    try {
      const shop_id = ctx.params.id;
      const count = await reviewService.getReviewCount('SHOP', shop_id);
      ctx.body = { 
        success: true, 
        data: { 
          shop_id: parseInt(shop_id), 
          review_count: count 
        } 
      };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new ShopController();