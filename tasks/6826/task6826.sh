#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

ERRFILE=$BASEDIR/lupe/tasks/6826/logs/oss_info_not_found.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/6826/logs/oss_public_number_log.`date '+%Y%m%d'`

echo "OSS Line Id|ESN Hex|Shipping Order" > $LOGFILE
echo "OSS Line Id|ESN Hex" > $ERRFILE

psql -q \
     -t \
     -c "select l.line_id
		       ,ui.value
		   from line l
		   join line_equipment le on le.line_id = l.line_id
		   join unique_identifier ui on le.equipment_id = ui.equipment_id and ui.unique_identifier_type = 'ESN HEX'
		  where l.notes NOT like 'SO%'
		    and l.end_date IS null
		  order by 1" \
| while read LINEID ESN ; do
        ESN=`echo "$ESN"|awk '{print $2}'`
	SHIPORD=`psql -q \
		      -t \
		      -c \
			   "SELECT public_number
	  		      FROM dblink(fetch_jbilling_conn(),
					  'SELECT public_number
					     FROM purchase_order
					    WHERE id = (select order_id
					                  from prov_line
					                 WHERE esn_hex = ''$ESN''
					                   AND line_id = $LINEID
					                   and archived is null )') as rec_type (public_number text)"`
    
    if [[ $SHIPORD = "" ]]; then 
		echo "$LINEID|$ESN" >> $ERRFILE
	else
		SHIPORD=`echo $SHIPORD | xargs`
		echo "$LINEID|$ESN|$SHIPORD" >> $LOGFILE
	fi
done

