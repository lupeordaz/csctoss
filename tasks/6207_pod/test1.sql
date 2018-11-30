-- Test device 699739 on DENOSS01

-- Get username from device information; using device with SN = 745038

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
 where uis.value = '699739';

 equipment_id |   sn   |      esn       | line_id | billing_entity_id |        radius_username         
--------------+--------+----------------+---------+-------------------+--------------------------------
        29686 | 699739 | A100000942E145 |   28742 |               221 | 
        29686 | 699739 | A100000942E145 |   46588 |               112 | 5774870113@tsp17.sprintpcs.com
(2 rows)

--  Call packet_of_disconnect(username);

select * from packet_of_disconnect( '5774870113@tsp17.sprintpcs.com');

                                  packet_of_disconnect                                   
-----------------------------------------------------------------------------------------
 RC1: SUCCESS
 RC2: Username 5774870113@tsp17.sprintpcs.com POD sent to DENASR02.contournetworks.net
 RC3: 5774870113@tsp17.sprintpcs.com,00A3431C,10.48.189.46,,DENASR02.contournetworks.net
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
                                       WHERE acctsessionid = ''017394EB''
                                         AND username = ''5774870113@tsp17.sprintpcs.com''')
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
 00A3431C      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:35:41+00 | 2018-03-15 15:52:52+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
(1 row)


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
 LIMIT 10;

  acctsessionid |            username            |     acctstarttime      |      acctstoptime      | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+------------------------+-------------------+------------------+--------------------+--------------
 00A36D06      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 16:22:39+00 |                        | 64000/57600       |                  |                    | 68.28.89.76
 00A3431C      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:35:41+00 | 2018-03-15 15:52:52+00 | 64000/57600       | 64000/57600      | Admin-Reset        | 68.28.81.76
 00A34244      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:24:47+00 | 2018-03-15 03:34:54+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01735595      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 03:14:39+00 | 2018-03-15 03:24:05+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 0173552B      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 02:58:41+00 | 2018-03-15 03:13:55+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01735342      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 01:35:56+00 | 2018-03-15 02:57:51+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
 00A3383A      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 00:04:44+00 | 2018-03-15 01:35:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 01734F7F      | 5774870113@tsp17.sprintpcs.com | 2018-03-14 23:18:59+00 | 2018-03-15 00:04:00+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 016FACE6      | 5774870113@tsp17.sprintpcs.com | 2018-02-21 21:42:28+00 | 2018-02-22 21:42:33+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.81.76
 009E98B5      | 5774870113@tsp17.sprintpcs.com | 2018-02-20 21:25:30+00 | 2018-02-21 21:25:35+00 | 64000/57600       | 64000/57600      | User-Request       | 68.28.89.76
(10 rows)


-- Issue the packet_of_disconnect from densoss06

select * from packet_of_disconnect( '5774870113@tsp17.sprintpcs.com');

                                  packet_of_disconnect                                   
-----------------------------------------------------------------------------------------
 RC1: SUCCESS
 RC2: Username 5774870113@tsp17.sprintpcs.com POD sent to DENASR02.contournetworks.net
 RC3: 5774870113@tsp17.sprintpcs.com,00A36D06,10.48.189.46,,DENASR02.contournetworks.net
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
                                       WHERE acctsessionid = ''00A36D06''
                                         AND username = ''5774870113@tsp17.sprintpcs.com''')
                      as p( acctsessionid text
                           ,username text
                           ,acctstarttime text
                           ,acctstoptime text
                           ,connectinfo_start text
                           ,connectinfo_stop text
                           ,acctterminatecause text
                           ,nasipaddress text);


 acctsessionid |            username            |     acctstarttime      | acctstoptime | connectinfo_start | connectinfo_stop | acctterminatecause | nasipaddress 
---------------+--------------------------------+------------------------+--------------+-------------------+------------------+--------------------+--------------
 00A36D06      | 5774870113@tsp17.sprintpcs.com | 2018-03-15 16:22:39+00 |              | 64000/57600       |                  |                    | 68.28.89.76
(1 row)


