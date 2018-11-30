#
# Removes log files from the following directories:
#   /home/postgres/csctoss_logs
#   /home/postgres/slony/LOGS
#
source /home/postgres/.bash_profile

# standard postgres database logs -- 5 days
find /pgdata/pg_8014/csctoss_logs -mtime +5 -exec rm -f {} \;

# job logs -- 14 days
find /home/postgres/dba/logs -mtime +14 -exec rm -f {} \;

# slony logs -- 14 days
find $SLONYLOGS/*log* -mtime +14 -exec rm -f {} \;

exit 0

