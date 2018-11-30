-- Test device 639831 on DENOSS01

select le.equipment_id
      ,uis.value as SN
      ,uie.value as ESN
      ,le.line_id
      ,l.billing_entity_id
      ,l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uis on (uis.equipment_id = le.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER')
  join unique_identifier uie on (uie.equipment_id = le.equipment_id and uie.unique_identifier_type = 'ESN HEX')
 where uis.value = '639831';

 equipment_id |   sn   |   esn    | line_id | billing_entity_id |   radius_username   
--------------+--------+----------+---------+-------------------+---------------------
         2379 | 639831 | F611C1DC |    2553 |               112 | 
         2379 | 639831 | F611C1DC |   43997 |               703 | 
         2379 | 639831 | F611C1DC |   44009 |               112 | 3123883702@uscc.net
(3 rows)

--  Call packet_of_disconnect(username);

select * from packet_of_disconnect( '3123883702@uscc.net');

                                  packet_of_disconnect                                   
-----------------------------------------------------------------------------------------
 RC1: SUCCESS
 RC2: Username 3123883702@uscc.net POD sent to denasr01.contournetworks.net
 RC3: 3123883702@uscc.net,0677F803,10.48.162.57,,denasr01.contournetworks.net
 ERR:
(4 rows)


-- Retrieve Log results

SELECT p.acctsessionid
      ,p.username
      ,p.acctstarttime
      ,p.acctstoptime
      ,p.connectinfo_start
      ,p.connectinfo_stop
      ,p.acctterminatecause
      ,p.nasipaddress
  FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
                                    ,'SELECT acctsessionid
                                            ,username
                                            ,acctstarttime
                                            ,acctstoptime
                                            ,connectinfo_start
                                            ,connectinfo_stop
                                            ,acctterminatecause
                                            ,nasipaddress
                                        FROM master_radacct 
                                       WHERE acctsessionid = ''0677F803''
                                         AND username = ''3123883702@uscc.net''')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text);

 acctsessionid |            username            |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 0677F803      | 3123883702@uscc.net | 2018-03-15 03:02:14+00 |              | 64000/57600       |                  |                    | 68.28.81.76(1 row)


--  Display last 10 starttimes

SELECT p.acctsessionid
      ,p.username
      ,p.acctstarttime
      ,p.acctstoptime
      ,p.connectinfo_start
      ,p.connectinfo_stop
      ,p.acctterminatecause
      ,p.nasipaddress
  FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
                                    ,'SELECT acctsessionid
                                            ,username
                                            ,acctstarttime
                                            ,acctstoptime
                                            ,connectinfo_start
                                            ,connectinfo_stop
                                            ,acctterminatecause
                                            ,nasipaddress
                                        FROM master_radacct 
                                       WHERE username = ''3123883702@uscc.net''')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text)
 ORDER BY 3 DESC
 LIMIT 10;

  acctsessionid |            username            |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 00A3431C      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:35:41+00 | 2018-03-15 15:52:52+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 00A34244      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:24:47+00 | 2018-03-15 03:34:54+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01735595      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:14:39+00 | 2018-03-15 03:24:05+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 0173552B      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 02:58:41+00 | 2018-03-15 03:13:55+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01735342      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 01:35:56+00 | 2018-03-15 02:57:51+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 00A3383A      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 00:04:44+00 | 2018-03-15 01:35:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01734F7F      | 5774870113@tsp17.sprintpcs.com | 2018-03-14 23:18:59+00 | 2018-03-15 00:04:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 016FACE6      | 5774870113@tsp17.sprintpcs.com | 2018-02-21 21:42:28+00 | 2018-02-22 21:42:33+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 009E98B5      | 5774870113@tsp17.sprintpcs.com | 2018-02-20 21:25:30+00 | 2018-02-21 21:25:35+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 009E4330      | 5774870113@tsp17.sprintpcs.com | 2018-02-19 20:46:19+00 | 2018-02-20 20:46:24+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
(10 rows)


-- Other queries



SELECT p.acctsessionid
      ,p.username
      ,p.acctstarttime
      ,p.acctstoptime
      ,p.connectinfo_start
      ,p.connectinfo_stop
      ,p.acctterminatecause
      ,p.nasipaddress
  FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
              ,'SELECT username
                      ,acctsessionid
                      ,framedipaddress
                      ,xascendsessionsvrkey
                      ,nasidentifier
                 FROM master_radacct 
                WHERE acctstoptime IS NULL
                  AND acctstarttime > (current_timestamp - interval '1 day')')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text)
 ORDER BY 3 DESC
 LIMIT 10;




