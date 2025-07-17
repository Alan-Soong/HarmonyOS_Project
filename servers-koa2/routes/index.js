// const router = require('koa-router')()

// router.get('/', async (ctx, next) => {
//   await ctx.render('index', {
//     title: 'Hello Koa 2!'
//   })
// })

// router.get('/string', async (ctx, next) => {
//   ctx.body = 'koa2 string'
// })

// router.get('/json', async (ctx, next) => {
//   ctx.body = {
//     title: 'koa2 json'
//   }
// })

// module.exports = router

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
router.get('/users/:id', UserController.getUser);
router.put('/users/:id', UserController.updateUser);

// Shops
router.post('/shops', ShopController.createShop);
router.get('/shops', ShopController.getShops);
router.get('/shops/:id', ShopController.getShop);

// Special_Dishes
router.post('/dishes', DishController.createDish);
router.get('/dishes', DishController.getDishes);
router.get('/dishes/:id', DishController.getDish);

// Posts
router.post('/posts', PostController.createPost);
router.get('/posts', PostController.getPosts);
router.get('/posts/:id', PostController.getPost);

// Reviews
router.post('/reviews', ReviewController.createReview);
router.get('/reviews', ReviewController.getReviews);

// Likes
router.post('/likes', LikeController.createLike);
router.delete('/likes/:user_id/:target_type/:target_id', LikeController.deleteLike);

// Ratings
router.post('/ratings/shops', RatingController.createShopRating);
router.post('/ratings/dishes', RatingController.createDishRating);
router.get('/ratings/shops/:shop_id', RatingController.getShopRatings);
router.get('/ratings/dishes/:dish_id', RatingController.getDishRatings);

// Messages
router.post('/messages', MessageController.createMessage);
router.get('/messages/receiver/:receiver_id', MessageController.getMessagesByReceiver);
router.put('/messages/:message_id/read', MessageController.markMessageAsRead);

// Following_Shops
router.post('/following/shops', FollowingShopsController.followShop);
router.delete('/following/shops/:user_id/:shop_id', FollowingShopsController.unfollowShop);
router.get('/following/shops/:user_id', FollowingShopsController.getFollowedShops);

module.exports = router;