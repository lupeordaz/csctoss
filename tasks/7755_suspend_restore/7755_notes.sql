
-- Customer attempted to Temp Suspend two devices but despite the Portal stating that the devices 
-- were Temp disconnected, no disconnection occurred. Remains in an 'Active' state. Verified myself as well.
--
-- FD112928
--
-- SN608091 and SN641420


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
 where uis.value in ('608091', '641420');
 line_id | equipment_id |   radius_username   |  mac   | serialno | esn_hex  
---------+--------------+---------------------+--------+----------+----------
   12075 |         7868 | 3125463357@uscc.net | 0E14ED | 608091   | F615D6E8
   33032 |         4470 | 3125468004@uscc.net | 0DD870 | 641420   | F614A49E
    4840 |         4470 |                     | 0DD870 | 641420   | F614A49E
   30261 |         4470 |                     | 0DD870 | 641420   | F614A49E
(4 rows)


par_esn_hex:   F615D6E8
par_username:  3125463357@uscc.net



SELECT equipment_id 
  FROM unique_identifier
  WHERE unique_identifier_type = 'ESN HEX'
  AND value LIKE 'F615D6E8';
 equipment_id 
--------------
         7868  => var_equipment_id


SELECT value 
    FROM unique_identifier
    WHERE unique_identifier_type = 'MIN'
    AND equipment_id = 7868;
   value    
------------
 3125463357   =>  var_mdn
(1 row)


SELECT unam.username 
  FROM username unam
 WHERE 1 = 1
   AND username ~ '@'
   AND substr(username, 1, strpos(username, '@') - 1) = 3125463357;



           username            
-------------------------------
 3125463357@cn01.sprintpcs.com    =>  var_username
 3125463357@uscc.net              =>  var_username
(2 rows)

par_esn_hex:        F615D6E8
par_username:       3125463357@uscc.net
var_equipment_id:   7868 
var_mdn:            3125463357

var_username:       3125463357@cn01.sprintpcs.com 
var_username:       3125463357@uscc.net



IF EXISTS (SELECT TRUE 
             FROM line 
            WHERE radius_username LIKE var_username 
              AND line_label LIKE par_esn_hex 
              AND end_date IS NULL
          ) THEN
    IF var_username ~ '@vzw' THEN
        IF NOT EXISTS( SELECT TRUE 
                         FROM usergroup 
                        WHERE username LIKE var_username 
                          AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione'
                      ) THEN
                            INSERT INTO usergroup(username, groupname, priority)
                            VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
        END IF;
    ELSE
        IF NOT EXISTS( SELECT TRUE 
                         FROM usergroup 
                        WHERE username LIKE var_username 
                          AND groupname LIKE 'userdisconnected'
                      ) THEN
                            INSERT INTO usergroup(username, groupname, priority)
                            VALUES (var_username, 'userdisconnected', 1);
        END IF;
    END IF;
ELSE
    IF EXISTS (SELECT TRUE 
                 FROM username 
                WHERE username LIKE var_username
              ) THEN
      IF var_username ~ '@vzw' THEN
          IF NOT EXISTS( SELECT TRUE 
                           FROM usergroup 
                          WHERE username LIKE var_username 
                            AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione'
                        ) THEN
                              INSERT INTO usergroup(username, groupname, priority)
                              VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
          END IF;
      ELSE
          IF NOT EXISTS( SELECT TRUE 
                           FROM usergroup 
                          WHERE username LIKE var_username 
                            AND groupname LIKE 'userdisconnected'
                        ) THEN
                              INSERT INTO usergroup(username, groupname, priority)
                              VALUES (var_username, 'userdisconnected', 1);
          END IF;
      END IF;
    END IF;
END IF;


