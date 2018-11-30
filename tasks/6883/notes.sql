
A10000369E52C9

A100004394E8B4


CREATE OR REPLACE FUNCTION rma_device_info(text)
  RETURNS SETOF rma_device_info_retval AS


-- Type: rma_device_info_retval

-- DROP TYPE rma_device_info_retval;

CREATE TYPE rma_device_info_retval AS
   (model text,
    esn text,
    serial integer);
ALTER TYPE rma_device_info_retval
  OWNER TO csctoss_owner;




csctoss=# SELECT * FROM rma_device_info('352613070136233');
ERROR:  invalid input syntax for integer: "S15816"
CONTEXT:  PL/pgSQL function "rma_device_info" line 47 at assignment
csctoss=# 

csctoss=# SELECT equipment_id                              
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value = '352613070136233';
 equipment_id 
--------------
        43462
(1 row)

csctoss=# SELECT value                              
    FROM unique_identifier
    WHERE unique_identifier_type = 'SERIAL NUMBER'
    AND equipment_id = 43462;
 value  
--------
 S15816
(1 row)


csctoss=# SELECT model_number1                             
  FROM equipment e
  LEFT OUTER JOIN equipment_model em 
    ON em.equipment_model_id = e.equipment_model_id
 WHERE equipment_id = 43462;
 model_number1 
---------------
 SL-05-E2-CV1
(1 row)



  var_return.model = var_model;
  var_return.esn = par_esn_hex;
  var_return.serial = var_serial;
  RETURN NEXT var_return;
  RETURN;
  --RETURN var_return;

--

csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# DROP TYPE rma_device_info_retval CASCADE;
NOTICE:  drop cascades to function rma_device_info(text)
DROP TYPE
csctoss=# COMMIT;
COMMIT
csctoss=# 

--

\i csctoss.rma_device_info_retval.sql 
SET
SET
SET
SET
SET
SET
CREATE TYPE
ALTER TYPE
csctoss=#

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
csctoss=# SELECT * FROM rma_device_info('352613070136233');
ERROR:  invalid input syntax for integer: "S15816"
CONTEXT:  PL/pgSQL function "rma_device_info" line 27 at select into variables
csctoss=# \q

Modify rma_device_info; 

--

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
csctoss=# SELECT * FROM rma_device_info('352613070136233');
    model     |       esn       | serial 
--------------+-----------------+--------
 SL-05-E2-CV1 | 352613070136233 | S15816
(1 row)




