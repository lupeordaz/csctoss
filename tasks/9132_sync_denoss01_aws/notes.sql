csctoss=# \i ../types/csctoss.ops_api_retval.sql 
SET
SET
SET
SET
SET
CREATE TYPE
ALTER TYPE
csctoss=# \df ops_api_activate
                                                       List of functions
 Schema  |       Name       |       Result data type        |                   Argument data types                   |  Type  
---------+------------------+-------------------------------+---------------------------------------------------------+--------
 csctoss | ops_api_activate | SETOF ops_api_activate_retval | text, text, text, text, text, text, integer, text, text | normal
(1 row)

csctoss=# DROP FUNCTION ops_api_activate(text, text, text, text, text, text, integer, text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_activate.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
COMMENT

csctoss=# \df ops_api_assign
                                                  List of functions
 Schema  |      Name      |      Result data type       |                Argument data types                |  Type  
---------+----------------+-----------------------------+---------------------------------------------------+--------
 csctoss | ops_api_assign | SETOF ops_api_assign_retval | text, text, integer, text, boolean                | normal
 csctoss | ops_api_assign | SETOF ops_api_assign_retval | text, text, integer, text, boolean, text          | normal
 csctoss | ops_api_assign | SETOF ops_api_assign_retval | text, text, integer, text, boolean, text, boolean | normal
(3 rows)

csctoss=# DROP FUNCTION ops_api_assign(text, text, integer, text, boolean);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_assign(text, text, integer, text, boolean, text);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_assign(text, text, integer, text, boolean, text, boolean);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_assign.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION

csctoss=# \df ops_api_expire
                                   List of functions
 Schema  |      Name      |      Result data type       | Argument data types |  Type  
---------+----------------+-----------------------------+---------------------+--------
 csctoss | ops_api_expire | SETOF ops_api_expire_retval | text                | normal
(1 row)

csctoss=# DROP FUNCTION ops_api_expire(text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_expire.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT

csctoss=# \df ops_api_modify
                                   List of functions
 Schema  |      Name      |      Result data type       | Argument data types |  Type  
---------+----------------+-----------------------------+---------------------+--------
 csctoss | ops_api_modify | SETOF ops_api_modify_retval | text, text, text    | normal
(1 row)
csctoss=# drop function ops_api_modify(text, text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_modify.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT

csctoss=# \df ops_api_restore
                                    List of functions
 Schema  |      Name       |       Result data type       | Argument data types |  Type  
---------+-----------------+------------------------------+---------------------+--------
 csctoss | ops_api_restore | SETOF ops_api_restore_retval | text                | normal
(1 row)

csctoss=# drop function ops_api_restore(text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_restore.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT

csctoss=# \df ops_api_suspend
                                    List of functions
 Schema  |      Name       |       Result data type       | Argument data types |  Type  
---------+-----------------+------------------------------+---------------------+--------
 csctoss | ops_api_suspend | SETOF ops_api_suspend_retval | text                | normal
(1 row)

csctoss=# drop function ops_api_suspend(text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_suspend.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=# 



csctoss=# \df ops_api_user_restore 
                                      List of functions
 Schema  |         Name         |       Result data type       | Argument data types |  Type  
---------+----------------------+------------------------------+---------------------+--------
 csctoss | ops_api_user_restore | SETOF ops_api_restore_retval | text                | normal
 csctoss | ops_api_user_restore | SETOF ops_api_restore_retval | text, text          | normal
(2 rows)

csctoss=# DROP FUNCTION ops_api_user_restore (text);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_user_restore (text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_user_restore.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=# \df ops_api_restore
                                    List of functions
 Schema  |      Name       |       Result data type       | Argument data types |  Type  
---------+-----------------+------------------------------+---------------------+--------
 csctoss | ops_api_restore | SETOF ops_api_restore_retval | text                | normal
(1 row)

csctoss=# drop function ops_api_restore(text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_restore.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=# 

csctoss=# \df ops_api_suspend
                                    List of functions
 Schema  |      Name       |       Result data type       | Argument data types |  Type  
---------+-----------------+------------------------------+---------------------+--------
 csctoss | ops_api_suspend | SETOF ops_api_suspend_retval | text                | normal
(1 row)

csctoss=# drop function ops_api_suspend(text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_suspend.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=#

csctoss=# \df ops_change_static_ip
                                      List of functions
 Schema  |         Name         |      Result data type       | Argument data types |  Type  
---------+----------------------+-----------------------------+---------------------+--------
 csctoss | ops_change_static_ip | ops_change_static_ip_retval | integer, text, text | normal
(1 row)

