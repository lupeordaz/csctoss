SET search_path = csctoss, pg_catalog;

DROP FUNCTION ops_api_assign(text, text, integer, text, boolean, boolean);

DROP FUNCTION static_ip_desc(text);

DROP FUNCTION unique_id(integer, text);

DROP FUNCTION username_correct();

DROP TABLE billing_entity_fusio;

CREATE TABLE v_contact_id (
	nextval bigint
);

CREATE TRIGGER _csctoss_repl_logtrigger_1270
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1270', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1150
	AFTER INSERT OR UPDATE OR DELETE ON equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1150', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1080
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1080', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1930
	AFTER INSERT OR UPDATE OR DELETE ON line
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1930', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1940
	AFTER INSERT OR UPDATE OR DELETE ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1940', 'kkvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2480
	AFTER INSERT OR UPDATE OR DELETE ON location_labels
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2480', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1850
	AFTER INSERT OR UPDATE OR DELETE ON radreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1850', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1200
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1200', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1800
	AFTER INSERT OR UPDATE OR DELETE ON usergroup
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1800', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1250
	AFTER INSERT OR UPDATE OR DELETE ON address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1250', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1210
	AFTER INSERT OR UPDATE OR DELETE ON address_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1210', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2610
	AFTER INSERT OR UPDATE OR DELETE ON agreement_table
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2610', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1900
	AFTER INSERT OR UPDATE OR DELETE ON alert_activity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1900', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1870
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1870', 'kvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1880
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_contact
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1880', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1890
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_snmp
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1890', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2340
	AFTER INSERT OR UPDATE OR DELETE ON alert_priority
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2340', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1860
	AFTER INSERT OR UPDATE OR DELETE ON alert_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1860', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2350
	AFTER INSERT OR UPDATE OR DELETE ON alert_usage_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2350', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2360
	AFTER INSERT OR UPDATE OR DELETE ON alerts
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2360', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2140
	AFTER INSERT OR UPDATE OR DELETE ON api_device_login
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2140', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2150
	AFTER INSERT OR UPDATE OR DELETE ON api_device_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2150', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1370
	AFTER INSERT OR UPDATE OR DELETE ON api_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1370', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2160
	AFTER INSERT OR UPDATE OR DELETE ON api_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2160', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1380
	AFTER INSERT OR UPDATE OR DELETE ON api_request_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1380', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2170
	AFTER INSERT OR UPDATE OR DELETE ON api_supported_device
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2170', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1140
	AFTER INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1140', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1910
	AFTER INSERT OR UPDATE OR DELETE ON atm_processor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1910', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1760
	AFTER INSERT OR UPDATE OR DELETE ON attribute
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1760', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1750
	AFTER INSERT OR UPDATE OR DELETE ON attribute_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1750', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1330
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1330', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1710
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_download
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1710', 'kkvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1430
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_location_label
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1430', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1360
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1360', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1260
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1260', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1600
	AFTER INSERT OR UPDATE OR DELETE ON bp_aggregate_usage_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1600', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1590
	AFTER INSERT OR UPDATE OR DELETE ON bp_allotment_adjustment_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1590', 'kkkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1480
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_calendar
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1480', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1490
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_period
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1490', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1540
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1540', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1610
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_discount
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1610', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1560
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_onetime
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1560', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1550
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_static
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1550', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1440
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1440', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1450
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_unit
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1450', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1570
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_usage
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1570', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1520
	AFTER INSERT OR UPDATE OR DELETE ON bp_master_billing_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1520', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1460
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_discount_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1460', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1530
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_entity_preferences
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1530', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1630
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1630', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1470
	AFTER INSERT OR UPDATE OR DELETE ON bp_charge_frequency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1470', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1620
	AFTER INSERT OR UPDATE OR DELETE ON bp_past_due_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1620', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1640
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_billing_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1640', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1660
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_change_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1660', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1650
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_charge_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1650', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1680
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_status_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1680', 'kkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1670
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1670', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1580
	AFTER INSERT OR UPDATE OR DELETE ON bp_usage_allotment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1580', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2060
	AFTER INSERT OR UPDATE OR DELETE ON branding_button
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2060', 'kkvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2070
	AFTER INSERT OR UPDATE OR DELETE ON branding_content
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2070', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2080
	AFTER INSERT OR UPDATE OR DELETE ON branding_presentation
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2080', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1740
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1740', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1720
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1720', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1730
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1730', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1390
	AFTER INSERT OR UPDATE OR DELETE ON plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1390', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1350
	AFTER INSERT OR UPDATE OR DELETE ON product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1350', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1510
	AFTER INSERT OR UPDATE OR DELETE ON carrier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1510', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2240
	AFTER INSERT OR UPDATE OR DELETE ON carrier_api_activity_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2240', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2050
	AFTER INSERT OR UPDATE OR DELETE ON carrier_domain
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2050', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_2000
	AFTER INSERT OR UPDATE OR DELETE ON cc_auth_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2000', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2010
	AFTER INSERT OR UPDATE OR DELETE ON cc_encrypt_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2010', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1030
	AFTER INSERT OR UPDATE OR DELETE ON change_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1030', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2510
	AFTER INSERT OR UPDATE OR DELETE ON config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2510', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2520
	AFTER INSERT OR UPDATE OR DELETE ON config_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2520', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1300
	AFTER INSERT OR UPDATE OR DELETE ON contact
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1300', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1340
	AFTER INSERT OR UPDATE OR DELETE ON contact_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1340', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1280
	AFTER INSERT OR UPDATE OR DELETE ON contact_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1280', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1290
	AFTER INSERT OR UPDATE OR DELETE ON contact_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1290', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1500
	AFTER INSERT OR UPDATE OR DELETE ON currency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1500', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2500
	AFTER INSERT OR UPDATE OR DELETE ON device_monitor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2500', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1700
	AFTER INSERT OR UPDATE OR DELETE ON download_file_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1700', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2180', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_firmware
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2190', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1160
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1160', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1070
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1070', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2200
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2200', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2370
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2370', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1170
	AFTER INSERT OR UPDATE OR DELETE ON equipment_note
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1170', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1180', 'kkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1190', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1110
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1110', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1100
	AFTER INSERT OR UPDATE OR DELETE ON equipment_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1100', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1780
	AFTER INSERT OR UPDATE OR DELETE ON username
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1780', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2560
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2560', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2580
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty_rule
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2580', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2530
	AFTER INSERT OR UPDATE OR DELETE ON firmware
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2530', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2540
	AFTER INSERT OR UPDATE OR DELETE ON firmware_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2540', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1790
	AFTER INSERT OR UPDATE OR DELETE ON groupname
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1790', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2250
	AFTER INSERT OR UPDATE OR DELETE ON groupname_default
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2250', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1040
	AFTER INSERT OR UPDATE OR DELETE ON last_change_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1040', 'vvk');

