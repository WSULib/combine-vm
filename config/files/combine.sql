CREATE DATABASE combine;
CREATE USER 'combine'@'localhost' IDENTIFIED BY 'combine';
GRANT ALL PRIVILEGES ON * . * TO 'combine'@'localhost';
FLUSH PRIVILEGES;