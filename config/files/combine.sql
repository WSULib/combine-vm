CREATE DATABASE combine CHARACTER SET utf8 COLLATE utf8_general_ci;;
CREATE USER 'combine'@'localhost' IDENTIFIED BY 'combine';
GRANT ALL PRIVILEGES ON * . * TO 'combine'@'localhost';
FLUSH PRIVILEGES;
