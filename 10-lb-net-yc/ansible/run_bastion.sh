#!/bin/bash

cd "$(dirname "$0")" || exit

#ansible-playbook -i hosts_bastion bastion.yml
ansible-playbook -i hosts_bastion frontends.yml
#ansible-playbook -i hosts_bastion backends.yml
