-- Function: oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer)

-- DROP FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer);

CREATE OR REPLACE FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer)
  RETURNS boolean AS
$BODY$
DECLARE

  par_esn_hex                  text := $1;
  par_sn                       text := $2;
  par_username                 text := $3;
  par_line_id                  integer := $4;
  
  var_results_esn              boolean; 
  var_results_sn               boolean;
  var_results_username         boolean;
  var_results_line_id          boolean;
  
BEGIN
 --check esn hex
 SELECT 
 TRUE 
 INTO var_results_esn
 FROM(
     SELECT 
      esn_hex
     FROM prov_line
     WHERE end_date is null
     AND archived is null
     AND start_date is not null 
     AND acct_start_date is not null
     AND esn_hex = par_esn_hex 
    ) ss 
  LIMIT 1;
  
 --check sn
 SELECT 
 TRUE
 INTO var_results_sn 
 FROM(
     SELECT 
      sn
     FROM prov_line
     WHERE end_date is null
     AND archived is null
     AND start_date is not null 
     AND acct_start_date is not null
     AND sn = par_sn 
    ) ss 
  LIMIT 1;
 
 --check username
 SELECT 
 TRUE 
 INTO var_results_username
 FROM(
     SELECT 
      username
     FROM prov_line
     WHERE end_date is null
     AND archived is null
     AND start_date is not null 
     AND acct_start_date is not null
     AND username = par_username 
    ) ss 
  LIMIT 1;
 
--check line id 
 SELECT 
 TRUE 
 INTO var_results_line_id
 FROM(
     SELECT 
      line_id
     FROM prov_line
     WHERE end_date is null
     AND archived is null
     AND start_date is not null 
     AND acct_start_date is not null
     AND line_id = par_line_id 
    ) ss 
  LIMIT 1;
  
  
  
	
  IF (var_results_esn) THEN 
    RAISE EXCEPTION 'JBILLING: ESN already associated with an active so';	
  END IF;
  
  IF (var_results_sn) THEN 
    RAISE EXCEPTION 'JBILLING: SN already associated with an active so';		
  END IF;
  
  IF (var_results_username) THEN 
    RAISE EXCEPTION 'JBILLING: USERNAME already associated with an active so';	
  END IF;
  
  IF (var_results_line_id) THEN 
    RAISE EXCEPTION 'JBILLING: LINE ID already associated with an active so';		
  END IF;
  
  RETURN FALSE;

END ;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer) TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer) TO public;
GRANT EXECUTE ON FUNCTION oss.check_if_unique_ids_are_already_provisioned_to_an_so(text, text, text, integer) TO jbilling;
