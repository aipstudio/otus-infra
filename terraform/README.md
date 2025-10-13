### Настройки yandex cloud
* создать сервисный аккаунт в YC
* выдать права сервисному аккаунту
* сгенерировать ключ для доступа через yc
* установить yc
* посмотреть свои cloud_id и folder_id и задать их в ENV ниже

### Для запуска terraform использовать ENV:

    export TF_VAR_token=$(yc iam create-token)
    export TF_VAR_cloud_id=""
    export TF_VAR_folder_id=""
