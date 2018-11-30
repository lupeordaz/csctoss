
SELECT master_radacctid
      , source_hostname
      , radacctid
      ,  acctsessionid
      ,  acctuniqueid
      ,  username
      ,  realm
      ,  nasipaddress
      ,  nasportid
      ,  nasporttype
      , acctstarttime
      , acctstoptime
      , acctsessiontime
      , acctauthentic
      , connectinfo_start
      ,  connectinfo_stop
      ,  acctinputoctets
      ,  acctoutputoctets
      ,  calledstationid
      ,  callingstationid
      , acctterminatecause
      ,  servicetype
      ,framedprotocol
      ,  framedipaddress
      , acctstartdelay
      , acctstopdelay
      , xascendsessionsvrkey
      , tunnelclientendpoint
      ,  nasidentifier
      , CLASS
      ,  processed_flag 
  FROM master_radacct master_radacct 
 WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record  
 	                            FROM master_radacct mrac 
 	                           WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  
 	                           GROUP BY username )


COPY csctoss.master_radacct (
	master_radacctid
   , source_hostname
   , radacctid
   ,  acctsessionid
   ,  acctuniqueid
   ,  username
   ,  realm
   ,  nasipaddress
   ,  nasportid
   ,  nasporttype
   , acctstarttime
   , acctstoptime
   , acctsessiontime
   , acctauthentic
   , connectinfo_start
   ,  connectinfo_stop
   ,  acctinputoctets
   ,  acctoutputoctets
   ,  calledstationid
   ,  callingstationid
   , acctterminatecause
   ,  servicetype
   ,framedprotocol
   ,  framedipaddress
   , acctstartdelay
   , acctstopdelay
   , xascendsessionsvrkey
   , tunnelclientendpoint
   ,  nasidentifier
   , CLASS
   ,  processed_flag) FROM stdin WITH DELIMITER ',' NULL '<NULL>';


select username
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress
  from master_radacct 
 where username IN 
('3123884807@uscc.net',
'3124373914@uscc.net',
'3124375354@uscc.net',
'3124376780@uscc.net',
'3124376892@uscc.net',
'3124377165@uscc.net',
'3124377731@uscc.net',
'3125460323@uscc.net',
'3125468134@uscc.net',
'3125468186@uscc.net',
'4046953044@vzw3g.com',
'4049895050@vzw3g.com',
'4703529334@vzw3g.com',
'4706265806@vzw3g.com',
'4706266372@vzw3g.com',
'4707174364@vzw3g.com',
'5339382922@tsp17.sprintpcs.com',
'5339384500@tsp17.sprintpcs.com',
'5662070034@tsp17.sprintpcs.com',
'5662089394@tsp17.sprintpcs.com',
'5662089549@tsp17.sprintpcs.com',
'5662092993@tsp17.sprintpcs.com',
'5662093405@tsp17.sprintpcs.com',
'5662093631@tsp17.sprintpcs.com',
'5665290035@tsp17.sprintpcs.com',
'5665291569@tsp17.sprintpcs.com',
'5666923789@tsp17.sprintpcs.com',
'5774870062@tsp17.sprintpcs.com',
'6466500835@tsp17.sprintpcs.com',
'9174062053@tsp17.sprintpcs.com',
'9174492973@tsp18.sprintpcs.com',
'9175316061@tsp17.sprintpcs.com',
'9175681401@tsp18.sprintpcs.com',
'9177681459@tsp17.sprintpcs.com',
'9178580449@tsp18.sprintpcs.com',
'9178583078@tsp17.sprintpcs.com')






select line_id
      ,radius_username
      ,serial_number
      ,esn_hex
      ,static_ip_address
      ,last_connected_timestamp
      ,is_connected
  from portal_active_lines_vw
 where radius_username IN
