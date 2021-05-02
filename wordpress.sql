CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'P@$$w0rd!';
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;