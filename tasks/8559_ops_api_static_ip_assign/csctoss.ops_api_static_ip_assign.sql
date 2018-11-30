--
-- PostgreSQL database dump
--

-- Dumped from database version 8.0.14
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
--SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
--SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
--SET escape_string_warning = off;
--SET row_security = off;

SET search_path = csctoss, pg_catalog;

--
-- Name: ops_api_static_ip_assign(text, text, text, integer, integer); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_api_static_ip_assign(text, text, text, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_carrier                   text := $1;
  par_vrf                       text := $2;
  par_username                  text := $3;
  par_line_id					integer := $4;
  par_billing_entity_id         integer := $5;
  var_static_ip                 text;
  var_check_if_has_range        text;
  v_numrows               		integer;

BEGIN
    SET client_min_messages TO notice;
    RAISE NOTICE 'ops_api_static_ip_assign is called: parameters => [carrier=%][vrf=%][username=%][line_id=%][billing_entity_id=%]', par_carrier, par_vrf, par_username, par_line_id, par_billing_entity_id;

	PERFORM public.set_change_log_staff_id(3);

    -- Check if the parameters are null
    IF par_carrier IS NULL
        OR par_username IS NULL
        OR par_line_id IS NULL
        OR par_billing_entity_id IS NULL
        OR par_vrf IS NULL
    THEN
        RAISE NOTICE 'All or some of the input values are null.';
        var_static_ip = 'ERROR - All or some of the input values are null.';
        RETURN var_static_ip;
    END IF;

	SELECT static_ip
	INTO var_check_if_has_range
	FROM static_ip_pool sip
	JOIN static_ip_carrier_def sid
	ON (sid.carrier_def_id = sip.carrier_id)
	WHERE groupname = par_vrf
	AND carrier LIKE '%'||par_carrier||'%'
	AND billing_entity_id = par_billing_entity_id
	--AND static_ip not like '166.%'
	ORDER BY billing_entity_id
	LIMIT 1;

    IF FOUND THEN
        RAISE NOTICE 'We found IP pool.';
        SELECT static_ip
          INTO var_static_ip
          FROM static_ip_pool sip
          JOIN static_ip_carrier_def sid
            ON (sid.carrier_def_id = sip.carrier_id)
         WHERE groupname = par_vrf
           AND is_assigned = FALSE
           AND carrier LIKE '%'||par_carrier||'%'
           AND billing_entity_id = par_billing_entity_id
         ORDER BY billing_entity_id , static_ip
         LIMIT 1
           FOR UPDATE;

        IF FOUND THEN
			RAISE NOTICE 'We found an available IP address in the IP pool. [IP=%]', var_static_ip;
			IF ( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

	        	RAISE NOTICE 'Processing radreply: Username: %, static_ip: %.', par_username, var_static_ip;
				--Insert Framed IP Address to rad_reply
				IF (select true from radreply where attribute = 'Framed-IP-Address' and username = par_username) THEN
			        var_static_ip = 'ERROR - Framed-IP INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
					              VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Framed-IP INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Framed-IP attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;
			ELSE 
				--Insert into rad_reply Class
				IF (select true from radreply where attribute = 'Class' and username = par_username) THEN
			        var_static_ip = 'ERROR - Class INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
								VALUES (par_username, 'Class', '=', par_line_id::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Class INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Class attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;

				--Insert into rad_reply Framed-IP-Address
				IF (select true from radreply where attribute = 'Framed-IP-Address' and username = par_username) THEN
			        var_static_ip = 'ERROR - Framed-IP INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
					 			VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Framed-IP INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;
            END IF; 

            RAISE NOTICE 'Updating static_ip_pool table for [IP=% / VRF=%]', var_static_ip, par_vrf;
			--Update static_ip_pool
			UPDATE static_ip_pool
			   SET is_assigned = 'TRUE'
                  ,line_id = par_line_id
			 WHERE static_ip = var_static_ip
  			   AND groupname = par_vrf;

            IF NOT FOUND THEN
            RAISE EXCEPTION 'OSS: Radreply Update Failed.';
                var_static_ip = 'ERROR - OSS: Radreply Update Failed.';
                RETURN var_static_ip;
			ELSE
			   RETURN var_static_ip;
            END IF;
	    ELSE
			RAISE EXCEPTION 'OSS: No avalible static IPs for ip block selected';
            var_static_ip = 'ERROR - OSS: No avalible static IPs for ip block selected.';
            RETURN var_static_ip;
		END IF;

	ELSE
        RAISE NOTICE 'No billing entity id path selected.';
		SELECT static_ip
		INTO var_static_ip
		FROM static_ip_pool sip
		JOIN static_ip_carrier_def sid
		 ON (sid.carrier_def_id = sip.carrier_id)
		WHERE groupname = par_vrf
		AND is_assigned = FALSE
		AND carrier LIKE '%'||par_carrier||'%'
		AND billing_entity_id is null
		ORDER BY static_ip
		LIMIT 1
		FOR UPDATE;

        IF FOUND THEN
			IF( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN
	        	RAISE NOTICE 'Processing radreply: Username: %, static_ip: %.', par_username, var_static_ip;
				--Insert Framed IP Address to rad_reply
				IF (select true from radreply where attribute = 'Framed-IP-Address' and username = par_username) THEN
			        var_static_ip = 'ERROR - Framed-IP INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
					              VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Framed-IP INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Framed-IP attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;
            ELSE 
				--Insert into rad_reply Class
				IF (select true from radreply where attribute = 'Class' and username = par_username) THEN
			        var_static_ip = 'ERROR - Class INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
								VALUES (par_username, 'Class', '=', par_line_id::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Class INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Class attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;

				--Insert into rad_reply Framed-IP-Address
				IF (select true from radreply where attribute = 'Framed-IP-Address' and username = par_username) THEN
			        var_static_ip = 'ERROR - Framed-IP INSERT Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
			        RETURN var_static_ip;
			    ELSE
					INSERT INTO radreply (username, attribute, op, value, priority)
					 			VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
					GET DIAGNOSTICS v_numrows = ROW_COUNT;
		    		IF v_numrows <> 1 then
			        	var_static_ip = 'ERROR - Framed-IP INSERT 2 Failed: username: '|| par_username || ', var_static_ip: '|| var_static_ip ||'.';
				        RETURN var_static_ip;
				    ELSE
				    	RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
				    END IF;
				END IF;
                       
            END IF; 
			--Update static_ip_pool
			RAISE NOTICE 'Update static_ip_pool for static_ip %: line_id - %, groupname - %', var_static_ip, par_line_id, par_vrf;
			UPDATE static_ip_pool
			 SET is_assigned = 'TRUE' ,
                         line_id = par_line_id
			WHERE static_ip = var_static_ip
			AND groupname = par_vrf;

            IF NOT FOUND THEN
                RAISE NOTICE 'OSS: Radreply Update Failed.';
                var_static_ip = 'ERROR:  OSS: Radreply Update Failed.';
                RETURN var_static_ip;
			ELSE
				RETURN var_static_ip;
            END IF;

		ELSE
			RAISE NOTICE 'Check for a valid range for par_vrf %, carrier %', par_vrf, par_carrier;
			--check input paramiters for a valid range
			SELECT static_ip
			INTO var_static_ip
			FROM static_ip_pool sip
			JOIN static_ip_carrier_def sid
			 ON (sid.carrier_def_id = sip.carrier_id)
			WHERE groupname = par_vrf
			AND carrier LIKE '%'||par_carrier||'%'
			AND billing_entity_id is null
			--AND static_ip NOT LIKE '166.%'
			ORDER BY static_ip
			LIMIT 1;

			RAISE NOTICE 'var_static_ip:  %', var_static_ip;
			IF (var_static_ip IS NOT NULL) THEN
                RAISE NOTICE 'OSS: No avalible static ips for ip block selected';
                var_static_ip = 'ERROR:  OSS: No avalible static ips for ip block selected.';
                RETURN var_static_ip;
			ELSE
                RAISE NOTICE 'OSS: No IP Block For given VRF/CARRIER combination.';
                var_static_ip = 'ERROR:  OSS: No IP Block For given VRF/CARRIER combination.';
                RETURN var_static_ip;
			END IF;
		END IF;
	END IF;
END;
$_$;


ALTER FUNCTION csctoss.ops_api_static_ip_assign(text, text, text, integer, integer) OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

