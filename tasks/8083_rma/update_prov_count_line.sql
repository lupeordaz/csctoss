-- Function: oss.update_prov_count_line(text)

-- DROP FUNCTION oss.update_prov_count_line(text);

CREATE OR REPLACE FUNCTION oss.update_prov_count_line(text)
  RETURNS boolean AS
$BODY$
DECLARE

  par_so_number              text := $1;
  var_results_count          bigint; 
  var_results_order_id          bigint;   
  
BEGIN
		SELECT 
			count(*)
		INTO var_results_count
		FROM
		prov_line pl 
		JOIN purchase_order po 
		ON pl.order_id =  po.id 
		WHERE public_number = par_so_number;
		
		SELECT 
		 ol.order_id::bigint
		INTO var_results_order_id
		FROM order_line ol
		JOIN purchase_order po ON ol.order_id = po.id 
		JOIN item i ON ol.item_id = i.id
		JOIN item_type_map im ON im.item_id = i.id
		WHERE po.public_number = par_so_number
		AND im.type_id = 300;
		
		IF FOUND THEN
			UPDATE 
			    order_line ol
			SET
			     provisioning_count=var_results_count
			WHERE ol.order_id = var_results_order_id
			AND ol.item_id > 10;
		ELSE
			RAISE EXCEPTION 'JBILLING: Error Updataing Prov Count';	
		END IF;
		
		RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION oss.update_prov_count_line(text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.update_prov_count_line(text) TO postgres;
GRANT EXECUTE ON FUNCTION oss.update_prov_count_line(text) TO public;
GRANT EXECUTE ON FUNCTION oss.update_prov_count_line(text) TO jbilling;
