--
-- PostgreSQL database dump
--

-- Dumped from database version 8.0.14
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

SET search_path = csctoss, pg_catalog;

--
-- Name: portal_active_lines_vw; Type: VIEW; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE VIEW portal_active_lines_vw AS
SELECT line.line_id
      ,(line.start_date)::date AS line_start_date
      ,(line.end_date)::date AS line_end_date
      ,line.radius_username
      ,em.model_number1 AS equipment_model_number
      ,em.carrier AS equipment_carrier
      , em.make AS equipment_maker
      , em.vendor AS equipment_vendor
      , prd.product_code
      , plan."comment" AS sales_order_number
      , (SELECT unique_identifier.value 
      	   FROM unique_identifier 
      	  WHERE ((unique_identifier.unique_identifier_type = 'ESN HEX'::text) 
      	  	AND (unique_identifier.equipment_id = lieq.equipment_id))) AS esn_hex
      , (SELECT unique_identifier.value 
      	   FROM unique_identifier 
      	  WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) 
      	  	AND (unique_identifier.equipment_id = lieq.equipment_id))) AS serial_number
      , liloc."owner" AS location_owner
      , liloc.id AS location_id
      , liloc.address AS location_address
      , liloc.name AS location_name
      , liloc.processor AS location_processor
      , (SELECT soup_cellsignal.cellsignal 
      	   FROM soup_cellsignal 
      	  WHERE ((soup_cellsignal.esn1 = (SELECT unique_identifier.value 
      	  	                                FROM unique_identifier 
      	  	                               WHERE (   (unique_identifier.unique_identifier_type = 'ESN HEX'::text) 
      	  	                               	     AND (unique_identifier.equipment_id = lieq.equipment_id)
      	  	                               	     )
      	  	                              )
      	         ) OR (soup_cellsignal.esn2 = (SELECT unique_identifier.value 
      	         	                            FROM unique_identifier 
      	         	                           WHERE (   (unique_identifier.unique_identifier_type = 'ESN HEX'::text) 
      	         	                           	     AND (unique_identifier.equipment_id = lieq.equipment_id)
      	         	                           	     )
      	         	                           )
      	              )
      	        ) ORDER BY soup_cellsignal."timestamp" DESC LIMIT 1) AS cellsignal
      , CASE WHEN (line.radius_username IS NOT NULL) 
                  THEN (COALESCE((SELECT radreply.value 
                  	                FROM radreply 
                  	               WHERE (((radreply.attribute)::text = 'Framed-IP-Address'::text) 
                  	               	     AND ((radreply.username)::text = line.radius_username)
                  	               	     )
                  	             ), ('N/A'::text)::character varying)
                       )::text 
                  ELSE 'IP Not Avalible'::text 
             END AS static_ip_address
      , be.name
      , (SELECT ops_get_connection_status.ops_get_connection_status FROM ops_get_connection_status(line.radius_username)) AS connection_status
      , COALESCE((SELECT (max(master_radacct.acctstarttime))::text AS max FROM master_radacct WHERE ((master_radacct.username)::text = line.radius_username) GROUP BY master_radacct.username), 'No connections in last 3 months'::text) AS last_connected_timestamp
      , (SELECT soup_device_stats_table.firmware 
      	   FROM soup_device_stats_table 
      	  WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value 
      	  	                                                FROM unique_identifier 
      	  	                                               WHERE (    (unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) 
      	  	                                               	      AND (unique_identifier.equipment_id = lieq.equipment_id)
      	  	                                               	      )
      	  	                                               )
      	  ) ORDER BY soup_device_stats_table.datetime DESC LIMIT 1) AS firmware_version

      , (ew.warranty_start_date)::date AS warranty_start_date
      , (ew.warranty_end_date)::date AS warranty_end_date
      , CASE WHEN ((ew.warranty_end_date)::date >= ('now'::text)::date) THEN 'In warranty'::text ELSE 'Out of warranty'::text END AS warranty_status
      
      , sci.config_name AS soup_config_name

      , (SELECT CASE WHEN ((SELECT count(*) AS count FROM master_radacct WHERE ((master_radacct.username)::text = line.radius_username)) = 0) THEN 'NO'::text ELSE CASE WHEN ((SELECT count(*) AS count FROM master_radacct mrad WHERE (((((mrad.username)::text = line.radius_username) AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval))) AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max FROM master_radacct mrad2 WHERE ((mrad2.username)::text = (mrad.username)::text)))) AND (mrad.acctstoptime IS NULL))) = 1) THEN 'YES'::text ELSE 'NO'::text END END AS "case") AS is_connected, (SELECT ops_get_config_status.ops_get_config_status FROM ops_get_config_status(sci.config_name)) AS config_status, (SELECT ops_get_firmware_status.ops_get_firmware_status FROM ops_get_firmware_status((SELECT soup_device_stats_table.firmware FROM soup_device_stats_table WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AND (unique_identifier.equipment_id = lieq.equipment_id)))) ORDER BY soup_device_stats_table.datetime DESC LIMIT 1))) AS firmware_status, be.billing_entity_id, be.parent_billing_entity_id FROM ((((((((((line JOIN billing_entity be ON ((line.billing_entity_id = be.billing_entity_id))) LEFT JOIN plan ON ((line.line_id = plan.line_id))) LEFT JOIN product prd ON ((plan.product_id = prd.product_id))) LEFT JOIN line_equipment lieq ON ((line.line_id = lieq.line_id))) LEFT JOIN equipment eq ON ((lieq.equipment_id = eq.equipment_id))) LEFT JOIN equipment_model em ON ((eq.equipment_model_id = em.equipment_model_id))) LEFT JOIN location_labels liloc ON ((line.line_id = liloc.line_id))) LEFT JOIN usergroup ug ON ((((ug.username)::text = line.radius_username) AND ((ug.groupname)::text = 'userdisconnected'::text)))) LEFT JOIN equipment_warranty ew ON ((eq.equipment_id = ew.equipment_id))) LEFT JOIN soup_config_info sci ON ((sci.equipment_id = eq.equipment_id))) WHERE ((((1 = 1) AND (lieq.end_date IS NULL)) AND (line.end_date IS NULL)) AND (line.radius_username IS NOT NULL));


ALTER TABLE portal_active_lines_vw OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

