


mysql> select service, returncode, count(*) from alerts where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK) group by service, returncode order by service, returncode;
+-------------------+------------+----------+
| service           | returncode | count(*) |
+-------------------+------------+----------+
| CellularManager   |          1 |        6 |
| CellularManager   |          2 |    18899 |
| CellularManager   |          3 |      612 |
| CellularManager   |          4 |   147541 |
| CellularManager   |          5 |        2 |
| CellularManager   |          6 |     1087 |
| CellularManager   |          7 |      221 |
| CellularManager   |          8 |        2 |
| CellularManager   |         10 |        1 |
| PortManager       |          1 |        7 |
| PortManager       |          2 |       16 |
| PortManager       |         16 |        8 |
| SOUP              |          1 |        1 |
| TransactionLogger |          0 |     1106 |
| TransactionLogger |          5 |     1375 |
+-------------------+------------+----------+
15 rows in set (1.38 sec)

mysql> select did       ,service       ,returncode        ,output   from alerts   where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     and service = 'CellularManager'     and returncode = 1;
+------+-----------------+------------+-------------------------------+
| did  | service         | returncode | output                        |
+------+-----------------+------------+-------------------------------+
| 9103 | CellularManager |          1 | Dead PPP connection restarted |
| 3616 | CellularManager |          1 | Dead PPP connection restarted |
| 8491 | CellularManager |          1 | Dead PPP connection restarted |
| 8892 | CellularManager |          1 | Dead PPP connection restarted |
| 9103 | CellularManager |          1 | Dead PPP connection restarted |
| 9103 | CellularManager |          1 | Dead PPP connection restarted |
+------+-----------------+------------+-------------------------------+
6 rows in set (0.70 sec)

mysql> select did       ,service       ,returncode        ,output   from alerts   where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     and service = 'CellularManager'     and returncode = 2 limit 15;
+-------+-----------------+------------+---------------------------------------+
| did   | service         | returncode | output                                |
+-------+-----------------+------------+---------------------------------------+
|  4541 | CellularManager |          2 | Rebooted due to watchdog timeout      |
| 14172 | CellularManager |          2 | Rebooted due to watchdog timeout      |
| 13244 | CellularManager |          2 | Rebooted due to watchdog timeout      |
| 12364 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  6421 | CellularManager |          2 | Rebooted due to watchdog timeout      |
| 14556 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  4468 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  1755 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  1587 | CellularManager |          2 | Rebooted due to watchdog timeout      |
| 13524 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  5376 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  4152 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  9493 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  4276 | CellularManager |          2 | Rebooted due to watchdog timeout      |
|  3247 | CellularManager |          2 | Connection Monitor rebooted the unit. |
+-------+-----------------+------------+---------------------------------------+
15 rows in set (0.74 sec)


select did
      ,output
      ,count(*)
  from alerts
 where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 1 DAY)
   and service = 'CellularManager'
   and returncode = 4
 group by did, output
having count(*) > 1
 order by did, output;


mysql> select did       ,service       ,returncode        ,output   from alerts   where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     and service = 'CellularManager'     and returncode = 4 limit 15;
+-------+-----------------+------------+--------------------------------------------------------------------------------------+
| did   | service         | returncode | output                                                                               |
+-------+-----------------+------------+--------------------------------------------------------------------------------------+
|  6497 | CellularManager |          4 | Average Signal Strength 96% over 24 hours 00 minutes,MIN = 29%,MAX = 100%            |
|  1591 | CellularManager |          4 | Average Signal Strength 96% over 24 hours 00 minutes,MIN = 67%,MAX = 100%            |
|  8493 | CellularManager |          4 | FW2770P(0):Average Signal Strength 96% over 24 hours 00 minutes,MIN = 83%,MAX = 100% |
| 14364 | CellularManager |          4 | Average Signal Strength 19% over 24 hours 00 minutes,MIN = 6%,MAX = 32%              |
| 12227 | CellularManager |          4 | Average Signal Strength 61% over 24 hours 00 minutes,MIN = 54%,MAX = 67%             |
|  4010 | CellularManager |          4 | Average Signal Strength 77% over 24 hours 00 minutes,MIN = 51%,MAX = 100%            |
| 12142 | CellularManager |          4 | Average Signal Strength 83% over 24 hours 00 minutes,MIN = 19%,MAX = 100%            |
| 10193 | CellularManager |          4 | Average Signal Strength 77% over 24 hours 00 minutes,MIN = 54%,MAX = 96%             |
|  6714 | CellularManager |          4 | Average Signal Strength 96% over 24 hours 00 minutes,MIN = 96%,MAX = 100%            |
|  2681 | CellularManager |          4 | Average Signal Strength 45% over 24 hours 00 minutes,MIN = 0%,MAX = 67%, 0% errors   |
|  6188 | CellularManager |          4 | Average Signal Strength 22% over 24 hours 00 minutes,MIN = 0%,MAX = 35%, 0% errors   |
| 11450 | CellularManager |          4 | Average Signal Strength 58% over 24 hours 00 minutes,MIN = 38%,MAX = 67%             |
| 11352 | CellularManager |          4 | Average Signal Strength 96% over 24 hours 00 minutes,MIN = 96%,MAX = 100%            |
|  5708 | CellularManager |          4 | FW2770P(0):Average Signal Strength 96% over 24 hours 00 minutes,MIN = 83%,MAX = 100% |
|  6007 | CellularManager |          4 | Average Signal Strength 58% over 24 hours 00 minutes,MIN = 38%,MAX = 67%             |
+-------+-----------------+------------+--------------------------------------------------------------------------------------+
15 rows in set (1.44 sec)

