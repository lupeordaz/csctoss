#
# Removes log files from the following directories:
#   /u01/csctmon_logs
#   /home/postgres/dba/logs
#
source /home/postgres/.bash_profile

# standard postgres database logs -- 7 days
find /u01/csctmon_logs -mtime +5 -exec rm -f {} \;

# job logs -- 14 days
find /home/postgres/dba/logs -mtime +14 -exec rm -f {} \;

exit 0
