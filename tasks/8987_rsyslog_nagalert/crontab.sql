# ############################################################# #
# Min | HR | Day of Month | Month | Day of Week | File | Output #
# ############################################################# #

# NOTE : This server on UTC. 7am UTC = 12 Midnight MST

# execute syslog purge command 
05 07 * * * /usr/bin/mysql -D Syslog -e "delete from nagalert where fwstart_time < (NOW() - INTERVAL 5 DAY);"
