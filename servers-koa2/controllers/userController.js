const userService = require('../services/userService');
const postService = require('../services/postService');
const reviewService = require('../services/reviewService');

class UserController {
  async createUser(ctx) {
    try {
      const { username, password, avatar_url } = ctx.request.body;
      const user = await userService.createUser({ username, password, avatar_url });
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

  async getUsers(ctx) {
    try {
      const users = await userService.getUsers();
      ctx.body = { success: true, data: users };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async updateUser(ctx) {
    try {
      const { username, password, avatar_url } = ctx.request.body;
      const user = await userService.updateUser(ctx.params.id, { username, password, avatar_url });
      ctx.body = { success: true, data: user };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async loginUser(ctx) {
    try {
      const { username, password } = ctx.request.body;
      const user = await userService.loginUser(username, password);
      ctx.body = { success: true, data: user, message: 'Login successful' };
    } catch (error) {
      ctx.status = 401;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserPosts(ctx) {
    try {
      const posts = await postService.getPostsByUserId(ctx.params.id);
      ctx.body = { success: true, data: posts };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserReviews(ctx) {
    try {
      const reviews = await reviewService.getReviewsByUserId(ctx.params.id);
      ctx.body = { success: true, data: reviews };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserProfile(ctx) {
    try {
      const userProfile = await userService.getUserProfile(ctx.params.id);
      ctx.body = { success: true, data: userProfile };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserLikedPosts(ctx) {
    try {
      const userId = ctx.params.id;
      const likedPosts = await userService.getUserLikedPosts(userId);
      ctx.body = { success: true, data: likedPosts };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserStats(ctx) {
    try {
      const userId = ctx.params.id;
      const stats = await userService.getUserStats(userId);
      ctx.body = { success: true, data: stats };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async searchUsers(ctx) {
    try {
      const { username } = ctx.query;
      if (!username) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'Username parameter is required' };
        return;
      }
      const users = await userService.searchUsersByUsername(username);
      ctx.body = { success: true, data: users };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getUserByUsername(ctx) {
    try {
      const { username } = ctx.params;
      const user = await userService.getUserByUsername(username);
      ctx.body = { success: true, data: user };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new UserController();