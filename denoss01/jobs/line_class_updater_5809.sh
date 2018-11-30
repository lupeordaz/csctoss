#!/bin/bash
#
# Populates missing Class attribute in radreply table with line_id and corrects mismatched data.
#
# $Id: $
#
#set -x
source /home/postgres/.bash_profile
DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/line_class_updater_5809.$DATE

v_cnt=`psql -q -t -f line_class_qry1.sql`

echo $v_cnt
if [ $v_cnt -gt 0 ]
then
    #echo "CSCTOSS LINE/CLASS REPORT FOR $DATE" > $LOGFILE
    echo "" > $LOGFILE

    # identify lines with missing class and output to logfile
    echo "-----------------------------------------------------" >> $LOGFILE
    echo "THE FOLLOWING LINES HAVE NO CLASS DEFINED IN RADREPLY" >> $LOGFILE
    echo "-----------------------------------------------------" >> $LOGFILE
    echo "" >> $LOGFILE

    psql -q -t -f line_class_qry2.sql >> $LOGFILE
    psql -q -c "select * from line_class_fix()" >> $LOGFILE
fi
