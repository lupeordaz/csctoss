--
-- PostgreSQL database dump
--

-- Dumped from database version 8.0.14
-- Dumped by pg_dump version 9.6.6
-- DROP TYPE unique_id_retval;

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
-- Name: unique_id_retval; Type: TYPE; Schema: csctoss; Owner: csctoss_owner
--

CREATE TYPE unique_id_retval AS (
	line_id      			integer,                                                   
    equipment_id			integer,
    radius_username			text,
    uim_value				text,
    uis_value				text,
    uie_value				text,
	message 				text
);

ALTER TYPE unique_id_retval OWNER TO csctoss_owner;

