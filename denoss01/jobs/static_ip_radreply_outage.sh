#!/bin/bash
#
# Report of "static_ip_pool/radreply outage".
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/static_ip_radreply_outage.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/static_ip_radreply_outage.tmp
#LOCK=/home/postgres/dba/jobs/`basename $0`.lock

EMAILTO=gordaz@cctus.com

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# #################################################### #
# SECTION TO GENERATE static_ip/radreply outage report #
# #################################################### #

REPORT_FROM=`TZ=MST date -d '24 hours ago' +'%Y/%m/%d %H:%M'`
REPORT_TO=`TZ=MST date +'%Y/%m/%d %H:%M'`
echo "[Report Static IP/Radreply Outage  <${REPORT_FROM} -> ${REPORT_TO}>(MST)]" > $TMPFILE
echo " " >> $TMPFILE
echo "Static Pool table shows line is active but no entry in Radreply." >> $TMPFILE

TABLESUFFIX=`TZ=MST date -d '1 day ago' +'%Y%m'`
# execute query
psql -U csctoss_owner -q --pset=border=2 -c \
"
select a.static_ip as sip_static_ip
      ,a.groupname
      ,c.carrier
      ,b.line_id as line_line_id
      ,d.name as Billilng_Entity_Name
  from static_ip_pool a
  left outer join line b ON (a.line_id = b.line_id)
  join static_ip_carrier_def c ON a.carrier_id = c.carrier_def_id
  left outer join billing_entity d ON a.billing_entity_id = d.billing_entity_id
 where a.is_assigned = TRUE
   and a.line_id = b.line_id
   and a.static_ip NOT IN (select value from radreply);
" >> $TMPFILE

echo "Static Pool table shows line is in-active but entry exists in Radreply." >> $TMPFILE
echo " "
# execute second query
psql -U csctoss_owner -q --pset=border=2 -c \
"
select a.static_ip as sip_static_ip
      ,a.groupname
      ,c.carrier
      ,b.line_id as line_line_id
      ,d.name as Billilng_Entity_Name
  from static_ip_pool a
  left outer join line b ON (a.line_id = b.line_id)
  join static_ip_carrier_def c ON a.carrier_id = c.carrier_def_id
  left outer join billing_entity d ON a.billing_entity_id = d.billing_entity_id
 where a.is_assigned = FALSE
   and a.line_id = b.line_id
   and a.static_ip IN (select value from radreply);
" >> $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then

  cat $TMPFILE >> $LOGFILE
  cat $TMPFILE | mail -s "`hostname` ERROR:  Static_ip_pool/Radreply outage!" ${EMAILTO}
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end report Port-Preempted------------------------" >> $LOGFILE

exit 0

