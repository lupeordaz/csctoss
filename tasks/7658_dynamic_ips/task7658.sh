#!/bin/bash
#

serial_number=$1

read USERNAME MODELNO <<<$(psql -t -A -F' ' -q\
   -c "select l.radius_username 
             ,em.model_number2
         from unique_identifier ui
         join equipment e on e.equipment_id = ui.equipment_id
         join line_equipment le on le.equipment_id = e.equipment_id
         join line l on l.line_id = le.line_id
         join equipment_model em on em.equipment_model_id = e.equipment_model_id
        where ui.unique_identifier_type = 'SERIAL NUMBER'
          and ui.value = '$serial_number'
          and le.end_date is null")

IPADDRESS=`psql -q \
          -t \
          -c \
         "select framedipaddress from dblink((select * from fetch_csctmon_conn()),
              'select username
                    ,framedipaddress
                    ,acctstarttime
                from master_radacct
               where username = ''$USERNAME''
               order by acctstarttime desc limit 1
              ') AS mrac (username text, framedipaddress text, acctstarttime text)"`

echo "serial no.:    $serial_number"
echo "username:      $USERNAME"
echo "model number:  $MODELNO"
echo ""
echo "IP Address:    $IPADDRESS"
