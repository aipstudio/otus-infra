CREATE USER IF NOT EXISTS '{{ pxc_proxysql_username }}'@'%' IDENTIFIED WITH caching_sha2_password by '{{ pxc_proxysql_password }}';
GRANT USAGE ON *.* TO '{{ pxc_proxysql_username }}'@'%';

CREATE USER IF NOT EXISTS '{{ cms_username }}'@'%' IDENTIFIED WITH caching_sha2_password by '{{ cms_password }}';
GRANT ALL ON *.* TO '{{ cms_username }}'@'%';

FLUSH PRIVILEGES;
