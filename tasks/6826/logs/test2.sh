#!/bin/bash
#

ESN=$1
LINEID=$2

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

echo $SHIPORD

