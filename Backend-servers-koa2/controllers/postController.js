const postService = require('../services/postService');
const reviewService = require('../services/reviewService');
const likeService = require('../services/likeService');

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
      const { user_id } = ctx.query; // 可选的用户ID参数
      let post;
      
      if (user_id) {
        // 如果提供了用户ID，获取带有点赞状态的帖子
        post = await postService.getPostWithLikeStatus(ctx.params.id, user_id);
      } else {
        // 否则获取普通帖子信息
        post = await postService.getPost(ctx.params.id);
      }
      
      ctx.body = { success: true, data: post };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPostsByUserId(ctx) {
    try {
      const posts = await postService.getPostsByUserId(ctx.params.id);
      ctx.body = { success: true, data: posts };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPostReviews(ctx) {
    try {
      const reviews = await reviewService.getReviews('POST', ctx.params.id);
      ctx.body = { success: true, data: reviews };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPostLikes(ctx) {
    try {
      const likes = await likeService.getLikes('POST', ctx.params.id);
      ctx.body = { success: true, data: likes };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async likePost(ctx) {
    try {
      const { user_id } = ctx.request.body;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      const like = await likeService.createLike({
        user_id: user_id,
        target_type: 'POST',
        target_id: ctx.params.id
      });
      
      ctx.body = { success: true, data: like };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async unlikePost(ctx) {
    try {
      const { user_id } = ctx.query;
      if (!user_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'user_id is required' };
        return;
      }
      
      await likeService.deleteLike(user_id, 'POST', ctx.params.id);
      ctx.body = { success: true };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getPostReviewCount(ctx) {
    try {
      const post_id = ctx.params.id;
      const count = await reviewService.getReviewCount('POST', post_id);
      ctx.body = { 
        success: true, 
        data: { 
          post_id: parseInt(post_id), 
          review_count: count 
        } 
      };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }
}

module.exports = new PostController();