#!/bin/bash
#

SERIALNO=$1
echo $SERIALNO

read USERNAME IPADDR MODEL <<< $(psql -q -t -A -F ' ' \
     -c "select rr.username
               ,rr.value as ip_address
               ,em.model_number2
           from unique_identifier ui
           join equipment e on e.equipment_id = ui.equipment_id
           join equipment_model em on em.equipment_model_id = e.equipment_model_id
           join unique_identifier uim on uim.equipment_id = ui.equipment_id and uim.unique_identifier_type = 'MDN'
           join radreply rr on rr.username LIKE '%'||uim.value||'%' AND rr.attribute = 'Framed-IP-Address'
          where ui.unique_identifier_type = 'SERIAL NUMBER'
            and ui.value = '$SERIALNO'")

echo "Username: $USERNAME, IP Address: $IPADDR, Model: $MODEL" 
