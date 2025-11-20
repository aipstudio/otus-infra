delete from mysql_servers;
{% for mysql in mysqls %}
INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (1,'{{ mysql.host }}',{{ mysql.port }});
{% endfor %}

delete from mysql_replication_hostgroups;
INSERT INTO mysql_replication_hostgroups (writer_hostgroup,reader_hostgroup,comment) VALUES (0,1,'{{ pxc_cluster_name }}');

UPDATE global_variables SET variable_value='{{ pxc_proxysql_username }}' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='{{ pxc_proxysql_password }}' WHERE variable_name='mysql-monitor_password';

LOAD MYSQL VARIABLES TO RUNTIME; SAVE MYSQL VARIABLES TO DISK;
LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;
