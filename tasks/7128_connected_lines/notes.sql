-- Task 7128













-- SN 692688:  config status does not display properly on Webportal

select * from unique_identifier where unique_identifier_type = 'SERIAL NUMBER' and value = '692688';
 equipment_id | unique_identifier_type | value  | notes | date_created | date_modified 
--------------+------------------------+--------+-------+--------------+---------------
        37033 | SERIAL NUMBER          | 692688 |       | 2014-02-05   | 
(1 row)

select * from unique_identifier where equipment_id = 37033;
 equipment_id | unique_identifier_type |    value     | notes | date_created | date_modified 
--------------+------------------------+--------------+-------+--------------+---------------
        37033 | ESN DEC                | 24601070263  |       | 2014-02-05   | 
        37033 | ESN HEX                | F61054B7     |       | 2014-02-05   | 
        37033 | MAC ADDRESS            | 0080440F0C3C |       | 2014-02-05   | 
        37033 | MDN                    | 4045489137   |       | 2014-02-05   | 
        37033 | MIN                    | 4045489137   |       | 2014-02-05   | 
        37033 | SERIAL NUMBER          | 692688       |       | 2014-02-05   | 
(6 rows)

select * from soup_config_info where equipment_id = 37033;

 config_id | message | equipment_id | config_name 
-----------+---------+--------------+-------------
(0 rows)

--

[gordaz@densoup01 processed]$ pwd

/opt/sdm/processed

[gordaz@densoup01 processed]$ ll *0F0C3C*
-rw-r--r-- 1 root root 14506 Apr 28 01:31 CFGDB_0F0C3C.bdnl.20180428_013105
-rw-r--r-- 1 root root 14491 Apr 28 15:51 CFGDB_0F0C3C.bdnl.20180428_155103
-rw-r--r-- 1 root root 14513 May 19 03:38 CFGDB_0F0C3C.bdnl.20180519_033823
-rw-r--r-- 1 root root 14498 May 30 20:40 CFGDB_0F0C3C.bdnl.20180530_204026








[gordaz@densoup01 ~]$ tail -f /opt/sdm/config.log
WARN,13B6C4,CONTOURVERSIONACFNSL1258PG1f4262018
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 67
Server: Werkzeug/0.12.1 Python/2.7.13
Date: Fri, 01 Jun 2018 17:33:21 GMT

{
  "response": "The config information was inserted correctly."
}
WARN,0F0C3C,CONTOURVERSIONACFN7310G1f4262018
HTTP/1.0 200 OK
Content-Type: application/json
Content-Length: 67
Server: Werkzeug/0.12.1 Python/2.7.13
Date: Fri, 01 Jun 2018 18:07:43 GMT

{
  "response": "The config information was inserted correctly."
}

