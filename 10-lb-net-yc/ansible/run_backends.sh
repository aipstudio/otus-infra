#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

ansible-playbook -i hosts_bastion backends_docker.yml $ARGS
ansible-playbook -i hosts_bastion backends_iscsi.yml $ARGS
ansible-playbook -i hosts_bastion backends_multipath.yml $ARGS
ansible-playbook -i hosts_bastion backends_pcs.yml $ARGS
ansible-playbook -i hosts_bastion backends_lvm.yml $ARGS
