#!/bin/bash
#
# Script to periodically vacuum / analyze the csctmon database.
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres/dba
VACLOG=$BASEDIR/logs/csctmon_vacuum.D`date +%u`.log

echo ""                                                                      	>  $VACLOG
echo "CSCTMON DB `hostname` Database Vacuum Report"                          	>> $VACLOG
echo "---------------------------------------------------"                   	>> $VACLOG
echo ""                                                                      	>> $VACLOG

# run the vacuum command with appropriate parameters
psql -q -U postgres -c "vacuum analyze verbose" -d csctmon 
cat $BASEDIR/logs/csctmon_vacuum.log                                      	>> $VACLOG
rm -f $BASEDIR/logs/csctmon_vacuum.log
exit 0