CREATE TRIGGER _csctoss_repl_logtrigger_2260
	AFTER INSERT OR UPDATE OR DELETE ON line_alert
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2260', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2270
	AFTER INSERT OR UPDATE OR DELETE ON line_alert_email
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2270', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1920
	AFTER INSERT OR UPDATE OR DELETE ON line_assignment_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1920', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1950
	AFTER INSERT OR UPDATE OR DELETE ON line_terminal
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1950', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1970
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_day
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1970', 'kvkvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2330
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_day_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2330', 'kvkvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1980
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_month
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1980', 'kkkvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2280
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_overage_calc
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2280', 'kvkvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2230
	AFTER INSERT OR UPDATE OR DELETE ON lns_lookup
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2230', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1220
	AFTER INSERT OR UPDATE OR DELETE ON location_label_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1220', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1310
	AFTER INSERT OR UPDATE OR DELETE ON login_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1310', 'kkkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_7000
	AFTER INSERT OR UPDATE OR DELETE ON master_radpostauth
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '7000', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1960
	AFTER INSERT OR UPDATE OR DELETE ON mrad_duplicate
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1960', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1810
	AFTER INSERT OR UPDATE OR DELETE ON nas
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1810', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2570
	AFTER INSERT OR UPDATE OR DELETE ON soup_config_info
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2570', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2490
	AFTER INSERT OR UPDATE OR DELETE ON oss_jbill_billing_entity_mapping
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2490', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_5300
	AFTER INSERT OR UPDATE OR DELETE ON otaps_monthly_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5300', 'kvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5310
	AFTER INSERT OR UPDATE OR DELETE ON otaps_product_code_translation
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5310', 'vkvkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2550
	AFTER INSERT OR UPDATE OR DELETE ON otaps_service_line_number
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2550', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2040
	AFTER INSERT OR UPDATE OR DELETE ON parser_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2040', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2020
	AFTER INSERT OR UPDATE OR DELETE ON plan_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2020', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1230
	AFTER INSERT OR UPDATE OR DELETE ON plan_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1230', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1690
	AFTER INSERT OR UPDATE OR DELETE ON portal_properties
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1690', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2290
	AFTER INSERT OR UPDATE OR DELETE ON product_overage_threshold
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2290', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2130
	AFTER INSERT OR UPDATE OR DELETE ON purchase_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2130', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1820
	AFTER INSERT OR UPDATE OR DELETE ON radcheck
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1820', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1830
	AFTER INSERT OR UPDATE OR DELETE ON radgroupcheck
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1830', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1840
	AFTER INSERT OR UPDATE OR DELETE ON radgroupreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1840', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2590
	AFTER INSERT OR UPDATE OR DELETE ON radius_operator
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2590', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1120
	AFTER INSERT OR UPDATE OR DELETE ON receiving_lot
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1120', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1060
	AFTER INSERT OR UPDATE OR DELETE ON replication_failure
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1060', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1400
	AFTER INSERT OR UPDATE OR DELETE ON report
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1400', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2600
	AFTER INSERT OR UPDATE OR DELETE ON rma_form
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2600', 'kvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1990
	AFTER INSERT OR UPDATE OR DELETE ON sales_order
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1990', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1320
	AFTER INSERT OR UPDATE OR DELETE ON security_roles
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1320', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1410
	AFTER INSERT OR UPDATE OR DELETE ON shipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1410', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1420
	AFTER INSERT OR UPDATE OR DELETE ON shipment_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1420', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1130
	AFTER INSERT OR UPDATE OR DELETE ON software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1130', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2300
	AFTER INSERT OR UPDATE OR DELETE ON soup_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2300', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2090
	AFTER INSERT OR UPDATE OR DELETE ON soup_device
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2090', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2310
	AFTER INSERT OR UPDATE OR DELETE ON soup_dirnames
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2310', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2320
	AFTER INSERT OR UPDATE OR DELETE ON sprint_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2320', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2400
	AFTER INSERT OR UPDATE OR DELETE ON sprint_csa
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2400', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_8000
	AFTER INSERT OR UPDATE OR DELETE ON sprint_master_radacct
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '8000', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2390
	AFTER INSERT OR UPDATE OR DELETE ON sprint_msl
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2390', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1010
	AFTER INSERT OR UPDATE OR DELETE ON staff
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1010', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1020
	AFTER INSERT OR UPDATE OR DELETE ON staff_access
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1020', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1240
	AFTER INSERT OR UPDATE OR DELETE ON state_code
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1240', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2410
	AFTER INSERT OR UPDATE OR DELETE ON static_ip_carrier_def
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2410', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2380
	AFTER INSERT OR UPDATE OR DELETE ON static_ip_pool
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2380', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1000
	AFTER INSERT OR UPDATE OR DELETE ON system_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1000', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2110
	AFTER INSERT OR UPDATE OR DELETE ON throw_away_minutes
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2110', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1050
	AFTER INSERT OR UPDATE OR DELETE ON timezone
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1050', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2420
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2420', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1090
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1090', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2120
	AFTER INSERT OR UPDATE OR DELETE ON usergroup_error_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2120', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2470
	AFTER INSERT OR UPDATE OR DELETE ON userlevels
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2470', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2430
	AFTER INSERT OR UPDATE OR DELETE ON webui_users
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2430', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

