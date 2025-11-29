#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

export ANSIBLE_FORCE_COLOR=true

#ansible-playbook -i hosts_bastion postgresql_destroy.yml $ARGS
ansible-playbook -i hosts_bastion postgresql_data.yml $ARGS
ansible-playbook -i hosts_bastion postgresql_etcd.yml $ARGS
ansible-playbook -i hosts_bastion postgresql.yml $ARGS
ansible-playbook -i hosts_bastion postgresql_haproxy.yml $ARGS

ansible-playbook -i hosts_bastion elk_filebeat.yml $ARGS
