-- Issue 8559 Test Plan

-- Test 1

pr_carrier				VZW
par_vrf					SERVICE-vzwretail_cnione
par_username			4702302503@vzw3g.com
par_line_id				47045
par_billing_entity_id	157

BEGIN; select * from ops_api_static_ip_assign('VZW','SERVICE-vzwretail_cnione','4702302503@vzw3g.com', 47045, 157); ROLLBACK;
BEGIN

NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4702302503@vzw3g.com][line_id=47045][billing_entity_id=157]
NOTICE:  We found IP pool.
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.56.10]
NOTICE:  Processing radreply: Username: 4702302503@vzw3g.com, static_ip: 10.81.56.10.
                                   ops_api_static_ip_assign                                   
----------------------------------------------------------------------------------------------
 ERROR - Framed-IP INSERT Failed: username: 4702302503@vzw3g.com, var_static_ip: 10.81.56.10.
(1 row)

ROLLBACK
csctoss=# 


-- Test 2

pr_carrier				VZW
par_vrf					SERVICE-vzwretail_cnione
par_username			4702302503@vzw3g.com
par_line_id				47045
par_billing_entity_id	825

BEGIN; select * from ops_api_static_ip_assign('VZW','SERVICE-vzwretail_cnione','4702302503@vzw3g.com', 47045, 825); ROLLBACK;
BEGIN
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4702302503@vzw3g.com][line_id=47045][billing_entity_id=825]
NOTICE:  No billing entity id path selected.
NOTICE:  Processing radreply: Username: 4702302503@vzw3g.com, static_ip: 10.80.0.215.
                                   ops_api_static_ip_assign                                   
----------------------------------------------------------------------------------------------
 ERROR - Framed-IP INSERT Failed: username: 4702302503@vzw3g.com, var_static_ip: 10.80.0.215.
(1 row)

ROLLBACK
csctoss=# 




