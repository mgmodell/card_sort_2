CREATE USER IF NOT EXISTS 'cs2'@'localhost' IDENTIFIED BY 'cs2';

GRANT ALL PRIVILEGES ON cs2_dev.* TO 'cs2'@'localhost';
GRANT ALL PRIVILEGES ON cs2_test.* TO 'cs2'@'localhost';

FLUSH PRIVILEGES;
