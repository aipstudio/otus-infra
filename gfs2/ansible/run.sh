#!/bin/bash

cd "$(dirname "$0")" || exit

ansible-playbook -i ../hosts prepare.yml
ansible-playbook -i ../hosts initiators.yml
ansible-playbook -i ../hosts multipath.yml
ansible-playbook -i ../hosts pcs.yml
ansible-playbook -i ../hosts lvm.yml
ansible-playbook -i ../hosts pcs_add_gfs2.yml
