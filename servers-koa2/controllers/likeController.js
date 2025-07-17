const likeService = require('../services/likeService');

class LikeController {
  async createLike(ctx) {
    try {
      const likeData = ctx.request.body;
      const like = await likeService.createLike(likeData);
      ctx.body = { success: true, data: like };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async deleteLike(ctx) {
    try {
      const { user_id, target_type, target_id } = ctx.params;
      await likeService.deleteLike(user_id, target_type, target_id);
      ctx.body = { success: true };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new LikeController();