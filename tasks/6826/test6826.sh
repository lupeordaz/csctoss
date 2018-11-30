#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

ESN='A000001F54BFF6'
LINE='21050'

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
						                   AND line_id = $LINE
						                   and archived is null )') as rec_type (public_number text)"`

echo "ESN:      " $ESN  
echo "Line Id:  " $LINE  
echo "SHIPORD:  "  $SHIPORD
	
