const Router = require('koa-router');
const UserController = require('../controllers/userController');
const ShopController = require('../controllers/shopController');
const DishController = require('../controllers/dishController');
const PostController = require('../controllers/postController');
const ReviewController = require('../controllers/reviewController');
const LikeController = require('../controllers/likeController');
const RatingController = require('../controllers/ratingController');
const MessageController = require('../controllers/messageController');
const FollowingShopsController = require('../controllers/followingShopsController');

const router = new Router({ prefix: '/api' });

// Users
router.post('/users', UserController.createUser);
router.post('/users/login', UserController.loginUser);
router.get('/users', UserController.getUsers);
router.get('/users/search', UserController.searchUsers);
router.get('/users/username/:username', UserController.getUserByUsername);
router.get('/users/:id', UserController.getUser);
router.get('/users/:id/profile', UserController.getUserProfile);
router.get('/users/:id/posts', UserController.getUserPosts);
router.get('/users/:id/reviews', UserController.getUserReviews);
router.get('/users/:id/liked-posts', UserController.getUserLikedPosts);
router.get('/users/:id/stats', UserController.getUserStats);
router.put('/users/:id', UserController.updateUser);

// Shops
router.post('/shops', ShopController.createShop);
router.get('/shops', ShopController.getShops);
router.get('/shops/search', ShopController.searchShops);
router.get('/shops/:id', ShopController.getShop);
router.get('/shops/:id/reviews', ShopController.getShopReviews);
router.get('/shops/:id/reviews/count', ShopController.getShopReviewCount);
router.get('/shops/:id/likes', ShopController.getShopLikes);
router.post('/shops/:id/likes', ShopController.likeShop);
router.delete('/shops/:id/likes', ShopController.unlikeShop);

// Special_Dishes
router.post('/dishes', DishController.createDish);
router.get('/dishes', DishController.getDishes);
router.get('/dishes/:id', DishController.getDish);
router.get('/dishes/:id/reviews', DishController.getDishReviews);
router.get('/dishes/:id/reviews/count', DishController.getDishReviewCount);
router.get('/dishes/:id/likes', DishController.getDishLikes);
router.post('/dishes/:id/likes', DishController.likeDish);
router.delete('/dishes/:id/likes', DishController.unlikeDish);

// Posts
router.post('/posts', PostController.createPost);
router.get('/posts', PostController.getPosts);
router.get('/posts/:id', PostController.getPost);
router.get('/posts/:id/reviews', PostController.getPostReviews);
router.get('/posts/:id/reviews/count', PostController.getPostReviewCount);
router.get('/posts/:id/likes', PostController.getPostLikes);
router.post('/posts/:id/likes', PostController.likePost);
router.delete('/posts/:id/likes', PostController.unlikePost);

// Reviews
router.post('/reviews', ReviewController.createReview);
router.get('/reviews/count/target', ReviewController.getReviewCount);
router.get('/reviews/stats/target', ReviewController.getReviewStats);
router.get('/reviews', ReviewController.getReviews);
router.get('/reviews/:id', ReviewController.getReview);

// Likes
router.post('/likes', LikeController.createLike);
router.delete('/likes/:user_id/:target_type/:target_id', LikeController.deleteLike);
router.get('/likes/count/:target_type/:target_id', LikeController.getLikeCount);
router.get('/likes/:target_type/:target_id', LikeController.getLikes);
router.get('/likes/status/:user_id/:target_type/:target_id', LikeController.getLikeStatus);

// Ratings
router.post('/ratings/shops', RatingController.createShopRating);
router.post('/ratings/dishes', RatingController.createDishRating);
router.get('/ratings/shops/:shop_id', RatingController.getShopRatings);
router.get('/ratings/dishes/:dish_id', RatingController.getDishRatings);
router.get('/ratings/shops/:shop_id/users/:user_id', RatingController.getUserShopRating);
router.get('/ratings/dishes/:dish_id/users/:user_id', RatingController.getUserDishRating);
router.put('/ratings/shops/:shop_id/users/:user_id', RatingController.updateShopRating);
router.put('/ratings/dishes/:dish_id/users/:user_id', RatingController.updateDishRating);
router.delete('/ratings/shops/:shop_id/users/:user_id', RatingController.deleteShopRating);
router.delete('/ratings/dishes/:dish_id/users/:user_id', RatingController.deleteDishRating);
router.get('/ratings/shops/:shop_id/stats', RatingController.getShopRatingStats);
router.get('/ratings/dishes/:dish_id/stats', RatingController.getDishRatingStats);

// Messages
router.post('/messages', MessageController.createMessage);
router.get('/messages/receiver/:receiver_id', MessageController.getMessagesByReceiver);
router.put('/messages/:message_id/read', MessageController.markMessageAsRead);
router.get('/messages', MessageController.getMessages);
router.get('/messages/sender/:sender_id', MessageController.getMessagesBySender);
router.get('/messages/chat/:user1_id/:user2_id', MessageController.getChatMessages);


// Following_Shops
router.post('/following/shops', FollowingShopsController.followShop);
router.delete('/following/shops/:user_id/:shop_id', FollowingShopsController.unfollowShop);
router.get('/following/shops/:user_id', FollowingShopsController.getFollowedShops);

module.exports = router;