/*==============================================================*/
/* Table: Users                                                 */
/*==============================================================*/
CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(20) NOT NULL UNIQUE,
  avatar_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL
) COMMENT 'User table';

/*==============================================================*/
/* Table: Shops                                                 */
/*==============================================================*/
CREATE TABLE Shops (
  shop_id INT AUTO_INCREMENT PRIMARY KEY,
  shop_name VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  latitude DECIMAL(10,8) NOT NULL COMMENT 'Latitude',
  longitude DECIMAL(10,8) NOT NULL COMMENT 'Longitude',
  business_hours VARCHAR(50) COMMENT 'Business hours',
  avg_price INT COMMENT 'Average spend per person (in cents)',
  discount_info TEXT COMMENT 'Discount information',
  contact_phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Shop table';

/*==============================================================*/
/* Table: Special_Dishes                                        */
/*==============================================================*/
CREATE TABLE Special_Dishes (
  dish_id INT AUTO_INCREMENT PRIMARY KEY,
  dish_name VARCHAR(50) NOT NULL,
  description TEXT COMMENT 'Dish description',
  origin_region VARCHAR(50) COMMENT 'Cuisine region',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  popularity INT DEFAULT 0 COMMENT 'Popularity index (cached value)'
) COMMENT 'Special dishes table';

/*==============================================================*/
/* Table: Posts                                                 */
/*==============================================================*/
CREATE TABLE Posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  visibility ENUM('PUBLIC', 'PRIVATE', 'FRIENDS_ONLY') DEFAULT 'PUBLIC',
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) COMMENT 'User posts table';

/*==============================================================*/
/* Table: Reviews                                               */
/*==============================================================*/
CREATE TABLE Reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  target_type ENUM('SHOP', 'POST', 'DISH') NOT NULL COMMENT 'Type of target being reviewed',
  target_id INT NOT NULL COMMENT 'ID of the associated object',
  parent_review_id INT NULL COMMENT 'Parent review ID if replying to another review',
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (parent_review_id) REFERENCES Reviews(review_id) ON DELETE CASCADE
) COMMENT 'Reviews table (supports multi-level replies)';

/*==============================================================*/
/* Table: Likes                                                 */
/*==============================================================*/
CREATE TABLE Likes (
  like_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  target_type ENUM('POST', 'REVIEW', 'DISH') NOT NULL COMMENT 'Type of target being liked',
  target_id INT NOT NULL COMMENT 'ID of the associated object',
  liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_like (user_id, target_type, target_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) COMMENT 'Unified likes table';

/*==============================================================*/
/* Table: Shop_Ratings                                          */
/*==============================================================*/
CREATE TABLE Shop_Ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  shop_id INT NOT NULL,
  user_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (shop_id) REFERENCES Shops(shop_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  UNIQUE KEY unique_shop_rating (shop_id, user_id)
) COMMENT 'Shop rating table';

/*==============================================================*/
/* Table: Dish_Ratings                                          */
/*==============================================================*/
CREATE TABLE Dish_Ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  dish_id INT NOT NULL,
  user_id INT NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (dish_id) REFERENCES Special_Dishes(dish_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  UNIQUE KEY unique_dish_rating (dish_id, user_id)
) COMMENT 'Dish rating table';

/*==============================================================*/
/* Index optimization                                           */
/*==============================================================*/
CREATE INDEX idx_reviews_target ON Reviews(target_type, target_id);
CREATE INDEX idx_likes_target ON Likes(target_type, target_id);
CREATE INDEX idx_shop_ratings ON Shop_Ratings(shop_id);
CREATE INDEX idx_dish_ratings ON Dish_Ratings(dish_id);