('3123884807@uscc.net',
'3124373914@uscc.net',
'3124375354@uscc.net',
'3124376780@uscc.net',
'3124376892@uscc.net',
'3124377165@uscc.net',
'3124377731@uscc.net',
'3125460323@uscc.net',
'3125468134@uscc.net',
'3125468186@uscc.net',
'4046953044@vzw3g.com',
'4049895050@vzw3g.com',
'4703529334@vzw3g.com',
'4706265806@vzw3g.com',
'4706266372@vzw3g.com',
'4707174364@vzw3g.com',
'5339382922@tsp17.sprintpcs.com',
'5339384500@tsp17.sprintpcs.com',
'5662070034@tsp17.sprintpcs.com',
'5662089394@tsp17.sprintpcs.com',
'5662089549@tsp17.sprintpcs.com',
'5662092993@tsp17.sprintpcs.com',
'5662093405@tsp17.sprintpcs.com',
'5662093631@tsp17.sprintpcs.com',
'5665290035@tsp17.sprintpcs.com',
'5665291569@tsp17.sprintpcs.com',
'5666923789@tsp17.sprintpcs.com',
'5774870062@tsp17.sprintpcs.com',
'6466500835@tsp17.sprintpcs.com',
'9174062053@tsp17.sprintpcs.com',
'9174492973@tsp18.sprintpcs.com',
'9175316061@tsp17.sprintpcs.com',
'9175681401@tsp18.sprintpcs.com',
'9177681459@tsp17.sprintpcs.com',
'9178580449@tsp18.sprintpcs.com',
'9178583078@tsp17.sprintpcs.com');

---

select l.line_id                                                         
	  ,le.equipment_id
	  ,l.radius_username
	  ,uim.value as mac
	  ,uis.value as serialno
	  ,uie.value as esn_hex
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uie.value = 

--

select l.line_id                                                         
	  ,le.equipment_id
	  ,l.radius_username
	  ,uis.value as serialno
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uis.value = 420584


--

SELECT count(*) AS count 
  FROM master_radacct mrad 
 WHERE (((   (mrad.username)::text = '3124375354@uscc.net') 
          AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval)
              )
        ) 
        AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max 
                                                               FROM master_radacct mrad2 
                                                               WHERE ((mrad2.username)::text = (mrad.username)::text))
            )
      ) 
   AND (mrad.acctstoptime IS NULL);
 count 
-------
     0
(1 row)

--

select username
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress 
  from master_radacct mrad
WHERE (((   (mrad.username)::text = '3124375354@uscc.net') 
          AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval)
              )
        ) 
        AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max 
                                        FROM master_radacct mrad2 
                                       WHERE ((mrad2.username)::text = (mrad.username)::text))
            )
       ) AND (mrad.acctstoptime IS NULL);

 username | acctstarttime | acctstoptime | nasipaddress 
----------+---------------+--------------+--------------
(0 rows)
	
--

csctoss=# select l.line_id                                                                                         
          ,le.equipment_id
          ,l.radius_username
          ,uis.value as serialno
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uis.value = '419868';
 line_id | equipment_id |   radius_username    | serialno 
---------+--------------+----------------------+----------
   44839 |        42529 | 4705327131@vzw3g.com | 419868
(1 row)


csctoss=# select username                                                          
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress 
  from master_radacct mrad
WHERE (((   (mrad.username)::text = '4705327131@vzw3g.com') 
          AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval)
              )
        ) 
        AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max 
                                        FROM master_radacct mrad2 
                                       WHERE ((mrad2.username)::text = (mrad.username)::text))
            )
       ) AND (mrad.acctstoptime IS NULL);

 username | acctstarttime | acctstoptime | nasipaddress 
----------+---------------+--------------+--------------
(0 rows)

--

-- master_rad_hourly_copy.sh

