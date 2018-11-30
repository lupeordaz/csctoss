

To solve this issue temporarily, we need to use this view portal_active_lines_vw and populate soup_config_name and firmware_version 
with the string "Managed" for the devices which equipment_maker is equal to "Digi International". 

This process need to be performed in production, so the customers will see the change done. Lupe, can you do it, please?



SELECT soup_device_stats_table.firmware 
      	   FROM soup_device_stats_table 
      	  WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value 
      	  	                                                FROM unique_identifier 
      	  	                                               WHERE (    (unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) 
      	  	                                               	      AND (unique_identifier.equipment_id = lieq.equipment_id)
      	  	                                               	      )
      	  	                                               )
      	  ) ORDER BY soup_device_stats_table.datetime DESC LIMIT 1) AS firmware_version


--

select uis.value as serial_number
      ,em.model_number2
      ,em.part_number
      ,uie.value as esn_hex
  from equipment_model em
  join equipment e ON e.equipment_model_id = em.equipment_model_id
  join unique_identifier uis ON uis.equipment_id = e.equipment_id AND uis.unique_identifier_type = 'SERIAL NUMBER'
  join unique_identifier uie ON uie.equipment_id = e.equipment_id AND uie.unique_identifier_type = 'ESN HEX'
 where em.vendor like '%Digi%'
 order by 1;



---

Steps:

1.  Select all the serial_number and esn_hex values from OSS where the vendor is like '%Digi%'.

serial_number|esn_hex|vendor
00042D03A558|A0000033617F29|Digi International
00042D05E08E|A10000458112FD|Digi International
00042D05E092|A1000045811864|Digi International
00042D05E099|A10000458058E7|Digi International
00042D05E09B|A1000045811870|Digi International
00042D05E09D|A1000045805EB9|Digi International
.
.
.
S421157|353238060029278|Digi International
S421162|353238060028171|Digi International
S421206|353238060029690|Digi International
S421303|353238060034971|Digi International
S421374|353238060066668|Digi International
UNKNOWN|6087D5DA|Digi International
(567 rows)


2.  Copy the serial_numbers to a file and send the file (6856_sn.txt) to the soup server.

3.  Select did, serial_number, and esn_hex from device table joined to cellinfo table (to get the esn_hex)
	where the device.serial_number = file (6856_sn.txt) serial_number.

4.  Verify the serial_number and esn_hex from SOUP match the same values from OSS.

5.  Select did from device using the same criteria as in step 3.

6.  Create update script for the did 

	update

--


(SELECT ops_get_firmware_status.ops_get_firmware_status 
   FROM ops_get_firmware_status(
        (SELECT soup_device_stats_table.firmware 
           FROM soup_device_stats_table 
          WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value 
                                                            FROM unique_identifier 
                                                           WHERE (   (unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) 
                                                             AND (unique_identifier.equipment_id = 43063)
                                                                 )
                                                          )
                                            ) 
         ORDER BY soup_device_stats_table.datetime DESC LIMIT 1
        )
                                )
      ) AS firmware_status


