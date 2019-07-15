DROP DATABASE IF EXISTS cardea_db;
CREATE DATABASE cardea_db;
USE cardea_db;

-- Users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(128) NOT NULL,
    login_key varchar(255) DEFAULT NULL,
    login_key_expiry datetime DEFAULT NULL,
    last_ip varchar(40) DEFAULT NULL,
    last_login datetime DEFAULT NULL,
    display_name varchar(20) NOT NULL,
    about_self varchar(255)  DEFAULT NULL,
    role enum('medic','patient','mod') NOT NULL DEFAULT 'patient',
    joined_date datetime DEFAULT CURRENT_TIMESTAMP,
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_verified tinyint(1) DEFAULT NULL,
    is_blocked tinyint(1) DEFAULT NULL,
    is_deleted tinyint(1) DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Posts
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    id int(11) NOT NULL AUTO_INCREMENT,
    parent_id int(11) DEFAULT NULL,
    user_id int(11) NOT NULL,
    forum enum('p2p','p2m','m2m','all') NOT NULL DEFAULT 'p2m',
    type_of enum('group','question','discussion','blog','comment','message','chat') NOT NULL DEFAULT 'question',
    visibility enum('public','registered','patients','medics','connections','custom') NOT NULL DEFAULT 'public',
    identity enum('self','pseudo','anon') NOT NULL DEFAULT 'self',
    title varchar(420) NOT NULL,
    content text DEFAULT NULL,
    order_index int(11) DEFAULT NULL,
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_blocked tinyint(1) DEFAULT '0',
    PRIMARY KEY (id),
    FOREIGN KEY (parent_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    KEY title (title),
    FULLTEXT KEY content (content)
);

-- Custom cascading rules for posts & users
ALTER TABLE posts
    ADD CONSTRAINT user_id
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- Custom cascading rules for posts & parent posts
ALTER TABLE posts
    ADD CONSTRAINT parent_id
    FOREIGN KEY (parent_id)
    REFERENCES posts(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- Votes
DROP TABLE IF EXISTS votes;
CREATE TABLE votes (
    id int(11) NOT NULL AUTO_INCREMENT,
    post_id int(11) NOT NULL,
    user_id int(11) NOT NULL,
    type_of enum('positive','negative','spam','offensive','compromising') NOT NULL DEFAULT 'positive',
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Subscriptions
DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id int(11) NOT NULL,
    post_id int(11) NOT NULL,
    type_of enum('group','post','user') NOT NULL DEFAULT 'group',
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Connections
DROP TABLE IF EXISTS connections;
CREATE TABLE connections (
    id int(11) NOT NULL AUTO_INCREMENT,
    user1_id int(11) NOT NULL,
    user2_id int(11) NOT NULL,
    is_approved tinyint(1) DEFAULT '0',
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user1_id) REFERENCES users(id),
    FOREIGN KEY (user2_id) REFERENCES users(id)
);

-- Visibility
DROP TABLE IF EXISTS visibility;
CREATE TABLE visibility (
    id int(11) NOT NULL AUTO_INCREMENT,
    user_id int(11) NOT NULL,
    post_id int(11) NOT NULL,
    time_stamp datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- MedFact
DROP TABLE IF EXISTS medfact;
CREATE TABLE medfact (
    id int(11) NOT NULL,
    veracity decimal(3,3) NOT NULL,
    confidence decimal(3,3) NOT NULL,
    label enum('trusted','untrusted','unknown') NOT NULL DEFAULT 'unknown',
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES posts(id)
);

-- Iron Mask
DROP TABLE IF EXISTS ironmask;
CREATE TABLE ironmask (
    id int(11) NOT NULL,
    pseudonym enum('registered','patient','medic','connection') NOT NULL DEFAULT 'registered',
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES posts(id)
);

-- BubbleNet
DROP TABLE IF EXISTS bubblenet;
CREATE TABLE bubblenet (
    id int(11) NOT NULL AUTO_INCREMENT,
    keyword varchar(100) NOT NULL,
    post_id int(11) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);