SELECT master_radacctid
      , source_hostname
      , radacctid
      ,  acctsessionid
      ,  acctuniqueid
      ,  username
      ,  realm
      ,  nasipaddress
      ,  nasportid
      ,  nasporttype
      , acctstarttime
      , acctstoptime
      , acctsessiontime
      , acctauthentic
      , connectinfo_start
      ,  connectinfo_stop
      ,  acctinputoctets
      ,  acctoutputoctets
      ,  calledstationid
      ,  callingstationid
      , acctterminatecause
      ,  servicetype
      ,framedprotocol
      ,  framedipaddress
      , acctstartdelay
      , acctstopdelay 
      , xascendsessionsvrkey
      , tunnelclientendpoint
      ,  nasidentifier
      , CLASS
      ,  processed_flag 
  FROM master_radacct master_radacct 
 WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record  
 	                            FROM master_radacct mrac 
 	                           WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  
 	                           GROUP BY username );

SELECT master_radacctid
      ,  username
      ,  nasipaddress
      , acctstarttime
      , acctstoptime
      .
      .
      .
  FROM master_radacct master_radacct
 WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record
                                    FROM master_radacct mrac
                                   WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
                                   GROUP BY username );

SELECT master_radacctid
      ,  username
      ,  nasipaddress
      , acctstarttime
      , acctstoptime
  FROM master_radacct master_radacct
 WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record
                                    FROM master_radacct mrac
                                   WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
                                   GROUP BY username )
   AND username = '4705327118@vzw3g.com';
 master_radacctid |       username       | nasipaddress |     acctstarttime      |      acctstoptime      
------------------+----------------------+--------------+------------------------+------------------------
        363804217 | 4705327118@vzw3g.com | 10.119.19.2  | 2018-05-14 04:54:12+00 | 2018-06-20 15:35:07+00
(1 row)



SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE master_radacctid IN ( select mr.master_radacctid
                               from master_radacct mr
                              where mr.acctstarttime = (
                                                        SELECT max(acctstarttime)
                                                          FROM master_radacct mrac
                                                         WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
                                                           and username = mr.username
                                                         GROUP BY username ) );
   AND username = '4705327118@vzw3g.com';
 master_radacctid |       username       | nasipaddress |     acctstarttime      | acctstoptime 
------------------+----------------------+--------------+------------------------+--------------
        363803189 | 4705327118@vzw3g.com | 10.119.19.2  | 2018-06-20 15:03:35+00 | 
(1 row)



SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
  JOIN (select master_radacctid, max(acctstarttime) as maxacctstarttime
  	      from master_radacct 
  	     group by master_radacctid) mrac
    ON mr.master_radacctid = mrac.master_radacctid
   AND mr.acctstarttime = mrac.maxacctstarttime;




'4705327118@vzw3g.com'
'4705327141@vzw3g.com'

SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE mr.acctstarttime = ( select max(mr2.acctstarttime) 
                              from master_radacct as mr2
                             where mr2.username = mr.username
                               and mr2.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL))
   and mr.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL) 
   and mr.username in ('4705327118@vzw3g.com','4705327141@vzw3g.com')
 order by mr.username, mr.acctstarttime;



SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE mr.acctstarttime = ( select max(mr2.acctstarttime) 
                              from master_radacct as mr2
                             where mr2.username = mr.username
                               and mr2.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL))
   and mr.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL) ;



















	

SELECT max(master_radacctid)                                                                                
  FROM master_radacct mrac 
 WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
   and mrac.username = '4705327118@vzw3g.com';
    max    
-----------
 363804217
(1 row)


select master_radacctid
      ,username
      ,acctstarttime
      ,acctstoptime  
  from master_radacct 
 where master_radacctid = 363804217;
 master_radacctid |       username       |     acctstarttime      |      acctstoptime      
------------------+----------------------+------------------------+------------------------
        363804217 | 4705327118@vzw3g.com | 2018-05-14 04:54:12+00 | 2018-06-20 15:35:07+00
(1 row)


select master_radacct
      ,username
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress  
  from master_radacct 
 where username = '4705327118@vzw3g.com' 
 order by acctstarttime desc;
 master_radacctid |       username       |     acctstarttime      |      acctstoptime      | nasipaddress 
