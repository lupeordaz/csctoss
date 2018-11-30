--
-- PostgreSQL database dump
--

-- Dumped from database version 8.0.14

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
-- Name: ops_api_retval; Type: TYPE; Schema: csctoss; Owner: csctoss_owner
--

CREATE TYPE ops_api_retval AS (
	result_code boolean,
	error_message text
);

ALTER TYPE ops_api_retval OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

