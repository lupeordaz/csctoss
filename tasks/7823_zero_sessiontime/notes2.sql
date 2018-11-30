-- Query for all records (Sprint, USCC , voda and VZW)
Select *
From master_radacct
Where acctsessiontime = '0'
And acctstarttime >= '2018-06-01'
Order by master_radacctid DESC;
 
-- Query for just VZW records
 
Select *
From master_radacct
Where acctsessiontime = '0'
And username like '%vzw3g.com'
AND acctstoptime is NOT NULL
And acctstarttime >= '2018-06-01'
Order by master_radacctid DESC;



select username
      ,framedipaddress
      ,source_hostname
      ,acctstarttime
      ,acctstoptime
      ,acctauthentic
      ,acctterminatecause
  from master_radacct
 where acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-06-01'
 order by username, framedipaddress;
            username            | framedipaddress |     acctstarttime      |      acctstoptime      | acctauthentic | acctterminatecause 
--------------------------------+-----------------+------------------------+------------------------+---------------+--------------------
 2123350476@tsp17.sprintpcs.com | 10.47.217.171   | 2018-06-17 06:57:13+00 | 2018-06-17 06:57:12+00 | RADIUS        | NAS-Error
 2123350476@tsp17.sprintpcs.com | 10.47.218.149   | 2018-06-17 06:57:28+00 | 2018-06-17 06:57:28+00 | RADIUS        | NAS-Error
 2123350476@tsp17.sprintpcs.com | 10.47.219.69    | 2018-06-17 07:01:41+00 | 2018-06-17 07:01:41+00 | RADIUS        | NAS-Error
 2123900637@tsp17.sprintpcs.com | 10.47.209.89    | 2018-06-17 07:02:18+00 | 2018-06-17 07:02:17+00 | RADIUS        | NAS-Error
 2123900637@tsp17.sprintpcs.com | 10.47.211.9     | 2018-06-17 06:59:19+00 | 2018-06-17 06:59:19+00 | RADIUS        | NAS-Error
 2123900637@tsp17.sprintpcs.com | 10.47.217.11    | 2018-06-17 07:03:15+00 | 2018-06-17 07:03:15+00 | RADIUS        | NAS-Error
 2123900637@tsp17.sprintpcs.com | 10.47.221.251   | 2018-06-17 07:00:15+00 | 2018-06-17 07:00:15+00 | RADIUS        | NAS-Error
.
.
.


select count(*) from (
select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
      ,acctauthentic
      ,acctterminatecause
  from master_radacct
 where acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-06-01'
 order by username, framedipaddress) as total;
 count 
-------
 29424
(1 row)

-- master radacct copy
SELECT mr.username
      ,mr.framedipaddress
      ,mr.acctstarttime
      ,mr.acctstoptime
      ,mr.acctsessiontime
      ,mr.acctinputoctets
      ,mr.acctoutputoctets
  FROM master_radacct mr
 INNER JOIN 
      (select username, max(acctstarttime) as acctstarttime
         from master_radacct
        group by username
        order by username) mr2  
    on mr.username = mr2.username and mr.acctstarttime = mr2.acctstarttime 
WHERE mr.username IN
(
);



