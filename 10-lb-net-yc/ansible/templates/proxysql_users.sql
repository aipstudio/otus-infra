DELETE FROM mysql_users WHERE username = '{{ cms_username }}';
INSERT INTO mysql_users (username,password) VALUES ('{{ cms_username }}','{{ cms_password }}');

LOAD MYSQL USERS TO RUNTIME; SAVE MYSQL USERS TO DISK;
