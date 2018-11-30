Replication process does not include NAS table updates.  If changes take place on the NAS table,
they have to be propogated manually to all Radius servers.  The changes did not get
propogated to atlrad33, so I have to manually add the different entries.

---

SELECT change_log_id
      ,table_name
      ,rtrim(substr(table_name,instr(table_name,'"',1,3)+1,100),'"')||'_updater' as function_call
      ,change_type
      ,primary_key
  FROM csctoss.change_log clog
 WHERE change_log_id >  var_last_change_log_id
   AND change_log_id <= var_max_change_log_id
   AND table_name =  'csctoss"."nas'
ORDER BY change_log_id

--

INSERT INTO nas (id, nasname, shortname, type, ports, secret, community, description) VALUES
(183, '69.78.101.116', 'Branchburg_WSN_S-NAT_VIP', 'other', 1701, 'nEWrEwaBR85heY', '', 'Branchburg WSN S-NAT VIP'),
(184, '69.78.232.252', 'Colorado_Springs_WSN S-NAT_VIP', 'other', 1701, 'nEWrEwaBR85heY', '', 'Colorado Springs WSN S-NAT VIP'),
(185, '10.16.64.38', 'atlpbr02-g0-0', 'cisco', 1701, 'crazybob', '', ''),
(186, '10.16.64.70', 'atlpbr02-g0-1', 'cisco', 1701, 'crazybob', '', ''),
(187, '47.73.56.86', 'Vodafone-AAA5', 'other', 1701, '$cct108d@f0n', '', 'Vodafone'),
(188, '47.73.56.87', 'Vodafone-AAA6', 'other', 1701, '$cct108d@f0n', '', 'Vodafone'),
(189, '68.31.122.77', 'Sprint-rstn-aaa-roamf5snat1', 'other', 1701, 'Spr1ntC0untour', '', ''),
(190, '68.31.122.78', 'Sprint-rstn-aaa-roamf5snat2', 'other', 1701, 'Spr1ntC0untour', '', ''),
(191, '68.31.126.77', 'Sprint-sob-aaa-roamf5snat1', 'other', 1701, 'Spr1ntC0untour', '', ''),
(192, '68.31.126.78', 'Sprint-sob-aaa-roamf5snat2', 'other', 1701, 'Spr1ntC0untour', '', ''),
(193, '68.31.46.77', 'Sprint-nob-aaa-roamf5snat1', 'other', 1701, 'Spr1ntC0untour', '', ''),
(194, '68.31.46.78', 'Sprint-nob-aaa-roamf5snat2', 'other', 1701, 'Spr1ntC0untour', '', ''),
(195, '69.78.159.233', 'New_AAA IP_1 - VZW', 'other', 1701, 'nEWrEwaBR85heY', '', ''),
(196, '69.78.159.234', 'New_AAA IP_2 - VZW', 'other', 1701, 'nEWrEwaBR85heY', '', ''),
(197, '63.55.32.27', 'New_AAA IP_3 - VZW', 'other', 1701, 'nEWrEwaBR85heY', '', ''),
(198, '63.55.160.27', 'New_AAA IP_4 - VZW', 'other', 1701, 'nEWrEwaBR85heY', '', '');