IF EXISTS(

--    SELECT TRUE 
--
--            FROM unique_identifier 
--
--            JOIN line_equipment le USING (equipment_id) 
--           WHERE value = '3125463357' AND le.end_date IS NULL
SELECT TRUE 
  FROM unique_identifier 
  JOIN line_equipment le USING (equipment_id) 
 WHERE value = '3125463357' AND le.end_date IS NULL;
 bool 
------
 t
(1 row)

           ) THEN

    IF EXISTS( 

      SELECT TRUE 
        FROM usergroup 
       WHERE username LIKE var_username 
         AND (   groupname LIKE 'userdisconnected' 
              OR groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione')



             ) THEN









      DELETE FROM usergroup
      WHERE username LIKE var_username
      AND groupname LIKE 'userdisconnected';

      DELETE FROM usergroup
      WHERE username LIKE var_username
      AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione';




SELECT * FROM csctoss.ops_api_user_suspend('F615D6E8','3125463357@uscc.net');
 result_code | error_message 
-------------+---------------
 t           | 
(1 row)

csctoss=# 


SELECT * FROM csctoss.ops_api_user_suspend('F614A49E','3125468004@uscc.net');

select l.line_id                                                         
      ,le.equipment_id
      ,l.start_date
      ,l.end_date
      ,l.radius_username
      ,uim.value as mac
      ,uis.value as serialno
      ,uie.value as esn_hex
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uis.value in ('608091', '641420');


--

select substr(username, 1, strpos(username, '@') - 1)
csctoss-#   from username
csctoss-#  where username like '%@cn01.sprintpcs.com';
   substr   
------------


select count(*) from usergroup where username like '%cn01.sprintpcs.com';
 count 
-------
    82
(1 row)

--
--  Based on input from Justice, we need to remove from username table 
--  where username like '%cn01.sprintpcs.com'.
--
--

select substring(username,1,10)
  from username
 where username like '%cn01.sprintpcs.com' 
 order by substring(username,1,10);
 substring  
------------
 3035551234
 3122173463
 3122173516
 3122173791
 3122176455
 3122179046
 3122179578
 3123886912
 3123888978
 3123889325
 3123889384
 3123889438
 3123889611
 3123889723
 3124370805
 3124372038
 3124372290
 3124372411
 3124372531
 3124373105
 3124373794
 3124373816
 3124374055
 3124374906
 3124375041
 3124375062
 3124375071
 3124376540
 3124376611
 3124376883
 3124376884
 3124377199
 3124377367
 3124377594
 3124377854
 3124377869
 3124377885
 3124378046
 3124378248
 3124378394
 3124378444
 3124379018
 3124379061
 3125460269
 3125460290
 3125460339
 3125463357
 3125464810
 3125465661
 3125465704
 3125467627
 3125467966
 3125468004
 3125469553
 3125469561
 3125469568
 3125469817
 3126710457
 3126711248
 3126711545
 3126712255
 3126712570
 3126712599
 3129961634
 3129964459
 3129964496
 3129964596
 3129964619
 3129964702
 5662127563
 5662127565
 6462421173
(72 rows)


select username
      ,billing_entity_id
      ,enabled
      ,start_date
      ,end_date
  from username 
 where username like '%cn01.sprintpcs.com' order by username;
           username            | billing_entity_id | enabled | start_date |  end_date  
-------------------------------+-------------------+---------+------------+------------
 3124370805@cn01.sprintpcs.com |                 2 | t       | 2015-06-24 | 2999-12-31
 3123886912@cn01.sprintpcs.com |               283 | t       | 2013-10-07 | 2999-12-31
 3124373105@cn01.sprintpcs.com |               283 | t       | 2013-10-07 | 2999-12-31
 3125469553@cn01.sprintpcs.com |               161 | t       | 2013-10-01 | 2099-12-31
 3124375071@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3122179046@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3122179578@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3124374055@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3124377199@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3124372038@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3124377367@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3126711248@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3124376611@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3125464810@cn01.sprintpcs.com |               221 | t       | 2013-10-14 | 2099-12-31
 3123889438@cn01.sprintpcs.com |               287 | t       | 2013-10-07 | 2999-12-31
 3126712570@cn01.sprintpcs.com |               657 | t       | 2013-10-07 | 2999-12-31
 3124376884@cn01.sprintpcs.com |               657 | t       | 2013-10-07 | 2999-12-31
 3124377885@cn01.sprintpcs.com |               657 | t       | 2013-10-07 | 2999-12-31
 3129964619@cn01.sprintpcs.com |               657 | t       | 2013-10-07 | 2999-12-31
 3126712599@cn01.sprintpcs.com |               657 | t       | 2013-10-07 | 2999-12-31
 3129961634@cn01.sprintpcs.com |               385 | t       | 2013-10-07 | 2999-12-31
 3124372411@cn01.sprintpcs.com |               484 | t       | 2013-10-07 | 2999-12-31
 3129964702@cn01.sprintpcs.com |                53 | t       | 2013-10-07 | 2999-12-31
 3123889384@cn01.sprintpcs.com |               444 | t       | 2013-10-07 | 2999-12-31
 3125468004@cn01.sprintpcs.com |               287 | t       | 2013-10-07 | 2999-12-31
 3125463357@cn01.sprintpcs.com |               287 | t       | 2013-10-07 | 2999-12-31
 3129964596@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2999-12-31
 3124377854@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2999-12-31
 3124379018@cn01.sprintpcs.com |               112 | t       | 2013-10-01 | 2999-12-31
 3125460339@cn01.sprintpcs.com |               112 | t       | 2013-10-01 | 2199-12-31
 3124376540@cn01.sprintpcs.com |               112 | t       | 2013-10-01 | 2999-12-31
 3126711545@cn01.sprintpcs.com |               112 | t       | 2013-10-01 | 2999-12-31
 3124378248@cn01.sprintpcs.com |               112 | t       | 2013-10-01 | 2999-12-31
 3125469561@cn01.sprintpcs.com |               126 | t       | 2013-10-01 | 2099-12-31
 3125469568@cn01.sprintpcs.com |               126 | t       | 2013-10-01 | 2099-12-31
 3125460290@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3124375041@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3124375062@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3125460269@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3125465704@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3125465661@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3122176455@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3125469817@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3125467627@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3122173463@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3123889611@cn01.sprintpcs.com |               144 | t       | 2013-10-01 | 2099-12-31
 3123889723@cn01.sprintpcs.com |               161 | t       | 2013-10-01 | 2099-12-31
 3125467966@cn01.sprintpcs.com |               161 | t       | 2013-10-01 | 2099-12-31
 3122173516@cn01.sprintpcs.com |               161 | t       | 2013-10-01 | 2099-12-31
 3122173791@cn01.sprintpcs.com |               215 | t       | 2013-10-01 | 2099-12-31
 3124372531@cn01.sprintpcs.com |               215 | t       | 2013-10-01 | 2099-12-31
 3124379061@cn01.sprintpcs.com |               215 | t       | 2013-10-01 | 2099-12-31
 3124378046@cn01.sprintpcs.com |               215 | t       | 2013-10-01 | 2099-12-31
 3123889325@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124378444@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124374906@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124372290@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124377594@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3129964459@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124378394@cn01.sprintpcs.com |               284 | t       | 2013-10-01 | 2099-12-31
 3124376883@cn01.sprintpcs.com |               459 | t       | 2013-10-01 | 2099-12-31
 3126710457@cn01.sprintpcs.com |               459 | t       | 2013-10-01 | 2099-12-31
 3126712255@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2199-12-31
 3129964496@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2199-12-31
 3124373816@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2199-12-31
 3124373794@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2999-12-31
 3124377869@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2999-12-31
 3123888978@cn01.sprintpcs.com |                22 | t       | 2013-10-01 | 2999-12-31
 6462421173@cn01.sprintpcs.com |                22 | t       | 2013-09-18 | 2099-09-18
 3035551234@cn01.sprintpcs.com |                 1 | t       | 2013-09-18 | 2999-12-31
 5662127563@cn01.sprintpcs.com |                 1 | t       | 2013-09-18 | 2999-12-31
 5662127565@cn01.sprintpcs.com |                 1 | t       | 2013-09-18 | 2999-12-31
(72 rows)

select username
      ,billing_entity_id
      ,enabled
      ,start_date
      ,end_date
  from username 
 where substring(username,1,10) IN
('3035551234',
'3122173463',
'3122173516',
'3122173791',
'3122176455',
'3122179046',
'3122179578',
'3123886912',
'3123888978',
'3123889325',
'3123889384',
'3123889438',
'3123889611',
'3123889723',
'3124370805',
'3124372038',
'3124372290',
'3124372411',
'3124372531',
'3124373105',
'3124373794',
'3124373816',
'3124374055',
'3124374906',
'3124375041',
'3124375062',
'3124375071',
'3124376540',
'3124376611',
'3124376883',
'3124376884',
'3124377199',
'3124377367',
'3124377594',
'3124377854',
'3124377869',
'3124377885',
'3124378046',
'3124378248',
'3124378394',
'3124378444',
'3124379018',
'3124379061',
'3125460269',
'3125460290',
'3125460339',
'3125463357',
'3125464810',
'3125465661',
'3125465704',
'3125467627',
'3125467966',
'3125468004',
'3125469553',
'3125469561',
'3125469568',
'3125469817',
'3126710457',
'3126711248',
'3126711545',
'3126712255',
'3126712570',
'3126712599',
'3129961634',
'3129964459',
'3129964496',
'3129964596',
'3129964619',
'3129964702',
'5662127563',
'5662127565',
'6462421173') order by username;
            username            | billing_entity_id | enabled | start_date |  end_date  
--------------------------------+-------------------+---------+------------+------------
 3035551234@cn01.sprintpcs.com  |                 1 | t       | 2013-09-18 | 2999-12-31
 3122173463@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3122173463@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3122173516@cn01.sprintpcs.com  |               161 | t       | 2013-10-01 | 2099-12-31
 3122173516@uscc.net            |               161 | t       | 2012-11-21 | 2999-12-31
 3122173791@cn01.sprintpcs.com  |               215 | t       | 2013-10-01 | 2099-12-31
 3122173791@uscc.net            |               215 | t       | 2009-10-26 | 2999-12-31
 3122176455@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3122176455@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3122179046@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3122179046@uscc.net            |               221 | t       | 2010-06-11 | 2999-12-31
 3122179578@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3122179578@uscc.net            |               221 | t       | 2010-06-11 | 2999-12-31
 3123886912@cn01.sprintpcs.com  |               283 | t       | 2013-10-07 | 2999-12-31
 3123886912@uscc.net            |               484 | t       | 2011-01-19 | 2999-12-31
 3123888978@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2999-12-31
 3123888978@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3123889325@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3123889325@uscc.net            |               284 | t       | 2009-12-29 | 2999-12-31
 3123889384@cn01.sprintpcs.com  |               444 | t       | 2013-10-07 | 2999-12-31
 3123889384@uscc.net            |               444 | t       | 2009-11-20 | 2999-12-31
 3123889438@cn01.sprintpcs.com  |               287 | t       | 2013-10-07 | 2999-12-31
 3123889438@uscc.net            |               107 | t       | 2010-01-05 | 2999-12-31
 3123889611@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3123889611@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3123889723@cn01.sprintpcs.com  |               161 | t       | 2013-10-01 | 2099-12-31
 3123889723@uscc.net            |               161 | t       | 2012-07-27 | 2999-12-31
 3124370805@cn01.sprintpcs.com  |                 2 | t       | 2015-06-24 | 2999-12-31
 3124370805@uscc.net            |               171 | t       | 2013-07-18 | 2999-12-31
 3124372038@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124372038@uscc.net            |               221 | t       | 2010-09-17 | 2999-12-31
 3124372290@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3124372290@uscc.net            |               284 | t       | 2010-07-14 | 2999-12-31
 3124372411@cn01.sprintpcs.com  |               484 | t       | 2013-10-07 | 2999-12-31
 3124372411@uscc.net            |               484 | t       | 2011-01-19 | 2999-12-31
 3124372531@cn01.sprintpcs.com  |               215 | t       | 2013-10-01 | 2099-12-31
 3124372531@uscc.net            |               215 | t       | 2010-10-19 | 2999-12-31
 3124373105@cn01.sprintpcs.com  |               283 | t       | 2013-10-07 | 2999-12-31
 3124373105@uscc.net            |               484 | t       | 2011-01-19 | 2999-12-31
 3124373794@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2999-12-31
 3124373794@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3124373816@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2199-12-31
 3124373816@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3124374055@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124374055@uscc.net            |                 1 | t       | 2010-04-01 | 2999-12-31
 3124374906@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3124374906@uscc.net            |               284 | t       | 2010-05-04 | 2999-12-31
 3124375041@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3124375041@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3124375062@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3124375062@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3124375071@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124375071@uscc.net            |               221 | t       | 2010-06-11 | 2999-12-31
 3124376540@cn01.sprintpcs.com  |               112 | t       | 2013-10-01 | 2999-12-31
 3124376540@uscc.net            |               112 | t       | 2013-10-01 | 2999-12-31
 3124376611@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124376611@uscc.net            |               221 | t       | 2010-09-17 | 2999-12-31
 3124376883@cn01.sprintpcs.com  |               459 | t       | 2013-10-01 | 2099-12-31
 3124376883@uscc.net            |               459 | t       | 2010-11-08 | 2999-12-31
 3124376884@cn01.sprintpcs.com  |               657 | t       | 2013-10-07 | 2999-12-31
 3124376884@uscc.net            |               657 | t       | 2013-04-23 | 2999-12-31
 3124377199@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124377199@uscc.net            |                99 | t       | 2010-09-17 | 2999-12-31
 3124377367@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3124377367@uscc.net            |               221 | t       | 2010-09-17 | 2999-12-31
 3124377594@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3124377594@uscc.net            |               284 | t       | 2010-09-28 | 2999-12-31
 3124377854@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2999-12-31
 3124377854@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3124377869@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2999-12-31
 3124377869@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3124377885@cn01.sprintpcs.com  |               657 | t       | 2013-10-07 | 2999-12-31
 3124377885@uscc.net            |               657 | t       | 2013-04-23 | 2999-12-31
 3124378046@cn01.sprintpcs.com  |               215 | t       | 2013-10-01 | 2099-12-31
 3124378046@uscc.net            |               215 | t       | 2011-01-25 | 2999-12-31
 3124378248@cn01.sprintpcs.com  |               112 | t       | 2013-10-01 | 2999-12-31
 3124378248@uscc.net            |               112 | t       | 2013-10-01 | 2999-12-31
 3124378394@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3124378394@uscc.net            |               284 | t       | 2011-03-16 | 2999-12-31
 3124378444@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3124378444@uscc.net            |               284 | t       | 2011-02-14 | 2999-12-31
 3124379018@cn01.sprintpcs.com  |               112 | t       | 2013-10-01 | 2999-12-31
 3124379018@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3124379061@cn01.sprintpcs.com  |               215 | t       | 2013-10-01 | 2099-12-31
 3124379061@uscc.net            |               215 | t       | 2010-12-16 | 2999-12-31
 3125460269@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125460269@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3125460290@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125460290@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3125460339@cn01.sprintpcs.com  |               112 | t       | 2013-10-01 | 2199-12-31
 3125460339@uscc.net            |               112 | t       | 2013-10-01 | 2999-12-31
 3125463357@cn01.sprintpcs.com  |               287 | t       | 2013-10-07 | 2999-12-31
 3125463357@uscc.net            |               287 | t       | 2010-06-29 | 2999-12-31
 3125464810@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3125464810@uscc.net            |                 1 | t       | 2010-01-14 | 2999-12-31
 3125465661@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125465661@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3125465704@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125465704@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3125467627@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125467627@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3125467966@cn01.sprintpcs.com  |               161 | t       | 2013-10-01 | 2099-12-31
 3125467966@uscc.net            |               161 | t       | 2012-08-27 | 2999-12-31
 3125468004@cn01.sprintpcs.com  |               287 | t       | 2013-10-07 | 2999-12-31
 3125468004@uscc.net            |               287 | t       | 2013-02-01 | 2999-12-31
 3125469553@cn01.sprintpcs.com  |               161 | t       | 2013-10-01 | 2099-12-31
 3125469553@uscc.net            |               161 | t       | 2012-07-27 | 2999-12-31
 3125469561@cn01.sprintpcs.com  |               126 | t       | 2013-10-01 | 2099-12-31
 3125469561@uscc.net            |               126 | t       | 2009-07-07 | 2999-12-31
 3125469568@cn01.sprintpcs.com  |               126 | t       | 2013-10-01 | 2099-12-31
 3125469568@uscc.net            |               126 | t       | 2009-08-04 | 2999-12-31
 3125469817@cn01.sprintpcs.com  |               144 | t       | 2013-10-01 | 2099-12-31
 3125469817@uscc.net            |               144 | t       | 2012-07-31 | 2999-12-31
 3126710457@cn01.sprintpcs.com  |               459 | t       | 2013-10-01 | 2099-12-31
 3126710457@uscc.net            |               459 | t       | 2011-08-04 | 2999-12-31
 3126711248@cn01.sprintpcs.com  |               221 | t       | 2013-10-14 | 2099-12-31
 3126711248@uscc.net            |                 1 | t       | 2010-07-14 | 2999-12-31
 3126711545@cn01.sprintpcs.com  |               112 | t       | 2013-10-01 | 2999-12-31
 3126711545@uscc.net            |               112 | t       | 2013-10-01 | 2999-12-31
 3126712255@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2199-12-31
 3126712255@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3126712570@cn01.sprintpcs.com  |               657 | t       | 2013-10-07 | 2999-12-31
 3126712570@uscc.net            |               657 | t       | 2013-04-23 | 2999-12-31
 3126712599@cn01.sprintpcs.com  |               657 | t       | 2013-10-07 | 2999-12-31
 3126712599@uscc.net            |               657 | t       | 2013-04-23 | 2999-12-31
 3129961634@cn01.sprintpcs.com  |               385 | t       | 2013-10-07 | 2999-12-31
 3129961634@uscc.net            |               385 | t       | 2012-01-13 | 2999-12-31
 3129964459@cn01.sprintpcs.com  |               284 | t       | 2013-10-01 | 2099-12-31
 3129964459@uscc.net            |               284 | t       | 2011-02-08 | 2999-12-31
 3129964496@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2199-12-31
 3129964496@uscc.net            |               112 | t       | 2013-09-24 | 2999-12-31
 3129964596@cn01.sprintpcs.com  |                22 | t       | 2013-10-01 | 2999-12-31
 3129964596@uscc.net            |               591 | t       | 2013-09-24 | 2999-12-31
 3129964619@cn01.sprintpcs.com  |               657 | t       | 2013-10-07 | 2999-12-31
 3129964619@uscc.net            |               657 | t       | 2013-04-23 | 2999-12-31
 3129964702@cn01.sprintpcs.com  |                53 | t       | 2013-10-07 | 2999-12-31
 3129964702@uscc.net            |                53 | t       | 2013-03-06 | 2999-12-31
 5662127563@cn01.sprintpcs.com  |                 1 | t       | 2013-09-18 | 2999-12-31
 5662127565@cn01.sprintpcs.com  |                 1 | t       | 2013-09-18 | 2999-12-31
 6462421173@cn01.sprintpcs.com  |                22 | t       | 2013-09-18 | 2099-09-18
 6462421173@tsp17.sprintpcs.com |                 1 | t       | 2010-08-05 | 2999-12-31
(141 rows)



select *
  from radreply
 where substring(username,1,10) IN
('5662127563',
'5662127565',
'3035551234',
.
.
.
'3125468004',
'3125463357') order by username;
  id   |           username            |     attribute     | op |     value     | priority 
-------+-------------------------------+-------------------+----+---------------+----------
 51120 | 3122173463@uscc.net           | Class             | =  | 28932         |       10
 62666 | 3122179046@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.111   |       10
 62667 | 3122179578@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.123   |       10
 79228 | 3123886912@cn01.sprintpcs.com | Class             | =  | 45272         |       10
 11667 | 3123889325@uscc.net           | Class             | =  | 6745          |       10
 72187 | 3123889438@uscc.net           | Class             | =  | 41576         |       10
 72188 | 3123889438@uscc.net           | Framed-IP-Address | =  | 10.56.108.122 |       10
 73102 | 3124370805@uscc.net           | Class             | =  | 42103         |       10
 62670 | 3124372038@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.13    |       10
 26579 | 3124372038@uscc.net           | Class             | =  | 13859         |       10
 26679 | 3124372038@uscc.net           | Framed-IP-Address | =  | 10.56.2.13    |       10
 24268 | 3124372290@uscc.net           | Class             | =  | 12475         |       10
 66383 | 3124372531@uscc.net           | Framed-IP-Address | =  | 10.56.184.228 |       10
 28367 | 3124372531@uscc.net           | Class             | =  | 15002         |       10
 79229 | 3124373105@cn01.sprintpcs.com | Class             | =  | 45273         |       10
 46729 | 3124374055@uscc.net           | Class             | =  | 12616         |       10
 46730 | 3124374055@uscc.net           | Framed-IP-Address | =  | 10.56.1.211   |       10
 20559 | 3124374906@uscc.net           | Class             | =  | 10217         |       10
 51102 | 3124375062@uscc.net           | Class             | =  | 28914         |       10
 62692 | 3124375071@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.107   |       10
 22539 | 3124375071@uscc.net           | Class             | =  | 11435         |       10
 22599 | 3124375071@uscc.net           | Framed-IP-Address | =  | 10.56.1.107   |       10
 62673 | 3124376611@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.45    |       10
 26611 | 3124376611@uscc.net           | Class             | =  | 13891         |       10
 26711 | 3124376611@uscc.net           | Framed-IP-Address | =  | 10.56.2.45    |       10
 28921 | 3124376883@uscc.net           | Class             | =  | 15293         |       10
 59050 | 3124376884@uscc.net           | Class             | =  | 34422         |       10
 62669 | 3124377199@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.7     |       10
 72788 | 3124377199@uscc.net           | Class             | =  | 17386         |       10
 62671 | 3124377367@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.32    |       10
 27777 | 3124377594@uscc.net           | Class             | =  | 14578         |       10
 59049 | 3124377885@uscc.net           | Class             | =  | 34421         |       10
 33366 | 3124378394@uscc.net           | Class             | =  | 18229         |       10
 60339 | 3124378444@uscc.net           | Class             | =  | 10216         |       10
 66467 | 3124379061@uscc.net           | Framed-IP-Address | =  | 10.56.184.75  |       10
 30260 | 3124379061@uscc.net           | Class             | =  | 16116         |       10
 62674 | 3125464810@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.64    |       10
 51113 | 3125465661@uscc.net           | Class             | =  | 28925         |       10
 51017 | 3125469553@uscc.net           | Class             | =  | 28842         |       10
  4050 | 3125469561@uscc.net           | Class             | =  | 2665          |       10
  4687 | 3125469568@uscc.net           | Class             | =  | 3694          |       10
 51115 | 3125469817@uscc.net           | Class             | =  | 28927         |       10
 39416 | 3126710457@uscc.net           | Class             | =  | 21321         |       10
 57212 | 3126711248@uscc.net           | Framed-IP-Address | =  | 10.56.2.41    |       10
 59052 | 3126712570@uscc.net           | Class             | =  | 34424         |       10
 59047 | 3126712599@uscc.net           | Class             | =  | 34419         |       10
 32082 | 3129964459@uscc.net           | Class             | =  | 17150         |       10
 72485 | 3129964596@uscc.net           | Class             | =  | 11617         |       10
 59048 | 3129964619@uscc.net           | Class             | =  | 34420         |       10
(49 rows)
-- these are the culprits!
 62666 | 3122179046@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.111   |       10
 62667 | 3122179578@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.123   |       10
* 79228 | 3123886912@cn01.sprintpcs.com | Class             | =  | 45272         |       10
 62670 | 3124372038@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.13    |       10
* 79229 | 3124373105@cn01.sprintpcs.com | Class             | =  | 45273         |       10
 62692 | 3124375071@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.1.107   |       10
 62673 | 3124376611@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.45    |       10
 62669 | 3124377199@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.7     |       10
 62671 | 3124377367@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.32    |       10
 62674 | 3125464810@cn01.sprintpcs.com | Framed-IP-Address | =  | 10.56.2.64    |       10


select line_id
      ,start_date
      ,end_date
      ,radius_username
  from line
 where substring(radius_username,1,10) IN
('5662127563',
'5662127565',
.
.
.
'3126711248',
'3125468004',
'3125463357') order by substring(radius_username,1,10);
 line_id |       start_date       | end_date |        radius_username        
---------+------------------------+----------+-------------------------------
   45272 | 2017-06-20 00:00:00+00 |          | 3123886912@cn01.sprintpcs.com
    6745 | 2009-12-29 00:00:00+00 |          | 3123889325@uscc.net
   41576 | 2015-04-29 00:00:00+00 |          | 3123889438@uscc.net
   42103 | 2015-06-25 00:00:00+00 |          | 3124370805@uscc.net
   13859 | 2010-09-17 00:00:00+00 |          | 3124372038@uscc.net
   12475 | 2010-07-14 00:00:00+00 |          | 3124372290@uscc.net
   15002 | 2010-10-19 00:00:00+00 |          | 3124372531@uscc.net
   45273 | 2017-06-20 00:00:00+00 |          | 3124373105@cn01.sprintpcs.com
   10217 | 2010-05-04 00:00:00+00 |          | 3124374906@uscc.net
   11435 | 2010-06-11 00:00:00+00 |          | 3124375071@uscc.net
   13891 | 2010-09-17 00:00:00+00 |          | 3124376611@uscc.net
   15293 | 2010-11-08 00:00:00+00 |          | 3124376883@uscc.net
   34422 | 2013-04-23 00:00:00+00 |          | 3124376884@uscc.net
   17386 | 2011-02-24 00:00:00+00 |          | 3124377199@uscc.net
   14578 | 2010-09-28 00:00:00+00 |          | 3124377594@uscc.net
   34421 | 2013-04-23 00:00:00+00 |          | 3124377885@uscc.net
   18229 | 2011-03-16 00:00:00+00 |          | 3124378394@uscc.net
   10216 | 2010-05-04 00:00:00+00 |          | 3124378444@uscc.net
   16116 | 2010-12-16 00:00:00+00 |          | 3124379061@uscc.net
   28842 | 2012-07-27 00:00:00+00 |          | 3125469553@uscc.net
    2665 | 2009-07-07 00:00:00+00 |          | 3125469561@uscc.net
    3694 | 2009-08-04 00:00:00+00 |          | 3125469568@uscc.net
   21321 | 2011-08-04 00:00:00+00 |          | 3126710457@uscc.net
   34424 | 2013-04-23 00:00:00+00 |          | 3126712570@uscc.net
   34419 | 2013-04-23 00:00:00+00 |          | 3126712599@uscc.net
   17150 | 2011-02-08 00:00:00+00 |          | 3129964459@uscc.net
   11617 | 2010-06-18 00:00:00+00 |          | 3129964596@uscc.net
   34420 | 2013-04-23 00:00:00+00 |          | 3129964619@uscc.net
(28 rows)

   45272 | 2017-06-20 00:00:00+00 |          | 3123886912@cn01.sprintpcs.com
   45273 | 2017-06-20 00:00:00+00 |          | 3124373105@cn01.sprintpcs.com


select username
      ,groupname
  from usergroup
 where substring(username,1,10) IN 
('5662127563',
'5662127565',
.
.
.
'3126711248',
'3125468004',
'3125463357') order by username;
            username            |      groupname       
--------------------------------+----------------------
 3122173516@cn01.sprintpcs.com  | SERVICE-private_atm
 3122173516@uscc.net            | disconnected
 3122173516@uscc.net            | SERVICE-private_atm

 3122173791@cn01.sprintpcs.com  | SERVICE-private_atm
 3122173791@uscc.net            | disconnected
 3122173791@uscc.net            | SERVICE-public_atm

 3122176455@cn01.sprintpcs.com  | SERVICE-private_atm
 3122176455@uscc.net            | disconnected
 3122176455@uscc.net            | SERVICE-private_atm

 3122179046@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3122179046@uscc.net            | disconnected
 3122179046@uscc.net            | SERVICE-fcti

 3122179578@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3122179578@uscc.net            | disconnected
 3122179578@uscc.net            | SERVICE-fcti

 3123888978@cn01.sprintpcs.com  | userdisconnected
 3123888978@cn01.sprintpcs.com  | SERVICE-private_inet
 3123888978@uscc.net            | disconnected
 3123888978@uscc.net            | SERVICE-private_inet

 3123889384@cn01.sprintpcs.com  | disconnected
 3123889384@cn01.sprintpcs.com  | SERVICE-private_atm
 3123889384@uscc.net            | SERVICE-private_atm
 3123889384@uscc.net            | disconnected


 3123889611@cn01.sprintpcs.com  | SERVICE-private_atm
 3123889611@uscc.net            | disconnected
 3123889611@uscc.net            | SERVICE-private_atm

 3123889723@cn01.sprintpcs.com  | SERVICE-private_atm
 3123889723@uscc.net            | disconnected
 3123889723@uscc.net            | SERVICE-private_atm


 3124372411@cn01.sprintpcs.com  | SERVICE-private_atm
 3124372411@uscc.net            | disconnected
 3124372411@uscc.net            | SERVICE-private_atm

 3124373794@cn01.sprintpcs.com  | userdisconnected
 3124373794@cn01.sprintpcs.com  | SERVICE-private_inet
 3124373794@uscc.net            | disconnected
 3124373794@uscc.net            | SERVICE-private_inet

 3124373816@cn01.sprintpcs.com  | userdisconnected
 3124373816@cn01.sprintpcs.com  | SERVICE-private_inet
 3124373816@uscc.net            | disconnected
 3124373816@uscc.net            | SERVICE-private_inet

 3124374055@cn01.sprintpcs.com  | disconnected
 3124374055@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124374055@uscc.net            | SERVICE-fcti

 3124375041@cn01.sprintpcs.com  | SERVICE-private_atm
 3124375041@uscc.net            | disconnected
 3124375041@uscc.net            | SERVICE-private_atm

 3124376540@cn01.sprintpcs.com  | SERVICE-private_inet
 3124376540@uscc.net            | disconnected
 3124376540@uscc.net            | SERVICE-inventory

 3124377367@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124377367@uscc.net            | disconnected
 3124377367@uscc.net            | SERVICE-fcti

 3124377854@cn01.sprintpcs.com  | userdisconnected
 3124377854@cn01.sprintpcs.com  | SERVICE-private_inet
 3124377854@uscc.net            | disconnected
 3124377854@uscc.net            | SERVICE-private_inet

 3124377869@cn01.sprintpcs.com  | SERVICE-private_inet
 3124377869@uscc.net            | disconnected
 3124377869@uscc.net            | SERVICE-private_inet

 3124378046@cn01.sprintpcs.com  | SERVICE-private_atm
 3124378046@uscc.net            | disconnected
 3124378046@uscc.net            | SERVICE-cardtronics

 3124378248@cn01.sprintpcs.com  | SERVICE-private_inet
 3124378248@uscc.net            | SERVICE-inventory
 3124378248@uscc.net            | disconnected

 3124379018@cn01.sprintpcs.com  | userdisconnected
 3124379018@cn01.sprintpcs.com  | SERVICE-private_inet
 3124379018@uscc.net            | disconnected
 3124379018@uscc.net            | SERVICE-private_inet

 3124379061@cn01.sprintpcs.com  | SERVICE-private_atm
 3124379061@uscc.net            | SERVICE-cardtronics

 3125460269@cn01.sprintpcs.com  | SERVICE-private_atm
 3125460269@uscc.net            | disconnected
 3125460269@uscc.net            | SERVICE-private_atm

 3125460290@cn01.sprintpcs.com  | SERVICE-private_atm
 3125460290@uscc.net            | disconnected
 3125460290@uscc.net            | SERVICE-private_atm

 3125460339@cn01.sprintpcs.com  | SERVICE-private_inet
 3125460339@uscc.net            | disconnected
 3125460339@uscc.net            | SERVICE-inventory

 3125463357@cn01.sprintpcs.com  | userdisconnected
 3125463357@cn01.sprintpcs.com  | SERVICE-private_atm
 3125463357@uscc.net            | disconnected
 3125463357@uscc.net            | SERVICE-cardtronics

 3125464810@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3125464810@uscc.net            | disconnected
 3125464810@uscc.net            | SERVICE-fcti

 3125465661@cn01.sprintpcs.com  | SERVICE-private_atm
 3125465661@uscc.net            | disconnected
 3125465661@uscc.net            | SERVICE-private_atm

 3125465704@cn01.sprintpcs.com  | SERVICE-private_atm
 3125465704@uscc.net            | disconnected
 3125465704@uscc.net            | SERVICE-private_atm

 3125467627@cn01.sprintpcs.com  | SERVICE-private_atm
 3125467627@uscc.net            | disconnected
 3125467627@uscc.net            | SERVICE-private_atm

 3125467966@cn01.sprintpcs.com  | SERVICE-private_atm
 3125467966@uscc.net            | disconnected
 3125467966@uscc.net            | SERVICE-private_atm

 3125468004@cn01.sprintpcs.com  | userdisconnected
 3125468004@cn01.sprintpcs.com  | SERVICE-private_atm
 3125468004@uscc.net            | disconnected
 3125468004@uscc.net            | SERVICE-cardtronics

 3125469817@cn01.sprintpcs.com  | SERVICE-private_atm
 3125469817@uscc.net            | disconnected
 3125469817@uscc.net            | SERVICE-private_atm

 3126711248@cn01.sprintpcs.com  | disconnected
 3126711248@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3126711248@uscc.net            | SERVICE-fcti

 3126711545@cn01.sprintpcs.com  | SERVICE-private_inet
 3126711545@uscc.net            | disconnected
 3126711545@uscc.net            | SERVICE-private_inet

 3126712255@cn01.sprintpcs.com  | SERVICE-private_inet
 3126712255@uscc.net            | disconnected
 3126712255@uscc.net            | SERVICE-private_inet

 3129961634@cn01.sprintpcs.com  | SERVICE-private_atm
 3129961634@uscc.net            | disconnected
 3129961634@uscc.net            | SERVICE-cardtronics

 3129964496@cn01.sprintpcs.com  | SERVICE-private_inet
 3129964496@uscc.net            | disconnected
 3129964496@uscc.net            | SERVICE-private_inet



 3124377594@cn01.sprintpcs.com  | SERVICE-private_atm
 3124377594@uscc.net            | SERVICE-private_atm

 3124377885@cn01.sprintpcs.com  | SERVICE-private_atm
 3124377885@uscc.net            | SERVICE-private_atm

 3124378394@cn01.sprintpcs.com  | SERVICE-private_atm
 3124378394@uscc.net            | SERVICE-private_atm

 3124378444@cn01.sprintpcs.com  | SERVICE-private_atm
 3124378444@uscc.net            | SERVICE-private_atm

 3125469553@cn01.sprintpcs.com  | SERVICE-private_atm
 3125469553@uscc.net            | SERVICE-private_atm

 3125469561@cn01.sprintpcs.com  | SERVICE-private_atm
 3125469561@uscc.net            | SERVICE-private_atm

 3125469568@cn01.sprintpcs.com  | SERVICE-private_atm
 3125469568@uscc.net            | SERVICE-private_atm

 3126710457@cn01.sprintpcs.com  | SERVICE-private_atm
 3126710457@uscc.net            | SERVICE-private_atm

 3126712570@cn01.sprintpcs.com  | SERVICE-private_atm
 3126712570@uscc.net            | SERVICE-private_atm

 3126712599@cn01.sprintpcs.com  | SERVICE-private_atm
 3126712599@uscc.net            | SERVICE-private_atm

 3129964459@cn01.sprintpcs.com  | SERVICE-private_atm
 3129964459@uscc.net            | SERVICE-private_atm

 3129964596@cn01.sprintpcs.com  | SERVICE-private_inet
 3129964596@uscc.net            | SERVICE-private_atm

 3129964619@cn01.sprintpcs.com  | SERVICE-private_atm
 3129964619@uscc.net            | SERVICE-private_atm

 5662127563@cn01.sprintpcs.com  | SERVICE-inventory

 5662127565@cn01.sprintpcs.com  | SERVICE-inventory

 6462421173@cn01.sprintpcs.com  | SERVICE-inventory
 6462421173@tsp17.sprintpcs.com | SERVICE-inventory
(187 rows)


usergroup
 3035551234@cn01.sprintpcs.com  | SERVICE-inventory

 3122173463@cn01.sprintpcs.com  | SERVICE-private_atm
 3122173463@uscc.net            | SERVICE-private_atm

 3123886912@cn01.sprintpcs.com  | SERVICE-private_atm
 3123886912@uscc.net            | SERVICE-private_atm

 3123889325@cn01.sprintpcs.com  | SERVICE-private_atm
 3123889325@uscc.net            | SERVICE-private_atm

 3123889438@cn01.sprintpcs.com  | SERVICE-private_atm
 3123889438@uscc.net            | SERVICE-cardtronics
 3124370805@cn01.sprintpcs.com  | SERVICE-inventory
 3124370805@uscc.net            | SERVICE-private_atm

 3124372038@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124372038@uscc.net            | SERVICE-fcti

 3124372290@cn01.sprintpcs.com  | SERVICE-private_atm
 3124372290@uscc.net            | SERVICE-private_atm
 3124372531@cn01.sprintpcs.com  | SERVICE-private_atm
 3124372531@uscc.net            | SERVICE-cardtronics

 3124373105@cn01.sprintpcs.com  | SERVICE-private_atm
 3124373105@uscc.net            | SERVICE-private_atm

 3124374906@cn01.sprintpcs.com  | SERVICE-private_atm
 3124374906@uscc.net            | SERVICE-private_atm

 3124375062@cn01.sprintpcs.com  | SERVICE-private_atm
 3124375062@uscc.net            | SERVICE-private_atm
 3124376611@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124376611@uscc.net            | SERVICE-fcti

 3124376883@cn01.sprintpcs.com  | SERVICE-private_atm
 3124376883@uscc.net            | SERVICE-private_atm

 3124376884@cn01.sprintpcs.com  | SERVICE-private_atm
 3124376884@uscc.net            | SERVICE-private_atm

 3124377199@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124377199@uscc.net            | SERVICE-private_atm

 3124375071@cn01.sprintpcs.com  | SERVICE-fcti_cn01
 3124375071@uscc.net            | SERVICE-fcti



radreply

line
   45272 | 2017-06-20 00:00:00+00 |          | 3123886912@cn01.sprintpcs.com
   45273 | 2017-06-20 00:00:00+00 |          | 3124373105@cn01.sprintpcs.com

select username 
      ,billing_entity_id as bill
      ,start_date
      ,end_date
      ,notes
  from username
 where substring(username,1,10) IN
('5662127563',
'5662127565',
.
.
.
'3126711248',
'3125468004',
'3125463357') order by username;
            username            | bill | start_date |  end_date  |                    notes                     
--------------------------------+------+------------+------------+----------------------------------------------
 3035551234@cn01.sprintpcs.com  |    1 | 2013-09-18 | 2999-12-31 | 
 3122173463@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3122173463@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3122173516@cn01.sprintpcs.com  |  161 | 2013-10-01 | 2099-12-31 | uscc conversion
 3122173516@uscc.net            |  161 | 2012-11-21 | 2999-12-31 | SO-06320
 3122173791@cn01.sprintpcs.com  |  215 | 2013-10-01 | 2099-12-31 | uscc conversion
 3122173791@uscc.net            |  215 | 2009-10-26 | 2999-12-31 | Merrimak ATM Group - Dave Evans : SO-00
 3122176455@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3122176455@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3122179046@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3122179046@uscc.net            |  221 | 2010-06-11 | 2999-12-31 | SO-01394
 3122179578@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3122179578@uscc.net            |  221 | 2010-06-11 | 2999-12-31 | SO-01394
 3123886912@cn01.sprintpcs.com  |  283 | 2013-10-07 | 2999-12-31 | SO-11587
 3123886912@uscc.net            |  484 | 2011-01-19 | 2999-12-31 | SO-02273
 3123888978@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3123888978@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07815
 3123889325@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3123889325@uscc.net            |  284 | 2009-12-29 | 2999-12-31 | Lombardi ATM Sales & Service Inc. : SO-00672
 3123889384@cn01.sprintpcs.com  |  444 | 2013-10-07 | 2999-12-31 | uscc conversion
 3123889384@uscc.net            |  444 | 2009-11-20 | 2999-12-31 | SO-11317
 3123889438@cn01.sprintpcs.com  |  287 | 2013-10-07 | 2999-12-31 | uscc conversion
 3123889438@uscc.net            |  107 | 2010-01-05 | 2999-12-31 | SO-9829
 3123889611@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3123889611@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3123889723@cn01.sprintpcs.com  |  161 | 2013-10-01 | 2099-12-31 | uscc conversion
 3123889723@uscc.net            |  161 | 2012-07-27 | 2999-12-31 | SO-05588
 3124370805@cn01.sprintpcs.com  |    2 | 2015-06-24 | 2999-12-31 | 
 3124370805@uscc.net            |  171 | 2013-07-18 | 2999-12-31 | SO-9972
 3124372038@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124372038@uscc.net            |  221 | 2010-09-17 | 2999-12-31 | SO-01806
 3124372290@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124372290@uscc.net            |  284 | 2010-07-14 | 2999-12-31 | SO-01523
 3124372411@cn01.sprintpcs.com  |  484 | 2013-10-07 | 2999-12-31 | uscc conversion
 3124372411@uscc.net            |  484 | 2011-01-19 | 2999-12-31 | SO-02273
 3124372531@cn01.sprintpcs.com  |  215 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124372531@uscc.net            |  215 | 2010-10-19 | 2999-12-31 | SO-01924
 3124373105@cn01.sprintpcs.com  |  283 | 2013-10-07 | 2999-12-31 | SO-11587
 3124373105@uscc.net            |  484 | 2011-01-19 | 2999-12-31 | SO-02273
 3124373794@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124373794@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07814
 3124373816@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2199-12-31 | USCC Conversion to Sprint
 3124373816@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07813
 3124374055@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124374055@uscc.net            |    1 | 2010-04-01 | 2999-12-31 | RJ Amusements : SO-01066
 3124374906@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124374906@uscc.net            |  284 | 2010-05-04 | 2999-12-31 | SO-01204
 3124375041@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124375041@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3124375062@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124375062@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3124375071@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124375071@uscc.net            |  221 | 2010-06-11 | 2999-12-31 | SO-01394
 3124376540@cn01.sprintpcs.com  |  112 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124376540@uscc.net            |  112 | 2013-10-01 | 2999-12-31 | SO-07853
 3124376611@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124376611@uscc.net            |  221 | 2010-09-17 | 2999-12-31 | SO-01806
 3124376883@cn01.sprintpcs.com  |  459 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124376883@uscc.net            |  459 | 2010-11-08 | 2999-12-31 | SO-02011
 3124376884@cn01.sprintpcs.com  |  657 | 2013-10-07 | 2999-12-31 | uscc conversion
 3124376884@uscc.net            |  657 | 2013-04-23 | 2999-12-31 | SO-07045
 3124377199@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124377199@uscc.net            |   99 | 2010-09-17 | 2999-12-31 | SO-02466
 3124377367@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3124377367@uscc.net            |  221 | 2010-09-17 | 2999-12-31 | SO-01806
 3124377594@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124377594@uscc.net            |  284 | 2010-09-28 | 2999-12-31 | SO-01847
 3124377854@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124377854@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07816
 3124377869@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124377869@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07814
 3124377885@cn01.sprintpcs.com  |  657 | 2013-10-07 | 2999-12-31 | uscc conversion
 3124377885@uscc.net            |  657 | 2013-04-23 | 2999-12-31 | SO-07045
 3124378046@cn01.sprintpcs.com  |  215 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124378046@uscc.net            |  215 | 2011-01-25 | 2999-12-31 | SO-02299
 3124378248@cn01.sprintpcs.com  |  112 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124378248@uscc.net            |  112 | 2013-10-01 | 2999-12-31 | SO-07853
 3124378394@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124378394@uscc.net            |  284 | 2011-03-16 | 2999-12-31 | SO-02572
 3124378444@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124378444@uscc.net            |  284 | 2011-02-14 | 2999-12-31 | SO-02414
 3124379018@cn01.sprintpcs.com  |  112 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3124379018@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07816
 3124379061@cn01.sprintpcs.com  |  215 | 2013-10-01 | 2099-12-31 | uscc conversion
 3124379061@uscc.net            |  215 | 2010-12-16 | 2999-12-31 | SO-02148
 3125460269@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125460269@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3125460290@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125460290@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3125460339@cn01.sprintpcs.com  |  112 | 2013-10-01 | 2199-12-31 | USCC Conversion to Sprint
 3125460339@uscc.net            |  112 | 2013-10-01 | 2999-12-31 | SO-07853
 3125463357@cn01.sprintpcs.com  |  287 | 2013-10-07 | 2999-12-31 | uscc conversion
 3125463357@uscc.net            |  287 | 2010-06-29 | 2999-12-31 | SO-01472
 3125464810@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3125464810@uscc.net            |    1 | 2010-01-14 | 2999-12-31 | Dons Place Inc. : SO-00732
 3125465661@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125465661@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3125465704@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125465704@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3125467627@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125467627@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3125467966@cn01.sprintpcs.com  |  161 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125467966@uscc.net            |  161 | 2012-08-27 | 2999-12-31 | SO-05779
 3125468004@cn01.sprintpcs.com  |  287 | 2013-10-07 | 2999-12-31 | uscc conversion
 3125468004@uscc.net            |  287 | 2013-02-01 | 2999-12-31 | SO-06658
 3125469553@cn01.sprintpcs.com  |  161 | 2013-10-01 | 2099-12-31 | usccconversion
 3125469553@uscc.net            |  161 | 2012-07-27 | 2999-12-31 | SO-05588
 3125469561@cn01.sprintpcs.com  |  126 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125469561@uscc.net            |  126 | 2009-07-07 | 2999-12-31 | Eastern ATM Inc. : SO-00221
 3125469568@cn01.sprintpcs.com  |  126 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125469568@uscc.net            |  126 | 2009-08-04 | 2999-12-31 | Eastern ATM Inc. : SO-00256
 3125469817@cn01.sprintpcs.com  |  144 | 2013-10-01 | 2099-12-31 | uscc conversion
 3125469817@uscc.net            |  144 | 2012-07-31 | 2999-12-31 | SO-05619
 3126710457@cn01.sprintpcs.com  |  459 | 2013-10-01 | 2099-12-31 | uscc conversion
 3126710457@uscc.net            |  459 | 2011-08-04 | 2999-12-31 | SO-03433
 3126711248@cn01.sprintpcs.com  |  221 | 2013-10-14 | 2099-12-31 | uscc conversion
 3126711248@uscc.net            |    1 | 2010-07-14 | 2999-12-31 | 
 3126711545@cn01.sprintpcs.com  |  112 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3126711545@uscc.net            |  112 | 2013-10-01 | 2999-12-31 | SO-07853
 3126712255@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2199-12-31 | USCC Conversion to Sprint
 3126712255@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07812
 3126712570@cn01.sprintpcs.com  |  657 | 2013-10-07 | 2999-12-31 | uscc conversion
 3126712570@uscc.net            |  657 | 2013-04-23 | 2999-12-31 | SO-07045
 3126712599@cn01.sprintpcs.com  |  657 | 2013-10-07 | 2999-12-31 | uscc conversion
 3126712599@uscc.net            |  657 | 2013-04-23 | 2999-12-31 | SO-07045
 3129961634@cn01.sprintpcs.com  |  385 | 2013-10-07 | 2999-12-31 | uscc conversion
 3129961634@uscc.net            |  385 | 2012-01-13 | 2999-12-31 | SO-04348
 3129964459@cn01.sprintpcs.com  |  284 | 2013-10-01 | 2099-12-31 | uscc conversion
 3129964459@uscc.net            |  284 | 2011-02-08 | 2999-12-31 | SO-02386
 3129964496@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2199-12-31 | USCC Conversion to Sprint
 3129964496@uscc.net            |  112 | 2013-09-24 | 2999-12-31 | SO-07812
 3129964596@cn01.sprintpcs.com  |   22 | 2013-10-01 | 2999-12-31 | USCC Conversion to Sprint
 3129964596@uscc.net            |  591 | 2013-09-24 | 2999-12-31 | SO-01420
 3129964619@cn01.sprintpcs.com  |  657 | 2013-10-07 | 2999-12-31 | uscc conversion
 3129964619@uscc.net            |  657 | 2013-04-23 | 2999-12-31 | SO-07045
 3129964702@cn01.sprintpcs.com  |   53 | 2013-10-07 | 2999-12-31 | uscc conversion
 3129964702@uscc.net            |   53 | 2013-03-06 | 2999-12-31 | SO-06830
 5662127563@cn01.sprintpcs.com  |    1 | 2013-09-18 | 2999-12-31 | 
 5662127565@cn01.sprintpcs.com  |    1 | 2013-09-18 | 2999-12-31 | 
 6462421173@cn01.sprintpcs.com  |   22 | 2013-09-18 | 2099-09-18 | Greg Testing of Proxy Realm
 6462421173@tsp17.sprintpcs.com |    1 | 2010-08-05 | 2999-12-31 | SO-01605
(141 rows)


-- Test with following:

 3125469553@cn01.sprintpcs.com  | SERVICE-private_atm
 3125469553@uscc.net            | SERVICE-private_atm


select * from unique_identifier where unique_identifier_type = 'MIN' and value like '%3125469553%';
 equipment_id | unique_identifier_type |   value    | notes | date_created | date_modified 
--------------+------------------------+------------+-------+--------------+---------------
         3523 | MIN                    | 3125469553 |       | 2009-06-05   | 
(1 row)

csctoss=# select * from unique_identifier where equipment_id = 3523;
 equipment_id | unique_identifier_type |    value    | notes | date_created | date_modified 
--------------+------------------------+-------------+-------+--------------+---------------
         3523 | ESN DEC                | 24601360554 |       | 2009-06-05   | 
         3523 | ESN HEX                | F614C2AA    |       | 2009-06-05   | 
         3523 | MAC ADDRESS            | 0DA654      |       | 2010-03-29   | 
         3523 | MDN                    | 3123765540  |       | 2009-06-05   | 
         3523 | MIN                    | 3125469553  |       | 2009-06-05   | 
         3523 | SERIAL NUMBER          | 640546      |       | 2009-07-29   | 
(6 rows)



csctoss=# BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

select * from ops_api_user_suspend('F614C2AA','3125469553@uscc.net');

select * from usergroup where username = '3125469553@uscc.net'




The problem is that there were 72 usernames with the suffix of '@cn01.sprintpcs.com' as well as with the suffix '@uscc.net'.  I modified the application ops_api_user_suspend to retrieve the correct username (the one with the suffix '@uscc.net'.  Here is the code:

~~~ sql
  SELECT unam.username INTO var_username
  FROM username unam
  WHERE 1 = 1
  AND username ~ '@'
  AND username NOT LIKE '%cn01.%'
  AND substr(username, 1, strpos(username, '@') - 1) = var_mdn;

~~~

This will ensure that none of the usernames with suffix of '@cn01.sprintpcs.com' will be selected.  
~~~ sql
csctoss=# BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_user_suspend('F614C2AA','3125469553@uscc.net');
NOTICE:  var_username: 3125469553@uscc.net
 result_code | error_message 
-------------+---------------
 t           | 
(1 row)

csctoss=# select * from usergroup where username like '3125469553%';
   id   |           username            |      groupname      | priority 
--------+-------------------------------+---------------------+----------
  76560 | 3125469553@cn01.sprintpcs.com | SERVICE-private_atm |    50000
 112609 | 3125469553@uscc.net           | userdisconnected    |        1
  43559 | 3125469553@uscc.net           | SERVICE-private_atm |    50000
(3 rows)

csctoss=# ROLLBACK;
ROLLBACK

~~~

This shows the process for ops_api_user_suspend() will work in the production environment.

I will set up a test for the ops_api_user_restore() function and test
