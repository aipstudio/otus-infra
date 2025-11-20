#!/bin/bash

cd "$(dirname "$0")" || exit

if [[ "$1" != "" ]]; then
  ARGS="-e variable_hosts='$1'"
fi

ansible-playbook -i hosts_bastion frontends.yml $ARGS
