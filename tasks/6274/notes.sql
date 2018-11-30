SELECT
  a.esn,
  TRIM(SUBSTRING(a.esn, 1, LOCATE(',', a.esn) - 1)) AS esn1,
  TRIM(SUBSTRING(a.esn, LOCATE(',', a.esn) + 1)) AS esn2,
  a.cellsignal,
  FROM_UNIXTIME(a.timestamp) AS timestamp
FROM cellsignal a
WHERE 1 = 1
AND a.timestamp >= unix_timestamp(CURRENT_TIMESTAMP - INTERVAL 1 DAY)
AND EXISTS (
  SELECT
  *
  FROM cellsignal b
  WHERE 1 = 1
  AND b.timestamp >= unix_timestamp(CURRENT_TIMESTAMP - INTERVAL 1 DAY)
  AND b.esn = a.esn
  GROUP BY b.esn
  HAVING MAX(b.timestamp) = a.timestamp
)


Resolution to issue:

1.  Log in to SOUP server and 'sudo su -'
2.  log in to the mysql database:  mysql -u root sdm
3.  Using the sql from copy_cellsignal_to_csctoss.sh, execute the 
    following query:

    SELECT a.esn
          ,TRIM(SUBSTRING(a.esn, 1, LOCATE(',', a.esn) - 1)) AS esn1
          ,TRIM(SUBSTRING(a.esn, LOCATE(',', a.esn) + 1)) AS esn2
          ,a.cellsignal,
    FROM_UNIXTIME(a.timestamp) AS timestamp
    FROM cellsignal a
    WHERE 1 = 1
    AND a.timestamp >= unix_timestamp(CURRENT_TIMESTAMP - INTERVAL 1 DAY)

    Result is 88 records displayed; way to small a population.

4.  Re-ran the script with 'INTERVAL 2 DAY'.

5.  Results showed a large number of entries, which is expected.  Something
    happenned within last two days.
6.  Checked /opt/sdm/sdm.log and found that there was a reboot two days ago.
7.  Check to see if the python script /opt/sdm/sdm.py is running.  Issuing a ps -ef
    command shows that the script is not running.
8.  Execute the /opt/sdm/startsdm script to start the sdm.py program

    ./startsdm

9.  Issue the ps -ef command again:

    ps -ef | grep sdm

    [root@densoup01 sdm]# ps -ef | grep sdm
    root       461     1  4 14:53 pts/1    00:00:00 python2 /opt/sdm/sdm.py -v
    root       505 32552  0 14:53 pts/1    00:00:00 grep sdm
    root      9040  9039  0 Mar14 ?        00:00:00 inotifywait -m /opt/sdm/savefiles -e create -e moved_to
    [

10. Execute the "tail -f /opt/sdm/sdm.log" command to verify that data is being generated.

11. On OSS, query database table soup_ellsignal:

    select count(*) FROM soup_cellsignal ;
     count 
    -------
      4566
    (1 row)

    This verifies that data is being transmitted.

12. Issue is resolved.



crontab -e
 3957  /opt/soup-scripts/copy_cellsignal_to_csctoss.sh
 3958  vi /opt/soup-scripts/copy_cellsignal_to_csctoss.sh
 3959  crontab -e
 3960  cat /tmp/copy_cellsignal_to_csctoss.log
 3961  ls /tmp/copy_cellsignal_to_csctoss.log
 3962  ls -ltra /tmp/copy_cellsignal_to_csctoss.log
 3963  crontab -e
 3964  mysql -u root sdm
 3965  df -h
 3966  less /var/log/messages
 3967  uptime 
 3968  last 
 3969  last | less
 3970  sync
 3971  netstat -anpt | less
 3972  netstat -anpt | grep LISTEN
 3973  crontab -e
 3974  date
 3975  ls -ltrah
 3976  crontab -e
 3977  tail -f /opt/sdm/sdm.log
 3978  ps -ef | grep sdm
 3979  cd /opt/sdm/
 3980  ls
 3981  ./startsdm 
 3982  ps -ef | grep sdm
 3983  tail -f /opt/sdm/sdm.log
 3984  crontab -e
 3985  cd /opt/soup-adminscripts/
 3986  ls
 3987  cd //
 3988  cd /opt/soup-scripts/
 3989  ls
 3990  ./copy_cellsignal_to_csctoss.sh
 3991  ls /opt/sdm/
 3992  ps -ef | grep start*
 3993  ps -ef | grep start
 3994  ps -ef | grep sdm
 3995  ls -ltr
 3996  ls /opt/sdm/*.log -ltr
 3997  ls -l /opt/sdm/sdm.log
 3998  ls -ltr /opt/sdm/sdm*
 3999  tail -f /opt/sdm/sdm.log
 4000  history 
[root@densoup01 soup-scripts]# !3957
/opt/soup-scripts/copy_cellsignal_to_csctoss.sh
BEGIN
DELETE 703
COMMIT
VACUUM
Done.
