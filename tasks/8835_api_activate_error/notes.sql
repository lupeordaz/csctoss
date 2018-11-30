
esnHex:				"﻿A100000267AB7",
esnDec:				"2832341955672750",
mdn:				"3039746852",
min:				"3039746852",
serial:				"654789",
mac:				"00806431871",
equipment:			75,
realm:				"vzw3g.com",
carrier:			"Verizon"


select * from ops_api_activate('﻿A100000267AB7','2832341955672750','3039746852','3039746852',654789,'00806431871',75,'vzw3g.com','Verizon');

--

esnHex:				'352613070667237',
esnDec:				'89148000004530258196',
mdn:				'4046388721',
min:				'4046388721',
serial:				981660,
mac:				'0080441341C6',
equipment:			189,
realm:				'vzw3g.com',
carrier:			'Verizon'


select * from ops_api_activate('352613070667237','89148000004530258196','4046388721','4046388721',981660,'0080441341C6',189,'vzw3g.com','Verizon');

--

par_esn_hex                 text    := 352613070667237
   par_esn_dec                text    := 89148000004530258196
   par_mdn                     text    := 4046388721
   par_min                     text    := 4046388721
   par_serial_number           text    := 981660
   par_mac_address             text    := 0080441341C6
   par_equipment_model_id      integer := 189
   par_realm                   text    := vzw3g.com
   par_carrier                 text    := VZW


select * from ops_api_activate('352613070667237','89148000004530258196','4046388721','4046388721',981660,'0080441341C6',189,'vzw3g.com','VZW');


