const postService = require('../services/postService');

class PostController {
  async createPost(ctx) {
    try {
      const postData = ctx.request.body;
      const post = await postService.createPost(postData);
      ctx.body = { success: true, data: post };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPosts(ctx) {
    try {
      const posts = await postService.getPosts();
      ctx.body = { success: true, data: posts };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPost(ctx) {
    try {
      const post = await postService.getPost(ctx.params.id);
      ctx.body = { success: true, data: post };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new PostController();