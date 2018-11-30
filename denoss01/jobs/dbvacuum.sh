#!/bin/bash
#
# Script to periodically vacuum / analyze the csctoss database.
#
set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres/dba
VACLOG=$BASEDIR/logs/csctoss_vacuum.D`date +%u`.log

echo ""                                                                      	>  $VACLOG
echo "CSCTOSS DB `hostname` Database Vacuum Report"                          	>> $VACLOG
echo "---------------------------------------------------"                   	>> $VACLOG
echo ""                                                                      	>> $VACLOG

# remove logs older than 1 week
find $BASEDIR/logs/csctoss_vacuum.*.log -mtime +6 -print|xargs -i rm {}     	>> $VACLOG

# run the vacuum command with appropriate parameters
psql -q -U postgres -c "vacuum analyze verbose" -d csctoss 
cat $BASEDIR/logs/csctoss_vacuum.log                                      	>> $VACLOG
rm -f $BASEDIR/logs/csctoss_vacuum.log
exit 0
