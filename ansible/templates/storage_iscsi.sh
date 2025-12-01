#!/bin/bash

targetcli << EOF

cd /backstores/block
create disk01 {{ iscsi_disk }}

cd /iscsi
create {{ iscsi_iqn_name }}:{{ iscsi_target_name }}

cd /iscsi/{{ iscsi_iqn_name }}:{{ iscsi_target_name }}/tpg1/luns
create /backstores/block/disk01 lun=1

cd ..
#set attribute authentication=0 #TODO - not working?
#set auth userid=trololo
#set auth password=trololo

cd acls/
{% if groups['backends'] is defined and groups['backends']|length>0 %}
{% for backend in backends -%}
create {{ iscsi_iqn_name }}:{{ backend.name }}
{% endfor %}
{% endif %}

saveconfig
EOF
