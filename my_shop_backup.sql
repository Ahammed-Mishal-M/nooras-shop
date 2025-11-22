-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               12.0.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for dress_shop_db
CREATE DATABASE IF NOT EXISTS `dress_shop_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `dress_shop_db`;

-- Dumping structure for table dress_shop_db.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_group: ~0 rows (approximately)

-- Dumping structure for table dress_shop_db.auth_group_permissions
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_group_permissions: ~0 rows (approximately)

-- Dumping structure for table dress_shop_db.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_permission: ~60 rows (approximately)
INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add log entry', 1, 'add_logentry'),
	(2, 'Can change log entry', 1, 'change_logentry'),
	(3, 'Can delete log entry', 1, 'delete_logentry'),
	(4, 'Can view log entry', 1, 'view_logentry'),
	(5, 'Can add permission', 2, 'add_permission'),
	(6, 'Can change permission', 2, 'change_permission'),
	(7, 'Can delete permission', 2, 'delete_permission'),
	(8, 'Can view permission', 2, 'view_permission'),
	(9, 'Can add group', 3, 'add_group'),
	(10, 'Can change group', 3, 'change_group'),
	(11, 'Can delete group', 3, 'delete_group'),
	(12, 'Can view group', 3, 'view_group'),
	(13, 'Can add user', 4, 'add_user'),
	(14, 'Can change user', 4, 'change_user'),
	(15, 'Can delete user', 4, 'delete_user'),
	(16, 'Can view user', 4, 'view_user'),
	(17, 'Can add content type', 5, 'add_contenttype'),
	(18, 'Can change content type', 5, 'change_contenttype'),
	(19, 'Can delete content type', 5, 'delete_contenttype'),
	(20, 'Can view content type', 5, 'view_contenttype'),
	(21, 'Can add session', 6, 'add_session'),
	(22, 'Can change session', 6, 'change_session'),
	(23, 'Can delete session', 6, 'delete_session'),
	(24, 'Can view session', 6, 'view_session'),
	(25, 'Can add category', 7, 'add_category'),
	(26, 'Can change category', 7, 'change_category'),
	(27, 'Can delete category', 7, 'delete_category'),
	(28, 'Can view category', 7, 'view_category'),
	(29, 'Can add color', 8, 'add_color'),
	(30, 'Can change color', 8, 'change_color'),
	(31, 'Can delete color', 8, 'delete_color'),
	(32, 'Can view color', 8, 'view_color'),
	(33, 'Can add size', 9, 'add_size'),
	(34, 'Can change size', 9, 'change_size'),
	(35, 'Can delete size', 9, 'delete_size'),
	(36, 'Can view size', 9, 'view_size'),
	(37, 'Can add product', 10, 'add_product'),
	(38, 'Can change product', 10, 'change_product'),
	(39, 'Can delete product', 10, 'delete_product'),
	(40, 'Can view product', 10, 'view_product'),
	(41, 'Can add product image', 11, 'add_productimage'),
	(42, 'Can change product image', 11, 'change_productimage'),
	(43, 'Can delete product image', 11, 'delete_productimage'),
	(44, 'Can view product image', 11, 'view_productimage'),
	(45, 'Can add product variant', 12, 'add_productvariant'),
	(46, 'Can change product variant', 12, 'change_productvariant'),
	(47, 'Can delete product variant', 12, 'delete_productvariant'),
	(48, 'Can view product variant', 12, 'view_productvariant'),
	(49, 'Can add cart item', 13, 'add_cartitem'),
	(50, 'Can change cart item', 13, 'change_cartitem'),
	(51, 'Can delete cart item', 13, 'delete_cartitem'),
	(52, 'Can view cart item', 13, 'view_cartitem'),
	(53, 'Can add order item', 14, 'add_orderitem'),
	(54, 'Can change order item', 14, 'change_orderitem'),
	(55, 'Can delete order item', 14, 'delete_orderitem'),
	(56, 'Can view order item', 14, 'view_orderitem'),
	(57, 'Can add order', 15, 'add_order'),
	(58, 'Can change order', 15, 'change_order'),
	(59, 'Can delete order', 15, 'delete_order'),
	(60, 'Can view order', 15, 'view_order');

-- Dumping structure for table dress_shop_db.auth_user
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_user: ~2 rows (approximately)
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$1000000$mfNv6r3FHwgBVcaSClEfix$sRZ6FYqaqX2wUBFoxwVe9vJDgTQJxCGtdSPFodoWOxs=', '2025-11-22 06:06:11.055719', 1, 'noora', '', '', '', 1, 1, '2025-11-17 12:01:54.726437'),
	(2, 'pbkdf2_sha256$1000000$pBvnanejGSHhvw0IAHLfiz$T5wTUP/dKyzZRzB1LWED9ZsoBj3zKl6/Qbe2j/P1W6o=', '2025-11-22 05:48:16.914756', 0, 'mishal123', 'Ahammed', 'Mishal M', 'ahmedmishal246@gmail.com', 0, 1, '2025-11-18 07:04:51.000000');

-- Dumping structure for table dress_shop_db.auth_user_groups
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_user_groups: ~0 rows (approximately)

-- Dumping structure for table dress_shop_db.auth_user_user_permissions
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.auth_user_user_permissions: ~0 rows (approximately)

-- Dumping structure for table dress_shop_db.django_admin_log
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.django_admin_log: ~82 rows (approximately)
INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2025-11-17 12:04:29.557422', '1', 'Party Wears', 1, '[{"added": {}}]', 7, 1),
	(2, '2025-11-17 12:04:42.010770', '2', 'Western Wears', 1, '[{"added": {}}]', 7, 1),
	(3, '2025-11-17 12:04:55.742804', '3', 'Casual Wears', 1, '[{"added": {}}]', 7, 1),
	(4, '2025-11-17 12:05:07.625315', '4', 'Essentials', 1, '[{"added": {}}]', 7, 1),
	(5, '2025-11-17 12:09:53.323310', '1', 'S', 1, '[{"added": {}}]', 9, 1),
	(6, '2025-11-17 12:10:01.606710', '2', 'L', 1, '[{"added": {}}]', 9, 1),
	(7, '2025-11-17 12:10:10.452080', '3', 'M', 1, '[{"added": {}}]', 9, 1),
	(8, '2025-11-17 12:10:52.605348', '1', 'RED', 1, '[{"added": {}}]', 8, 1),
	(9, '2025-11-17 12:11:00.522120', '2', 'GREEN', 1, '[{"added": {}}]', 8, 1),
	(10, '2025-11-17 12:12:35.298351', '1', '"Lilac Shimmer" Sharara Set', 1, '[{"added": {}}, {"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"added": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - S / RED (2 in stock)"}}, {"added": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - S / GREEN (3 in stock)"}}, {"added": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - M / GREEN (4 in stock)"}}, {"added": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - L / RED (2 in stock)"}}]', 10, 1),
	(11, '2025-11-17 12:19:46.055740', '1', '"Lilac Shimmer" Sharara Set', 2, '[]', 10, 1),
	(12, '2025-11-18 06:30:59.826123', '4', 'Premium Section', 2, '[{"changed": {"fields": ["Name", "Description", "Slug"]}}]', 7, 1),
	(13, '2025-11-19 09:28:29.040621', '9', 'Ahammed', 3, '', 15, 1),
	(14, '2025-11-19 09:28:29.040621', '8', 'Ahammed', 3, '', 15, 1),
	(15, '2025-11-19 09:28:29.040621', '7', 'Ahammed', 3, '', 15, 1),
	(16, '2025-11-19 09:28:29.040621', '6', 'Ahammed', 3, '', 15, 1),
	(17, '2025-11-19 09:28:29.040621', '5', 'Ahammed', 3, '', 15, 1),
	(18, '2025-11-19 09:28:29.040621', '4', 'Ahammed', 3, '', 15, 1),
	(19, '2025-11-19 09:28:29.040621', '3', 'Ahammed', 3, '', 15, 1),
	(20, '2025-11-19 09:28:29.040621', '2', 'Ahammed', 3, '', 15, 1),
	(21, '2025-11-19 09:28:29.040621', '1', 'Ahammed', 3, '', 15, 1),
	(22, '2025-11-19 09:43:14.509815', '12', 'Ahammed', 3, '', 15, 1),
	(23, '2025-11-19 09:43:14.509815', '11', 'Ahammed', 3, '', 15, 1),
	(24, '2025-11-19 09:43:14.509815', '10', 'Ahammed', 3, '', 15, 1),
	(25, '2025-11-19 09:44:55.361390', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"changed": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - M / GREEN (1 in stock)", "fields": ["Stock"]}}]', 10, 1),
	(26, '2025-11-19 09:48:42.529790', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"changed": {"name": "product variant", "object": "\\"Lilac Shimmer\\" Sharara Set - M / GREEN (0 in stock)", "fields": ["Stock"]}}]', 10, 1),
	(27, '2025-11-19 09:49:28.652402', '1', '"Lilac Shimmer" Sharara Set', 2, '[]', 10, 1),
	(28, '2025-11-19 09:55:07.154973', '3', '"Lilac Shimmer" Sharara Set - M / GREEN (5 in stock)', 2, '[{"changed": {"fields": ["Stock"]}}]', 12, 1),
	(29, '2025-11-19 10:21:13.756269', '14', 'Ahammed', 3, '', 15, 1),
	(30, '2025-11-19 10:21:13.756269', '13', 'Ahammed', 3, '', 15, 1),
	(31, '2025-11-19 10:22:02.870843', '4', 'XS', 1, '[{"added": {}}]', 9, 1),
	(32, '2025-11-19 10:22:11.354770', '5', 'XL', 1, '[{"added": {}}]', 9, 1),
	(33, '2025-11-19 10:22:15.150895', '6', 'XXL', 1, '[{"added": {}}]', 9, 1),
	(34, '2025-11-19 10:22:26.029147', '3', 'BLUE', 1, '[{"added": {}}]', 8, 1),
	(35, '2025-11-19 10:22:35.710166', '4', 'BLACK', 1, '[{"added": {}}]', 8, 1),
	(36, '2025-11-19 10:22:44.672925', '5', 'PINK', 1, '[{"added": {}}]', 8, 1),
	(37, '2025-11-20 06:29:40.393523', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}]', 10, 1),
	(38, '2025-11-20 06:30:38.077289', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"added": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}]', 10, 1),
	(39, '2025-11-20 06:31:31.803728', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"deleted": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"deleted": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"deleted": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}, {"deleted": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}]', 10, 1),
	(40, '2025-11-20 06:31:46.078766', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"deleted": {"name": "product image", "object": "Image for \\"Lilac Shimmer\\" Sharara Set"}}]', 10, 1),
	(41, '2025-11-20 06:39:45.352762', '16', 'Ahammed', 2, '[{"changed": {"fields": ["Status"]}}]', 15, 1),
	(42, '2025-11-20 08:03:17.904484', '2', 'mishal123', 2, '[{"changed": {"fields": ["Email address"]}}]', 4, 1),
	(43, '2025-11-20 08:05:36.202168', '17', 'Ahammed', 2, '[{"changed": {"fields": ["Status"]}}]', 15, 1),
	(44, '2025-11-20 08:06:45.116025', '15', 'Ahammed', 2, '[{"changed": {"fields": ["Status"]}}]', 15, 1),
	(45, '2025-11-20 08:26:56.778396', '18', 'Ahammed', 2, '[{"changed": {"fields": ["Status"]}}]', 15, 1),
	(46, '2025-11-20 11:00:45.977958', '1', '"Lilac Shimmer" Sharara Set', 2, '[{"changed": {"fields": ["Is featured"]}}]', 10, 1),
	(47, '2025-11-20 12:30:14.086310', '21', 'Ahammed', 3, '', 15, 1),
	(48, '2025-11-20 12:30:14.086310', '20', 'Ahammed', 3, '', 15, 1),
	(49, '2025-11-20 12:30:14.086310', '19', 'Ahammed', 3, '', 15, 1),
	(50, '2025-11-20 12:30:14.086310', '18', 'Ahammed', 3, '', 15, 1),
	(51, '2025-11-20 12:30:14.086310', '17', 'Ahammed', 3, '', 15, 1),
	(52, '2025-11-20 12:30:14.086310', '16', 'Ahammed', 3, '', 15, 1),
	(53, '2025-11-20 12:30:14.086310', '15', 'Ahammed', 3, '', 15, 1),
	(54, '2025-11-20 12:32:27.805241', '4', '"Lilac Shimmer" Sharara Set - L / RED (4 in stock)', 2, '[{"changed": {"fields": ["Stock"]}}]', 12, 1),
	(55, '2025-11-20 12:32:27.811244', '3', '"Lilac Shimmer" Sharara Set - M / GREEN (4 in stock)', 2, '[{"changed": {"fields": ["Stock"]}}]', 12, 1),
	(56, '2025-11-20 12:32:27.816346', '2', '"Lilac Shimmer" Sharara Set - S / GREEN (4 in stock)', 2, '[{"changed": {"fields": ["Stock"]}}]', 12, 1),
	(57, '2025-11-20 12:32:27.821343', '1', '"Lilac Shimmer" Sharara Set - S / RED (4 in stock)', 2, '[{"changed": {"fields": ["Stock"]}}]', 12, 1),
	(58, '2025-11-21 10:18:52.941352', '2', 'Royal Mustard Floral Sharara Set', 1, '[{"added": {}}]', 10, 1),
	(59, '2025-11-21 10:22:09.258596', '2', 'Royal Mustard Floral Sharara Set', 2, '[{"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - S / GREEN (5 in stock)"}}, {"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - S / BLUE (5 in stock)"}}, {"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - S / PINK (5 in stock)"}}, {"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - M / GREEN (4 in stock)"}}, {"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - M / BLUE (3 in stock)"}}, {"added": {"name": "product variant", "object": "Royal Mustard Floral Sharara Set - M / PINK (3 in stock)"}}]', 10, 1),
	(60, '2025-11-21 10:24:40.840119', '3', 'Ethereal Lilac Shimmer Sharara', 1, '[{"added": {}}, {"added": {"name": "product variant", "object": "Ethereal Lilac Shimmer Sharara - S / BLUE (3 in stock)"}}, {"added": {"name": "product variant", "object": "Ethereal Lilac Shimmer Sharara - S / BLACK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Ethereal Lilac Shimmer Sharara - M / PINK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Ethereal Lilac Shimmer Sharara - M / RED (4 in stock)"}}]', 10, 1),
	(61, '2025-11-21 10:46:40.722160', '6', 'Candy Stripe Breeze Cotton Shirt', 2, '[{"changed": {"fields": ["Thumbnail"]}}]', 10, 1),
	(62, '2025-11-21 10:46:56.592841', '5', 'Vivid Magenta Pop Oversized Shirt', 2, '[{"changed": {"fields": ["Thumbnail"]}}]', 10, 1),
	(63, '2025-11-21 10:47:06.430737', '4', 'Urban Chic Cocoa Wide-Leg Set', 2, '[{"changed": {"fields": ["Thumbnail"]}}]', 10, 1),
	(64, '2025-11-21 10:48:53.522933', '4', 'Urban Chic Cocoa Wide-Leg Set', 2, '[{"added": {"name": "product variant", "object": "Urban Chic Cocoa Wide-Leg Set - S / BLACK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Urban Chic Cocoa Wide-Leg Set - M / BLACK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Urban Chic Cocoa Wide-Leg Set - L / BLACK (0 in stock)"}}]', 10, 1),
	(65, '2025-11-21 10:49:23.606985', '6', 'MAGENTA', 1, '[{"added": {}}]', 8, 1),
	(66, '2025-11-21 10:49:57.785807', '5', 'Vivid Magenta Pop Oversized Shirt', 2, '[{"added": {"name": "product variant", "object": "Vivid Magenta Pop Oversized Shirt - S / MAGENTA (4 in stock)"}}, {"added": {"name": "product variant", "object": "Vivid Magenta Pop Oversized Shirt - M / MAGENTA (2 in stock)"}}]', 10, 1),
	(67, '2025-11-21 10:50:36.129383', '6', 'Candy Stripe Breeze Cotton Shirt', 2, '[{"added": {"name": "product variant", "object": "Candy Stripe Breeze Cotton Shirt - S / PINK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Candy Stripe Breeze Cotton Shirt - M / PINK (3 in stock)"}}]', 10, 1),
	(68, '2025-11-21 10:51:17.604079', '4', 'Urban Chic Cocoa Wide-Leg Set', 2, '[{"changed": {"fields": ["Is featured"]}}]', 10, 1),
	(69, '2025-11-21 11:03:09.234976', '7', 'Crimson Bloom Peplum Top', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Crimson Bloom Peplum Top - S / RED (10 in stock)"}}, {"added": {"name": "product variant", "object": "Crimson Bloom Peplum Top - M / RED (2 in stock)"}}, {"added": {"name": "product variant", "object": "Crimson Bloom Peplum Top - L / RED (4 in stock)"}}]', 10, 1),
	(70, '2025-11-21 11:04:47.472024', '7', 'YELLOW', 1, '[{"added": {}}]', 8, 1),
	(71, '2025-11-21 11:05:10.660454', '8', 'Sunshine Paisley Cotton Top', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Sunshine Paisley Cotton Top - S / YELLOW (2 in stock)"}}, {"added": {"name": "product variant", "object": "Sunshine Paisley Cotton Top - M / YELLOW (3 in stock)"}}]', 10, 1),
	(72, '2025-11-21 11:05:19.170564', '8', 'Sunshine Paisley Cotton Top', 2, '[]', 10, 1),
	(73, '2025-11-21 11:06:17.448704', '9', 'Blush Pink Floral Breeze Top', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Blush Pink Floral Breeze Top - S / PINK (5 in stock)"}}, {"added": {"name": "product variant", "object": "Blush Pink Floral Breeze Top - M / PINK (3 in stock)"}}, {"added": {"name": "product variant", "object": "Blush Pink Floral Breeze Top - L / PINK (4 in stock)"}}]', 10, 1),
	(74, '2025-11-21 11:06:45.058521', '7', 'Crimson Bloom Peplum Top', 2, '[{"changed": {"fields": ["Is featured"]}}]', 10, 1),
	(75, '2025-11-21 11:16:53.991153', '4', 'Premium Section', 3, '', 7, 1),
	(76, '2025-11-21 11:22:56.284595', '12', 'Majestic Magenta Gold-Work Lehenga', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Majestic Magenta Gold-Work Lehenga - XL / MAGENTA (2 in stock)"}}]', 10, 1),
	(77, '2025-11-21 11:23:49.961461', '8', 'SILVER & MAGENTA', 1, '[{"added": {}}]', 8, 1),
	(78, '2025-11-21 11:24:16.788512', '11', 'Celestial Silver & Crimson Silk Lehenga', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Celestial Silver & Crimson Silk Lehenga - XL / SILVER & MAGENTA (1 in stock)"}}]', 10, 1),
	(79, '2025-11-21 11:24:41.486633', '9', 'ROSE', 1, '[{"added": {}}]', 8, 1),
	(80, '2025-11-21 11:24:54.783531', '10', 'Royal Rose Embroidered Bridal Lehenga', 2, '[{"changed": {"fields": ["Thumbnail"]}}, {"added": {"name": "product variant", "object": "Royal Rose Embroidered Bridal Lehenga - XL / ROSE (3 in stock)"}}]', 10, 1),
	(81, '2025-11-21 11:25:10.112470', '12', 'Majestic Magenta Gold-Work Lehenga', 2, '[{"changed": {"fields": ["Is featured"]}}]', 10, 1),
	(82, '2025-11-22 06:07:10.466220', '4', 'Urban Chic Cocoa Wide-Leg Set', 2, '[{"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}, {"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}, {"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}, {"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}, {"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}, {"added": {"name": "product image", "object": "Image for Urban Chic Cocoa Wide-Leg Set"}}]', 10, 1);

-- Dumping structure for table dress_shop_db.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.django_content_type: ~15 rows (approximately)
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(2, 'auth', 'permission'),
	(3, 'auth', 'group'),
	(4, 'auth', 'user'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session'),
	(7, 'store', 'category'),
	(8, 'store', 'color'),
	(9, 'store', 'size'),
	(10, 'store', 'product'),
	(11, 'store', 'productimage'),
	(12, 'store', 'productvariant'),
	(13, 'store', 'cartitem'),
	(14, 'store', 'orderitem'),
	(15, 'store', 'order');

-- Dumping structure for table dress_shop_db.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.django_migrations: ~23 rows (approximately)
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2025-11-17 12:01:06.670801'),
	(2, 'auth', '0001_initial', '2025-11-17 12:01:06.917029'),
	(3, 'admin', '0001_initial', '2025-11-17 12:01:06.963988'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2025-11-17 12:01:06.969740'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-11-17 12:01:06.973740'),
	(6, 'contenttypes', '0002_remove_content_type_name', '2025-11-17 12:01:07.011918'),
	(7, 'auth', '0002_alter_permission_name_max_length', '2025-11-17 12:01:07.038304'),
	(8, 'auth', '0003_alter_user_email_max_length', '2025-11-17 12:01:07.053147'),
	(9, 'auth', '0004_alter_user_username_opts', '2025-11-17 12:01:07.059255'),
	(10, 'auth', '0005_alter_user_last_login_null', '2025-11-17 12:01:07.080107'),
	(11, 'auth', '0006_require_contenttypes_0002', '2025-11-17 12:01:07.082109'),
	(12, 'auth', '0007_alter_validators_add_error_messages', '2025-11-17 12:01:07.088105'),
	(13, 'auth', '0008_alter_user_username_max_length', '2025-11-17 12:01:07.104031'),
	(14, 'auth', '0009_alter_user_last_name_max_length', '2025-11-17 12:01:07.119149'),
	(15, 'auth', '0010_alter_group_name_max_length', '2025-11-17 12:01:07.133423'),
	(16, 'auth', '0011_update_proxy_permissions', '2025-11-17 12:01:07.139420'),
	(17, 'auth', '0012_alter_user_first_name_max_length', '2025-11-17 12:01:07.154422'),
	(18, 'sessions', '0001_initial', '2025-11-17 12:01:07.175597'),
	(19, 'store', '0001_initial', '2025-11-17 12:01:07.308775'),
	(20, 'store', '0002_cartitem', '2025-11-18 08:52:38.464229'),
	(21, 'store', '0003_order_orderitem', '2025-11-19 06:13:26.772062'),
	(22, 'store', '0004_order_razorpay_order_id', '2025-11-19 07:39:27.189406'),
	(23, 'store', '0005_product_is_featured', '2025-11-20 10:48:57.665329');

-- Dumping structure for table dress_shop_db.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.django_session: ~7 rows (approximately)
INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('3lcvdsg01hekbuilbiz03hr1k96sv1i3', '.eJxVjDsOwjAQRO_iGll2Ev8o6XMGa727wQFkS3FSIe5OIqWAYpp5b-YtImxrjlvjJc4krkKLy2-XAJ9cDkAPKPcqsZZ1mZM8FHnSJsdK_Lqd7t9Bhpb3tQ-oifWkfO-AjdPJWA2YQHli8hgs7pm6oAK7PvVmwMEpIhXQGWs78fkC8bw34w:1vLyAD:6rV6_IeM4b8buDFaF8FQE8mlQbp87_bbm6D67bQtI90', '2025-12-04 06:29:05.731021'),
	('4qowr9btc0bgynrk2gq18y1srav69src', '.eJxVjDsOwjAQRO_iGll2Ev8o6XMGa727wQFkS3FSIe5OIqWAYpp5b-YtImxrjlvjJc4krkKLy2-XAJ9cDkAPKPcqsZZ1mZM8FHnSJsdK_Lqd7t9Bhpb3tQ-oifWkfO-AjdPJWA2YQHli8hgs7pm6oAK7PvVmwMEpIhXQGWs78fkC8bw34w:1vM2Oh:5nivcFT7DsCaJuo6UhWOpCW-fxAnkGd1CFqNgiJaEJM', '2025-12-04 11:00:19.281634'),
	('5vfxx4v41gf0t1gu9o056w0o9f0js2gh', '.eJxVjDsOwjAQRO_iGll2Ev8o6XMGa727wQFkS3FSIe5OIqWAYpp5b-YtImxrjlvjJc4krkKLy2-XAJ9cDkAPKPcqsZZ1mZM8FHnSJsdK_Lqd7t9Bhpb3tQ-oifWkfO-AjdPJWA2YQHli8hgs7pm6oAK7PvVmwMEpIhXQGWs78fkC8bw34w:1vMO7q:lCiQUbCNN9Y_DlDzMoZAOriYfZYvKUscRMSYNJfb8DY', '2025-12-05 10:12:22.936095'),
	('brbnrazqfofl1fa8l3fv2h60uty2qyiz', '.eJxVjDEOgzAMAP_iuYpCcBOHsXvfgBzHLbQVSAQmxN-rSCysd6fbQXhZoduPG_S8rUO_FV36MUMHDi4ssXx1qiJ_eHrPRuZpXcZkamJOW8xzzvp7nO1lMHAZ6jahKGmjGTMSBqaESRpyrW8iY_QaxbYkyYZ79N62GDxZx-SdRX45OP4iAzo0:1vMgTo:MoCFCkIvUD8pH4nl1Y1R-AJYFbjR7FB8cpK-9k2azGI', '2025-12-06 05:48:16.923773'),
	('h9sr01517o6ow6951aeirwiqsk1i1cot', '.eJxVjDsOwjAQRO_iGll2Ev8o6XMGa727wQFkS3FSIe5OIqWAYpp5b-YtImxrjlvjJc4krkKLy2-XAJ9cDkAPKPcqsZZ1mZM8FHnSJsdK_Lqd7t9Bhpb3tQ-oifWkfO-AjdPJWA2YQHli8hgs7pm6oAK7PvVmwMEpIhXQGWs78fkC8bw34w:1vMgl9:5JxDprIq08qifadxsbvMN321ctRWnZzcVlbise9Lrk0', '2025-12-06 06:06:11.057732'),
	('mp4mxdnn96todyp72vsy9cznrab770b9', '.eJxVjDsOwjAQRO_iGll2Ev8o6XMGa727wQFkS3FSIe5OIqWAYpp5b-YtImxrjlvjJc4krkKLy2-XAJ9cDkAPKPcqsZZ1mZM8FHnSJsdK_Lqd7t9Bhpb3tQ-oifWkfO-AjdPJWA2YQHli8hgs7pm6oAK7PvVmwMEpIhXQGWs78fkC8bw34w:1vLena:ouWM9_359f54SMmI3MICLMbV0QQPPcYQ3DsELBEqqUg', '2025-12-03 09:48:26.070764'),
	('qqeb26ki3vj3vd3gx9wpik76cxs28vze', '.eJxVjDEOgzAMAP_iuYpCcIPD2L1vQI7jFtoqkQhMiL9XSCysd6fbQHheoN8AoXf7DQZel3FYq87DlKAHBxcWWb6aD5E-nN_FSMnLPEVzJOa01TxL0t_jbC-Dket4bCOKkjaaMCFhxxQxSkOu9U1gDF6D2JYk2u4evLctdp6sY_LOIr8c7H_NVDsY:1vLHBD:fnWn71slYGZkuyoxzwrvhEi47dTi_milyqQbW5WbEUQ', '2025-12-02 08:35:15.319831');

-- Dumping structure for table dress_shop_db.store_cartitem
CREATE TABLE IF NOT EXISTS `store_cartitem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity` int(10) unsigned NOT NULL CHECK (`quantity` >= 0),
  `created_at` datetime(6) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `variant_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_cartitem_user_id_3ff2f2b5_fk_auth_user_id` (`user_id`),
  KEY `store_cartitem_variant_id_0b32a016_fk_store_productvariant_id` (`variant_id`),
  CONSTRAINT `store_cartitem_user_id_3ff2f2b5_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `store_cartitem_variant_id_0b32a016_fk_store_productvariant_id` FOREIGN KEY (`variant_id`) REFERENCES `store_productvariant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_cartitem: ~1 rows (approximately)
INSERT INTO `store_cartitem` (`id`, `quantity`, `created_at`, `user_id`, `variant_id`) VALUES
	(16, 1, '2025-11-21 09:57:08.466945', 1, 4);

-- Dumping structure for table dress_shop_db.store_category
CREATE TABLE IF NOT EXISTS `store_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_category: ~4 rows (approximately)
INSERT INTO `store_category` (`id`, `name`, `description`, `slug`) VALUES
	(1, 'Party Wears', 'Party Wears', 'party-wears'),
	(2, 'Western Wears', 'Western Wears', 'western-wears'),
	(3, 'Casual Wears', 'Comfortable & Chic daily wear', 'casual-wears'),
	(5, 'Premium Wears', 'Exclusive designer lehengas and bridal wear', 'premium-section');

