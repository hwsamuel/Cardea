CREATE DATABASE `sigweb_db`;
USE `sigweb_db`;

CREATE TABLE `blogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `member_name` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`)
);
