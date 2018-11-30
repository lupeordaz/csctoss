
SELECT
  line_id                 ,
  serial_number           ,
  esn_hex                 ,
  connection_status       ,
  is_connected            ,
FROM csctoss.portal_active_lines_vw
WHERE (billing_entity_id = 699 
   OR parent_billing_entity_id = 699);


SELECT radius_username
  FROM csctoss.portal_active_lines_vw
 WHERE (billing_entity_id = 699
       OR parent_billing_entity_id = 699);

           radius_username            
--------------------------------------
 4705327118@vzw3g.com
 4705327119@vzw3g.com
.
.
.
 4704231075@vzw3g.com
 4703829344@vzw3g.com
(90 rows)

--


select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
 from master_radacct
where username = '4705327119@vzw3g.com'
order by acctstarttime desc;
     acctstarttime      
------------------------
 2018-05-18 21:45:02+00
 2018-05-18 21:39:13+00
 2018-04-28 23:45:44+00
 2018-04-22 17:05:42+00
 2018-04-18 20:01:25+00
 2018-04-02 04:55:51+00
 2018-03-21 19:11:46+00
 2018-03-17 03:16:27+00
 2018-03-17 02:16:34+00
 2018-03-17 02:11:17+00
 2018-03-17 00:16:36+00
 2018-03-16 23:59:56+00
 2018-03-16 22:21:32+00
 2018-03-11 13:50:14+00
 2018-02-16 21:51:04+00
 2018-01-21 07:16:59+00
 2018-01-03 00:44:23+00
 2018-01-03 00:42:56+00
 2018-01-01 06:03:07+00
 2017-12-17 11:30:58+00
 2017-12-16 16:17:19+00
 2017-12-14 16:17:42+00
 2017-12-14 02:32:18+00
 2017-12-07 09:24:31+00
 2017-11-29 20:59:57+00
 2017-11-29 20:59:30+00
 2017-11-16 18:32:10+00
 2017-11-15 23:21:15+00
 2017-11-15 01:49:45+00
 2017-11-10 00:53:11+00
 2017-11-09 21:34:13+00
 2017-11-01 10:51:31+00
 2017-10-23 23:59:01+00
 2017-10-15 14:07:06+00
 2017-10-15 14:05:31+00



SELECT radius_username
FROM csctoss.portal_active_lines_vw
WHERE (billing_entity_id = 699
       OR parent_billing_entity_id = 699)
  AND is_connected = 'NO';

           radius_username            
--------------------------------------
 4703829344@vzw3g.com
 4704231075@vzw3g.com
 4703163516@vzw3g.com
 4703829617@vzw3g.com
 4704230142@vzw3g.com
 882393256289434@m2m01.contournet.net
 4703460187@vzw3g.com
. 
.
.
 4705327144@vzw3g.com
 4705327148@vzw3g.com
 4705327131@vzw3g.com
 4705327119@vzw3g.com

--



select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
 from master_radacct
where username IN (
'4703829344@vzw3g.com',
'4704231075@vzw3g.com',
'4703163516@vzw3g.com',
'4703829617@vzw3g.com',
'4704230142@vzw3g.com',
'882393256289434@m2m01.contournet.net',
'4703460187@vzw3g.com',
.
.
.
'4705327144@vzw3g.com',
'4705327148@vzw3g.com',
'4705327131@vzw3g.com',
'4705327119@vzw3g.com') 
order by acctstarttime desc;


select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
  from master_radacct 
 where username = '4705327119@vzw3g.com'
 order by acctstarttime desc
 limit 6;
       username       | framedipaddress |     acctstarttime      |      acctstoptime      
----------------------+-----------------+------------------------+------------------------
 4705327119@vzw3g.com | 10.81.139.2     | 2018-05-18 21:45:02+00 | 
 4705327119@vzw3g.com | 10.81.139.2     | 2018-05-18 21:39:13+00 | 2018-05-18 21:44:37+00
 4705327119@vzw3g.com | 10.81.139.2     | 2018-04-28 23:45:44+00 | 2018-05-18 22:37:05+00
 4705327119@vzw3g.com | 10.81.139.2     | 2018-04-22 17:05:42+00 | 2018-04-28 22:45:09+00
 4705327119@vzw3g.com | 10.81.139.2     | 2018-04-18 20:01:25+00 | 2018-04-22 17:04:19+00
 4705327119@vzw3g.com | 10.81.139.2     | 2018-04-02 04:55:51+00 | 2018-04-18 20:59:18+00
(6 rows)

--

select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
  from master_radacct
 where username = '4705327119@vzw3g.com'
   and acctstarttime > '2018-05-01 00:00:00'::timestamp with time zone
 order by acctstarttime desc
 limit 1;

       username       | framedipaddress |     acctstarttime      | acctstoptime 
----------------------+-----------------+------------------------+--------------
 4705327119@vzw3g.com | 10.81.139.2     | 2018-05-18 21:45:02+00 | 
(1 row)


