SET password_encryption = 'md5';
create user {{ cms_username }} encrypted password '{{ cms_password }}';
ALTER USER {{ cms_username }} WITH PASSWORD '{{ cms_password }}';
create database {{ cms_database }} owner {{ cms_username }} encoding UTF8;
