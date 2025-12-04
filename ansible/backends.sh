#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

export ANSIBLE_FORCE_COLOR=true

#ansible-playbook -i hosts_bastion backends_docker.yml $ARGS
ansible-playbook -i hosts_bastion backends_iscsi.yml $ARGS
ansible-playbook -i hosts_bastion backends_multipath.yml $ARGS
ansible-playbook -i hosts_bastion backends_pcs.yml $ARGS
ansible-playbook -i hosts_bastion backends_lvm.yml $ARGS
ansible-playbook -i hosts_bastion backends_nginx.yml $ARGS
ansible-playbook -i hosts_bastion backends_selinux_disable.yml $ARGS
ansible-playbook -i hosts_bastion backends_php_fpm.yml $ARGS
ansible-playbook -i hosts_bastion backends_joomla.yml $ARGS

ansible-playbook -i hosts_bastion elk_filebeat.yml $ARGS
