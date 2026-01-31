CREATE USER IF NOT EXISTS 'clotheit'@'localhost' IDENTIFIED BY 'CLOTHEIT@2026#';

GRANT ALL PRIVILEGES ON clotheit_auth.* TO 'clotheit'@'localhost';
GRANT ALL PRIVILEGES ON clotheit_data.* TO 'clotheit'@'localhost';

FLUSH PRIVILEGES;

SOURCE db/schema.sql
SOURCE db/seed.sql

-- after cd into project root. SOURCE db/setup.sql