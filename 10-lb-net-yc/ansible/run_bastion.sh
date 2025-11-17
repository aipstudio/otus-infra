#!/bin/bash

cd "$(dirname "$0")" || exit

#ansible-playbook -i hosts_bastion bastion.yml
#ansible-playbook -i hosts_bastion storage.yml
#ansible-playbook -i hosts_bastion frontends.yml
#ansible-playbook -i hosts_bastion backends_docker.yml
#ansible-playbook -i hosts_bastion backends_iscsi.yml
#ansible-playbook -i hosts_bastion backends_multipath.yml
ansible-playbook -i hosts_bastion backends_pcs.yml
ansible-playbook -i hosts_bastion backends_lvm.yml