-- Dumping structure for table dress_shop_db.store_color
CREATE TABLE IF NOT EXISTS `store_color` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_color: ~9 rows (approximately)
INSERT INTO `store_color` (`id`, `name`) VALUES
	(1, 'RED'),
	(2, 'GREEN'),
	(3, 'BLUE'),
	(4, 'BLACK'),
	(5, 'PINK'),
	(6, 'MAGENTA'),
	(7, 'YELLOW'),
	(8, 'SILVER & MAGENTA'),
	(9, 'ROSE');

-- Dumping structure for table dress_shop_db.store_order
CREATE TABLE IF NOT EXISTS `store_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `address_line_1` varchar(100) NOT NULL,
  `address_line_2` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `pin_code` varchar(10) NOT NULL,
  `order_total` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `is_ordered` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `razorpay_order_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `store_order_user_id_ae5f7a5f_fk_auth_user_id` (`user_id`),
  CONSTRAINT `store_order_user_id_ae5f7a5f_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_order: ~4 rows (approximately)
INSERT INTO `store_order` (`id`, `first_name`, `last_name`, `phone`, `email`, `address_line_1`, `address_line_2`, `city`, `state`, `country`, `pin_code`, `order_total`, `status`, `ip`, `is_ordered`, `created_at`, `updated_at`, `payment_id`, `order_id`, `user_id`, `razorpay_order_id`) VALUES
	(22, 'Ahammed', 'Mishal M', '8943704395', 'ahmedmishal246@gmail.com', 'Puthenpeedika(h) vavulliapuram kavassery(po) palakkad(dt) 678543', '', 'Alathur', 'Kerala', 'India', '678543', 2000.00, 'Accepted', '127.0.0.1', 1, '2025-11-21 08:25:55.868569', '2025-11-21 08:26:10.964022', 'pay_simulated_123456', '2025112122', 2, 'order_RiK7R0NoOgeGiE'),
	(23, 'Ahammed', 'Mishal M', '8943704395', 'ahmedmishal246@gmail.com', 'Puthenpeedika(h) vavulliapuram kavassery(po) palakkad(dt) 678543', '', 'Alathur', 'Kerala', 'India', '678543', 2000.00, 'Accepted', '127.0.0.1', 1, '2025-11-21 09:59:24.830203', '2025-11-21 09:59:40.457848', 'pay_simulated_123456', '2025112123', 2, 'order_RiLiBrTWK2W7GF'),
	(24, 'Ahammed', 'Mishal M', '8943704395', 'ahmedmishal246@gmail.com', 'Puthenpeedika(h) vavulliapuram kavassery(po) palakkad(dt) 678543', '', 'Alathur', 'Kerala', 'India', '678543', 3499.00, 'Accepted', '127.0.0.1', 1, '2025-11-21 11:26:18.708788', '2025-11-21 11:26:30.391858', 'pay_simulated_123456', '2025112124', 2, 'order_RiNByDVyn00ryA'),
	(25, 'Ahammed', 'Mishal M', '8943704395', 'ahmedmishal246@gmail.com', 'Puthenpeedika(h) vavulliapuram kavassery(po) palakkad(dt) 678543', '', 'Alathur', 'Kerala', 'India', '678543', 1199.00, 'Accepted', '127.0.0.1', 1, '2025-11-22 06:23:07.960003', '2025-11-22 06:23:20.442095', 'pay_sim_9a660cfa55', '2025112225', 2, 'order_sim_9213397860');

-- Dumping structure for table dress_shop_db.store_orderitem
CREATE TABLE IF NOT EXISTS `store_orderitem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `order_id` bigint(20) NOT NULL,
  `variant_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_orderitem_order_id_acf8722d_fk_store_order_id` (`order_id`),
  KEY `store_orderitem_variant_id_a31fc8c9_fk_store_productvariant_id` (`variant_id`),
  CONSTRAINT `store_orderitem_order_id_acf8722d_fk_store_order_id` FOREIGN KEY (`order_id`) REFERENCES `store_order` (`id`),
  CONSTRAINT `store_orderitem_variant_id_a31fc8c9_fk_store_productvariant_id` FOREIGN KEY (`variant_id`) REFERENCES `store_productvariant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_orderitem: ~4 rows (approximately)
INSERT INTO `store_orderitem` (`id`, `price`, `quantity`, `created_at`, `order_id`, `variant_id`) VALUES
	(33, 2000.00, 1, '2025-11-21 08:25:55.879667', 22, 1),
	(34, 2000.00, 1, '2025-11-21 09:59:24.841206', 23, 1),
	(35, 3499.00, 1, '2025-11-21 11:26:18.718693', 24, 32),
	(36, 1199.00, 1, '2025-11-22 06:23:07.967096', 25, 22);

-- Dumping structure for table dress_shop_db.store_product
CREATE TABLE IF NOT EXISTS `store_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `product_code` varchar(50) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `thumbnail` varchar(100) DEFAULT NULL,
  `category_id` bigint(20) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  UNIQUE KEY `product_code` (`product_code`),
  KEY `store_product_category_id_574bae65_fk_store_category_id` (`category_id`),
  CONSTRAINT `store_product_category_id_574bae65_fk_store_category_id` FOREIGN KEY (`category_id`) REFERENCES `store_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_product: ~12 rows (approximately)
INSERT INTO `store_product` (`id`, `name`, `slug`, `product_code`, `description`, `thumbnail`, `category_id`, `is_featured`) VALUES
	(1, '"Lilac Shimmer" Sharara Set', 'lilac-shimmer-sharara-set', 'N-E38721', '"Step into the spotlight with our \'Lilac Shimmer\' Sharara Set. This stunning three-piece ensemble features a modern strappy kurta, wide-leg sharara pants, and a matching dupatta, all in a beautiful lilac and purple brocade. Intricate gold and silver zari work adds a touch of royal glamour, making it the perfect choice for weddings and festive celebrations."', 'product_thumbnails/party3_xNqgQTW.jpg', 1, 1),
	(2, 'Royal Mustard Floral Sharara Set', 'royal-mustard-floral-sharara-set', 'N-3BDF95', 'Radiate traditional elegance with this stunning mustard yellow Sharara set. This three-piece ensemble features a long-sleeve kurta adorned with intricate pink and purple floral motifs, highlighted by subtle zari sheen. Paired with heavily flared, matching patterned Sharara pants and a sheer net dupatta with a delicate gold border, this outfit is the perfect choice for Mehndi ceremonies, Haldi functions, or festive gatherings.', 'product_thumbnails/party1_m130a6e.jpg', 1, 0),
	(3, 'Ethereal Lilac Shimmer Sharara', 'ethereal-lilac-shimmer-sharara', 'N-928D63', 'Step into modern luxury with this breathtaking lilac Sharara set. Designed for the contemporary woman, this outfit features a chic, strappy sleeveless short kurta crafted from shimmering tissue-silk fabric. The wide-legged palazzo pants offer a graceful flow, while the matching dupatta with heavy silver border detailing adds a touch of regal sophistication. A perfect pick for day weddings, receptions, or cocktail parties.', 'product_thumbnails/party2_Ysr3y1i.jpg', 1, 0),
	(4, 'Urban Chic Cocoa Wide-Leg Set', 'urban-chic-cocoa-wide-leg-set', 'N-746AD2', 'Effortlessly stylish, this set features a sleek black sleeveless tank paired with flowy, cocoa-brown wide-leg trousers. Crafted for comfort and elegance, it\'s the perfect outfit for a casual day out or a coffee date.', 'product_thumbnails/western1_TKqfCeH.jpg', 2, 1),
	(5, 'Vivid Magenta Pop Oversized Shirt', 'vivid-magenta-pop-oversized-shirt', 'N-C4000A', 'Make a bold statement with this vibrant magenta button-down. Designed with a relaxed, oversized fit and soft fabric, it pairs perfectly with denim for a trendy, street-style look.', 'product_thumbnails/western2_cU7rPYD.jpg', 2, 0),
	(6, 'Candy Stripe Breeze Cotton Shirt', 'candy-stripe-breeze-cotton-shirt', 'N-DF72D3', 'A playful pink and white vertical striped shirt that screams summer vibes. Lightweight and breathable, this button-down features a casual collar and cuffed sleeves for a laid-back aesthetic.', 'product_thumbnails/western3_30opuFs.jpg', 2, 0),
	(7, 'Crimson Bloom Peplum Top', 'crimson-bloom-peplum-top', 'N-5A7E65', 'Add a pop of color to your day with this vibrant red floral peplum top. Featuring a flattering V-neckline and long sleeves, this gathered cotton top pairs perfectly with jeans.', 'product_thumbnails/casual1.jpg', 3, 1),
	(8, 'Sunshine Paisley Cotton Top', 'sunshine-paisley-cotton-top', 'N-0EB1E9', 'Brighten up your wardrobe with this cheerful mustard yellow top adorned with intricate white paisley motifs. The flared waistline makes it an ideal choice for comfort.', 'product_thumbnails/casual2.jpg', 3, 0),
	(9, 'Blush Pink Floral Breeze Top', 'blush-pink-floral-breeze-top', 'N-2B7442', 'Embrace the spring vibes with this lovely blush pink floral tunic. Designed with a relaxed fit and balloon-style sleeves for effortless elegance.', 'product_thumbnails/casual3.jpeg', 3, 0),
	(10, 'Royal Rose Embroidered Bridal Lehenga', 'royal-rose-embroidered-bridal-lehenga', 'N-AB6DD3', 'A masterpiece of craftsmanship, this deep rose lehenga features intricate thread work and zardosi embroidery. Paired with a matching blouse and sheer dupatta, it is perfect for the modern bride looking for tradition with a twist.', 'product_thumbnails/premium3.jpg', 5, 0),
	(11, 'Celestial Silver & Crimson Silk Lehenga', 'celestial-silver-crimson-silk-lehenga', 'N-FA9A9B', 'Step into luxury with this stunning silver-grey lehenga adorned with crimson paisley motifs. The contrasting red velvet blouse and shimmering dupatta add a touch of modern regality to this heavy festive ensemble.', 'product_thumbnails/premium2.jpg', 5, 0),
	(12, 'Majestic Magenta Gold-Work Lehenga', 'majestic-magenta-gold-work-lehenga', 'N-99DF64', 'Radiate elegance in this majestic magenta lehenga, heavily embellished with gold sequin and beadwork throughout the skirt. The soft net dupatta and structured blouse complete this dreamy, princess-cut ensemble.', 'product_thumbnails/premium1.jpg', 5, 1);

-- Dumping structure for table dress_shop_db.store_productimage
CREATE TABLE IF NOT EXISTS `store_productimage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `image` varchar(100) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `store_productimage_product_id_e50e4046_fk_store_product_id` (`product_id`),
  CONSTRAINT `store_productimage_product_id_e50e4046_fk_store_product_id` FOREIGN KEY (`product_id`) REFERENCES `store_product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_productimage: ~7 rows (approximately)
INSERT INTO `store_productimage` (`id`, `image`, `product_id`) VALUES
	(1, 'product_gallery/party3_6RcW1AZ.jpg', 1),
	(7, 'product_gallery/western1_XAOC2mJ.jpg', 4),
	(8, 'product_gallery/western1_wyTiOty.jpg', 4),
	(9, 'product_gallery/western1_NJVTYsx.jpg', 4),
	(10, 'product_gallery/western1_A3Tqh3l.jpg', 4),
	(11, 'product_gallery/western1_hoNqMCa.jpg', 4),
	(12, 'product_gallery/western1_tLxOoYU.jpg', 4);

-- Dumping structure for table dress_shop_db.store_productvariant
CREATE TABLE IF NOT EXISTS `store_productvariant` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `color_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) NOT NULL,
  `size_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `store_productvariant_product_id_size_id_color_id_70f6fd9e_uniq` (`product_id`,`size_id`,`color_id`),
  KEY `store_productvariant_color_id_9aed3d94_fk_store_color_id` (`color_id`),
  KEY `store_productvariant_size_id_09d75860_fk_store_size_id` (`size_id`),
  CONSTRAINT `store_productvariant_color_id_9aed3d94_fk_store_color_id` FOREIGN KEY (`color_id`) REFERENCES `store_color` (`id`),
  CONSTRAINT `store_productvariant_product_id_d0ac8a4e_fk_store_product_id` FOREIGN KEY (`product_id`) REFERENCES `store_product` (`id`),
  CONSTRAINT `store_productvariant_size_id_09d75860_fk_store_size_id` FOREIGN KEY (`size_id`) REFERENCES `store_size` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_productvariant: ~32 rows (approximately)
INSERT INTO `store_productvariant` (`id`, `price`, `stock`, `color_id`, `product_id`, `size_id`) VALUES
	(1, 2000.00, 2, 1, 1, 1),
	(2, 2000.00, 4, 2, 1, 1),
	(3, 2200.00, 4, 2, 1, 3),
	(4, 2300.00, 4, 1, 1, 2),
	(5, 1499.00, 5, 2, 2, 1),
	(6, 1499.00, 5, 3, 2, 1),
	(7, 1499.00, 5, 5, 2, 1),
	(8, 1699.00, 4, 2, 2, 3),
	(9, 1699.00, 3, 3, 2, 3),
	(10, 1699.00, 3, 5, 2, 3),
	(11, 1599.00, 3, 3, 3, 1),
	(12, 1599.00, 3, 4, 3, 1),
	(13, 1699.00, 3, 5, 3, 3),
	(14, 1699.00, 4, 1, 3, 3),
	(15, 1999.00, 3, 4, 4, 1),
	(16, 2099.00, 3, 4, 4, 3),
	(17, 2199.00, 0, 4, 4, 2),
	(18, 1499.00, 4, 6, 5, 1),
	(19, 1599.00, 2, 6, 5, 3),
	(20, 1699.00, 3, 5, 6, 1),
	(21, 1799.00, 3, 5, 6, 3),
	(22, 1199.00, 9, 1, 7, 1),
	(23, 1299.00, 2, 1, 7, 3),
	(24, 1399.00, 4, 1, 7, 2),
	(25, 999.00, 2, 7, 8, 1),
	(26, 1199.00, 3, 7, 8, 3),
	(27, 999.00, 5, 5, 9, 1),
	(28, 1199.00, 3, 5, 9, 3),
	(29, 1149.00, 4, 5, 9, 2),
	(30, 3999.00, 2, 6, 12, 5),
	(31, 4499.00, 1, 8, 11, 5),
	(32, 3499.00, 2, 9, 10, 5);

-- Dumping structure for table dress_shop_db.store_size
CREATE TABLE IF NOT EXISTS `store_size` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table dress_shop_db.store_size: ~6 rows (approximately)
INSERT INTO `store_size` (`id`, `name`) VALUES
	(1, 'S'),
	(2, 'L'),
	(3, 'M'),
	(4, 'XS'),
	(5, 'XL'),
	(6, 'XXL');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