------------------+----------------------+------------------------+------------------------+--------------
        363803189 | 4705327118@vzw3g.com | 2018-06-20 15:03:35+00 |                        | 10.119.19.2
        363802681 | 4705327118@vzw3g.com | 2018-06-20 14:47:12+00 | 2018-06-20 14:49:12+00 | 10.119.19.2
***     363804217 | 4705327118@vzw3g.com | 2018-05-14 04:54:12+00 | 2018-06-20 15:35:07+00 | 10.119.19.2	***
        361922057 | 4705327118@vzw3g.com | 2018-05-08 04:48:57+00 | 2018-05-14 03:42:50+00 | 10.119.19.2
        361919753 | 4705327118@vzw3g.com | 2018-05-08 02:54:46+00 | 2018-05-08 04:48:47+00 | 10.119.19.2
.
.
.

select mr.master_radacctid
      ,mr.acctstarttime
  from master_radacct mr
 where mr.username = '4705327118@vzw3g.com'
   and mr.acctstarttime = (
           SELECT max(acctstarttime)
             FROM master_radacct mrac 
            WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
              and mrac.username = '4705327118@vzw3g.com')
 group by mr.master_radacctid, mr.acctstarttime;
 master_radacctid |     acctstarttime      
------------------+------------------------
        363803189 | 2018-06-20 15:03:35+00
(1 row)


SELECT master_radacctid
      ,  username
      , acctstarttime
      , acctstoptime
      ,nasipaddress
  FROM master_radacct master_radacct 
 WHERE master_radacctid IN ( SELECT max(master_radacctid) AS record  
 

select mr.master_radacctid
      ,mr.acctstarttime
  from master_radacct mr
 where mr.username = '4705327118@vzw3g.com'
   and mr.acctstarttime = (
           SELECT max(acctstarttime)
             FROM master_radacct mrac 
            WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
              and mrac.username = '4705327118@vzw3g.com')
 group by mr.master_radacctid, mr.acctstarttime;
 master_radacctid |     acctstarttime      
------------------+------------------------
        363803189 | 2018-06-20 15:03:35+00


select master_radacctid
      ,username
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress
  from master_radacct
 where master_radacctid IN (
    select mr.master_radacctid
      from master_radacct mr
     where mr.username = '4705327118@vzw3g.com'
       and mr.acctstarttime = (
               SELECT max(acctstarttime)
                 FROM master_radacct mrac
                WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
                  and mrac.username = '4705327118@vzw3g.com')
     group by mr.master_radacctid, mr.acctstarttime);        

SELECT master_radacctid
      ,  username
      ,  nasipaddress
      , acctstarttime
      , acctstoptime
  FROM master_radacct master_radacct 
 WHERE master_radacctid IN ( SELECT max(master_radacctid) AS record  
                               FROM master_radacct mrac 
                              WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL) )
 GROUP BY username;





 select l.line_id                                                         
        ,le.equipment_id
        ,l.radius_username
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uis.value = '419929'

--


select now();
              now              
-------------------------------
 2018-06-21 23:34:10.168326+00
(1 row)

csctlog=> SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE mr.acctstarttime = ( select max(mr2.acctstarttime) 
                              from master_radacct as mr2
                             where mr2.username = mr.username
                               and mr2.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL))
   and mr.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL) 
   and mr.username in ('4705327118@vzw3g.com','4705327141@vzw3g.com')
 order by mr.username, mr.acctstarttime;
select now()
 master_radacctid |       username       | nasipaddress |     acctstarttime      | acctstoptime 
------------------+----------------------+--------------+------------------------+--------------
        363803189 | 4705327118@vzw3g.com | 10.119.19.2  | 2018-06-20 15:03:35+00 | 
        363706679 | 4705327141@vzw3g.com | 10.119.19.2  | 2018-06-18 11:13:15+00 | 
(2 rows)

csctlog=> select now()
csctlog-> ;
              now              
-------------------------------
 2018-06-21 23:38:58.394397+00
(1 row)

--

Hi Lupe,

I saw your comments on the Redmine. It looks you are trying to use the 
following condition for the query, but there are so many records which 
have same time stamp, so I think it causes another issue.

