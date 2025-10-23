### Переменные среды
    export TF_VAR_token=$(yc iam create-token)
    export TF_VAR_cloud_id="placeholder"
    export TF_VAR_folder_id="placeholder"

### Роли

http://$IP/ - бэк-приложение

http://$IP/static/ - статика фронтов

ansible/run.sh - запуск всех ролей

lb.yml - настройка входыщего балансира

frontend.yml - настройка фронтов

bachend.yml - настройка бэка

