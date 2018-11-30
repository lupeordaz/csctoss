-- Function: oss.check_if_last_device_to_prov_on_so(text)

-- DROP FUNCTION oss.check_if_last_device_to_prov_on_so(text);

CREATE OR REPLACE FUNCTION oss.check_if_last_device_to_prov_on_so(text)
  RETURNS boolean AS
$BODY$
DECLARE

  par_so_number              text := $1;
  var_results               boolean;
  

BEGIN
 select 
	sl.qnt <= ss.qnt as last_item
	INTO var_results
	FROM 
	(
		SELECT 
		 ol.quantity::bigint qnt
		FROM 
		 order_line ol
		JOIN purchase_order po ON ol.order_id = po.id 
		JOIN item i ON ol.item_id = i.id
		JOIN item_type_map im ON im.item_id = i.id
		--JOIN item_type it ON im.type_id = it.id
		WHERE public_number = par_so_number
		AND im.type_id = 300

	) sl
	, 
	(
		SELECT 
		count(*) as qnt 
		FROM 
		 prov_line pl 
		JOIN purchase_order po 
		ON pl.order_id = po.id 
		WHERE public_number = par_so_number
	) ss;
	
  IF (var_results) THEN 
    RETURN TRUE;	
  ELSE 
	RETURN FALSE;
  END IF;

END ;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION oss.check_if_last_device_to_prov_on_so(text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_if_last_device_to_prov_on_so(text) TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_if_last_device_to_prov_on_so(text) TO public;
GRANT EXECUTE ON FUNCTION oss.check_if_last_device_to_prov_on_so(text) TO jbilling;
