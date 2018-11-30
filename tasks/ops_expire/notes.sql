

ops_api_expire_ex()



A100001578C862


 equipment_id 
--------------
        41630
(1 row)

csctoss=# \e
 line_id 
---------
   46669
(1 row)

        radius_username         
--------------------------------
 5662086739@tsp17.sprintpcs.com
(1 row)





csctoss=# select * from ops_api_expire_ex('A100001578C862');
 result_code |             error_message              
-------------+----------------------------------------
 f           | Exception: Unknown exception happened.
(1 row)

csctoss=# SELECT TRUE FROM radreply WHERE username LIKE '5662086739@tsp17.sprintpcs.com';
 bool 
------
 t
(1 row)

csctoss=# SELECT * FROM radreply WHERE username LIKE '5662086739@tsp17.sprintpcs.com';
  id   |            username            | attribute | op | value | priority 
-------+--------------------------------+-----------+----+-------+----------
 81714 | 5662086739@tsp17.sprintpcs.com | Class     | =  | 46669 |       10
(1 row)

csctoss=# SELECT value INTO var_static_ip
csctoss-#     FROM radreply
csctoss-#     WHERE username = var_username
csctoss-#     A;
ERROR:  syntax error at or near "A" at character 89
LINE 4:     A;
            ^
csctoss=# \e
 value 
-------
(0 rows)


