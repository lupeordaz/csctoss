# !/bin/bash
#
# Database sizing report using "du" command and Postgres dbsize functions. Send to aallard once a month.
#
# Parms: 1)database name to analyze
#        2)directory to analyze
#
source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/db_sizing_report.out

# Check parameters
echo ""
if [ $# -lt 2 ]; then
  echo "ERROR: Usage ./db_sizing_report.sh <<database name>> <<directory to analyze>>"
  echo ""
  exit 1
elif [ $1 != "csctoss" -a $1 != "radiusdb" ]; then
  echo "ERROR: First parameter must be csctoss or radiusdb"
  echo ""
  exit 1
elif [ $2 != "/home/postgres" -a $2 != "/opt/pgsql" ]; then
  echo "ERROR: Second parameter must be /home/postgres or /opt/pgsql"
  echo ""
  exit 1
fi 

# Open psql session and query database size
psql -U postgres -d $1 -c "SELECT * FROM ROUND(pg_database_size('$1')::numeric/1048576,2)" > ./db_sizing_report.txt
RESULT=`sed -n 3,3p ./db_sizing_report.txt | sed 's/^[ \t]*//'`
rm -f ./db_sizing_report.txt

# Build email, get disk usage, send report
echo "**************************************************"	>  $LOGFILE
echo "DB Sizing Report For: `hostname`"				>> $LOGFILE
echo "Report Date         : `date +%Y%m%d`"			>> $LOGFILE
echo "**************************************************"	>> $LOGFILE
echo ""								>> $LOGFILE
echo "Database $1 Aggregate Size:"				>> $LOGFILE
echo "--------------------------------------------------"	>> $LOGFILE
echo "$RESULT MB"						>> $LOGFILE
echo ""								>> $LOGFILE
echo "Directory Analyzed: $2"					>> $LOGFILE
echo "--------------------------------------------------"	>> $LOGFILE
du -ch --max-depth=1 $2 					>> $LOGFILE
echo ""								>> $LOGFILE

for NAME in {"dba@cctus.com"}; do
  cat $LOGFILE | mail -s "DB Sizing Report For: `hostname`" $NAME
done

exit 0