mysql> select did       ,service       ,returncode        ,output   from alerts   where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     and service = 'CellularManager'     and returncode = 3 limit 15;
+-------+-----------------+------------+---------------------------------------------------+
| did   | service         | returncode | output                                            |
+-------+-----------------+------------+---------------------------------------------------+
|  8551 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  1331 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  4320 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  9493 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  3095 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  2761 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  4152 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
| 11240 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
| 11886 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  1317 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  8937 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
| 11240 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
| 12661 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
| 11258 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
|  1058 | CellularManager |          3 | Restarting PPP connection due to no DNS response. |
+-------+-----------------+------------+---------------------------------------------------+
15 rows in set (0.68 sec)


select did
      ,service       
      ,returncode        
      ,output   
  from alerts   
 where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     
   and service = 'CellularManager'     
   and returncode = 6 limit 15

mysql> select did       ,service       ,returncode        ,output   from alerts   where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     and service = 'CellularManager'     and returncode = 6 limit 15;
+-------+-----------------+------------+-----------------------------------------------------+
| did   | service         | returncode | output                                              |
+-------+-----------------+------------+-----------------------------------------------------+
| 13943 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
| 12102 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  5467 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  1991 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
| 12782 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  3727 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  3727 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  3727 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  3727 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  9791 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
| 12102 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  4424 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  4821 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  3727 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
|  8569 | CellularManager |          6 | Restarting PPP connection due to PPP check failure. |
+-------+-----------------+------------+-----------------------------------------------------+
15 rows in set (0.67 sec)



select did
      ,service       
      ,returncode        
      ,output   
  from alerts   
 where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 2 WEEK)     
   and service = 'CellularManager'     
   and returncode = 7 limit 15

+-------+-----------------+------------+-----------------------------------------------------+
| did   | service         | returncode | output                                              |
+-------+-----------------+------------+-----------------------------------------------------+
|  4821 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  2971 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  2971 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  6718 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  8990 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  4630 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9132 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9132 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
| 11914 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
| 11692 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9730 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9730 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9730 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  9730 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
|  2769 | CellularManager |          7 | Resetting cellular module due to PPP check failure. |
+-------+-----------------+------------+-----------------------------------------------------+


select did
      ,output
      ,count(*)
  from alerts
 where from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 1 DAY)
   and service = 'CellularManager'
   and returncode = 7
 group by did, output
having count(*) > 1
 order by did, output;

+------+-----------------------------------------------------+----------+
| did  | output                                              | count(*) |
+------+-----------------------------------------------------+----------+
| 2701 | Resetting cellular module due to PPP check failure. |        3 |
| 9730 | Resetting cellular module due to PPP check failure. |        2 |
+------+-----------------------------------------------------+----------+
2 rows in set (0.71 sec)



select d.serial_number
      ,d.eui as mac_address
      ,a.output
      ,count(*)
  from alerts a
  join device d on d.did = a.did
 where from_unixtime(a.srvtimestamp) >= (NOW() - INTERVAL 1 WEEK)
   and a.service = 'CellularManager'
   and a.returncode = 6
 group by a.did
having count(*) > 2
 order by count(*) desc

