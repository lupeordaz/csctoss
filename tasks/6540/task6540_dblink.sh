#!/bin/bash
#
#set -x

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

BILLID=$1
LINECNT=0

psql -q \
     -t \
     -c "select line_id
		   from line l
		  where billing_entity_id = $BILLID
		    and l.end_date IS null
		  order by 1" \
| while read BILLLINE ; do
    if [[ $BILLLINE -ne "" ]]; then
		LINEOUT=`psql -q \
			      -t \
			      -c \
				   "SELECT lineid
					  FROM dblink(fetch_jbilling_conn(),
					                                'SELECT line_id
					                                   FROM prov_line
					                                  WHERE line_id = $BILLLINE'
					                ) as rec_type (lineid int)"`
        LINECNT=$((LINECNT+1));
    fi

    if [[ $LINEOUT = "" ]]; then 
	echo "Line Missing on JBilling:  " $BILLLINE 
    fi
done

echo "Total lines processed:  " $LINECNT
