#!/bin/bash
#

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`"
psql -q \
     -t \
     -c "select l.line_id
		       ,ui.value
		   from line l
		   join line_equipment le on le.line_id = l.line_id
		   join unique_identifier ui on le.equipment_id = ui.equipment_id and ui.unique_identifier_type = 'ESN HEX'
		  where l.notes NOT like '''SO%'''
		    and l.end_date IS NOT nullL
		  order by 1 LIMIT 100;" \
| while read LINEID ESN ; do
	echo "Line Id: " $LINEID  "ESN Hex: " $ESN  "Shipping Order:  "  $SHIPORD
done