WHERE mr.acctstarttime = ( select max(mr2.acctstarttime)
.....

The "sub-query" should be like:

SELECT
.....

FROM master_radacct mr
WHERE ....
AND .....
(
SELECT
  username,
  MAX(acctstarttime)
FROM master_radacct mr2
WHERE .....
GROUP BY
  username
)

--
SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE 
SELECT
  username,
  MAX(acctstarttime)
FROM master_radacct mr2
WHERE .....
GROUP BY
  username

--

select mr1.master_radacctid
  from master_radacct mr1
 where mr1.username = '4705327118@vzw3g.com'
   and mr1.acctstarttime = ( SELECT MAX(mr2.acctstarttime)
							   FROM master_radacct mr2
							  WHERE mr2.username = mr1.username
							  GROUP BY mr2.username);
 master_radacctid 
------------------
        363803189
(1 row)


SELECT master_radacctid
      ,  username
      , acctstarttime
      , acctstoptime
      ,nasipaddress
  FROM master_radacct master_radacct 
 WHERE master_radacctid IN ( SELECT max(master_radacctid) AS record  
 	                            FROM master_radacct mrac 
 	                           WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  
 	                           GROUP BY username );


SELECT master_radacctid
      ,max(acctstarttime)
  FROM master_radacct mrac
 WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
 GROUP BY master_radacctid, username ;
                                     



select mr1.master_radacctid
  from master_radacct mr1
 where mr1.username = '4705327118@vzw3g.com'	
   and mr1.acctstarttime = ( SELECT MAX(mr2.acctstarttime)
							   FROM master_radacct mr2
							  WHERE mr2.username = mr1.username
							  GROUP BY mr2.username);


select master_radacctid, username, max(acctstarttime)
  from master_radacct
 where username = '4705327118@vzw3g.com'

--

select username, max(acctstarttime)
  from master_radacct
 group by username;


SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 WHERE mr.acctstarttime = ( select max(mr2.acctstarttime) 
                              from master_radacct as mr2
                             where mr2.username = mr.username
                               and mr2.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL))
   and mr.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL) ;

--- 20180625


SELECT master_radacctid
      ,max(acctstarttime)
  FROM master_radacct mrac
 WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
 GROUP BY username,mrac.master_radacctid ;

Time: 27367.523 ms

SELECT mrac.master_radacctid
      ,mrac.username
      ,mrac.nasipaddress
      ,mrac.acctstarttime
      ,mrac.acctstoptime
  FROM (SELECT username
  	          ,master_radacctid
  	          ,max(acctstarttime)
  	      FROM master_radacct
  	     GROUP BY username, master_radacctid) as master
  INNER JOIN master_radacct mrac
     on mrac.acctstarttime = master.acctstarttime AND
        mrac.master_radacct = master.master_radacctid;

  master_radacct mrac
 WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
 GROUP BY username,mrac.master_radacctid ;



SELECT mr.master_radacctid
      ,mr.username
      ,mr.nasipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime


SELECT master_radacctid
      ,max(acctstarttime)
  FROM master_radacct mrac 
 WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  
 GROUP BY username,mrac.master_radacctid ;


 master_radacctid |          max           
------------------+------------------------
        361328094 | 2018-04-24 22:54:34+00
        361329970 | 2018-04-24 23:55:12+00
        361374097 | 2018-04-25 21:43:37+00
        361464093 | 2018-04-27 13:15:46+00
        361483684 | 2018-04-28 00:42:54+00
        361484122 | 2018-04-28 00:58:05+00
        361484273 | 2018-04-28 01:03:15+00
        361484707 | 2018-04-28 01:19:27+00
        361485412 | 2018-04-28 01:45:35+00



SELECT master_radacctid
      ,  username
      , acctstarttime
      , acctstoptime
      ,nasipaddress
  FROM master_radacct master_radacct
  JOIN (SELECT mrac.master_radacctid
      ,max(mrac.acctstarttime)
  FROM master_radacct mrac 
 WHERE mrac.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  
 GROUP BY mrac.username,mrac.master_radacctid) mrac
    ON master_radacct.master_radacctid = mrac.master_radacctid


