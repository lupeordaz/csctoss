CREATE TABLE equipment_credential
(
  equipment_credential_id serial NOT NULL,
  equipment_id integer NOT NULL,
  credential_set smallint NOT NULL,
  preferred_set boolean NOT NULL DEFAULT false,
  username text,
  password text,

  CONSTRAINT equipment_credential_equipment_id_fk FOREIGN KEY (equipment_id)
      REFERENCES equipment (equipment_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

WITHOUT OIDS;
ALTER TABLE equipment_credential
  OWNER TO csctoss_owner;

GRANT ALL ON TABLE equipment_credential TO csctoss_owner;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE equipment_credential TO password_reset;
COMMENT ON TABLE equipment_credential
  IS 'Stores device credentials for remote login.';
