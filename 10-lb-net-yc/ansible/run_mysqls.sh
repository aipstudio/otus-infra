#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

#ansible-playbook -i hosts_bastion mysql_destroy.yml $ARGS
ansible-playbook -i hosts_bastion mysql_data.yml $ARGS
ansible-playbook -i hosts_bastion mysql.yml $ARGS
ansible-playbook -i hosts_bastion mysql_proxysql.yml $ARGS
