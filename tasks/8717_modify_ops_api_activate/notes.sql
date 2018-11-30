

select * from ops_api_activate('A100000267AB7','2832341955672750','00806431871','654789','3039746852','3039746852','vzw3g.com','equipment199','vzw3g';



   par_esn_hex                 text    := A100000267AB7
   par_esn_dec	               text    := 2832341955672750
   par_mdn                     text    := 00806431871
   par_min                     text    := 654789
   par_serial_number           text    := 3039746852
   par_mac_address             text    := 3039746852
   par_equipment_model_id      integer := vzw3g.com
   par_realm                   text    := equipment199
   par_carrier                 text    := ?


par_esn_hex                 text    := A100000267AB7
   par_esn_dec                text    := 2832341955672750
   par_mdn                     text    := 3039746852
   par_min                     text    := 3039746852
   par_serial_number           text    := 654789
   par_mac_address             text    := 00806431871
   par_equipment_model_id      integer := 199
   par_realm                   text    := vzw3g.com
   par_carrier                 text    := Verizon


select * from ops_api_activate('A100000267AB7','2832341955672750','3039746852','3039746852','654789','00806431871',199,'vzw3g','Verizon');