SELECT mr.master_radacctid
      ,mr.username
      ,mr.acctstarttime
      ,mr.acctstoptime
      ,mr.nasipaddress
  FROM master_radacct mr
  JOIN (SELECT mrac.master_radacctid
      ,max(mrac.acctstarttime)
  FROM master_radacct mrac
 WHERE mrac.acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)
 GROUP BY mrac.username,mrac.master_radacctid) mrac
    ON mr.master_radacctid = mrac.master_radacctid
 where mr.username = '4705327141@vzw3g.com';
 master_radacctid |       username       |     acctstarttime      |      acctstoptime      | nasipaddress 
------------------+----------------------+------------------------+------------------------+--------------
        362678430 | 4705327141@vzw3g.com | 2018-03-27 12:09:41+00 | 2018-05-25 19:00:36+00 | 10.119.19.2
        362865922 | 4705327141@vzw3g.com | 2018-05-25 18:02:51+00 | 2018-05-30 00:34:13+00 | 10.119.19.2
        363706679 | 4705327141@vzw3g.com | 2018-06-18 11:13:15+00 |                        | 10.119.19.2
        363708095 | 4705327141@vzw3g.com | 2018-05-30 01:34:45+00 | 2018-06-18 11:59:34+00 | 10.119.19.2
(4 rows)




select username, max(acctstarttime) 
  from master_radacct_201806
 group by username
 order by username;


---

select username, max(acctstarttime)                                                                                             
  from master_radacct_201806
 group by username
 order by username;

               username               |          max           
--------------------------------------+------------------------
 00:04:2D:0A:2C:E7                    | 2018-06-25 08:15:47+00
 2123350476@tsp17.sprintpcs.com       | 2018-06-25 20:05:43+00
 2123900637@tsp17.sprintpcs.com       | 2018-06-25 19:47:03+00
 2124989747@tsp17.sprintpcs.com       | 2018-06-25 11:09:39+00
 2126580026@tsp17.sprintpcs.com       | 2018-06-25 14:42:42+00
 2128589851@tsp17.sprintpcs.com       | 2018-06-25 18:13:07+00
 2129510888@tsp17.sprintpcs.com       | 2018-06-25 11:01:35+00
 3122170126@uscc.net                  | 2018-06-25 16:58:59+00
 3122170168@uscc.net                  | 2018-06-25 21:44:29+00
 3122170389@uscc.net                  | 2018-06-25 07:43:07+00

select master_radacctid 
  from master_radacct 
 where username = '2126580026@tsp17.sprintpcs.com' 
   and acctstarttime = '2018-06-25 14:42:42+00';
 master_radacctid 
------------------
        364023010
(1 row)

-- 20180626

select username, max(acctstarttime) 
  from master_radacct
 group by username
 order by username;

SELECT mr.master_radacctid
      ,mr.username
      ,mr.acctstarttime
      ,mr.acctstoptime
      ,mr.nasipaddress
  from master_radacctid mr
 inner join 
      (select username, max(acctstarttime) as acctstarttime
		 from master_radacct
		group by username
		order by username) mr2 
    on mr.username = mr2.username 
   and mr.acctstarttime = mr2.acctstarttime;


select master_radacctid
  from master_radacct
 where 



SELECT mr.master_radacctid
      ,mr.username
      ,mr.acctstarttime
      ,mr.acctstoptime
      ,mr.nasipaddress

