SELECT radius_username
  FROM csctoss.portal_active_lines_vw
 WHERE (billing_entity_id = 699
       OR parent_billing_entity_id = 699);
