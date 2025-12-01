#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

export ANSIBLE_FORCE_COLOR=true

#ansible-playbook -i hosts_bastion elk_elastic_destroy.yml $ARGS
ansible-playbook -i hosts_bastion elk_elastic_data.yml $ARGS
ansible-playbook -i hosts_bastion elk_elastic.yml $ARGS
ansible-playbook -i hosts_bastion elk_elastic_certs.yml $ARGS
ansible-playbook -i hosts_bastion elk_elastic_bootstrap.yml $ARGS
ansible-playbook -i hosts_bastion elk_elastic_configure.yml $ARGS

ansible-playbook -i hosts_bastion elk_logstash.yml $ARGS

#ansible-playbook -i hosts_bastion elk_filebeat.yml $ARGS