SELECT master_radacctid
      ,source_hostname
      ,radacctid
      ,acctsessionid
      ,acctuniqueid
      ,username
      ,realm
      ,nasipaddress
      ,nasportid
      ,nasporttype
      ,acctstarttime
      ,acctstoptime
      ,acctsessiontime
      ,acctauthentic
      ,connectinfo_start
      ,connectinfo_stop
      ,acctinputoctets
      ,acctoutputoctets
      ,calledstationid
      ,callingstationid
      ,acctterminatecause
      ,servicetype
      ,framedprotocol
      ,framedipaddress
      ,acctstartdelay
      ,acctstopdelay
      ,xascendsessionsvrkey
      ,tunnelclientendpoint
      , nasidentifier
      ,CLASS
      ,processed_flag 
  FROM master_radacct mr
 INNER JOIN 
      (select username, max(acctstarttime) as acctstarttime
         from master_radacct
        group by username
        order by username) mr2 
    on mr.username = mr2.username 
   and mr.acctstarttime = mr2.acctstarttime;


-- 20180626

SELECT mr.master_radacctid
      ,mr.username
      ,mr.acctstarttime
      ,mr.acctstoptime
  FROM master_radacct mr
 INNER JOIN 
       (select username
              ,max(acctstarttime) as acctstarttime
          from master_radacct
         group by username
         order by username
       ) mr2
    ON mr.username = mr2.username 
   and mr.acctstarttime = mr2.acctstarttime 
 WHERE mr.username = '4705327148@vzw3g.com';
 master_radacctid |       username       |     acctstarttime      |      acctstoptime      
------------------+----------------------+------------------------+------------------------
        363881430 | 4705327148@vzw3g.com | 2018-06-22 08:02:31+00 | 2018-06-22 08:02:31+00
(1 row)


select master_radacctid, username, acctstarttime, acctstoptime
  from master_radacct
 where username = '4705327148@vzw3g.com'
 order by acctstarttime desc;
 master_radacctid |       username       |     acctstarttime      |      acctstoptime      
------------------+----------------------+------------------------+------------------------
        363881430 | 4705327148@vzw3g.com | 2018-06-22 08:02:31+00 | 2018-06-22 08:02:31+00
        363879804 | 4705327148@vzw3g.com | 2018-06-22 07:47:43+00 | 
        363659744 | 4705327148@vzw3g.com | 2018-06-08 23:28:31+00 | 2018-06-17 09:16:08+00
        363297074 | 4705327148@vzw3g.com | 2018-05-31 13:46:42+00 | 2018-06-08 23:28:24+00
.
.
.
        343099689 | 4705327148@vzw3g.com | 2017-04-11 01:22:23+00 | 2017-04-11 02:25:40+00
        343099569 | 4705327148@vzw3g.com | 2017-04-11 01:18:50+00 | 2017-04-11 01:19:09+00
(28 rows)

select username
      ,CASE
        WHEN acctstoptime IS NULL THEN master_radacctid
        WHEN acctstarttime = (select max(mr.acctstarttime) from mr.master_radacctid where mr.username = username)
        	THEN master_radacctid
        END as radacctid
  from master_radacct mr
 where username = '4705327148@vzw3g.com';
       username       | radacctid |       starttime        | stoptime 
----------------------+-----------+------------------------+----------
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com |           |                        | 
 4705327148@vzw3g.com | 363879804 | 2018-06-22 07:47:43+00 | 
 4705327148@vzw3g.com |           |                        | 
(28 rows)



select mr.username
      ,CASE
        WHEN mr.acctstoptime IS NULL THEN master_radacctid
        WHEN mr.acctstarttime = (select max(mr2.acctstarttime) from master_radacct mr2 where mr2.username = username)
                THEN master_radacctid
        END as radacctid
  from master_radacct mr
 where mr.username = '4705327148@vzw3g.com';
       username       | radacctid 
----------------------+-----------
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com |          
 4705327148@vzw3g.com | 363879804
 4705327148@vzw3g.com |          
(28 rows)

select CASE
        WHEN mr.acctstoptime IS NULL THEN master_radacctid
        WHEN mr.acctstarttime = (select max(mr2.acctstarttime) from master_radacct mr2 where mr2.username = username)
                THEN master_radacctid
        END as radacctid
  from master_radacct mr
 where mr.username = '4705327148@vzw3g.com';
 radacctid 
-----------
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
 363879804
          
(28 rows)
