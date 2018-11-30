#!/bin/bash
#
# Populates missing Class attribute in radreply table with line_id and corrects mismatched data.
#
# $Id: $
#

source /home/postgres/.bash_profile
DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/line_class_updater.$DATE

#echo "CSCTOSS LINE/CLASS REPORT FOR $DATE" > $LOGFILE
echo "" > $LOGFILE

# identify lines with missing class and output to logfile
echo "-----------------------------------------------------" >> $LOGFILE
echo "THE FOLLOWING LINES HAVE NO CLASS DEFINED IN RADREPLY" >> $LOGFILE
echo "-----------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -c "select line.billing_entity_id
                  ,bent.name
                  ,line.line_id
                  ,coalesce((select value 
                               from radreply 
                              where attribute = 'Class' 
                                and username = line.radius_username),'Class Missing') as class
                  ,line.active_flag
                  ,line.start_date as line_start
                  ,line.end_date as line_end
                  ,line.radius_username
                  ,line.line_label
              from line
              join billing_entity bent using (billing_entity_id)
             where line.active_flag
               and not exists (select true
                                 from csctoss.radreply
                                where attribute = 'Class'
                                  and username = line.radius_username)
               and exists (select true
                             from line_equipment
                            where line_id = line.line_id
                              and end_date is null)
                         order by line.line_id" >> $LOGFILE

# identify lines with disagreeing class and write to logfile
echo "" >> $LOGFILE
echo "-----------------------------------------------------------" >> $LOGFILE
echo "THE FOLLOWING LINES DISAGREE BETWEEN LINE AND DEFINED CLASS" >> $LOGFILE
echo "-----------------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -c "select line.billing_entity_id
                  ,bent.name
                  ,line.line_id
                  ,rrep.value as class
                  ,line.active_flag
                  ,line.start_date as line_start
                  ,line.end_date as line_end
                  ,line.radius_username
                  ,line.line_label
              from line
   left outer join radreply rrep on (rrep.username = line.radius_username and rrep.attribute = 'Class')
              join billing_entity bent using (billing_entity_id)
             where line.active_flag
               and line.line_id <> rrep.value
               and exists (select true
                             from csctoss.radreply
                            where attribute = 'Class'
                              and username = line.radius_username)
               and exists (select true
                             from line_equipment
                            where line_id = line.line_id
                              and end_date is null)
          order by line.line_id" >> $LOGFILE

#cat $LOGFILE | mail -s "CSCTOSS LINE/CLASS REPORT FOR $DATE" dba@cctus.com

# identify lines with disagreeing billing_entity_address_id of PHYSICAL and write to logfile
echo "" >> $LOGFILE
echo "----------------------------------------------------------------------------" >> $LOGFILE
echo "THE FOLLOWING LINES DISAGREE BETWEEN LINE PHYSICAL BILLING_ENTITY_ADDRESS_ID" >> $LOGFILE
echo "----------------------------------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -c "select bent.name
                  ,line.billing_entity_id
                  ,line.line_id
                  ,line.billing_entity_address_id as bead_current
                  ,bead.address_type as address_type_current
                  ,(select address_id 
                      from billing_entity_address 
                     where billing_entity_id = line.billing_entity_id 
                       and address_type = 'PHYSICAL') as bead_correct
                  ,'PHYSICAL' as address_type_correct
              from line
              join billing_entity bent using (billing_entity_id)
              join billing_entity_address bead on (line.billing_entity_id = bead.billing_entity_id and line.billing_entity_address_id = bead.address_id)
             where line.billing_entity_address_id <> (select address_id 
                                                        from billing_entity_address 
                                                       where billing_entity_id = line.billing_entity_id 
                                                         and address_type = 'PHYSICAL')
          order by bent.name
                  ,line.line_id" >> $LOGFILE

if [ `grep "(0 rows)" $LOGFILE | wc -l` -eq 3 ]; then
  echo "" >> $LOGFILE
  echo "No rows found. Do not mail empty results." >> $LOGFILE
else

  echo "" >> $LOGFILE
  echo "NOTE: The discrepancies have been auto corrected ..." >> $LOGFILE
  echo "" >> $LOGFILE

  cat $LOGFILE | mail -s "CSCTOSS LINE CLASS UPDATER REPORT FOR: $DATE" dba@cctus.com

  # this chunk of code corrects the most common error so we dont have to do it manually
  qry=`psql -q << EOF

  create view csctoss.line_err_temp
      as select line.line_id
              ,(select address_id
                  from billing_entity_address
                 where billing_entity_id = line.billing_entity_id
                   and address_type = 'PHYSICAL') as bead_correct
           from csctoss.line
           join csctoss.billing_entity bent using (billing_entity_id)
           join csctoss.billing_entity_address bead on (line.billing_entity_id =
                bead.billing_entity_id and line.billing_entity_address_id = bead.address_id)
          where line.billing_entity_address_id <> (select address_id
                                                     from csctoss.billing_entity_address
                                                    where billing_entity_id = line.billing_entity_id
                                                      and address_type = 'PHYSICAL') ;
  select public.set_change_log_staff_id(3) ;

  update csctoss.line_equipment
     set billing_entity_address_id = line_err_temp.bead_correct
    from csctoss.line_err_temp
   where line_equipment.line_id = line_err_temp.line_id ;

  update csctoss.line
     set billing_entity_address_id = line_err_temp.bead_correct
    from csctoss.line_err_temp
   where line.line_id = line_err_temp.line_id ;

  drop view csctoss.line_err_temp ;

  \q`
fi

# remove log files older than 7 days
find $BASEDIR/logs/line_class_updater* -mtime +7 -exec rm -f {} \;
exit 0
