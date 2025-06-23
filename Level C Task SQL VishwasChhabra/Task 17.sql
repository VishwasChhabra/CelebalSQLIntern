CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'StrongPassword@123';

GRANT ALL PRIVILEGES ON trial_database.* TO 'test_user'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'test_user'@'localhost';
