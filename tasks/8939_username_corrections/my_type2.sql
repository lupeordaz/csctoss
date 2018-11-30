--
-- PostgreSQL database dump
--
-- Dumped from database version 8.0.14

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;
SET search_path = csctoss, pg_catalog;

--
-- Name: my_type1; Type: TYPE; Schema: csctoss; Owner: csctoss_owner
--

CREATE TYPE my_type2 AS (
	upd_equip_id		int,
	correct_min     	text,
	exist_min       	text,
	related_equip_id	int,
	related_min 		text
);

ALTER TYPE my_type1 OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

