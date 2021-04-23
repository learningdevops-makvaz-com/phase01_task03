CREATE DATABASE IF NOT EXISTS wp_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE mysql;
CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY 'wp_password';
GRANT ALL ON *.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
