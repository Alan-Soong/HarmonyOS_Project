const userService = require('../services/userService');

class UserController {
  async createUser(ctx) {
    try {
      const { username, avatar_url } = ctx.request.body;
      const user = await userService.createUser({ username, avatar_url });
      ctx.body = { success: true, data: user };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUser(ctx) {
    try {
      const user = await userService.getUser(ctx.params.id);
      ctx.body = { success: true, data: user };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async updateUser(ctx) {
    try {
      const { username, avatar_url } = ctx.request.body;
      const user = await userService.updateUser(ctx.params.id, { username, avatar_url });
      ctx.body = { success: true, data: user };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new UserController();