csctoss=# drop function ops_change_static_ip(integer, text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_change_static_ip.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
csctoss=#



csctoss=# \df ops_api_user_suspend
                                      List of functions
 Schema  |         Name         |       Result data type       | Argument data types |  Type  
---------+----------------------+------------------------------+---------------------+--------
 csctoss | ops_api_user_suspend | SETOF ops_api_suspend_retval | text                | normal
 csctoss | ops_api_user_suspend | SETOF ops_api_suspend_retval | text, text          | normal
(2 rows)

csctoss=# DROP FUNCTION ops_api_user_suspend (text);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_user_suspend (text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_user_suspend.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT

csctoss=# \df ops_change_static_ip
                                      List of functions
 Schema  |         Name         |      Result data type       | Argument data types |  Type  
---------+----------------------+-----------------------------+---------------------+--------
 csctoss | ops_change_static_ip | ops_change_static_ip_retval | integer, text, text | normal
(1 row)

csctoss=# drop function ops_change_static_ip(integer, text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_change_static_ip.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION

csctoss=# \df update_unique_identifier_value 
                                                      List of functions
 Schema  |              Name              |              Result data type               |    Argument data types    |  Type  
---------+--------------------------------+---------------------------------------------+---------------------------+--------
 csctoss | update_unique_identifier_value | SETOF update_unique_identifier_value_retval | integer, text, text, text | normal
(1 row)

csctoss=# drop function update_unique_identifier_value (integer, text, text, text);
DROP FUNCTION
csctoss=# \i csctoss.update_unique_identifier_value.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
COMMENT
REVOKE
REVOKE
GRANT
GRANT

csctoss=# \df ops_api_static_ip_assign
                                          List of functions
 Schema  |           Name           | Result data type |        Argument data types         |  Type  
---------+--------------------------+------------------+------------------------------------+--------
 csctoss | ops_api_static_ip_assign | text             | text, text, text, integer, integer | normal
(1 row)

csctoss=# drop function ops_api_static_ip_assign (text, text, text, integer, integer);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_static_ip_assign.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION

csctoss=# \df ops_api_user_restore 
                                      List of functions
 Schema  |         Name         |       Result data type       | Argument data types |  Type  
---------+----------------------+------------------------------+---------------------+--------
 csctoss | ops_api_user_restore | SETOF ops_api_restore_retval | text                | normal
 csctoss | ops_api_user_restore | SETOF ops_api_restore_retval | text, text          | normal
(2 rows)

csctoss=# DROP FUNCTION ops_api_user_restore (text);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_user_restore (text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_user_restore.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=# \df ops_api_user_suspend
                                      List of functions
 Schema  |         Name         |       Result data type       | Argument data types |  Type  
---------+----------------------+------------------------------+---------------------+--------
 csctoss | ops_api_user_suspend | SETOF ops_api_suspend_retval | text                | normal
 csctoss | ops_api_user_suspend | SETOF ops_api_suspend_retval | text, text          | normal
(2 rows)

csctoss=# DROP FUNCTION ops_api_user_suspend (text);
DROP FUNCTION
csctoss=# DROP FUNCTION ops_api_user_suspend (text, text);
DROP FUNCTION
csctoss=# \i csctoss.ops_api_user_suspend.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT

csctoss=# \df ops_get_firmware_status 
                                  List of functions
 Schema  |          Name           | Result data type | Argument data types |  Type  
---------+-------------------------+------------------+---------------------+--------
 csctoss | ops_get_firmware_status | text             | text                | normal
(1 row)

csctoss=# \i csctoss.ops_get_firmware_status.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION

csctoss=# \df rma_device_info 
                                    List of functions
 Schema  |      Name       |       Result data type       | Argument data types |  Type  
---------+-----------------+------------------------------+---------------------+--------
 csctoss | rma_device_info | SETOF rma_device_info_retval | text                | normal
(1 row)

csctoss=# drop function rma_device_info (text);
DROP FUNCTION
csctoss=# \i csctoss.rma_device_info.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
csctoss=# \df rt_oss_rma
                           List of functions
 Schema  |    Name    | Result data type | Argument data types |  Type  
---------+------------+------------------+---------------------+--------
 csctoss | rt_oss_rma | oss_rma_retval   | text, text, text    | normal
(1 row)

csctoss=# \i csctoss.rt_oss_rma.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
CREATE FUNCTION
ALTER FUNCTION
REVOKE
REVOKE
GRANT
GRANT
GRANT
csctoss=# \i csctoss.static_ip_radreply_sync.sql 
SET
SET
SET
SET
SET
CREATE FUNCTION
ALTER FUNCTION
