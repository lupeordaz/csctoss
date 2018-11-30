CREATE TABLE sec_apps
(
  app_name character varying(128) NOT NULL,
  app_type character varying(255),
  description character varying(255),
  CONSTRAINT sec_apps_pkey PRIMARY KEY (app_name)
)
WITH 
  OIDS = FALSE
  ;
ALTER TABLE sec_apps
  OWNER TO csctoss_owner;
