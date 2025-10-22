#!/bin/bash

cd "$(dirname "$0")" || exit

#ansible-playbook -i hosts lb.yml
#ansible-playbook -i hosts frontends.yml
ansible-playbook -i hosts backends.yml