+---------------+--------------+-----------------------------------------------------+----------+
| serial_number | mac_address  | output                                              | count(*) |
+---------------+--------------+-----------------------------------------------------+----------+
| 890480        | 008044117C14 | Restarting PPP connection due to PPP check failure. |       27 |
| 760571        | 0080441013DC | Restarting PPP connection due to PPP check failure. |       15 |
| 699540        | 0080440F3600 | Restarting PPP connection due to PPP check failure. |       11 |
| 777110        | 0080441071EF | Restarting PPP connection due to PPP check failure. |       11 |
| 767092        | 0080440FE3D1 | Restarting PPP connection due to PPP check failure. |        9 |
| 699539        | 0080440F361A | Restarting PPP connection due to PPP check failure. |        9 |
| 699853        | 0080440F38AB | Restarting PPP connection due to PPP check failure. |        9 |
| 688316        | 0080440E744E | Restarting PPP connection due to PPP check failure. |        8 |
| 769144        | 0080441060B0 | Restarting PPP connection due to PPP check failure. |        8 |
| 767851        | 008044102B27 | Restarting PPP connection due to PPP check failure. |        7 |
| 732786        | 0080440FEF96 | Restarting PPP connection due to PPP check failure. |        7 |
| 765578        | 0080441028B1 | Restarting PPP connection due to PPP check failure. |        7 |
| 752936        | 008044104CDF | Restarting PPP connection due to PPP check failure. |        7 |
| 767102        | 0080440FE3EE | Restarting PPP connection due to PPP check failure. |        7 |
| 791169        | 00804410B48D | Restarting PPP connection due to PPP check failure. |        6 |
| 749209        | 0080440FFBD3 | Restarting PPP connection due to PPP check failure. |        6 |
| 770280        | 008044106375 | Restarting PPP connection due to PPP check failure. |        6 |
| 760067        | 0080441012B9 | Restarting PPP connection due to PPP check failure. |        6 |
| 766977        | 008044102A99 | Restarting PPP connection due to PPP check failure. |        6 |
| 770256        | 008044106356 | Restarting PPP connection due to PPP check failure. |        5 |
| 797703        | 00804410C583 | Restarting PPP connection due to PPP check failure. |        5 |
| 669649        | 0080440ED470 | Restarting PPP connection due to PPP check failure. |        5 |
| 788559        | 00804410A8E7 | Restarting PPP connection due to PPP check failure. |        4 |
| 690920        | 0080440F1A2A | Restarting PPP connection due to PPP check failure. |        4 |
| 895772        | 00804411B136 | Restarting PPP connection due to PPP check failure. |        4 |
| 873919        | 008044114397 | Restarting PPP connection due to PPP check failure. |        4 |
| 887306        | 00804411660A | Restarting PPP connection due to PPP check failure. |        4 |
| 681271        | 0080440E96C8 | Restarting PPP connection due to PPP check failure. |        4 |
| 788621        | 00804410A96D | Restarting PPP connection due to PPP check failure. |        4 |
| 874273        | 00804411496B | Restarting PPP connection due to PPP check failure. |        3 |
| 858003        | 00804410D98B | Restarting PPP connection due to PPP check failure. |        3 |
| 699727        | 0080440F36AE | Restarting PPP connection due to PPP check failure. |        3 |
| 779853        | 008044108DA2 | Restarting PPP connection due to PPP check failure. |        3 |
| 675755        | 0080440EE151 | Restarting PPP connection due to PPP check failure. |        3 |
| 776984        | 008044108072 | Restarting PPP connection due to PPP check failure. |        3 |
| 681439        | 0080440E8C81 | Restarting PPP connection due to PPP check failure. |        3 |
| 770334        | 008044106322 | Restarting PPP connection due to PPP check failure. |        3 |
| 732615        | 0080440FED93 | Restarting PPP connection due to PPP check failure. |        3 |
| 857815        | 00804410F9CB | Restarting PPP connection due to PPP check failure. |        3 |
| 777379        | 0080441090E3 | Restarting PPP connection due to PPP check failure. |        3 |
| 888345        | 008044117103 | Restarting PPP connection due to PPP check failure. |        3 |
| 681438        | 0080440E8C7E | Restarting PPP connection due to PPP check failure. |        3 |
| 681275        | 0080440E9D45 | Restarting PPP connection due to PPP check failure. |        3 |
| 866400        | 0080441119D0 | Restarting PPP connection due to PPP check failure. |        3 |
| 875808        | 00804411556A | Restarting PPP connection due to PPP check failure. |        3 |
| 860597        | 0080441124D2 | Restarting PPP connection due to PPP check failure. |        3 |
+---------------+--------------+-----------------------------------------------------+----------+
46 rows in set (0.73 sec)


select count(*) from (
SELECT
  device.did AS did,
  device.serial_number AS serial_number,
  DATE_FORMAT(FROM_UNIXTIME(alerts.srvtimestamp), '%Y-%m-%d %H:%i:%s') AS server_timestamp,
  DATE_FORMAT(FROM_UNIXTIME(alerts.locltimestamp), '%Y-%m-%d %H:%i:%s') AS local_timestamp,
  service AS service,
  returncode AS returncode,
  output AS output
FROM alerts
JOIN device ON (alerts.did = device.did)
WHERE from_unixtime(srvtimestamp) >= (NOW() - INTERVAL 14 DAY) ) as total



