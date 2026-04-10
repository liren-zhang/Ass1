/*
 Navicat Premium Data Transfer

 Source Server         : LocalDatabase_School
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : ass1_db

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 10/04/2026 23:12:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ass1_cart
-- ----------------------------
DROP TABLE IF EXISTS `ass1_cart`;
CREATE TABLE `ass1_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `ass1_cart_user_id_a419169f_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ass1_cart
-- ----------------------------
INSERT INTO `ass1_cart` VALUES (1, '2026-04-08 08:46:14.427440', '2026-04-08 08:46:14.427481', 1);
INSERT INTO `ass1_cart` VALUES (2, '2026-04-10 10:43:33.592875', '2026-04-10 10:43:33.592896', 2);
INSERT INTO `ass1_cart` VALUES (3, '2026-04-10 10:43:34.866810', '2026-04-10 10:43:34.866828', 3);

-- ----------------------------
-- Table structure for ass1_cartitem
-- ----------------------------
DROP TABLE IF EXISTS `ass1_cartitem`;
CREATE TABLE `ass1_cartitem`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int UNSIGNED NOT NULL,
  `cart_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ass1_cartitem_cart_id_product_id_f5250329_uniq`(`cart_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `ass1_cartitem_product_id_cd470559_fk_ass1_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `ass1_cartitem_cart_id_4d3082f2_fk_ass1_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `ass1_cart` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ass1_cartitem_product_id_cd470559_fk_ass1_product_id` FOREIGN KEY (`product_id`) REFERENCES `ass1_product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ass1_cartitem_chk_1` CHECK (`quantity` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ass1_cartitem
-- ----------------------------
INSERT INTO `ass1_cartitem` VALUES (4, 2, 2, 2);
INSERT INTO `ass1_cartitem` VALUES (5, 1, 3, 2);
INSERT INTO `ass1_cartitem` VALUES (7, 1, 2, 3);
INSERT INTO `ass1_cartitem` VALUES (8, 1, 3, 6);
INSERT INTO `ass1_cartitem` VALUES (9, 1, 3, 5);

-- ----------------------------
-- Table structure for ass1_product
-- ----------------------------
DROP TABLE IF EXISTS `ass1_product`;
CREATE TABLE `ass1_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `stock` int UNSIGNED NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `ass1_product_chk_1` CHECK (`stock` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ass1_product
-- ----------------------------
INSERT INTO `ass1_product` VALUES (2, 'product1', 199.00, 'Test product', '', 50, '2026-04-07 16:32:01.676888');
INSERT INTO `ass1_product` VALUES (3, 'Laptop', 999.99, 'High performance laptop', NULL, 10, '2026-04-10 23:11:16.000000');
INSERT INTO `ass1_product` VALUES (4, 'Mouse', 25.50, 'Wireless mouse', NULL, 50, '2026-04-10 23:11:16.000000');
INSERT INTO `ass1_product` VALUES (5, 'Keyboard', 45.00, 'Mechanical keyboard', NULL, 30, '2026-04-10 23:11:16.000000');
INSERT INTO `ass1_product` VALUES (6, 'Monitor', 199.99, '27 inch 4K monitor', NULL, 15, '2026-04-10 23:11:16.000000');
INSERT INTO `ass1_product` VALUES (7, 'Headphones', 79.99, 'Noise cancelling headphones', NULL, 25, '2026-04-10 23:11:16.000000');

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 3, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 3, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 3, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 3, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 2, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 2, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 2, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 2, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add 购物车', 7, 'add_cart');
INSERT INTO `auth_permission` VALUES (26, 'Can change 购物车', 7, 'change_cart');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 购物车', 7, 'delete_cart');
INSERT INTO `auth_permission` VALUES (28, 'Can view 购物车', 7, 'view_cart');
INSERT INTO `auth_permission` VALUES (29, 'Can add 购物车项', 8, 'add_cartitem');
INSERT INTO `auth_permission` VALUES (30, 'Can change 购物车项', 8, 'change_cartitem');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 购物车项', 8, 'delete_cartitem');
INSERT INTO `auth_permission` VALUES (32, 'Can view 购物车项', 8, 'view_cartitem');
INSERT INTO `auth_permission` VALUES (33, 'Can add 商品', 9, 'add_product');
INSERT INTO `auth_permission` VALUES (34, 'Can change 商品', 9, 'change_product');
INSERT INTO `auth_permission` VALUES (35, 'Can delete 商品', 9, 'delete_product');
INSERT INTO `auth_permission` VALUES (36, 'Can view 商品', 9, 'view_product');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$1200000$28ZRUZ2WpLHYq6tk1QZ5Ir$O5a6Jf6tgFjmdocIajSa4T4h0tSNRlUKQtB0OwbbCGw=', '2026-04-04 15:08:05.573211', 1, 'admin', '', '', '', 1, 1, '2026-04-03 06:51:05.315657');
INSERT INTO `auth_user` VALUES (2, 'pbkdf2_sha256$1200000$CHSFUqDmbFJiEhsWCzsMqj$bo3sKLuQB7ZzIeBRVSbP0+6ZnYdoKbWpd4+T72RPZ4A=', NULL, 0, 'USER', '', '', '', 0, 1, '2026-04-10 10:32:51.956751');
INSERT INTO `auth_user` VALUES (3, 'pbkdf2_sha256$1200000$su0zmoNRW8ClHliCHyySMb$xoENYmoKxpS4j9qRxK5LQg1RGGismdwulthUj0irl1g=', NULL, 0, 'USER1', '', '', '', 0, 1, '2026-04-10 10:43:13.783080');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2026-04-10 10:32:52.451769', '2', 'USER', 1, '[{\"added\": {}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (2, '2026-04-10 10:43:14.264115', '3', 'USER1', 1, '[{\"added\": {}}]', 4, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (7, 'ass1', 'cart');
INSERT INTO `django_content_type` VALUES (8, 'ass1', 'cartitem');
INSERT INTO `django_content_type` VALUES (9, 'ass1', 'product');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2026-04-03 06:50:02.340547');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2026-04-03 06:50:03.983281');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2026-04-03 06:50:04.334144');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2026-04-03 06:50:04.345473');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2026-04-03 06:50:04.357940');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2026-04-03 06:50:04.583571');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2026-04-03 06:50:04.720098');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2026-04-03 06:50:04.748580');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2026-04-03 06:50:04.759838');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2026-04-03 06:50:04.866280');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2026-04-03 06:50:04.877324');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2026-04-03 06:50:04.887838');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2026-04-03 06:50:05.032285');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2026-04-03 06:50:05.183758');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2026-04-03 06:50:05.223739');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2026-04-03 06:50:05.240493');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2026-04-03 06:50:05.387914');
INSERT INTO `django_migrations` VALUES (18, 'sessions', '0001_initial', '2026-04-03 06:50:05.486170');
INSERT INTO `django_migrations` VALUES (19, 'ass1', '0001_initial', '2026-04-04 14:51:22.105225');
INSERT INTO `django_migrations` VALUES (20, 'ass1', '0002_alter_cart_options_alter_cartitem_options_and_more', '2026-04-04 16:30:45.768666');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('0fzaahln6rp4uyjzkix6jmdwb7wte5xa', '.eJxVjEEOwiAQRe_C2pDCwARcuvcMZBioVA0kpV013t026UK3_733NxFoXUpYe57DlMRVKHH53SLxK9cDpCfVR5Pc6jJPUR6KPGmX95by-3a6fweFetlrawEBnR7RM-cEJmscYSBMalBqyGwUGEaDhggieO8Mj9rvmKKN1onPF8Q5Nzs:1w92bV:PEUj7RO5_B1NvqmsGK-KJHoHuy65Y5mMopMkqlpvGiE', '2026-04-18 15:08:05.586261');

SET FOREIGN_KEY_CHECKS = 1;
