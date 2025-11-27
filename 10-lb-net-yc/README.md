### Переменные среды

    export TF_VAR_token=$(yc iam create-token)
    export TF_VAR_cloud_id="placeholder"
    export TF_VAR_folder_id="placeholder"
    export TF_VAR_ssh_key=$(cat ~/.ssh/id_rsa.pub)

### terraform apply
Время запуска - 12 минут

### Комментарии к заданиям
Задание 10 - 2 фронта и 2 бэка + кластер субд. При отключении любого узла - система продолжаеть работать.

Задание 11 - 2 фронта и 2 бэка + кластер субд mysql(PXC). При отключении любого узла - система продолжаеть работать. Роли описаны ниже (префикс: mysql*.yml)

Задание 12 - в работе

Задание 14 - в работе

### Заметки

Доступность frontend балансировщиков проверяется /active.html - 200. Реализация yandex_lb_network_load_balancer (external)

Доступность mysql балансеров проверяется TCP 6033 - ProxyMYSQL. Реализация yandex_lb_network_load_balancer (internal)

### bastion

Конфигурирование всех хостов производится через бастион-хост (имеет external_ip)

### endpoints

${IP} = load_balancer_net_frontend

http://$IP/wp-admin/install.php - первоначальная конфигурация CMS wordpress

http://$IP/ - фронт

http://$IP/static/ - статика фронтов (для теста)

http://$IP/wb/ - webdebbuger - приложение в образе на бэкэндах (для теста)

http://$IP/info.php - проверить работу php-fpm

### terraform

* ansible.tf - конфигурация при запуске terraform

* frontends.tf - настройка через network load balancer и templates для VM

* backends.tf - VMs

* mysql.tf -  настройка через network load balancer без шаблона VM, через tagret-group

* storage.tf - VM

* bastion.tf - VM

* sa.tf - сервисные аккаунты с доступом

### Ansible

* bastion.yml - используется как JH

* storage.yml - конфигурация iscsi target

* fronrends_nginx.yml - настройка балансирова nginx (angie)

* backends_docker.yml - настройка бэкэнда (докер+webdebugger)

* backends_iscsi.yml - настройка iscsi initiators

* backends_multipath.yml - настройка multipath

* backends_lvs.yml - настройка lvm раздела для хранения статики /mnt/static на iscsi таргете

* backends_pcs.yml - настройка кластера pacemacer\corosync для живучести статики

* backends_php_fpm.yml - настройка движка php-fpm 7.4 (centos7)

* backends_wordpress.yml - настройка CMS wordpress

* mysql.yml - установка percona extradb cluster

* mysql_data.yml - настройка раздела для хранения данных

* mysql_proxysql.yml - настройка балансировщика для mysql

* postgresql - установка postgres и patroni

* postgresql_etcd - установка etcd

* postgresql_haproxy - настройка балансировщика

