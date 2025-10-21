### Переменные среды
    export TF_VAR_token=$(yc iam create-token)
    export TF_VAR_cloud_id="placeholder"
    export TF_VAR_folder_id="placeholder"

### Роли

ansible/run.sh - запуск всех ролей

prepare.yml - установка всех нужных пакетов
targets.yml - настройка iscsi сервера
initiators.yml - настройка iscsi клиентов
multipath.yml - настройка multipath
pcs.yml - сборка кластера pacemaker/corosync
pcs_test.yml - тестирование подключенных разделов
pcs_add_gfs2.yml - добавление в кластер pacemaker/corosync ресурсов LVM
lvm.yml - создание lvm раздела
