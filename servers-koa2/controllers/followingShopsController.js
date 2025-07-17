const followingShopsService = require('../services/followingShopsService');

class FollowingShopsController {
  async followShop(ctx) {
    try {
      const followData = ctx.request.body;
      const follow = await followingShopsService.followShop(followData);
      ctx.body = { success: true, data: follow };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async unfollowShop(ctx) {
    try {
      const { user_id, shop_id } = ctx.params;
      await followingShopsService.unfollowShop(user_id, shop_id);
      ctx.body = { success: true, message: 'Unfollowed successfully' };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getFollowedShops(ctx) {
    try {
      const { user_id } = ctx.params;
      const shops = await followingShopsService.getFollowedShops(user_id);
      ctx.body = { success: true, data: shops };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new FollowingShopsController();