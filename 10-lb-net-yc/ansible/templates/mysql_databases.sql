CREATE DATABASE IF NOT EXISTS {{ cms_database }} CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON {{ cms_database }}.* TO '{{ cms_username }}'@'%' WITH GRANT OPTION;
