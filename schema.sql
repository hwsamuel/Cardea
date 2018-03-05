CREATE DATABASE `cardea_db`;
USE `cardea_db`;

CREATE TABLE `posts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `parent_id` INT(11) NULL,
  `user_id` INT(11) NOT NULL,
  `topic_id` INT(11) NOT NULL,
  `title` VARCHAR(140) NOT NULL,
  `content` TEXT NULL,
  `forum` ENUM('p2p','p2m','m2m') NULL,
  `identity` ENUM('self','pseudonym', 'anon') DEFAULT 'self',
  `privacy` ENUM('public','registered','patients','medics','connections') DEFAULT 'public',
  `post_type` ENUM('category','topic','question','blurb','journal','answer','comment') NOT NULL,
  `last_edited` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `post_reactions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `post_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `reaction` ENUM('upvote','downvote','hug','high-five','confused') NOT NULL,
  `identity` ENUM('self','pseudonym', 'anon')  DEFAULT 'self',
  PRIMARY KEY (`id`)
);

CREATE TABLE `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `display_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `user_type` ENUM('patient','medic','researcher')  DEFAULT 'patient',
  `is_verified` BOOL NULL,
  `last_login` DATETIME NULL,
  `joined_date` DATETIME NULL,
  `about_self` VARCHAR(255) NULL,
  `identicon` VARCHAR(100) NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `user_subscriptions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user1_id` INT(11) NOT NULL,
  `user2_id` INT(11) NOT NULL,
  `subscription_type` ENUM('subscriber','connection')  DEFAULT 'subscriber',
  `is_approved` BOOL NULL,
  `is_private` BOOL NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `post_subscriptions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `topic_id` INT(11) NOT NULL,
  `is_private` BOOL NULL,
  PRIMARY KEY (`id`)
);
