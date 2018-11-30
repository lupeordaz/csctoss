DELETE from nagalert where fwstart_time < NOW() - INTERVAL 5 DAY 

Start putting active/cancelled lines into OpenTaps database......
EOS

/usr/bin/mysql -A -h 10.17.70.22 -P 3306 -u root --password=cctus@admin123 cct_0007 < /opt/scripts/load_lines_into_opentaps.sql

cat <<- EOS
Finished putting active/cancelled lines into OpenTaps database.

Calculate number of records on service_line_number/service_line_detail tables.....
EOS


/usr/bin/mysql DELETE FROM NAGALERT WHERE FWSTART_TIME < now() - INTERVAL 5 DAY;


[root@denmgt04 ~]# mysql -D Syslog -e "select count(*) from nagalert where fwstart_time < (NOW() - INTERVAL 5 DAY);"
+----------+
| count(*) |
+----------+
|    85904 |
+----------+
[root@denmgt04 ~]# 


[root@denmgt04 ~]# mysql -D Syslog -e "select count(*) from nagalert where fwstart_time < (NOW() - INTERVAL 6 DAY);"
+----------+
| count(*) |
+----------+
|       18 |
+----------+
[root@denmgt04 ~]# 

# ############################################################# #
# Min | HR | Day of Month | Month | Day of Week | File | Output #
# ############################################################# #

# NOTE : This server on UTC. 7am UTC = 12 Midnight MST

# execute syslog purge command 
05 07 * * * /usr/bin/mysql -D Syslog -e "delete from nagalert where fwstart_time < (NOW() - INTERVAL 5 DAY);"


[root@denmgt04 ~]# /usr/bin/mysql -D Syslog -e "select count(*) from nagalert where fwstart_time < (NOW() - INTERVAL 6 DAY);" 
+----------+
| count(*) |
+----------+
|        0 |
+----------+
