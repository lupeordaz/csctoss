#!/bin/bash
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
OUTFILE=$BASEDIR/logs/check_jbill_oss_mrc_mismatch.out
RECIP=yshibuya@cctus.com
#RECIP=btekeste



# check for MRCs that are in JBilling but missing in OSS
psql -U csctoss_owner csctoss -q -c "SELECT * FROM csctoss.check_missing_MRCs();" > $OUTFILE


if [ `grep "(0 rows)" "${OUTFILE}" | wc -l` -ne 1 ];then

   cat $OUTFILE | mail -s "MRCs missing in OSS detected" $RECIP

fi


psql -U csctoss_owner csctoss -q -c "SELECT * FROM csctoss.check_jbilling_mrc_allowance() ; " > $OUTFILE

if [ `grep "(0 rows)" "${OUTFILE}" | wc -l` -ne 1 ];then
   
   cat $OUTFILE | mail -s "MRCs with null allowance_kb in Jbilling detected" $RECIP

fi
