### Переменные среды
    export TF_VAR_token=$(yc iam create-token)
    export TF_VAR_cloud_id="placeholder"
    export TF_VAR_folder_id="placeholder"

### Роли

ansible-playbook -i hosts ansible/gfs2.yml
