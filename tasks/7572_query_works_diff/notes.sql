[gordaz@cctlix03 7572_query_works_diff]$ eqid
--------------------------------------------
-                                          -
-     Unique Identifier Types:             -
-        1.  Serial Number                 -
-        2.  ESN HEX                       -
-        3.  MAC                           -
-                                          -
--------------------------------------------
 
Enter the unique identifier type: 
1
 
Enter the unique identifier value: 
927226
--------------------------------------------
|                                           
|  Line Id:       42537                   
|  Equipment Id:  40823                  
|  Username:      4048315831@vzw3g.com                 
|  Mac Address:   00804411FFD6                      
|  Serial Number: 927226                 
|  ESN Hex:       A1000012C00286                   
|                                           
--------------------------------------------

--

SELECT username
      ,nasipaddress
      ,acctstarttime
      ,acctinputoctets + acctoutputoctets AS total_octets
      ,callingstationid
      ,framedipaddress AS url
      ,acctsessionid
  FROM csctlog.master_radacct
 WHERE acctstoptime IS NULL
   AND acctstarttime > current_date - 1
   AND username = '4048315831@vzw3g.com'
 ORDER BY username, acctstarttime DESC;

       username       | nasipaddress |     acctstarttime      | total_octets | callingstationid |     url     | acctsessionid 
----------------------+--------------+------------------------+--------------+------------------+-------------+---------------
 4048315831@vzw3g.com | 10.210.230.9 | 2018-07-27 14:18:49+00 |            0 | 311284049796004  | 10.81.22.87 | 218C49CA
(1 row)