SET search_path = invoice, pg_catalog;

CREATE TRIGGER _csctoss_repl_logtrigger_2440
	AFTER INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2440', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2450
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2450', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2460
	AFTER INSERT OR UPDATE OR DELETE ON file_system
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2460', 'kvvvvvv');

SET search_path = rt3, pg_catalog;

CREATE TRIGGER _csctoss_repl_logtrigger_5000
	AFTER INSERT OR UPDATE OR DELETE ON acl
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5000', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5010
	AFTER INSERT OR UPDATE OR DELETE ON attachments
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5010', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5020
	AFTER INSERT OR UPDATE OR DELETE ON attributes
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5020', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5030
	AFTER INSERT OR UPDATE OR DELETE ON cachedgroupmembers
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5030', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5040
	AFTER INSERT OR UPDATE OR DELETE ON customfields
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5040', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5050
	AFTER INSERT OR UPDATE OR DELETE ON customfieldvalues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5050', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5060
	AFTER INSERT OR UPDATE OR DELETE ON groupmembers
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5060', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5070
	AFTER INSERT OR UPDATE OR DELETE ON groups
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5070', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5080
	AFTER INSERT OR UPDATE OR DELETE ON links
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5080', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5090
	AFTER INSERT OR UPDATE OR DELETE ON objectcustomfields
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5090', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5100
	AFTER INSERT OR UPDATE OR DELETE ON objectcustomfieldvalues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5100', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5110
	AFTER INSERT OR UPDATE OR DELETE ON principals
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5110', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5120
	AFTER INSERT OR UPDATE OR DELETE ON queues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5120', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5180
	AFTER INSERT OR UPDATE OR DELETE ON tickets
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5180', 'kvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5200
	AFTER INSERT OR UPDATE OR DELETE ON users
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5200', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5130
	AFTER INSERT OR UPDATE OR DELETE ON scripactions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5130', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5140
	AFTER INSERT OR UPDATE OR DELETE ON scripconditions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5140', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5150
	AFTER INSERT OR UPDATE OR DELETE ON scrips
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5150', 'kvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5160
	AFTER INSERT OR UPDATE OR DELETE ON sessions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5160', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5170
	AFTER INSERT OR UPDATE OR DELETE ON templates
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5170', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5190
	AFTER INSERT OR UPDATE OR DELETE ON transactions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5190', 'kvvvvvvvvvvvvv');
