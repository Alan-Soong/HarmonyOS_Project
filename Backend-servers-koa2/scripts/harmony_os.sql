/*
Navicat MySQL Data Transfer

Source Server         : DataBaseHomeWork
Source Server Version : 80019
Source Host           : localhost:3306
Source Database       : harmony_os

Target Server Type    : MYSQL
Target Server Version : 80019
File Encoding         : 65001

Date: 2025-07-25 10:50:19
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `dish_ratings`
-- ----------------------------
DROP TABLE IF EXISTS `dish_ratings`;
CREATE TABLE `dish_ratings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `dish_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `unique_dish_rating` (`dish_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_dish_ratings` (`dish_id`),
  CONSTRAINT `dish_ratings_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `special_dishes` (`dish_id`) ON DELETE CASCADE,
  CONSTRAINT `dish_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `dish_ratings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dish rating system';

-- ----------------------------
-- Records of dish_ratings
-- ----------------------------

-- ----------------------------
-- Table structure for `following_shops`
-- ----------------------------
DROP TABLE IF EXISTS `following_shops`;
CREATE TABLE `following_shops` (
  `follow_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT 'Follower user ID',
  `shop_id` int NOT NULL COMMENT 'Followed shop ID',
  `followed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of follow action',
  PRIMARY KEY (`follow_id`),
  UNIQUE KEY `unique_follow` (`user_id`,`shop_id`) COMMENT 'Prevent duplicate follows',
  KEY `idx_following_user` (`user_id`),
  KEY `idx_following_shop` (`shop_id`),
  CONSTRAINT `following_shops_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `following_shops_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`shop_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Shop following relationships';

-- ----------------------------
-- Records of following_shops
-- ----------------------------
INSERT INTO `following_shops` VALUES ('36', '1', '2', '2025-07-24 20:47:07');
INSERT INTO `following_shops` VALUES ('38', '1', '3', '2025-07-25 02:06:26');
INSERT INTO `following_shops` VALUES ('39', '1', '7', '2025-07-25 04:41:03');

-- ----------------------------
-- Table structure for `likes`
-- ----------------------------
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `like_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `target_type` enum('POST','REVIEW','DISH') NOT NULL COMMENT 'Type of liked entity',
  `target_id` int NOT NULL COMMENT 'ID of the liked entity',
  `liked_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`like_id`),
  UNIQUE KEY `unique_like` (`user_id`,`target_type`,`target_id`),
  KEY `idx_likes_target` (`target_type`,`target_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Unified liking system';

-- ----------------------------
-- Records of likes
-- ----------------------------
INSERT INTO `likes` VALUES ('1', '1', 'REVIEW', '2', '2025-07-23 01:59:46');
INSERT INTO `likes` VALUES ('3', '2', 'POST', '1', '2025-07-24 02:09:06');
INSERT INTO `likes` VALUES ('4', '1', 'POST', '1', '2025-07-24 13:55:31');
INSERT INTO `likes` VALUES ('7', '3', 'POST', '1', '2025-07-24 15:09:28');
INSERT INTO `likes` VALUES ('17', '1', 'POST', '6', '2025-07-25 04:40:31');
INSERT INTO `likes` VALUES ('18', '1', 'POST', '10', '2025-07-25 09:13:04');
INSERT INTO `likes` VALUES ('19', '9', 'REVIEW', '6', '2025-07-25 09:43:23');
INSERT INTO `likes` VALUES ('20', '1', 'POST', '4', '2025-07-25 09:34:33');
INSERT INTO `likes` VALUES ('22', '4', 'REVIEW', '9', '2025-07-03 09:43:29');
INSERT INTO `likes` VALUES ('23', '3', 'REVIEW', '1', '2025-07-02 09:43:41');
INSERT INTO `likes` VALUES ('24', '7', 'REVIEW', '3', '2025-07-05 09:43:47');
INSERT INTO `likes` VALUES ('25', '1', 'REVIEW', '3', '2025-06-04 09:43:52');
INSERT INTO `likes` VALUES ('26', '1', 'REVIEW', '7', '2025-07-08 09:43:59');
INSERT INTO `likes` VALUES ('27', '4', 'REVIEW', '5', '2025-07-02 09:46:49');
INSERT INTO `likes` VALUES ('28', '1', 'REVIEW', '4', '2025-07-25 09:46:55');
INSERT INTO `likes` VALUES ('29', '7', 'REVIEW', '23', '2025-07-25 09:47:02');
INSERT INTO `likes` VALUES ('30', '5', 'REVIEW', '11', '2025-07-25 09:47:07');
INSERT INTO `likes` VALUES ('31', '9', 'REVIEW', '8', '2025-06-20 09:47:10');
INSERT INTO `likes` VALUES ('32', '3', 'REVIEW', '7', '2025-06-02 09:47:16');
INSERT INTO `likes` VALUES ('33', '1', 'REVIEW', '5', '2025-05-14 09:47:21');
INSERT INTO `likes` VALUES ('34', '5', 'REVIEW', '8', '2025-07-14 09:47:29');
INSERT INTO `likes` VALUES ('35', '6', 'REVIEW', '10', '2025-07-06 09:47:35');
INSERT INTO `likes` VALUES ('38', '5', 'REVIEW', '9', '2025-07-02 09:47:40');
INSERT INTO `likes` VALUES ('39', '2', 'REVIEW', '9', '2025-06-17 09:47:46');
INSERT INTO `likes` VALUES ('40', '8', 'POST', '5', '2025-05-06 09:50:20');
INSERT INTO `likes` VALUES ('41', '8', 'POST', '7', '2025-05-12 09:50:31');
INSERT INTO `likes` VALUES ('42', '3', 'POST', '4', '2025-06-02 09:50:38');
INSERT INTO `likes` VALUES ('43', '8', 'POST', '3', '2025-07-07 09:50:48');
INSERT INTO `likes` VALUES ('44', '6', 'POST', '9', '2025-07-14 09:51:00');
INSERT INTO `likes` VALUES ('45', '5', 'POST', '10', '2025-07-01 09:51:05');
INSERT INTO `likes` VALUES ('46', '7', 'POST', '10', '2025-06-02 09:51:15');
INSERT INTO `likes` VALUES ('47', '9', 'POST', '7', '2025-07-13 09:51:23');
INSERT INTO `likes` VALUES ('48', '8', 'POST', '2', '2025-07-01 09:51:28');
INSERT INTO `likes` VALUES ('49', '3', 'POST', '7', '2025-07-07 09:51:33');

-- ----------------------------
-- Table structure for `messages`
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL COMMENT 'Sender user ID',
  `receiver_id` int NOT NULL COMMENT 'Recipient user ID',
  `content` text NOT NULL COMMENT 'Message content',
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of sending',
  `is_read` tinyint(1) DEFAULT '0' COMMENT 'Read status flag',
  PRIMARY KEY (`message_id`),
  KEY `idx_messages_sender` (`sender_id`),
  KEY `idx_messages_receiver` (`receiver_id`),
  KEY `idx_messages_sent` (`sent_at`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Private messaging system';

-- ----------------------------
-- Records of messages
-- ----------------------------
INSERT INTO `messages` VALUES ('1', '2', '1', '你好你好你好', '2025-07-22 09:52:00', '0');
INSERT INTO `messages` VALUES ('2', '1', '2', '今天天气真不错！你要和我一起出去吃饭吗', '2025-07-19 18:33:25', '0');
INSERT INTO `messages` VALUES ('3', '1', '2', '1111快来', '2025-07-20 09:45:15', '0');
INSERT INTO `messages` VALUES ('4', '1', '2', '六百六十六', '2025-07-21 08:37:24', '0');
INSERT INTO `messages` VALUES ('5', '1', '2', '4', '2025-07-21 08:42:27', '0');
INSERT INTO `messages` VALUES ('6', '2', '1', '99999999999999', '2025-07-22 10:22:25', '0');
INSERT INTO `messages` VALUES ('7', '1', '2', '你好啊', '2025-07-22 11:07:40', '0');
INSERT INTO `messages` VALUES ('9', '1', '8', '「【限时特惠】亲爱的会员，您收藏的「海底捞（XX店）」推出工作日午市6.8折套餐，点击立即预约>>」', '2025-07-23 16:26:01', '0');
INSERT INTO `messages` VALUES ('10', '1', '7', '姐妹！发现公司楼下新开了家重庆火锅，老板是重庆人，要组队去测评吗？周六中午！', '2025-07-24 20:58:17', '0');
INSERT INTO `messages` VALUES ('13', '6', '1', '冲！我刚看了菜单，鲜毛肚+耙鸡爪是招牌，约11点避开排队？', '2025-07-24 09:31:50', '0');
INSERT INTO `messages` VALUES ('14', '5', '1', '你上周推荐的『星洲小馆』海南鸡饭选葱油还是辣椒酱啊？', '2025-07-24 11:07:20', '0');
INSERT INTO `messages` VALUES ('15', '1', '3', '后厨被拍到用虹鳟冒充三文鱼（附截图），人均200还玩套路不能忍！', '2025-07-24 15:10:05', '0');
INSERT INTO `messages` VALUES ('16', '1', '4', '带我一个！要海盐焦糖千层，你在静安寺地铁站交易？', '2025-07-24 20:05:43', '0');
INSERT INTO `messages` VALUES ('17', '1', '5', '葱油', '2025-07-24 20:13:04', '0');
INSERT INTO `messages` VALUES ('18', '1', '6', '好', '2025-07-24 20:17:53', '0');
INSERT INTO `messages` VALUES ('19', '7', '1', '什么事啊', '2025-07-24 18:34:57', '0');
INSERT INTO `messages` VALUES ('20', '2', '1', '要吃饭吗', '2025-07-25 03:18:54', '0');
INSERT INTO `messages` VALUES ('21', '4', '1', '你要吃什么', '2025-07-04 04:37:48', '0');
INSERT INTO `messages` VALUES ('22', '8', '1', '来不来吃饭', '2025-07-25 04:39:09', '0');
INSERT INTO `messages` VALUES ('23', '8', '1', '海参鲍鱼大闸蟹', '2025-07-25 04:39:48', '0');

-- ----------------------------
-- Table structure for `posts`
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `visibility` enum('PUBLIC','PRIVATE','FRIENDS_ONLY') DEFAULT 'PUBLIC',
  `images` json DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'insert photos',
  PRIMARY KEY (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User-generated posts table';

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO `posts` VALUES ('1', '1', '意大利菜', '大众点评网这家意大利餐厅简直是我的心头好！手工制作的宽面嚼劲十足，搭配慢炖8小时的博洛尼亚肉酱，每一根面条都裹满了浓郁酱汁。\n提拉米苏是现场制作的，马斯卡彭奶酪和咖啡酒的比例恰到好处，顶层的可可粉带着微苦的平衡。\n服务生对酒单了如指掌，推荐的巴罗洛红酒单宁柔顺，完美衬托了牛排的油脂香。唯一遗憾的是餐前面包不够热，但店家主动补送了新鲜烤制的佛卡夏表示歉意，细节满分！', '2025-07-24 16:58:36', '2025-07-24 19:06:41', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('2', '2', '法餐', '作为法餐爱好者必须给这家店五星！\n油封鸭腿表皮酥脆得像玻璃纸，切开后肉质却柔嫩多汁，底部铺着的橙子酱化解了油腻感。最惊艳的是焦糖布丁，表面脆糖片厚度均匀，敲开时清脆声悦耳，内馅冰凉丝滑如同丝绸。\n侍酒师专业度惊人，仅凭我们点的海鲜拼盘就搭配出矿物质感十足的白葡萄酒。环境优雅安静，桌间距足够大，非常适合纪念日用餐。洗手间的细节尤其到位，连护手霜都是帕尔玛之水的！', '2025-07-08 16:58:41', '2025-07-24 19:06:15', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('3', '3', '川菜', '成都老饕强推的川菜馆果然名不虚传！\n水煮鱼的辣椒都是从四川空运的青花椒，麻味层次分明但不刺激喉咙。惊喜发现居然有手工醪糟冰粉，气泡绵密得像云朵，配上现熬的红糖和酒酿，解辣神器非他莫属。\n老板说毛血旺用了新鲜鸭血而非代用品，确实弹嫩无腥气。服务贴心到会主动询问辣度接受范围，看到我们出汗立即送来冰镇酸梅汤。唯一的缺点是停车位紧张，建议提前预约代客泊车服务！', '2025-07-02 16:58:47', '2025-07-24 19:06:45', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('4', '4', '日式料理', '隐藏在巷弄里的日式烧鸟专门店太惊艳！\n所有串烧都用备长炭烤制，鸡生蚝外焦里嫩还带着炭火香。明太子山药烧绝妙，山药的脆与明太子的咸鲜在口中交织。清酒选择多达四十种，温酒器保持60度恒温这点很专业。板前师傅会展示当天空运的鲜鱼，金枪鱼大腹的雪花纹理美得像艺术品。\n座位下方设计了收纳篮放包包，和服服务员跪式点餐也不会让人觉得局促。离开时主厨还赠送了自酿梅酒小样，诚意满满！', '2025-06-11 22:58:53', '2025-07-24 19:06:58', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('5', '5', '法式餐点', '法式甜品店的三层下午茶物超所值！\n最下层咸点里的烟熏三文鱼挞惊艳，挞皮酥松到入口即化。中间层的开心果泡芙香气浓郁，还能咬到研磨的果仁颗粒。顶层的芒果椰子慕斯做出仿真水果造型，百香果夹心酸度平衡得刚好。\n茶具选用的是Wedgwood骨瓷，伯爵茶回甘悠长。服务生详细介绍每道甜点的灵感来源，知道我们要拍照还主动调整摆盘方向。建议坐在玻璃花房位置，午后光影特别适合出片！', '2025-07-12 12:02:01', '2025-07-24 19:06:30', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('6', '6', '本帮菜', '米其林推荐的本帮菜果然地道！\n红烧肉用陶罐慢煨三小时，肥肉晶莹似琥珀，瘦肉酥而不柴，搭配的茨饭团吸饱了酱汁。蟹粉豆腐的蟹膏分量惊人，每勺都能舀到大块蟹腿肉。最意外的是熏鱼居然用鲳鱼制作，比常见的青鱼更细嫩。服务员提醒我们用荠菜肉丝炒年糕配着吃解腻，确实妙招。\n环境复刻了石库门风格，留声机放着周璇的老上海金曲，连餐后水果都切成了玫瑰造型！', '2025-07-23 16:59:20', '2025-07-24 19:06:53', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('7', '7', '露天餐厅', '海滨露台餐厅的夕阳晚餐太浪漫！\n生蚝拼盘囊括六国品种，爱尔兰的蚝带着坚果尾韵，配上自调的红酒醋洋葱碎绝了。主菜的龙虾意面用了整只波士顿龙虾，虾脑熬制的酱汁鲜浓到舔盘。调酒师特制的海风玛格丽特，杯沿用柠檬汁和烟熏盐做了霜冻效果。\n九点时服务生悄悄为邻桌庆生的客人播放交响乐版生日歌，所有食客都自发鼓掌，这种温情体验远超食物本身价值！', '2025-05-13 16:59:28', '2025-07-24 19:06:35', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('8', '8', '素食餐厅', '素食餐厅颠覆了我的认知！\n\"惠灵顿牛排\"用杏鲍菇模仿牛肉肌理，酥皮裹着波特菇和菠菜馅，淋黑松露酱后真有吃肉的口感。分子料理的芒果鱼子酱在口中爆开时，酸味激活了整个味蕾。最绝的是豆腐芝士蛋糕，绵密度不输真芝士，饼底用椰枣和坚果制成。\n开放式厨房能看到厨师现场制作豆腐，豆香弥漫整个餐厅。离店时赠送的手作燕麦饼干，装在可降解种子纸袋里，环保理念贯穿始终！', '2024-06-27 14:59:39', '2025-07-24 19:07:03', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('9', '4', '土耳其烤肉', '土耳其老板亲自烤的果木烤肉绝了！\n旋转烤肉柱足有一人高，削下的肉片边缘焦脆中间粉嫩。招牌的皮塔饼裹着烤肉、酸奶酱和烤茄子泥，搭配的辣椒油是用五种干椒调制。隐藏菜单的羊奶酪冰淇淋，咸甜交织的滋味让人上头。水烟区有二十种口味可选，苹果木薄荷味最清爽。\n晚九点有肚皮舞表演，舞者会邀请食客互动。老板说每周四有鹰嘴豆泥制作课，已预约下期体验！', '2025-07-01 16:59:49', '2025-07-24 19:06:50', 'PUBLIC', null);
INSERT INTO `posts` VALUES ('10', '5', '有机餐厅', '农场直供的有机餐厅吃得安心！\n沙拉里的蔬菜还带着晨露，可溯源到具体大棚。散养鸡做的椰子鸡锅，汤底清甜得不需要蘸料。现磨的豆浆火锅新颖，自制嫩豆腐三分钟就凝固。儿童餐区设计用心，有迷你厨房供孩子做蔬菜印章画。\n离店时能购买当日食材，买了刚摘的草莓香气扑鼻。服务员在介绍时会展示iPad里的农场实时监控，看到我们的食物从土地到餐桌的全过程很治愈！', '2025-07-14 16:59:54', '2025-07-24 19:07:02', 'PUBLIC', null);

-- ----------------------------
-- Table structure for `reviews`
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `target_type` enum('SHOP','POST','DISH') NOT NULL COMMENT 'Type of entity being reviewed',
  `target_id` int NOT NULL COMMENT 'ID of the reviewed entity',
  `parent_review_id` int DEFAULT NULL COMMENT 'Parent review ID for reply threads',
  `images` json DEFAULT NULL COMMENT 'Review images in JSON format',
  PRIMARY KEY (`review_id`),
  KEY `user_id` (`user_id`),
  KEY `parent_review_id` (`parent_review_id`),
  KEY `idx_reviews_target` (`target_type`,`target_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`parent_review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Review system with reply support';

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES ('1', '1', '打算', '2025-07-20 00:37:35', 'POST', '2', null);
INSERT INTO `reviews` VALUES ('2', '1', '好吃啊好吃', '2025-07-22 01:18:20', 'SHOP', '3', null);
INSERT INTO `reviews` VALUES ('3', '1', '我想吃烤鸭了', '2025-07-23 16:50:31', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('4', '2', 'Great food and service!', '2025-07-23 16:50:42', 'DISH', '1', null);
INSERT INTO `reviews` VALUES ('5', '1', 'This is a reply to the previous comment', '2025-07-23 16:50:53', 'SHOP', '1', '3');
INSERT INTO `reviews` VALUES ('6', '1', '哈哈哈哈', '2025-07-23 17:00:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('7', '2', '喜欢吃好吃的', '2025-07-23 17:00:16', 'SHOP', '1', '6');
INSERT INTO `reviews` VALUES ('8', '3', 'Thanks for the recommendation! Will definitely try it.', '2025-07-23 17:00:27', 'SHOP', '1', '6');
INSERT INTO `reviews` VALUES ('9', '1', '111', '2025-07-23 17:22:27', 'SHOP', '20', null);
INSERT INTO `reviews` VALUES ('10', '1', '222', '2025-07-23 17:24:22', 'SHOP', '20', '9');
INSERT INTO `reviews` VALUES ('11', '1', 'let us eat!', '2025-07-23 23:24:28', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('12', '1', '123456', '2025-07-24 00:40:06', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('13', '2', 'Great post! Thanks for sharing.', '2025-07-24 00:40:15', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('14', '3', 'I have a question about this topic...', '2025-07-24 00:40:24', 'POST', '1', '12');
INSERT INTO `reviews` VALUES ('15', '1', '123', '2025-07-24 01:18:39', 'POST', '10', null);
INSERT INTO `reviews` VALUES ('16', '1', 'Testing current time', '2025-07-24 01:31:19', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('17', '2', 'Another test for time verification', '2025-07-24 01:32:14', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('18', '1', 'Time test verification', '2025-07-24 01:36:11', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('19', '2', 'Fixed time test', '2025-07-24 01:37:18', 'POST', '1', null);
INSERT INTO `reviews` VALUES ('20', '1', '456', '2025-07-24 01:52:19', 'POST', '10', '15');
INSERT INTO `reviews` VALUES ('21', '1', '刚出锅的包子热气腾腾，咬开瞬间汁水四溢，肉馅鲜嫩，面皮松软，不愧是百年老字号', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('22', '2', '招牌猪肉包馅料足，肥瘦比例恰到好处，一口下去满是满足，连吃三个都不过瘾', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('23', '3', '包子个头饱满，褶子均匀，看着就很有食欲，味道更是一绝，让人回味无穷', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('24', '4', '老字号的味道就是不一样，面皮有嚼劲，内馅鲜香，吃一次就忘不了', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('25', '5', '汤汁浓郁醇厚，肉馅紧实，搭配醋和姜丝，味道层次更丰富，太美味啦', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('26', '6', '来天津必吃的狗不理包子，果然名不虚传，每一口都是满满的幸福感', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('27', '7', '包子皮薄馅大，咬开后汤汁在嘴里爆开，鲜香的味道瞬间充满口腔', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('28', '3', '这里的包子用料实在，肉质新鲜，味道正宗，是能让人记住的美味', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('29', '4', '每次来天津都要打卡的店，包子的味道始终如一，经典又好吃', '2025-07-24 16:34:05', 'SHOP', '1', null);
INSERT INTO `reviews` VALUES ('30', '8', '蒸饺也很不错，和包子一样美味，推荐大家来尝尝，绝对不会失望', '2025-07-24 16:34:05', 'SHOP', '1', null);

-- ----------------------------
-- Table structure for `shops`
-- ----------------------------
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops` (
  `shop_id` int NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(100) NOT NULL,
  `address` varchar(200) NOT NULL,
  `latitude` decimal(20,8) NOT NULL COMMENT 'Geographical latitude',
  `longitude` decimal(20,8) NOT NULL COMMENT 'Geographical longitude',
  `business_hours` varchar(50) DEFAULT NULL COMMENT 'Operating hours',
  `avg_price` int DEFAULT NULL COMMENT 'Average price per person (in cents)',
  `discount_info` text COMMENT 'Discount information',
  `contact_phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `follower_count` int DEFAULT '0' COMMENT 'Cached follower count',
  `image_url` varchar(255) DEFAULT NULL COMMENT 'URL or path to shop image',
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Restaurant information table';

-- ----------------------------
-- Records of shops
-- ----------------------------
INSERT INTO `shops` VALUES ('1', '狗不理包子(山东路总店)', '和平区山东路77号', '39.12653000', '117.19875000', '06:30-20:30', '120', '套餐9折', '022-27302540', '2025-07-23 22:16:56', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/%E7%8B%97%E4%B8%8D%E7%90%86.png');
INSERT INTO `shops` VALUES ('2', '桂园餐厅', '和平区成都道101号', '39.11584000', '117.20156000', '11:00-14:00,17:00-21:30', '85', '满200减30', '022-23321999', '2025-07-21 16:59:15', '1', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂园餐厅.png');
INSERT INTO `shops` VALUES ('3', '肯德基', '津南区咸水沽镇吾悦广场1楼', '35.00000000', '35.00000000', '6:00-22:00', '30', null, '66666666', '2025-07-21 17:00:56', '1', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/KFC.png');
INSERT INTO `shops` VALUES ('7', '耳朵眼会馆', '南开区鼓楼东街8号', '39.14062000', '117.18123000', '11:00-21:00', '180', 'NULL', '022-27270123', '2025-07-23 22:25:59', '1', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼会馆.png');
INSERT INTO `shops` VALUES ('10', '津菜典藏', '河西区友谊路32号', '39.08731000', '117.21245000', '10:30-22:00', '150', '午市8.8折', '022-88328888', '2025-07-23 22:33:26', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏.png');
INSERT INTO `shops` VALUES ('11', '红旗饭庄', '河东区津塘路83号', '39.13015000', '117.25137000', '10:00-22:00', '95', 'NULL', '022-24311518', '2025-07-23 22:33:30', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/红旗饭庄.png');
INSERT INTO `shops` VALUES ('12', '大铁勺酒楼', '西青区迎水道138号', '39.09876000', '117.15234000', '11:00-14:30,17:00-21:30', '80', '会员9折', '022-23679999', '2025-07-23 22:33:34', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大铁勺酒楼.png');
INSERT INTO `shops` VALUES ('13', '昱德来酒楼', '和平区昆明路78号', '39.12047000', '117.19562000', '10:30-22:00', '75', '满100送菜', '022-27816888', '2025-07-23 22:33:37', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/昱德来酒楼.png');
INSERT INTO `shops` VALUES ('14', '陈傻子餐厅', '南开区南丰路16号', '39.12788000', '117.17015000', '09:30-21:30', '65', '包子买5送1', '022-27459888', '2025-07-23 22:33:43', '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/陈傻子餐厅.png');
INSERT INTO `shops` VALUES ('15', '百饺园', '和平区新华路241号', '39.12412000', '117.20781000', '10:00-22:00', '90', '饺子第二份半价', '022-27123333', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/百饺园.png');
INSERT INTO `shops` VALUES ('16', '宴宾楼', '和平区辽宁路135号', '39.13256000', '117.20042000', '11:00-22:00', '130', 'NULL', '022-27306668', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宴宾楼.png');
INSERT INTO `shops` VALUES ('17', '小宝栗子', '和平区西安道18号', '39.11894000', '117.19875000', '08:00-21:00', '40', '买2斤送半斤', '022-27839999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小宝栗子.png');
INSERT INTO `shops` VALUES ('18', '石头门坎', '南开区古文化街', '39.14725000', '117.19106000', '07:00-19:00', '35', 'NULL', '022-27354998', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/石头门坎.png');
INSERT INTO `shops` VALUES ('19', '南楼煎饼', '河西区围堤道与隆昌路交口', '39.10477000', '117.22361000', '20:00-06:00', '15', 'NULL', '18202512315', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南楼煎饼.png');
INSERT INTO `shops` VALUES ('20', '老永胜包子', '南开区西湖道31号', '39.12218000', '117.16237000', '06:00-20:00', '25', '豆浆免费', '022-27655888', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老永胜包子.png');
INSERT INTO `shops` VALUES ('21', '惠宾饭庄', '河北区中山路126号', '39.16192000', '117.20388000', '10:30-21:00', '70', '老顾客9折', '022-26361999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠宾饭庄.png');
INSERT INTO `shops` VALUES ('22', '登瀛楼', '河西区友谊路42号', '39.08645000', '117.21567000', '11:00-14:00,17:00-21:00', '160', 'NULL', '022-88326666', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼.png');
INSERT INTO `shops` VALUES ('23', '正阳春鸭子楼', '和平区辽宁路146号', '39.13321000', '117.19983000', '10:30-21:00', '110', '烤鸭8.8折', '022-27307788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/正阳春鸭子楼.png');
INSERT INTO `shops` VALUES ('24', '起士林', '和平区浙江路33号', '39.12874000', '117.21155000', '11:00-22:00', '140', '下午茶7折', '022-23321688', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/起士林.png');
INSERT INTO `shops` VALUES ('25', '成桂西餐厅', '和平区河北路287号', '39.12237000', '117.20599000', '11:30-22:00', '200', '生日免单', '022-23311788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/成桂西餐厅.png');
INSERT INTO `shops` VALUES ('26', '马记烧卖', '红桥区丁字沽三号路', '39.17285000', '117.15892000', '06:30-20:00', '30', '买3笼送1笼', '13820667892', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/马记烧卖.png');
INSERT INTO `shops` VALUES ('27', '食为天', '河西区永安道219号', '39.10857000', '117.22344000', '11:00-21:30', '85', '满150减20', '022-23268877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/食为天.png');
INSERT INTO `shops` VALUES ('28', '利顺德大饭店', '和平区台儿庄路33号', '39.13001000', '117.21678000', '07:00-22:00', '220', '住店客8折', '022-23311688', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/利顺德大饭店.png');
INSERT INTO `shops` VALUES ('29', '老陶包子', '南开区南开大学西南村', '39.10432000', '117.16877000', '07:00-22:00', '20', '学生9折', '15902217563', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老陶包子.png');
INSERT INTO `shops` VALUES ('30', '清真鸿起来饭庄', '和平区辽宁路154号', '39.13421000', '117.20015000', '11:00-21:30', '60', '菜金满百88折', '022-27305678', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真鸿起来饭庄.png');
INSERT INTO `shops` VALUES ('31', '小老饭庄', '红桥区西马路', '39.15233000', '117.17892000', '10:30-21:00', '75', '现金结账95折', '022-87728833', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小老饭庄.png');
INSERT INTO `shops` VALUES ('32', '柒號馆', '和平区哈尔滨道127号', '39.13145000', '117.20678000', '11:00-14:30,17:00-21:00', '95', '预约送饮品', '18522007789', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/柒號馆.png');
INSERT INTO `shops` VALUES ('33', '三合益餐厅', '和平区辽宁路138号', '39.13298000', '117.19967000', '09:00-21:00', '45', '凉皮买2送1', '022-27306689', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三合益餐厅.png');
INSERT INTO `shops` VALUES ('34', '大福来', '河北区中山路32号', '39.15987000', '117.20211000', '06:00-20:00', '25', '锅巴菜加量不加价', '022-26218866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大福来.png');
INSERT INTO `shops` VALUES ('35', '砂锅李', '河西区九江路46号', '39.11123000', '117.21899000', '11:00-14:30,17:00-21:30', '90', '砂锅特价', '022-23260088', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/砂锅李.png');
INSERT INTO `shops` VALUES ('36', '巷子深', '和平区河北路113号', '39.12358000', '117.20641000', '11:30-14:00,17:30-20:30', '65', '皇家肘子特惠', '13312115567', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深.png');
INSERT INTO `shops` VALUES ('37', '火炉情怀', '南开区万德庄大街', '39.11876000', '117.18345000', '16:30-02:00', '85', '啤酒买一送一', '022-87456666', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/火炉情怀.png');
INSERT INTO `shops` VALUES ('38', '九河香舍', '南开区古文化街', '39.14689000', '117.19201000', '11:00-21:00', '110', '民国主题套餐88折', '18622009988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍.png');
INSERT INTO `shops` VALUES ('39', '昱得来海鲜', '滨海新区开发区第三大街', '39.04123000', '117.68977000', '10:00-22:00', '150', '海鲜加工费5折', '022-66238888', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/昱得来海鲜.png');
INSERT INTO `shops` VALUES ('40', '卫鼎轩', '南开区城厢中路', '39.14156000', '117.18543000', '11:00-21:30', '130', '四合院包间无最低消费', '022-27280128', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/卫鼎轩.png');
INSERT INTO `shops` VALUES ('41', '津沽小院', '河西区利民道72号', '39.09876000', '117.23654000', '11:00-22:00', '85', '院景位预约9折', '13920123456', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津沽小院.png');
INSERT INTO `shops` VALUES ('42', '桃子餐厅', '河北区王串场六号路', '39.16789000', '117.23123000', '10:00-22:00', '65', '招牌菜特价', '022-26427789', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅.png');
INSERT INTO `shops` VALUES ('43', '同发号饭庄', '红桥区复兴路', '39.15876000', '117.16789000', '11:00-21:00', '80', '老味津菜85折', '022-27345678', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/同发号饭庄.png');
INSERT INTO `shops` VALUES ('44', '陆壹捌餐厅', '和平区云南路38号', '39.11654000', '117.19231000', '11:00-22:00', '180', '小洋楼私房菜9折', '022-23319999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/陆壹捌餐厅.png');
INSERT INTO `shops` VALUES ('45', '东林餐厅', '河北区林东道', '39.16234000', '117.21789000', '11:00-21:30', '55', '虾酱鸡特惠', '022-26237890', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/东林餐厅.png');
INSERT INTO `shops` VALUES ('46', '老城里二姑包子', '南开区西关大街', '39.13789000', '117.17345000', '06:00-20:00', '28', '外卖满50减5', '15822223334', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老城里二姑包子.png');
INSERT INTO `shops` VALUES ('47', '清真马记富来饭庄', '南开区鼓楼南街', '39.14233000', '117.18321000', '07:00-21:00', '50', '早餐套餐8折', '022-27281234', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真马记富来饭庄.png');
INSERT INTO `shops` VALUES ('48', '桂顺斋', '和平区和平路101号', '39.12987000', '117.20567000', '08:30-20:00', '35', '老字号满百包邮', '022-27306677', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂顺斋.png');
INSERT INTO `shops` VALUES ('49', '益民餐厅', '红桥区丁字沽一号路', '39.17543000', '117.16234000', '10:00-22:00', '45', '学生证9折', '022-26558899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/益民餐厅.png');
INSERT INTO `shops` VALUES ('50', '益发顺', '南开区西湖道', '39.12198000', '117.16123000', '10:30-21:30', '75', '铜锅涮肉送酸梅汤', '13602007890', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/益发顺.png');
INSERT INTO `shops` VALUES ('51', '老张牛肉面', '和平区滨江道', '39.12765000', '117.20321000', '10:00-22:00', '42', '加面免费', '022-27112233', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老张牛肉面.png');
INSERT INTO `shops` VALUES ('52', '大姨捞面', '南开区万德庄', '39.11987000', '117.18234000', '11:00-20:30', '25', '免费续面', '18202567890', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大姨捞面.png');
INSERT INTO `shops` VALUES ('53', '津门张记包子', '河西区大沽南路', '39.10123000', '117.23123000', '06:30-20:00', '30', '三鲜包子特供', '022-28356677', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门张记包子.png');
INSERT INTO `shops` VALUES ('54', '大吉利潮汕牛肉火锅', '南开区鞍山西道', '39.11567000', '117.17234000', '11:00-23:00', '95', '手打牛丸特价', '022-27459999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大吉利潮汕牛肉火锅.png');
INSERT INTO `shops` VALUES ('55', '老天津卫炸酱面', '红桥区西于庄', '39.16890000', '117.15234000', '10:00-21:30', '35', '免费加酱', '13132109876', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老天津卫炸酱面.png');
INSERT INTO `shops` VALUES ('56', '食味酒味·锦', '和平区芷江路', '39.12123000', '117.19456000', '17:30-02:00', '110', '精酿啤酒买二送一', '18698008877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/食味酒味·锦.png');
INSERT INTO `shops` VALUES ('57', '', '南开区大悦城', '39.13567000', '117.17901000', '10:00-22:00', '90', '网红甜品9折', '022-27279988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/娜娜家.png');
INSERT INTO `shops` VALUES ('58', '福满满海鲜饺子', '滨海新区塘沽解放路', '39.03123000', '117.65789000', '10:30-21:30', '75', '海鲜饺子买赠', '022-25889999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/福满满海鲜饺子.png');
INSERT INTO `shops` VALUES ('59', '惠丰阁', '河东区津塘路', '39.12890000', '117.24901000', '11:00-21:00', '85', '津鲁菜88折', '022-24118877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠丰阁.png');
INSERT INTO `shops` VALUES ('60', '老艺人餐馆', '河北区金海道', '39.15678000', '117.21345000', '10:00-22:00', '60', '手艺菜特惠', '022-26439988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老艺人餐馆.png');
INSERT INTO `shops` VALUES ('61', '大姨海蛎煎', '和平区长沙路', '39.11876000', '117.19765000', '17:00-22:00', '45', '闽南小吃85折', '13820669988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大姨海蛎煎.png');
INSERT INTO `shops` VALUES ('62', '津门一串', '河西区梅江', '39.05789000', '117.22345000', '16:00-02:00', '80', '夜宵时段7.8折', '15902228899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门一串.png');
INSERT INTO `shops` VALUES ('63', '老码头', '南开区水上公园东路', '39.09234000', '117.17012000', '11:00-21:30', '100', '码头主题套餐', '022-23918888', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老码头.png');
INSERT INTO `shops` VALUES ('64', '恩宏德', '甘肃路97号增1号', '39.13176000', '117.19283000', '11:00-14:00,17:00-21:00', '80', 'NULL', '15202206633', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德.png');
INSERT INTO `shops` VALUES ('65', '顺兴和', '陕西路1号', '39.12985000', '117.20124000', '11:00-21:00', '70', 'NULL', '17602207315', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/顺兴和.png');
INSERT INTO `shops` VALUES ('66', '泰钰丰', '河西区永安道', '39.10789000', '117.22567000', '10:30-22:00', '110', '烤鸭特惠', '022-23269999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/泰钰丰.png');
INSERT INTO `shops` VALUES ('67', '玉泉饭庄', '红桥区西青道', '39.16234000', '117.14234000', '11:00-21:30', '65', '家常菜满百88折', '022-27778899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/玉泉饭庄.png');
INSERT INTO `shops` VALUES ('68', '三不馆儿', '南开区长江道', '39.12876000', '117.16234000', '11:00-22:00', '55', '怀旧主题9折', '022-27665566', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三不馆儿.png');
INSERT INTO `shops` VALUES ('69', '津门一爆', '河东区新开路', '39.13876000', '117.23876000', '16:30-23:00', '70', '爆肚买二送一', '18522001122', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门一爆.png');
INSERT INTO `shops` VALUES ('70', '食味匠', '和平区重庆道', '39.11987000', '117.20456000', '11:00-21:00', '180', '创意菜套餐', '022-23307788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/食味匠.png');
INSERT INTO `shops` VALUES ('71', '宽记老门口', '塘沽区上海道', '39.02654000', '117.66321000', '11:00-22:00', '85', '熏排骨特价', '022-25807788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宽记老门口.png');
INSERT INTO `shops` VALUES ('72', '老六素货', '河北区靖江路', '39.15432000', '117.24567000', '09:00-19:00', '25', '素什锦特惠', '13102008899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老六素货.png');
INSERT INTO `shops` VALUES ('73', '四辈羊汤', '红桥区咸阳北路', '39.17876000', '117.16234000', '05:30-14:00', '35', '羊汤免费续', '022-26559988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/四辈羊汤.png');
INSERT INTO `shops` VALUES ('74', '马记茶汤', '南开区古文化街', '39.14678000', '117.19123000', '09:00-18:00', '15', '第二碗半价', '13920208877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/马记茶汤.png');
INSERT INTO `shops` VALUES ('75', '津门十三张', '河西区利民道', '39.09876000', '117.23876000', '17:00-02:00', '75', '精酿啤酒畅饮', '18698007788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门十三张.png');
INSERT INTO `shops` VALUES ('76', '小海地小虎烧烤', '河西区小海地', '39.05678000', '117.27654000', '17:00-03:00', '65', '满百送酒', '13820668899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小海地小虎烧烤.png');
INSERT INTO `shops` VALUES ('77', '大姨糖堆儿', '河北区中山路', '39.16234000', '117.20321000', '10:00-20:00', '10', '买5送1', '18202559988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大姨糖堆儿.png');
INSERT INTO `shops` VALUES ('78', '老姑砂锅', '南开区西湖村', '39.12123000', '117.17234000', '16:00-24:00', '50', '砂锅配烧饼套餐', '13132117788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老姑砂锅.png');
INSERT INTO `shops` VALUES ('80', '同义成锅巴菜', '和平区辽宁路148号', '39.13291000', '117.19988000', '06:00-20:30', '18', '锅巴菜加量不加价', '022-27306611', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/同义成锅巴菜.png');
INSERT INTO `shops` VALUES ('81', '老鸟市姜糖梨水', '红桥区西沽公园东门', '39.16532000', '117.15367000', '09:30-18:00', '12', '第二杯半价', '15122668899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老鸟市姜糖梨水.png');
INSERT INTO `shops` VALUES ('82', '清真洪记肠粉', '河西区广东路127号', '39.10544000', '117.22341000', '10:30-21:00', '28', '肠粉买二送一', '18522009966', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真洪记肠粉.png');
INSERT INTO `shops` VALUES ('83', '渔家小院', '津南区咸水沽建国大街', '38.98657000', '117.40185000', '11:00-21:30', '65', '水库鱼鲜88折', '022-28517788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/渔家小院.png');
INSERT INTO `shops` VALUES ('84', '德盛元水饺', '南开区西湖道45号', '39.12208000', '117.16192000', '10:00-20:00', '25', '手工水饺特惠', '13132556677', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/德盛元水饺.png');
INSERT INTO `shops` VALUES ('85', '火神庙老豆腐', '河北区狮子林大街102号', '39.16088000', '117.21001000', '05:30-12:00', '15', '豆腐脑买赠活动', '13602118833', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/火神庙老豆腐.png');
INSERT INTO `shops` VALUES ('86', '粤食堂茶点', '河西区友谊北路32号', '39.10977000', '117.21904000', '10:00-22:00', '88', '午市点心78折', '022-28319999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/粤食堂茶点.png');
INSERT INTO `shops` VALUES ('87', '老爆三爆肚', '红桥区西关大街58号', '39.13815000', '117.17562000', '17:00-24:00', '55', '啤酒免费续杯', '13920669988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老爆三爆肚.png');
INSERT INTO `shops` VALUES ('88', '山上下居酒屋', '和平区南京路189号', '39.12895000', '117.21901000', '11:00-23:00', '120', '满200减30', '022-87338899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/山上下居酒屋.png');
INSERT INTO `shops` VALUES ('89', '巷子深肘子', '河西区利民道82号', '39.09988000', '117.23716000', '11:00-14:00', '68', '每日限量30份', '13312118866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深肘子.png');
INSERT INTO `shops` VALUES ('90', '四久诚卤煮', '南开区万德庄大街76号', '39.11947000', '117.18396000', '11:30-22:00', '48', '卤煮买赠活动', '15022337766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/四久诚卤煮.png');
INSERT INTO `shops` VALUES ('91', '桃子餐厅王串场店', '河北区王串场五号路', '39.16729000', '117.22871000', '10:30-21:30', '63', '招牌八珍豆腐特价', '022-26437789', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅王串场店.png');
INSERT INTO `shops` VALUES ('92', '老铁熏鸡', '西青区杨柳青御河道', '39.13822000', '117.01256000', '08:00-18:00', '38', '熏鸡翅买五送一', '13820663399', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老铁熏鸡.png');
INSERT INTO `shops` VALUES ('93', '清真尔发家', '北辰区果园北道24号', '39.22881000', '117.13444000', '10:00-22:00', '55', '传统津菜85折', '022-26915566', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真尔发家.png');
INSERT INTO `shops` VALUES ('94', '玉泉饭庄中北镇店', '西青区中北镇万源路', '39.14267000', '117.10289000', '11:00-21:30', '72', '老字号津味', '022-27998866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/玉泉饭庄中北镇店.png');
INSERT INTO `shops` VALUES ('95', '苏易士西餐厅', '和平区成都道40号', '39.11685000', '117.20175000', '11:30-22:00', '130', '俄式套餐9折', '022-23328877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/苏易士西餐厅.png');
INSERT INTO `shops` VALUES ('96', '小树林水煮鱼', '河北区金钟河大街228号', '39.16388000', '117.22691000', '11:00-23:00', '68', '草鱼买一赠一', '022-26279922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小树林水煮鱼.png');
INSERT INTO `shops` VALUES ('97', '津门李记肠粉', '滨海新区解放路789号', '39.03017000', '117.65723000', '10:00-21:30', '35', '鲜虾肠粉特价', '022-25887766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门李记肠粉.png');
INSERT INTO `shops` VALUES ('98', '大福来北宁店', '河北区中山路58号', '39.15987000', '117.20198000', '06:00-19:30', '22', '早点套餐优惠', '022-26218877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大福来北宁店.png');
INSERT INTO `shops` VALUES ('99', '清真二园子', '红桥区南运河南路', '39.15555000', '117.17005000', '10:30-14:00', '42', '回民家常菜', '13110006655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真二园子.png');
INSERT INTO `shops` VALUES ('100', '恩宏德德才里店', '河西区隆昌路94号', '39.10121000', '117.22617000', '11:00-14:00', '82', '椒盐板筋必点', '15202207788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德德才里店.png');
INSERT INTO `shops` VALUES ('101', '老姑砂锅万德庄店', '南开区万德庄大街118号', '39.12098000', '117.18401000', '16:30-24:00', '52', '砂锅配醋椒豆腐', '13602008855', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老姑砂锅万德庄店.png');
INSERT INTO `shops` VALUES ('102', '桂顺斋南市店', '和平区荣业大街112号', '39.13345000', '117.18807000', '08:30-20:00', '45', '满百包邮', '022-27275533', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂顺斋南市店.png');
INSERT INTO `shops` VALUES ('103', '古丽花儿山西路店', '和平区山西路284号', '39.12001000', '117.20233000', '11:00-22:30', '70', '酸奶买赠', '15522889966', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/古丽花儿山西路店.png');
INSERT INTO `shops` VALUES ('104', '益民餐厅丁字沽店', '红桥区丁字沽一号路', '39.17599000', '117.16205000', '09:30-21:30', '40', '学生证9折', '022-26558877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/益民餐厅丁字沽店.png');
INSERT INTO `shops` VALUES ('105', '胖姐炒面', '滨海新区塘沽学校大街', '39.02598000', '117.65322000', '16:00-02:00', '25', '深夜食堂特惠', '15902223366', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/胖姐炒面.png');
INSERT INTO `shops` VALUES ('106', '百饺园小白楼店', '和平区曲阜道38号', '39.11781000', '117.22277000', '10:30-21:00', '95', '海鲜饺特价', '022-23307788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/百饺园小白楼店.png');
INSERT INTO `shops` VALUES ('107', '盛运潮汕火锅', '河西区围堤道146号', '39.10563000', '117.23018000', '11:00-22:30', '89', '手打牛丸88折', '022-28379977', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/盛运潮汕火锅.png');
INSERT INTO `shops` VALUES ('108', '津菜典藏梅江店', '河西区珠江道99号', '39.07065000', '117.23418000', '10:30-22:00', '145', '四合院环境', '022-88228866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏梅江店.png');
INSERT INTO `shops` VALUES ('109', '耳朵眼鼓楼店', '南开区鼓楼北街25号', '39.14315000', '117.18452000', '10:00-21:30', '78', '炸糕礼盒装', '022-27298822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼鼓楼店.png');
INSERT INTO `shops` VALUES ('110', '柒號馆哈尔滨道店', '和平区哈尔滨道127号', '39.13151000', '117.20688000', '11:00-21:30', '98', '私房菜预约制', '18522007799', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/柒號馆哈尔滨道店.png');
INSERT INTO `shops` VALUES ('111', '昱得来海鲜北塘店', '滨海新区北塘古镇', '39.17214000', '117.71835000', '09:30-20:30', '120', '海鲜加工5折', '022-67238888', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/昱得来海鲜北塘店.png');
INSERT INTO `shops` VALUES ('112', '石头门坎南市店', '和平区慎益街88号', '39.13458000', '117.18601000', '07:00-19:00', '38', '素包买五送一', '022-27271258', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/石头门坎南市店.png');
INSERT INTO `shops` VALUES ('113', '宽记老门口大港店', '滨海新区学府路12号', '38.84277000', '117.45609000', '11:00-22:00', '72', '熏排骨特供', '022-63215577', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宽记老门口大港店.png');
INSERT INTO `shops` VALUES ('114', '桃子餐厅鞍山西道店', '南开区鞍山西道322号', '39.11365000', '117.17098000', '10:30-21:30', '68', '八珍豆腐特价', '022-27450099', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅鞍山西道店.png');
INSERT INTO `shops` VALUES ('115', '宝轩府永安道店', '河西区永安道219-1', '39.10892000', '117.22389000', '11:00-22:00', '108', '鱼头泡饼78折', '022-23269988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宝轩府永安道店.png');
INSERT INTO `shops` VALUES ('116', '登瀛楼河东店', '河东区津塘路23号', '39.13238000', '117.25067000', '11:00-21:30', '138', '老字号鲁菜', '022-24319922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼河东店.png');
INSERT INTO `shops` VALUES ('117', '天宝楼酱货', '和平区辽宁路135号', '39.13221000', '117.20067000', '09:00-20:30', '65', '酱货满百减20', '022-27305533', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/天宝楼酱货.png');
INSERT INTO `shops` VALUES ('118', '友达面馆', '南开区西湖村大街33号', '39.12013000', '117.17202000', '10:30-21:00', '45', '酸菜鱼面特惠', '13312119988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/友达面馆.png');
INSERT INTO `shops` VALUES ('120', '老码头古文化街店', '南开区通北路', '39.14988000', '117.19401000', '11:00-22:00', '95', '民俗主题餐厅', '022-27278800', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老码头古文化街店.png');
INSERT INTO `shops` VALUES ('121', '津门一串西青店', '西青区大寺镇友发路', '39.01817000', '117.24842000', '17:00-03:00', '78', '深夜烤串7折', '15822221133', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门一串西青店.png');
INSERT INTO `shops` VALUES ('122', '小宝栗子中山路店', '河北区中山路178号', '39.16099000', '117.20367000', '08:30-20:00', '42', '冰栗子新品特惠', '022-26238899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小宝栗子中山路店.png');
INSERT INTO `shops` VALUES ('123', '津门张记老店', '北辰区宜兴埠镇', '39.22548000', '117.21387000', '06:30-20:00', '35', '三鲜包买赠', '022-26992277', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门张记老店.png');
INSERT INTO `shops` VALUES ('124', '南楼煎饼新华路店', '和平区新华路216号', '39.12498000', '117.20901000', '19:00-07:00', '18', '双蛋馃箅儿', '13920886655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南楼煎饼新华路店.png');
INSERT INTO `shops` VALUES ('125', '宴宾楼长江道店', '南开区长江道102号', '39.12676000', '117.16333000', '10:30-22:00', '125', '老爆三特价', '022-27668877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宴宾楼长江道店.png');
INSERT INTO `shops` VALUES ('126', '小海地小虎烧烤总店', '河西区小海地学苑路', '39.05715000', '117.27819000', '17:00-03:30', '58', '烤羊腿特惠', '13820669955', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小海地小虎烧烤总店.png');
INSERT INTO `shops` VALUES ('127', '红旗饭庄芥园道店', '红桥区芥园道13号', '39.14876000', '117.15533000', '10:30-21:30', '92', '罾蹦鲤鱼特供', '022-27528899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/红旗饭庄芥园道店.png');
INSERT INTO `shops` VALUES ('128', '起士林小白楼店', '和平区浙江路33号', '39.12874000', '117.21155000', '11:00-22:30', '140', '德式猪肘9折', '022-23321666', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/起士林小白楼店.png');
INSERT INTO `shops` VALUES ('129', '正阳春鸭子楼河东店', '河东区六纬路112号', '39.12854000', '117.25676000', '10:30-21:30', '105', '烤鸭套餐特价', '022-24115577', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/正阳春鸭子楼.png');
INSERT INTO `shops` VALUES ('130', '成桂西餐厅河北路店', '和平区河北路287号', '39.12237000', '117.20599000', '11:30-22:30', '220', '生日免单', '022-23311766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/成桂西餐厅河北路店.png');
INSERT INTO `shops` VALUES ('131', '清真鸿起来西北角店', '红桥区西关大街58号', '39.13976000', '117.17289000', '10:30-22:00', '58', '红烧牛舌尾特价', '13132559977', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真鸿起来西北角店.png');
INSERT INTO `shops` VALUES ('132', '老城里二姑包子总店', '南开区西关大街19号', '39.13811000', '117.17345000', '06:00-21:00', '26', '水馅包子特供', '15822220044', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老城里二姑包子总店.png');
INSERT INTO `shops` VALUES ('133', '娜娜家万象城店', '河西区乐园道9号', '39.09128000', '117.21975000', '10:00-22:00', '92', '网红甜品88折', '022-88327755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/娜娜家万象城店.png');
INSERT INTO `shops` VALUES ('134', '小老饭庄河北店', '河北区金纬路232号', '39.15598000', '117.21345000', '10:30-21:00', '80', '红烧牛窝骨特惠', '022-26439922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小老饭庄河北店.png');
INSERT INTO `shops` VALUES ('135', '大铁勺天拖店', '南开区红旗路278号', '39.12456000', '117.15099000', '10:30-21:30', '85', '铁勺凤爪必点', '022-23679977', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大铁勺天拖店.png');
INSERT INTO `shops` VALUES ('136', '昱得来海鲜开发区店', '滨海新区第三大街51号', '39.04112000', '117.68891000', '10:30-23:00', '155', '帝王蟹特价', '022-66238822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/昱得来海鲜开发区店.png');
INSERT INTO `shops` VALUES ('137', '陆壹捌五大道店', '和平区马场道188号', '39.10889000', '117.20798000', '11:00-22:30', '210', '小洋楼私房菜', '022-23319922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/陆壹捌五大道店.png');
INSERT INTO `shops` VALUES ('138', '清真三合益西北角店', '红桥区西马路', '39.15109000', '117.17933000', '10:00-21:00', '42', '牛肉烧饼特价', '022-87727733', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真三合益西北角店.png');
INSERT INTO `shops` VALUES ('139', '大姨捞面总店', '南开区万德庄大街', '39.12003000', '117.18255000', '10:30-20:00', '28', '免费续面加卤', '13662009922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大姨捞面总店.png');
INSERT INTO `shops` VALUES ('140', '惠宾饭庄中山路老店', '河北区中山路126号', '39.16192000', '117.20388000', '10:30-21:30', '78', '老爆三特惠', '022-26361933', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠宾饭庄中山路老店.png');
INSERT INTO `shops` VALUES ('141', '东林餐厅林东道店', '河北区林东道112号', '39.16355000', '117.21799000', '11:00-21:30', '60', '虾酱鸡必点', '022-26237822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/东林餐厅林东道店.png');
INSERT INTO `shops` VALUES ('142', '南市狗不理总店', '和平区山东路77号', '39.12653000', '117.19875000', '06:30-20:30', '120', '经典包子套餐', '022-27302540', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南市狗不理总店.png');
INSERT INTO `shops` VALUES ('143', '清真马记富来锅巴菜', '南开区鼓楼东街', '39.14732000', '117.18411000', '06:00-11:00', '15', '锅巴菜加蛋特惠', '022-27281211', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真马记富来锅巴菜.png');
INSERT INTO `shops` VALUES ('144', '三不馆儿水上店', '河西区体院北环湖中道', '39.08007000', '117.21091000', '11:00-22:00', '72', '津味家常菜', '022-23317700', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三不馆儿水上店.png');
INSERT INTO `shops` VALUES ('145', '小老味饭庄总店', '红桥区西关街58号', '39.14089000', '117.17298000', '10:30-21:30', '78', '红烧牛尾特价', '022-27278899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小老味饭庄总店.png');
INSERT INTO `shops` VALUES ('146', '东林烤场', '西青区中北镇阜盛道', '39.13916000', '117.09102000', '10:30-00:00', '65', '自助烧烤88折', '18622990022', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/东林烤场.png');
INSERT INTO `shops` VALUES ('147', '津沽渔家', '津南区葛沽镇', '38.98699000', '117.50182000', '11:00-21:30', '78', '水库鱼鲜', '022-28689900', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津沽渔家.png');
INSERT INTO `shops` VALUES ('148', '老永胜包子王顶堤店', '南开区艳阳路62号', '39.10512000', '117.15223000', '06:30-19:30', '28', '红豆粥免费', '022-23327755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老永胜包子王顶堤店.png');
INSERT INTO `shops` VALUES ('149', '九河香舍五大道店', '和平区云南路45号', '39.11677000', '117.19209000', '11:00-22:00', '110', '民国风餐厅', '18622009900', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍五大道店.png');
INSERT INTO `shops` VALUES ('150', '泰钰丰金融街店', '河西区永安道47号', '39.10658000', '117.22481000', '10:30-22:00', '125', '烤鸭卷饼88折', '022-23267755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/泰钰丰金融街店.png');
INSERT INTO `shops` VALUES ('151', '起士林西饼店', '河西区友谊路21号', '39.09385000', '117.21568000', '09:00-21:00', '35', '俄式蛋糕', '022-88325522', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/起士林西饼店.png');
INSERT INTO `shops` VALUES ('152', '大姨糖堆', '南开区西马路', '39.13987000', '117.17566000', '09:00-20:00', '12', '冰糖葫芦买三送一', '15922221144', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大姨糖堆.png');
INSERT INTO `shops` VALUES ('153', '正阳春金茂店', '河西区南京路39号', '39.11721000', '117.22089000', '10:30-21:30', '115', '春饼卷鸭特惠', '022-23306688', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/正阳春鸭子楼.png');
INSERT INTO `shops` VALUES ('154', '古丽花儿塘沽店', '滨海新区解放路699号', '39.03119000', '117.65827000', '11:00-22:00', '68', '新疆大盘鸡特价', '022-25889900', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/古丽花儿塘沽店.png');
INSERT INTO `shops` VALUES ('155', '北李妈妈菜', '南开区南门外大街', '39.13655000', '117.18789000', '11:00-21:30', '78', '东北菜88折', '022-27275599', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/北李妈妈菜.png');
INSERT INTO `shops` VALUES ('156', '卫鼎轩大悦城店', '南开区南门外大街2号', '39.13788000', '117.18012000', '10:30-22:00', '125', '创意津菜', '022-27280111', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/卫鼎轩大悦城店.png');
INSERT INTO `shops` VALUES ('157', '惠美饺子中山门店', '河北区中山路109号', '39.15999000', '117.20633000', '10:00-21:00', '38', '海鲜水饺特惠', '022-26360099', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠美饺子中山门店.png');
INSERT INTO `shops` VALUES ('158', '胖哥俩肉蟹煲', '南开区大悦城南区4楼', '39.13587000', '117.17999000', '11:00-22:00', '85', '招牌肉蟹煲买赠', '022-27302233', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/胖哥俩肉蟹煲.png');
INSERT INTO `shops` VALUES ('159', '老铁熏鸡总店', '河西区平泉道8号', '39.08225000', '117.23418000', '08:00-19:00', '45', '熏鸡翅买三送一', '13920218855', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老铁熏鸡总店.png');
INSERT INTO `shops` VALUES ('160', '桃子餐厅中山门店', '河东区中山门龙潭路', '39.10479000', '117.27654000', '10:30-21:00', '60', '老爆三特价', '022-84119933', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅中山门店.png');
INSERT INTO `shops` VALUES ('161', '九寸钉自助烤肉', '和平区滨江道208号', '39.12881000', '117.20444000', '11:00-22:00', '98', '晚市减15元', '022-27109977', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九寸钉自助烤肉.png');
INSERT INTO `shops` VALUES ('162', '三个渔夫友谊路店', '河西区友谊路50号', '39.08521000', '117.21682000', '10:00-22:00', '160', '蒸汽海鲜9折', '022-88326655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三个渔夫友谊路店.png');
INSERT INTO `shops` VALUES ('163', '天津卫码头', '南开区水上公园东路', '39.09319000', '117.17121000', '11:00-21:30', '90', '传统小吃', '022-23918866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/天津卫码头.png');
INSERT INTO `shops` VALUES ('164', '巷子深河西店', '河西区九龙路58号', '39.11563000', '117.22188000', '11:30-14:00', '78', '脱骨肘子每日特供', '13302008899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深河西店.png');
INSERT INTO `shops` VALUES ('165', '祥禾饽饽铺', '和平区五大道湖南路', '39.11533000', '117.19677000', '09:00-20:30', '38', '宫廷糕点满减', '022-23109988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/祥禾饽饽铺.png');
INSERT INTO `shops` VALUES ('166', '南门煎饼', '红桥区光荣道82号', '39.17788000', '117.16123000', '05:00-12:00', '16', '绿豆面煎饼果子', '13012300022', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南门煎饼.png');
INSERT INTO `shops` VALUES ('167', '西北角早点', '红桥区西马路', '39.15129000', '117.17785000', '05:30-10:30', '20', '传统清真早餐', '18202517788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/西北角早点.png');
INSERT INTO `shops` VALUES ('168', '百饺园金皇店', '河西区南京路18号', '39.11376000', '117.22391000', '10:30-21:30', '100', '海鲜饺礼盒装', '022-23300088', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/百饺园金皇店.png');
INSERT INTO `shops` VALUES ('169', '宴宾楼和平总店', '和平区辽宁路135号', '39.13256000', '117.20042000', '10:30-22:00', '130', '传统老字号', '022-27306655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宴宾楼和平总店.png');
INSERT INTO `shops` VALUES ('170', '耳朵眼新世界店', '南开区东马路', '39.13873000', '117.18492000', '10:00-22:00', '25', '豆沙炸糕', '022-27279911', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼新世界店.png');
INSERT INTO `shops` VALUES ('171', '津菜典藏水上店', '南开区水上公园北路', '39.09433000', '117.17721000', '10:30-22:00', '160', '园林主题餐厅', '022-23319988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏水上店.png');
INSERT INTO `shops` VALUES ('172', '大福来奥城店', '南开区奥城商业街', '39.09844000', '117.17278000', '06:30-20:00', '24', '嘎巴菜套餐', '022-23998877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大福来奥城店.png');
INSERT INTO `shops` VALUES ('173', '鸿起顺东楼店', '河西区利民道72号', '39.09819000', '117.23888000', '10:30-21:00', '72', '老字号清真', '022-28308899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起顺东楼店.png');
INSERT INTO `shops` VALUES ('174', '登瀛楼宾水道店', '河西区宾水道增9号', '39.09425000', '117.22145000', '10:30-21:30', '152', '九转大肠特价', '022-88327722', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼宾水道店.png');
INSERT INTO `shops` VALUES ('175', '马记烧卖河北店', '河北区黄纬路78号', '39.15900000', '117.20298000', '07:00-20:30', '32', '烧卖买三送一', '13820226655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/马记烧卖河北店.png');
INSERT INTO `shops` VALUES ('176', '老永胜包子河北店', '河北区金钟河大街', '39.16538000', '117.21789000', '06:30-19:00', '26', '小米粥免费', '022-26429988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老永胜包子河北店.png');
INSERT INTO `shops` VALUES ('177', '桂圆餐厅成都道店', '和平区成都道101号', '39.11584000', '117.20156000', '11:00-21:30', '85', '传统津菜', '022-23321999', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂圆餐厅成都道店.png');
INSERT INTO `shops` VALUES ('178', '柒號馆滨江道店', '和平区哈尔滨道128号', '39.13122000', '117.20711000', '11:00-14:30', '95', '私房菜预约制', '18522207711', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/柒號馆滨江道店.png');
INSERT INTO `shops` VALUES ('179', '食为天白堤路店', '南开区白堤路238号', '39.11898000', '117.16567000', '11:00-21:30', '88', '罾蹦鲤鱼特惠', '022-27459922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/食为天白堤路店.png');
INSERT INTO `shops` VALUES ('180', '清真马记富来老店', '南开区西湖道102号', '39.12289000', '117.16098000', '05:30-12:00', '18', '锅巴菜套餐', '13672009933', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真马记富来老店.png');
INSERT INTO `shops` VALUES ('181', '卫鼎轩国金店', '和平区南京路189号', '39.12832000', '117.21885000', '11:00-22:00', '138', '创意津菜', '022-27307799', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/卫鼎轩国金店.png');
INSERT INTO `shops` VALUES ('182', '恩宏德甘肃路店', '和平区甘肃路97号', '39.13176000', '117.19283000', '11:00-14:00', '80', '椒盐板筋必点', '15202208822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德甘肃路店.png');
INSERT INTO `shops` VALUES ('183', '三合益餐厅和平店', '和平区长春道', '39.13287000', '117.19543000', '09:00-20:30', '38', '凉皮买二送一', '022-27227744', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三合益餐厅和平店.png');
INSERT INTO `shops` VALUES ('184', '九河香舍南开店', '南开区鼓楼北里', '39.14782000', '117.18687000', '10:30-22:00', '105', '津派创意菜', '18622009988', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍南开店.png');
INSERT INTO `shops` VALUES ('185', '清真鸿起来南开店', '南开区西湖村大街', '39.12176000', '117.17192000', '10:30-22:00', '52', '红烧牛舌尾特价', '13102009877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/清真鸿起来南开店.png');
INSERT INTO `shops` VALUES ('186', '小老味饭庄河西店', '河西区绍兴道', '39.11025000', '117.21887000', '10:30-21:00', '76', '红烧牛窝骨', '022-23260099', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小老味饭庄河西店.png');
INSERT INTO `shops` VALUES ('187', '桃子餐厅塘沽店', '滨海新区福建路', '39.03002000', '117.66593000', '10:30-21:00', '65', '招牌八珍豆腐', '022-25883366', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅塘沽店.png');
INSERT INTO `shops` VALUES ('188', '大铁勺西青店', '西青区张家窝镇', '39.05678000', '117.03556000', '10:30-21:30', '80', '铁勺凤爪特惠', '022-87997755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大铁勺西青店.png');
INSERT INTO `shops` VALUES ('189', '老姑砂锅河北店', '河北区金钟河大街', '39.16298000', '117.22543000', '16:30-24:00', '50', '醋椒豆腐砂锅', '13602007755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老姑砂锅河北店.png');
INSERT INTO `shops` VALUES ('190', '登瀛楼河西总店', '河西区友谊路42号', '39.08645000', '117.21567000', '10:30-22:00', '165', '鲁菜特惠', '022-88326600', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼河西总店.png');
INSERT INTO `shops` VALUES ('191', '起士林友谊店', '河西区友谊路21号', '39.09311000', '117.21499000', '11:00-22:00', '145', '德式西餐', '022-88325566', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/起士林友谊店.png');
INSERT INTO `shops` VALUES ('192', '津菜典藏河东店', '河东区六纬路85号', '39.12785000', '117.25876000', '10:30-22:00', '158', '津派园林风格', '022-24118888', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏河东店.png');
INSERT INTO `shops` VALUES ('193', '耳朵眼南开店', '南开区鞍山西道', '39.11332000', '117.17001000', '09:30-21:00', '20', '传统炸糕', '022-27452277', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼南开店.png');
INSERT INTO `shops` VALUES ('194', '惠宾饭庄塘沽店', '滨海新区解放路156号', '39.03176000', '117.66101000', '10:30-21:30', '75', '老爆三特惠', '022-25887799', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠宾饭庄塘沽店.png');
INSERT INTO `shops` VALUES ('195', '大吉利潮汕火锅', '南开区万德庄大街', '39.11992000', '117.18482000', '11:00-22:30', '95', '手打牛丸特价', '022-87885577', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大吉利潮汕火锅.png');
INSERT INTO `shops` VALUES ('196', '玉泉饭庄红桥店', '红桥区丁字沽三号路', '39.17831000', '117.16329000', '10:30-21:30', '68', '津味家常菜', '022-26556622', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/玉泉饭庄红桥店.png');
INSERT INTO `shops` VALUES ('197', '桃子餐厅北站店', '河北区中山路198号', '39.16321000', '117.20456000', '10:30-21:00', '63', '八珍豆腐特价', '022-26237766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅北站店.png');
INSERT INTO `shops` VALUES ('198', '登瀛楼南开店', '南开区南京路358号', '39.11908000', '117.17901000', '11:00-22:00', '150', '九转大肠特惠', '022-27352288', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼南开店.png');
INSERT INTO `shops` VALUES ('199', '天宝隆包子铺', '西青区精武镇', '39.03987000', '117.10898000', '06:30-19:00', '24', '猪肉三鲜包特供', '022-23998822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/天宝隆包子铺.png');
INSERT INTO `shops` VALUES ('200', '金百万烤鸭滨海店', '滨海新区三大街', '39.04133000', '117.68988000', '10:30-22:00', '98', '烤鸭买赠活动', '022-66237722', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/金百万烤鸭滨海店.png');
INSERT INTO `shops` VALUES ('201', '津门一串河西店', '河西区土城地铁站', '39.08876000', '117.24589000', '17:00-02:00', '75', '精酿啤酒买二送一', '15902228800', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门一串河西店.png');
INSERT INTO `shops` VALUES ('202', '天津卫码头滨海店', '滨海新区塘沽外滩', '39.02888000', '117.67219000', '11:00-22:00', '85', '传统码头菜', '022-25336655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/天津卫码头滨海店.png');
INSERT INTO `shops` VALUES ('203', '巷子深大沽路店', '河西区大沽南路501号', '39.10422000', '117.23199000', '11:30-14:00', '75', '秘制肘子限时供应', '13622007744', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深大沽路店.png');
INSERT INTO `shops` VALUES ('204', '桂顺斋王串场店', '河北区王串场六号路', '39.16755000', '117.23218000', '08:00-20:30', '48', '传统糕点', '022-26438877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂顺斋王串场店.png');
INSERT INTO `shops` VALUES ('205', '老城里二姑包子河北店', '河北区靖江路', '39.15481000', '117.24789000', '06:00-20:00', '28', '水馅包子特惠', '15822221155', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老城里二姑包子河北店.png');
INSERT INTO `shops` VALUES ('206', '登瀛楼鼓楼店', '南开区鼓楼东街', '39.14598000', '117.18781000', '10:30-22:00', '160', '鲁菜九折', '022-27358800', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼鼓楼店.png');
INSERT INTO `shops` VALUES ('207', '南门烧鸡', '河北区金钟路', '39.15988000', '117.22001000', '09:00-19:00', '42', '童子鸡特价', '022-26217711', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南门烧鸡.png');
INSERT INTO `shops` VALUES ('208', '鸿起顺利民道店', '河西区利民道148号', '39.09788000', '117.24002000', '10:30-22:00', '70', '老字号清真', '022-28309955', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起顺利民道店.png');
INSERT INTO `shops` VALUES ('209', '卫鼎轩东丽店', '东丽区利津路', '39.09976000', '117.41187000', '10:30-22:00', '115', '四合院包间', '022-24883377', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/卫鼎轩东丽店.png');
INSERT INTO `shops` VALUES ('210', '九河香舍意大利风情店', '河北区自由道', '39.14775000', '117.20191000', '11:00-00:00', '120', '民国风酒馆', '18622007766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍意大利风情店.png');
INSERT INTO `shops` VALUES ('211', '桃子餐厅滨江道店', '和平区哈尔滨道126号', '39.13085000', '117.20645000', '11:00-22:00', '68', '八珍豆腐特价', '022-27303366', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅滨江道店.png');
INSERT INTO `shops` VALUES ('212', '耳朵眼小白楼店', '和平区开封道', '39.12562000', '117.22167000', '10:00-22:00', '20', '炸糕礼品装', '022-23318877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼小白楼店.png');
INSERT INTO `shops` VALUES ('213', '津菜典藏西青店', '西青区中北镇阜锦道', '39.13989000', '117.09101000', '10:30-22:00', '155', '津派园林', '022-27996622', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏西青店.png');
INSERT INTO `shops` VALUES ('214', '马记烧卖红桥店', '红桥区光荣道122号', '39.18001000', '117.15532000', '06:30-20:00', '32', '牛肉烧卖买三送一', '13920336677', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/马记烧卖红桥店.png');
INSERT INTO `shops` VALUES ('215', '老铁熏鸡滨海店', '滨海新区杭州道', '39.05122000', '117.65188000', '08:00-18:00', '45', '熏鸡翅特惠', '022-25337766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老铁熏鸡滨海店.png');
INSERT INTO `shops` VALUES ('216', '金百万烤鸭河东店', '河东区十一经路78号', '39.12511000', '117.26345000', '10:30-22:00', '95', '果木烤鸭特价', '022-24115588', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/金百万烤鸭河东店.png');
INSERT INTO `shops` VALUES ('217', '桂园餐厅河北店', '河北区中山路199号', '39.16198000', '117.20567000', '11:00-21:30', '80', '老爆三特惠', '022-26361133', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂园餐厅河北店.png');
INSERT INTO `shops` VALUES ('218', '津门李记肠粉总店', '河西区大沽南路', '39.10176000', '117.23328000', '10:00-21:30', '38', '肠粉买二送一', '15922220011', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门李记肠粉总店.png');
INSERT INTO `shops` VALUES ('219', '老码头海河店', '河北区海河东路', '39.15677000', '117.22198000', '11:00-22:30', '90', '河景餐厅', '022-26218899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老码头海河店.png');
INSERT INTO `shops` VALUES ('220', '昱得来海鲜汉沽店', '滨海新区汉沽新开中路', '39.25276000', '117.81882000', '09:30-20:00', '110', '汉沽海鲜', '022-67198866', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/昱得来海鲜汉沽店.png');
INSERT INTO `shops` VALUES ('221', '百饺园南开店', '南开区长江道102号', '39.12671000', '117.16299000', '10:30-22:00', '100', '手工水饺买赠', '022-27665522', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/百饺园南开店.png');
INSERT INTO `shops` VALUES ('222', '盛运火锅鼓楼店', '南开区城厢中路', '39.14298000', '117.18781000', '11:00-22:30', '95', '手打牛丸88折', '022-27278833', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/盛运火锅鼓楼店.png');
INSERT INTO `shops` VALUES ('223', '登瀛楼海光寺店', '和平区南京路309号', '39.11995000', '117.18001000', '10:30-22:00', '160', '鲁菜特惠套餐', '022-27819955', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼海光寺店.png');
INSERT INTO `shops` VALUES ('224', '耳朵眼南开二店', '南开区黄河道467号', '39.14022000', '117.16999000', '09:00-20:30', '22', '豆沙炸糕', '022-27558899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼南开二店.png');
INSERT INTO `shops` VALUES ('225', '鸿起来河东店', '河东区大直沽八号路', '39.11778000', '117.26102000', '10:30-22:00', '55', '红烧牛舌尾特价', '022-24116655', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起来河东店.png');
INSERT INTO `shops` VALUES ('226', '九河香舍文化街店', '南开区古文化街', '39.14987000', '117.19236000', '11:00-23:00', '115', '津味小酒馆', '18622007711', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍文化街店.png');
INSERT INTO `shops` VALUES ('227', '三个渔夫滨海店', '滨海新区第二大街', '39.03247000', '117.70012000', '10:30-22:00', '165', '蒸汽海鲜9折', '022-65337788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三个渔夫滨海店.png');
INSERT INTO `shops` VALUES ('228', '巷子深滨江道店', '和平区山西路192号', '39.12218000', '117.20378000', '11:30-14:30', '72', '每日限量肘子', '13602112266', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深滨江道店.png');
INSERT INTO `shops` VALUES ('229', '柒號馆五大道店', '和平区重庆道197号', '39.12011000', '117.20455000', '11:00-21:30', '110', '私房菜预约', '18522007722', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/柒號馆五大道店.png');
INSERT INTO `shops` VALUES ('230', '津菜典藏小白楼店', '和平区曲阜道38号', '39.11799000', '117.22289000', '10:30-22:00', '170', '小洋楼餐厅', '022-23308877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏小白楼店.png');
INSERT INTO `shops` VALUES ('231', '惠宾饭庄滨海店', '滨海新区塘沽解放路998号', '39.03102000', '117.66011000', '10:30-21:30', '76', '传统津菜', '022-25889922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/惠宾饭庄滨海店.png');
INSERT INTO `shops` VALUES ('232', '登瀛楼武清店', '武清区振华西道', '39.39127000', '117.06145000', '10:30-22:00', '150', '老字号分店', '022-29368877', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼武清店.png');
INSERT INTO `shops` VALUES ('233', '正阳春大光明桥店', '河东区十一经路', '39.12522000', '117.26231000', '10:30-21:30', '110', '烤鸭特惠套餐', '022-24109933', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/正阳春鸭子楼.png');
INSERT INTO `shops` VALUES ('234', '大福来河东店', '河东区成林道', '39.13895000', '117.27188000', '06:00-20:30', '25', '嘎巴菜特惠', '022-24318844', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大福来河东店.png');
INSERT INTO `shops` VALUES ('235', '恩宏德大沽路店', '河西区大沽南路', '39.10381000', '117.22899000', '11:00-14:00', '85', '清真老味', '15202205588', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德大沽路店.png');
INSERT INTO `shops` VALUES ('236', '老姑砂锅南开店', '南开区鞍山西道288号', '39.11234000', '117.17122000', '16:30-24:00', '48', '砂锅豆腐', '13602007799', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老姑砂锅南开店.png');
INSERT INTO `shops` VALUES ('237', '小宝栗子海光寺店', '南开区南京路308号', '39.12075000', '117.18128000', '08:30-19:30', '42', '糖炒栗子买送活动', '022-27452266', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小宝栗子海光寺店.png');
INSERT INTO `shops` VALUES ('238', '南楼煎饼总店', '河西区围堤道', '39.10477000', '117.22361000', '19:00-07:00', '17', '双蛋果篦儿', '13920888899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南楼煎饼总店.png');
INSERT INTO `shops` VALUES ('239', '北李妈妈菜河东店', '河东区万达广场', '39.13245000', '117.24598000', '11:00-22:00', '80', '东北菜9折', '022-24885533', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/北李妈妈菜河东店.png');
INSERT INTO `shops` VALUES ('240', '鸿起顺塘沽店', '滨海新区解放路123号', '39.03218000', '117.66231000', '10:30-22:00', '78', '清真老字号', '022-25886611', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起顺塘沽店.png');
INSERT INTO `shops` VALUES ('241', '登瀛楼开发区店', '滨海新区黄海路', '39.04887000', '117.71321000', '10:30-22:00', '158', '鲁菜特惠', '022-66220099', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼开发区店.png');
INSERT INTO `shops` VALUES ('242', '耳朵眼海河店', '河北区海河东路', '39.15988000', '117.21908000', '09:00-22:00', '25', '炸糕伴手礼', '022-26229900', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼海河店.png');
INSERT INTO `shops` VALUES ('243', '津菜典藏武清店', '武清区光明道288号', '39.38271000', '117.05878000', '10:30-22:00', '155', '园林式餐厅', '022-29447766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津菜典藏武清店.png');
INSERT INTO `shops` VALUES ('244', '桃子餐厅梅江店', '河西区紫金山路', '39.06892000', '117.23198000', '10:30-21:30', '70', '招牌菜特价', '022-88339955', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅梅江店.png');
INSERT INTO `shops` VALUES ('245', '三不馆儿梅江店', '河西区黑牛城道', '39.07554000', '117.24012000', '11:00-22:00', '75', '津味家常', '022-88227711', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三不馆儿梅江店.png');
INSERT INTO `shops` VALUES ('246', '大吉利火锅万德庄店', '南开区万德庄大街108号', '39.12107000', '117.18433000', '11:00-23:00', '95', '手打牛丸特价', '022-87880022', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大吉利火锅万德庄店.png');
INSERT INTO `shops` VALUES ('247', '卫鼎轩东站店', '河东区华兴道88号', '39.13889000', '117.21788000', '10:30-22:30', '125', '火车站旁四合院', '022-24338899', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/卫鼎轩东站店.png');
INSERT INTO `shops` VALUES ('248', '古丽花儿中北镇店', '西青区中北镇万卉路', '39.14818000', '117.09987000', '11:00-22:00', '72', '新疆风味', '022-27997755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/古丽花儿中北镇店.png');
INSERT INTO `shops` VALUES ('249', '恩宏德下瓦房店', '河西区大沽南路', '39.10567000', '117.23122000', '11:00-14:00', '82', '椒盐板筋', '15202201199', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德下瓦房店.png');
INSERT INTO `shops` VALUES ('250', '巷子深河西二店', '河西区桃园村大街', '39.11398000', '117.21905000', '11:30-14:00', '75', '脱骨肘子限量', '13302117788', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/巷子深河西二店.png');
INSERT INTO `shops` VALUES ('251', '桂园餐厅和平总店', '和平区成都道101号', '39.11588000', '117.20162000', '11:00-21:30', '88', '黑蒜子牛肉粒', '022-23321666', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂园餐厅和平总店.png');
INSERT INTO `shops` VALUES ('252', '老爆三红桥店', '红桥区丁字沽三号路', '39.17766000', '117.16211000', '17:00-24:00', '55', '深夜食堂特惠', '13820665599', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老爆三红桥店.png');
INSERT INTO `shops` VALUES ('253', '登瀛楼和平店', '和平区贵阳路', '39.12289000', '117.18907000', '10:30-22:00', '155', '鲁菜老字号', '022-27810088', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼和平店.png');
INSERT INTO `shops` VALUES ('254', '津门十三张西青店', '西青区李七庄地铁站', '39.07188000', '117.16788000', '17:30-02:30', '80', '精酿特惠', '18698007711', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/津门十三张西青店.png');
INSERT INTO `shops` VALUES ('255', '马记烧卖西北角店', '红桥区西关北街', '39.14388000', '117.17762000', '06:30-20:30', '35', '烧卖买三送一', '13920226633', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/马记烧卖西北角店.png');
INSERT INTO `shops` VALUES ('256', '小宝栗子万德庄店', '南开区万德庄大街', '39.11998000', '117.18211000', '08:00-20:00', '42', '冰栗子特供', '022-27451199', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小宝栗子万德庄店.png');
INSERT INTO `shops` VALUES ('257', '天宝隆包子王顶堤店', '南开区艳阳路36号', '39.10533000', '117.15177000', '06:30-19:30', '26', '三鲜包子', '13102207766', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/天宝隆包子王顶堤店.png');
INSERT INTO `shops` VALUES ('258', '宴宾楼塘沽店', '滨海新区福州道', '39.04266000', '117.66545000', '10:30-22:00', '120', '老字号分店', '022-25337755', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宴宾楼塘沽店.png');
INSERT INTO `shops` VALUES ('259', '大铁勺河东店', '河东区津塘路23号', '39.13245000', '117.25021000', '10:30-21:30', '90', '铁勺凤爪', '022-24310066', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大铁勺河东店.png');
INSERT INTO `shops` VALUES ('260', '老城里二姑包子总店分店', '南开区西湖道99号', '39.12299000', '117.16201000', '06:00-20:00', '28', '水馅包子特供', '15822220077', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老城里二姑包子总店分店.png');
INSERT INTO `shops` VALUES ('261', '恩宏德河东店', '河东区华捷道60号', '39.13875000', '117.22187000', '11:00-14:00', '78', '椒盐板筋', '15202202233', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恩宏德河东店.png');
INSERT INTO `shops` VALUES ('262', '桂顺斋西南角店', '南开区南马路', '39.13845000', '117.18221000', '08:00-20:00', '45', '传统糕点', '022-27270033', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桂顺斋西南角店.png');
INSERT INTO `shops` VALUES ('263', '三合益河北店', '河北区金纬路168号', '39.15699000', '117.21455000', '09:00-21:00', '40', '凉皮买二送一', '022-26441122', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/三合益河北店.png');
INSERT INTO `shops` VALUES ('264', '柒號馆小白楼店', '和平区开封道18号', '39.12566000', '117.22201000', '11:00-21:30', '105', '私房菜预约', '18522008800', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/柒號馆小白楼店.png');
INSERT INTO `shops` VALUES ('265', '玉泉饭庄北辰店', '北辰区京津公路', '39.21892000', '117.13233000', '10:30-21:30', '68', '津味老字号', '022-26998855', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/玉泉饭庄北辰店.png');
INSERT INTO `shops` VALUES ('266', '桃子餐厅西青店', '西青区张家窝知景道', '39.05987000', '117.03876000', '10:30-21:00', '65', '八珍豆腐特价', '022-87992211', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/桃子餐厅西青店.png');
INSERT INTO `shops` VALUES ('267', '北李妈妈菜河西店', '河西区乐园道银河', '39.09228000', '117.22045000', '11:00-22:00', '82', '东北菜88折', '022-88337700', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/北李妈妈菜河西店.png');
INSERT INTO `shops` VALUES ('268', '鸿起顺红桥店', '红桥区西关大街', '39.13999000', '117.17311000', '10:30-22:00', '70', '红烧牛尾特惠', '022-27558800', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起顺红桥店.png');
INSERT INTO `shops` VALUES ('269', '登瀛楼北辰店', '北辰区辰昌路', '39.21885000', '117.14122000', '10:30-22:00', '155', '鲁菜特惠', '022-26889966', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/登瀛楼北辰店.png');
INSERT INTO `shops` VALUES ('270', '耳朵眼武清店', '武清区振华西道', '39.39111000', '117.06122000', '09:00-21:30', '25', '炸糕礼品装', '022-29368855', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼武清店.png');
INSERT INTO `shops` VALUES ('271', '小宝栗子北站店', '河北区中山路222号', '39.16187000', '117.20544000', '08:00-20:30', '45', '糖炒栗子买送活动', '022-26238822', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小宝栗子北站店.png');
INSERT INTO `shops` VALUES ('272', '南门烧鸡河西店', '河西区大沽南路', '39.10299000', '117.22877000', '09:00-19:00', '42', '童子鸡特价', '022-28217744', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/南门烧鸡河西店.png');
INSERT INTO `shops` VALUES ('273', '老铁熏鸡南开店', '南开区万德庄大街', '39.12001000', '117.18233000', '08:00-18:00', '45', '熏鸡翅买三送一', '13920219977', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老铁熏鸡南开店.png');
INSERT INTO `shops` VALUES ('274', '鸿起顺塘沽二店', '滨海新区学校大街', '39.02659000', '117.65387000', '10:30-22:00', '75', '红烧牛舌尾特价', '022-25339922', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鸿起顺塘沽二店.png');
INSERT INTO `shops` VALUES ('275', '九河香舍滨海店', '滨海新区开发区三大街', '39.03998000', '117.69221000', '11:00-23:00', '120', '民国主题餐厅', '18622008833', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/九河香舍滨海店.png');
INSERT INTO `shops` VALUES ('276', '宴宾楼南开二店', '南开区宾水西道', '39.09012000', '117.17621000', '10:30-22:00', '125', '老字号分店', '022-23996677', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/宴宾楼南开二店.png');
INSERT INTO `shops` VALUES ('277', '大福来北辰店', '北辰区果园北道', '39.22976000', '117.13782000', '06:00-20:00', '24', '嘎巴菜', '022-26990022', null, '0', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/大福来北辰店.png');

-- ----------------------------
-- Table structure for `shop_ratings`
-- ----------------------------
DROP TABLE IF EXISTS `shop_ratings`;
CREATE TABLE `shop_ratings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `unique_shop_rating` (`shop_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_shop_ratings` (`shop_id`),
  CONSTRAINT `shop_ratings_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`shop_id`) ON DELETE CASCADE,
  CONSTRAINT `shop_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `shop_ratings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Restaurant rating system';

-- ----------------------------
-- Records of shop_ratings
-- ----------------------------
INSERT INTO `shop_ratings` VALUES ('2', '3', '1', '5', '2025-07-23 16:46:15');
INSERT INTO `shop_ratings` VALUES ('4', '2', '1', '4', '2025-07-24 20:46:59');
INSERT INTO `shop_ratings` VALUES ('27', '1', '1', '5', '2025-07-25 09:37:49');
INSERT INTO `shop_ratings` VALUES ('31', '7', '1', '4', '2025-07-25 09:32:45');
INSERT INTO `shop_ratings` VALUES ('32', '58', '7', '4', '2025-07-08 10:28:07');
INSERT INTO `shop_ratings` VALUES ('33', '60', '1', '1', '2025-07-01 10:28:17');
INSERT INTO `shop_ratings` VALUES ('34', '61', '6', '5', '2025-06-11 10:28:22');
INSERT INTO `shop_ratings` VALUES ('35', '45', '6', '4', '2025-07-25 10:28:32');
INSERT INTO `shop_ratings` VALUES ('36', '46', '4', '4', '2025-07-25 10:28:46');
INSERT INTO `shop_ratings` VALUES ('37', '38', '2', '2', '2025-07-14 10:28:50');
INSERT INTO `shop_ratings` VALUES ('38', '93', '3', '5', '2025-07-01 10:28:54');
INSERT INTO `shop_ratings` VALUES ('39', '14', '4', '1', '2025-06-03 10:29:08');
INSERT INTO `shop_ratings` VALUES ('40', '47', '4', '1', '2025-07-01 10:29:15');
INSERT INTO `shop_ratings` VALUES ('41', '44', '2', '1', '2025-07-25 10:29:20');
INSERT INTO `shop_ratings` VALUES ('42', '74', '7', '3', '2025-07-05 10:29:24');
INSERT INTO `shop_ratings` VALUES ('43', '100', '5', '1', '2025-07-01 10:29:37');
INSERT INTO `shop_ratings` VALUES ('44', '43', '5', '1', null);
INSERT INTO `shop_ratings` VALUES ('45', '24', '2', '1', null);
INSERT INTO `shop_ratings` VALUES ('46', '96', '4', '3', null);
INSERT INTO `shop_ratings` VALUES ('47', '63', '7', '2', null);
INSERT INTO `shop_ratings` VALUES ('48', '85', '2', '4', null);
INSERT INTO `shop_ratings` VALUES ('49', '11', '2', '1', null);
INSERT INTO `shop_ratings` VALUES ('50', '46', '7', '5', null);
INSERT INTO `shop_ratings` VALUES ('51', '84', '2', '2', null);
INSERT INTO `shop_ratings` VALUES ('52', '58', '2', '5', null);
INSERT INTO `shop_ratings` VALUES ('53', '90', '5', '2', null);
INSERT INTO `shop_ratings` VALUES ('54', '94', '1', '3', null);
INSERT INTO `shop_ratings` VALUES ('55', '34', '6', '4', null);
INSERT INTO `shop_ratings` VALUES ('56', '72', '1', '2', null);
INSERT INTO `shop_ratings` VALUES ('57', '55', '5', '1', null);
INSERT INTO `shop_ratings` VALUES ('58', '18', '5', '5', null);
INSERT INTO `shop_ratings` VALUES ('59', '48', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('60', '43', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('61', '15', '4', '4', null);
INSERT INTO `shop_ratings` VALUES ('62', '66', '7', '4', null);
INSERT INTO `shop_ratings` VALUES ('63', '64', '9', '4', null);
INSERT INTO `shop_ratings` VALUES ('64', '19', '5', '1', null);
INSERT INTO `shop_ratings` VALUES ('65', '59', '7', '4', null);
INSERT INTO `shop_ratings` VALUES ('66', '66', '9', '4', null);
INSERT INTO `shop_ratings` VALUES ('67', '103', '5', '3', null);
INSERT INTO `shop_ratings` VALUES ('68', '78', '9', '1', null);
INSERT INTO `shop_ratings` VALUES ('69', '101', '4', '3', null);
INSERT INTO `shop_ratings` VALUES ('70', '103', '7', '4', null);
INSERT INTO `shop_ratings` VALUES ('71', '19', '1', '1', null);
INSERT INTO `shop_ratings` VALUES ('72', '68', '7', '5', null);
INSERT INTO `shop_ratings` VALUES ('73', '12', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('74', '97', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('75', '78', '8', '1', null);
INSERT INTO `shop_ratings` VALUES ('76', '73', '9', '4', null);
INSERT INTO `shop_ratings` VALUES ('77', '69', '3', '2', null);
INSERT INTO `shop_ratings` VALUES ('78', '65', '4', '3', null);
INSERT INTO `shop_ratings` VALUES ('79', '83', '9', '4', null);
INSERT INTO `shop_ratings` VALUES ('80', '64', '3', '3', null);
INSERT INTO `shop_ratings` VALUES ('81', '71', '6', '2', null);
INSERT INTO `shop_ratings` VALUES ('82', '55', '8', '1', null);
INSERT INTO `shop_ratings` VALUES ('83', '35', '7', '5', null);
INSERT INTO `shop_ratings` VALUES ('84', '36', '5', '3', null);
INSERT INTO `shop_ratings` VALUES ('85', '12', '2', '1', null);
INSERT INTO `shop_ratings` VALUES ('86', '51', '2', '2', null);
INSERT INTO `shop_ratings` VALUES ('87', '74', '8', '2', null);
INSERT INTO `shop_ratings` VALUES ('88', '91', '7', '2', null);
INSERT INTO `shop_ratings` VALUES ('89', '19', '7', '2', null);
INSERT INTO `shop_ratings` VALUES ('90', '88', '2', '4', null);
INSERT INTO `shop_ratings` VALUES ('91', '75', '3', '2', null);
INSERT INTO `shop_ratings` VALUES ('95', '74', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('96', '76', '3', '2', null);
INSERT INTO `shop_ratings` VALUES ('97', '13', '2', '2', null);
INSERT INTO `shop_ratings` VALUES ('98', '35', '5', '3', null);
INSERT INTO `shop_ratings` VALUES ('99', '96', '8', '2', null);
INSERT INTO `shop_ratings` VALUES ('100', '105', '5', '5', null);
INSERT INTO `shop_ratings` VALUES ('101', '85', '4', '1', null);
INSERT INTO `shop_ratings` VALUES ('102', '88', '3', '4', null);
INSERT INTO `shop_ratings` VALUES ('103', '66', '1', '4', null);
INSERT INTO `shop_ratings` VALUES ('104', '32', '5', '4', null);
INSERT INTO `shop_ratings` VALUES ('105', '87', '5', '1', null);
INSERT INTO `shop_ratings` VALUES ('106', '56', '6', '5', null);
INSERT INTO `shop_ratings` VALUES ('107', '73', '7', '2', null);
INSERT INTO `shop_ratings` VALUES ('108', '84', '9', '4', null);
INSERT INTO `shop_ratings` VALUES ('109', '10', '1', '3', null);
INSERT INTO `shop_ratings` VALUES ('110', '55', '6', '3', null);
INSERT INTO `shop_ratings` VALUES ('111', '31', '1', '3', null);
INSERT INTO `shop_ratings` VALUES ('112', '41', '7', '2', null);
INSERT INTO `shop_ratings` VALUES ('113', '69', '8', '4', null);
INSERT INTO `shop_ratings` VALUES ('117', '99', '1', '3', null);
INSERT INTO `shop_ratings` VALUES ('118', '67', '2', '2', null);
INSERT INTO `shop_ratings` VALUES ('119', '76', '6', '4', null);
INSERT INTO `shop_ratings` VALUES ('120', '36', '7', '2', null);

-- ----------------------------
-- Table structure for `special_dishes`
-- ----------------------------
DROP TABLE IF EXISTS `special_dishes`;
CREATE TABLE `special_dishes` (
  `dish_id` int NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(50) NOT NULL,
  `description` text COMMENT 'Description of the dish',
  `origin_region` varchar(50) DEFAULT NULL COMMENT 'Regional origin of the dish',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `popularity` int DEFAULT '0' COMMENT 'Cached popularity score',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`dish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Specialty dishes table';

-- ----------------------------
-- Records of special_dishes
-- ----------------------------
INSERT INTO `special_dishes` VALUES ('1', '狗不理包子', '天津传统名点，始创于1858年，以选料精细、制作工艺严格著称，褶花匀称，肥而不腻。', '天津', '2025-07-17 15:30:31', '80', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/狗不理包子.jpg');
INSERT INTO `special_dishes` VALUES ('2', '十八街麻花', '酥脆香甜，久存不绵，有\"酥脆香甜、久存不绵\"的特点，是天津著名的传统小吃。', '天津', '2025-07-17 15:44:57', '85', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/十八街麻花.jpg');
INSERT INTO `special_dishes` VALUES ('3', '耳朵眼炸糕', '外皮酥脆，内馅香甜，是天津的传统小吃。', '天津', '2025-07-24 11:45:34', '80', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼炸糕.jpg');
INSERT INTO `special_dishes` VALUES ('4', '锅巴菜', '以绿豆、小米为原料，色泽金黄，口感咸香。', '天津', '2025-07-24 11:47:48', '89', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/锅巴菜.jpg');
INSERT INTO `special_dishes` VALUES ('5', '糖炒栗子', '栗子香甜软糯，秋冬季节街头常见的美味。', '天津', '2025-07-24 11:48:25', '86', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/糖炒栗子.jpg');
INSERT INTO `special_dishes` VALUES ('6', '老豆腐', '豆腐嫩滑，卤汁香浓，是天津人早餐的常见选择。', '天津', '2025-07-24 11:48:43', '85', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/老豆腐.jpg');
INSERT INTO `special_dishes` VALUES ('7', '卷圈', '外皮酥脆，内馅丰富，是天津的特色小吃。', '天津', '2025-07-24 11:53:49', '87', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/耳朵眼炸糕.jpg');

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Hashed user password',
  `avatar_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User information table';

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'Man', '111111m', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/QQ.png', '2025-07-17 10:24:39', '2025-07-25 09:30:49');
INSERT INTO `users` VALUES ('2', 'Pick', '1029384756', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/小狗.png', '2025-07-19 18:33:16', '2025-07-21 11:40:36');
INSERT INTO `users` VALUES ('3', '理性讨论', '10qoakzmpl,A', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/西瓜.png', '2025-07-19 21:03:43', '2025-07-19 21:12:54');
INSERT INTO `users` VALUES ('4', '疯狂星期四', '111111zz', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/恐龙.png', '2025-07-22 17:22:23', '2025-07-22 18:14:26');
INSERT INTO `users` VALUES ('5', 'A.Song', '111111a', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/饭盒.jpg', '2025-07-24 16:31:36', '2025-07-24 20:36:49');
INSERT INTO `users` VALUES ('6', '曦诺', '000000m', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/鳄鱼.jpg', '2025-07-24 16:31:57', null);
INSERT INTO `users` VALUES ('7', 'Shake', '222222m', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/汉堡.jpg', '2025-07-24 16:32:10', null);
INSERT INTO `users` VALUES ('8', '美食助手', '102938m', 'https://raw.githubusercontent.com/Alan-Soong/project_img/main/狐狸.jpg', '2025-07-24 16:32:35', null);
INSERT INTO `users` VALUES ('9', '123456', '123456ab', null, '2025-07-24 20:54:36', '2025-07-24 20:54:50');