-- Verify line is up and connected

csctoss=# SELECT p.acctsessionid
csctoss-#       ,p.username
csctoss-#       ,p.acctstarttime
csctoss-#       ,p.acctstoptime
csctoss-#       ,p.connectinfo_start
csctoss-#       ,p.connectinfo_stop
csctoss-#       ,p.acctterminatecause
csctoss-#       ,p.nasipaddress
csctoss-#   FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
csctoss(#                                     ,'SELECT acctsessionid
csctoss'#                                             ,username
csctoss'#                                             ,acctstarttime
csctoss'#                                             ,acctstoptime
csctoss'#                                             ,connectinfo_start
csctoss'#                                             ,connectinfo_stop
csctoss'#                                             ,acctterminatecause
csctoss'#                                             ,nasipaddress
csctoss'#                                         FROM master_radacct 
csctoss'#                                        WHERE username = ''5774870113@tsp17.sprintpcs.com''')
csctoss-#                       as p( acctsessionid text
csctoss(#                            ,username text
csctoss(#                            ,acctstarttime text
csctoss(#                            ,acctstoptime text
csctoss(#                            ,connectinfo_start text
csctoss(#                            ,connectinfo_stop text
csctoss(#                            ,acctterminatecause text
csctoss(#                            ,nasipaddress text)
csctoss-#  ORDER BY 3 DESC
csctoss-#  LIMIT 10;
 acctsessionid |      username       |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+---------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 067A0E9C      | 3123883702@uscc.net | 2018-03-19 04:11:11+00 |                        | 64000/57600       |                  |                    | 68.28.81.76
 02B0AA4E      | 3123883702@uscc.net | 2018-03-18 06:30:54+00 | 2018-03-19 04:10:48+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 02B02ADD      | 3123883702@uscc.net | 2018-03-17 06:29:25+00 | 2018-03-18 06:29:25+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 06789891      | 3123883702@uscc.net | 2018-03-16 06:29:00+00 | 2018-03-17 06:29:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 02AF9D3A      | 3123883702@uscc.net | 2018-03-16 06:13:20+00 | 2018-03-16 06:28:30+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 06787803      | 3123883702@uscc.net | 2018-03-16 03:16:23+00 | 2018-03-16 05:16:23+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 0677F803      | 3123883702@uscc.net | 2018-03-15 03:02:14+00 | 2018-03-16 03:02:19+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 02AEFF51      | 3123883702@uscc.net | 2018-03-15 01:35:16+00 | 2018-03-15 03:03:02+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.89.76
 02AEF372      | 3123883702@uscc.net | 2018-03-14 23:18:10+00 | 2018-03-15 01:36:01+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 02AE596E      | 3123883702@uscc.net | 2018-03-13 23:17:35+00 | 2018-03-14 23:17:35+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
(10 rows)

csctoss=# 


-- Display the connection status for username 5774870113@tsp17.sprintpcs.com

csctoss=# SELECT p.acctsessionid                                               
      ,p.username
      ,p.acctstarttime
      ,p.acctstoptime
      ,p.connectinfo_start
      ,p.connectinfo_stop
      ,p.acctterminatecause
      ,p.nasipaddress
  FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
                                    ,'SELECT acctsessionid
                                            ,username
                                            ,acctstarttime
                                            ,acctstoptime
                                            ,connectinfo_start
                                            ,connectinfo_stop
                                            ,acctterminatecause
                                            ,nasipaddress
                                        FROM master_radacct 
                                       WHERE username = ''5774870113@tsp17.sprintpcs.com''')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text)
 ORDER BY 3 DESC
 LIMIT 5;

  acctsessionid |            username            |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 00A455A7      | 5774870113@tsp17.sprintpcs.com | 2018-03-18 23:27:49+00 |                        | 64000/57600       |                  |                    | 68.28.89.76
 00A41579      | 5774870113@tsp17.sprintpcs.com | 2018-03-17 23:27:29+00 | 2018-03-18 23:27:34+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 0173A7F0      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:37:27+00 | 2018-03-17 22:37:32+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 0173A7AF      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:28:47+00 | 2018-03-16 22:30:09+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 00A3CB74      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:19:17+00 | 2018-03-16 22:27:01+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
(5 rows)


-- Issue packet of disconnect on username 5774870113@tsp17.sprintpcs.com

select * from packet_of_disconnect('5774870113@tsp17.sprintpcs.com');
                                  packet_of_disconnect                                   
-----------------------------------------------------------------------------------------
 RC1: SUCCESS
 RC2: Username 5774870113@tsp17.sprintpcs.com POD sent to DENASR02.contournetworks.net
 RC3: 5774870113@tsp17.sprintpcs.com,00A455A7,10.48.189.46,,DENASR02.contournetworks.net
 ERR:
(4 rows)


--  Result of prior query after the pod on username 5774870113@tsp17.sprintpcs.com

 acctsessionid |            username            |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 00A455A7      | 5774870113@tsp17.sprintpcs.com | 2018-03-18 23:27:49+00 | 2018-03-19 18:18:17+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.89.76
 00A41579      | 5774870113@tsp17.sprintpcs.com | 2018-03-17 23:27:29+00 | 2018-03-18 23:27:34+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 0173A7F0      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:37:27+00 | 2018-03-17 22:37:32+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 0173A7AF      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:28:47+00 | 2018-03-16 22:30:09+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 00A3CB74      | 5774870113@tsp17.sprintpcs.com | 2018-03-16 22:19:17+00 | 2018-03-16 22:27:01+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
(5 rows)


-- Display the connection status for username 3123883702@uscc.net

csctoss=# SELECT p.acctsessionid                                               
      ,p.username
      ,p.acctstarttime
      ,p.acctstoptime
      ,p.connectinfo_start
      ,p.connectinfo_stop
      ,p.acctterminatecause
      ,p.nasipaddress
  FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
                                    ,'SELECT acctsessionid
                                            ,username
                                            ,acctstarttime
                                            ,acctstoptime
                                            ,connectinfo_start
                                            ,connectinfo_stop
                                            ,acctterminatecause
                                            ,nasipaddress
                                        FROM master_radacct 
                                       WHERE username = ''3123883702@uscc.net''')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text)
 ORDER BY 3 DESC
 LIMIT 5;

 acctsessionid |      username       |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+---------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 02B16D01      | 3123883702@uscc.net | 2018-03-19 17:50:48+00 |                        | 64000/57600       |                  |                    | 68.28.89.76
 067A0E9C      | 3123883702@uscc.net | 2018-03-19 04:11:11+00 | 2018-03-19 17:38:49+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 02B0AA4E      | 3123883702@uscc.net | 2018-03-18 06:30:54+00 | 2018-03-19 04:10:48+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 02B02ADD      | 3123883702@uscc.net | 2018-03-17 06:29:25+00 | 2018-03-18 06:29:25+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 06789891      | 3123883702@uscc.net | 2018-03-16 06:29:00+00 | 2018-03-17 06:29:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
(5 rows)


-- Issue packet of disconnect on username 3123883702@uscc.net

select * from packet_of_disconnect('3123883702@uscc.net');
                                  packet_of_disconnect                                   
-----------------------------------------------------------------------------------------
 RC1: SUCCESS
 RC2: Username 3123883702@uscc.net POD sent to atlasr01.contournetworks.net
 RC3: 3123883702@cn01.sprintpcs.com,02B16D01,10.48.201.157,,atlasr01.contournetworks.net
 ERR:
(4 rows)


--  Result of prior query after the pod on username 3123883702@uscc.net


 acctsessionid |      username       |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+---------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 02B16D01      | 3123883702@uscc.net | 2018-03-19 17:50:48+00 | 2018-03-19 18:28:51+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.89.76
 067A0E9C      | 3123883702@uscc.net | 2018-03-19 04:11:11+00 | 2018-03-19 17:38:49+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 02B0AA4E      | 3123883702@uscc.net | 2018-03-18 06:30:54+00 | 2018-03-19 04:10:48+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 02B02ADD      | 3123883702@uscc.net | 2018-03-17 06:29:25+00 | 2018-03-18 06:29:25+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 06789891      | 3123883702@uscc.net | 2018-03-16 06:29:00+00 | 2018-03-17 06:29:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
(5 rows)