'3122174108@cn01.sprintpcs.com',
'3122179597@cn01.sprintpcs.com',
'3123886739@cn01.sprintpcs.com',
'3123887029@cn01.sprintpcs.com',
'3123887084@cn01.sprintpcs.com',
'3123887422@cn01.sprintpcs.com',
'3123887802@cn01.sprintpcs.com',
'3123888436@cn01.sprintpcs.com',
'3123888648@cn01.sprintpcs.com',
'3123888740@cn01.sprintpcs.com',
'3123889072@cn01.sprintpcs.com',
'3124370972@cn01.sprintpcs.com',
'3124371175@cn01.sprintpcs.com',
'3124371363@cn01.sprintpcs.com',
'3124372148@cn01.sprintpcs.com',
'3124372215@cn01.sprintpcs.com',
'3124372252@cn01.sprintpcs.com',
'3124372487@cn01.sprintpcs.com',
'3124373178@cn01.sprintpcs.com',
'3124373593@cn01.sprintpcs.com',
'3124373633@cn01.sprintpcs.com',
'3124373674@cn01.sprintpcs.com',
'3124373744@cn01.sprintpcs.com',
'3124374045@cn01.sprintpcs.com',
'3124374085@cn01.sprintpcs.com',
'3124374757@cn01.sprintpcs.com',
'3124375163@cn01.sprintpcs.com',
'3124375543@cn01.sprintpcs.com',
'3124375642@cn01.sprintpcs.com',
'3124375736@cn01.sprintpcs.com',
'3124375923@cn01.sprintpcs.com',
'3124376098@cn01.sprintpcs.com',
'3124376336@cn01.sprintpcs.com',
'3124376723@cn01.sprintpcs.com',
'3124376809@cn01.sprintpcs.com',
'3124376882@cn01.sprintpcs.com',
'3124377268@cn01.sprintpcs.com',
'3124377284@cn01.sprintpcs.com',
'3124377370@cn01.sprintpcs.com',
'3124377537@cn01.sprintpcs.com',
'3124377745@cn01.sprintpcs.com',
'3124377786@cn01.sprintpcs.com',
'3124377819@cn01.sprintpcs.com',
'3124378034@cn01.sprintpcs.com',
'3124378312@cn01.sprintpcs.com',
'3124378366@cn01.sprintpcs.com',
'3124378544@cn01.sprintpcs.com',
'3124378693@cn01.sprintpcs.com',
'3125461118@cn01.sprintpcs.com',
'3125461480@cn01.sprintpcs.com',
'3125462547@cn01.sprintpcs.com',
'3125467314@cn01.sprintpcs.com',
'3125467328@cn01.sprintpcs.com',
'3125468102@cn01.sprintpcs.com',
'3125468788@cn01.sprintpcs.com',
'3125469319@cn01.sprintpcs.com',
'3125469581@cn01.sprintpcs.com',
'3125469806@cn01.sprintpcs.com',
'3126711312@cn01.sprintpcs.com',
'3126711629@cn01.sprintpcs.com',
'3126711780@cn01.sprintpcs.com',
'3126711866@cn01.sprintpcs.com',
'3126712154@cn01.sprintpcs.com',
'3126712282@cn01.sprintpcs.com',
'3126712551@cn01.sprintpcs.com',
'3126712750@cn01.sprintpcs.com',
'3128545518@cn01.sprintpcs.com',
'3128545627@cn01.sprintpcs.com',
'3129961752@cn01.sprintpcs.com',
'3129964227@cn01.sprintpcs.com',
'3129964662@cn01.sprintpcs.com',
'4044165911@vzw3g.com',
'4046158249@vzw3g.com',
'4046158543@vzw3g.com',
'4048072791@vzw3g.com',
'4049718639@vzw3g.com',
'4049896593@vzw3g.com',
'4702250950@vzw3g.com',
'4702250980@vzw3g.com',
'4702494927@vzw3g.com',
'4702594466@vzw3g.com',
'4702599982@vzw3g.com',
'4702703004@vzw3g.com',
'4704231508@vzw3g.com',
'4704231511@vzw3g.com',
'4706062137@vzw3g.com',
'4707171328@vzw3g.com',
'4707257514@vzw3g.com',
'4707258714@vzw3g.com',
'5339384727@tsp17.sprintpcs.com',
'5449249874@tsp18.sprintpcs.com',
'5449249875@tsp17.sprintpcs.com',
'5662070072@tsp18.sprintpcs.com',
'5662070286@tsp18.sprintpcs.com',
'5662070335@tsp18.sprintpcs.com',
'5662070371@tsp17.sprintpcs.com',
'5668560726@tsp18.sprintpcs.com',
'5668561774@tsp18.sprintpcs.com',
'5668562948@tsp18.sprintpcs.com',
'5668563826@tsp17.sprintpcs.com',
'5668564106@tsp18.sprintpcs.com',
'9172045161@tsp17.sprintpcs.com',
'9173514444@tsp18.sprintpcs.com',


select username
      ,framedipaddress
      ,acctstarttime
      ,acctstoptime
      ,acctauthentic
      ,acctterminatecause
  from master_radacct
 where acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-06-01'
 order by username, framedipaddress;

SELECT count(*)
  FROM master_radacct
 WHERE acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-06-01';

DELETE from master_radacct
 where acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-06-01'



csctmon=> select substring(username,11) as carrier, count(*) 
  from master_radacct
 where acctsessiontime = '0'
   and acctstoptime is not null
   and acctstarttime >= '2018-07-01'
 group by carrier
 order by carrier;
       carrier        | count 
----------------------+-------
 @cn01.sprintpcs.com  |  8685
 @tsp17.sprintpcs.com |   467
 @tsp18.sprintpcs.com |   167
 @vzw3g.com           |  7194
(4 rows)

