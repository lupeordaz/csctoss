DECLARE                                                                                                        
                                                                                                                
   rec_firm             record ;                                                                                
   rec_error            record ;                                                                                
                                                                                                                
 BEGIN                                                                                                          
                                                                                                                
   PERFORM * FROM public.set_change_log_staff_id(3) ;                                                           
                                                                                                                
   -- first verify the interface job executed                                                                   
   IF NOT (SELECT TRUE FROM csctoss.firmware_gmu WHERE firmware_gmu_id = -1) THEN                               
     RETURN NEXT 'ERROR: Table firmware_gmu is empty or incomplete.' ;                                          
     RETURN ;                                                                                                   
   END IF ;                                                                                                     
                                                                                                                
   -- backfill equipment_id based on ESN HEX                                                                    
   UPDATE csctoss.firmware_gmu                                                                                  
      SET equipment_id =                                                                                        
         (select equipment_id                                                                                   
            from unique_identifier                                                                              
           where unique_identifier_type = 'ESN HEX'                                                             
             and value = firmware_gmu.value)                                                                    
    WHERE unique_identifier_type = 'ESN HEX'                                                                    
      AND equipment_id is null ;                                                                                
                                                                                                                
   -- backfill equipment_id based on serial number                                                              
   UPDATE csctoss.firmware_gmu                                                                                  
      SET equipment_id =                                                                                        
         (select equipment_id                                                                                   
            from unique_identifier                                                                              
           where unique_identifier_type = 'SERIAL NUMBER'                                                       
             and value = firmware_gmu.value)                                                                    
    WHERE unique_identifier_type = 'SERIAL NUMBER'                                                              
      AND equipment_id IS NULL ;                                                                                
                                                                                                                
   -- backfill equipment_model_id based on equipment_id                                                         
   UPDATE csctoss.firmware_gmu                                                                                  
      SET equipment_model_id = equipment.equipment_model_id                                                     
     FROM csctoss.equipment                                                                                     
    WHERE firmware_gmu.equipment_id is not null                                                                 
      AND firmware_gmu.equipment_id = equipment.equipment_id ;                                                  
                                                                                                                
   -- go through entries and mark as error where equipment_id null                                              
   UPDATE csctoss.firmware_gmu                                                                                  
      SET status = 'ERROR'                                                                                      
         ,error  = 'GMU '||vendor_name||' '||unique_identifier_type||' '||value||' Unmatached OSS Equipment ID.'
    WHERE firmware_gmu_id > 0                                                                                   
      AND equipment_id IS NULL ;                                                                                
                                                                                                                
   -- now go through distinct models and firmware and reconcile entries in equipment_firmware table             
   INSERT INTO csctoss.equipment_firmware (equipment_model_id, firmware_version)                                
        SELECT DISTINCT equipment_model_id, firmware_version                                                    
          FROM csctoss.firmware_gmu                                                                             
         WHERE equipment_model_id IS NOT NULL                                                                   
           AND firmware_version IS NOT NULL                                                                     
           AND status <> 'ERROR'                                                                                
        EXCEPT                                                                                                  
        SELECT DISTINCT equipment_model_id, firmware_version                                                    
          FROM csctoss.equipment_firmware ;                                                                     
                                                                                                                
   -- update new or changed equipment_firmware_id in equipment table                                            
   FOR rec_firm IN SELECT equp.equipment_id                                                                     
                         ,efrm.equipment_firmware_id as efrm_firm_id                                            
                         ,equp.equipment_firmware_id as equp_firm_id                                            
                     FROM csctoss.equipment equp                                                                
                     JOIN csctoss.firmware_gmu frmg ON (frmg.equipment_id = equp.equipment_id)                  
                     JOIN csctoss.equipment_firmware efrm ON (frmg.equipment_model_id = efrm.equipment_model_id 
                                                         AND frmg.firmware_version = efrm.firmware_version)     
                    WHERE frmg.equipment_id IS NOT NULL                                                         
                      AND frmg.equipment_model_id IS NOT NULL                                                   
                      AND frmg.firmware_version IS NOT NULL                                                     
   LOOP                                                                                                         
                                                                                                                
     -- if equipment_firmware_id null or disagrees with gmu data then update it                                 
     IF rec_firm.equp_firm_id IS NULL OR rec_firm.efrm_firm_id <> rec_firm.equp_firm_id THEN                    
       UPDATE csctoss.equipment                                                                                 
          SET equipment_firmware_id = rec_firm.efrm_firm_id                                                     
        WHERE equipment_id = rec_firm.equipment_id ;                                                            
     END IF ;                                                                                                   
                                                                                                                
   END LOOP ;                                                                                                   
                                                                                                                
   -- return all the errors                                                                                     
   FOR rec_error IN SELECT COALESCE(error,'EMPTY STRING') as err_msg                                            
                      FROM csctoss.firmware_gmu                                                                 
                     WHERE status = 'ERROR'                                                                     
                  ORDER BY firmware_gmu_id                                                                      
   LOOP                                                                                                         
     RETURN NEXT rec_error.err_msg ;                                                                            
   END LOOP ;                                                                                                   
                                                                                                                
   RETURN NEXT 'SUCCESS' ;                                                                                      
   RETURN ;                                                                                                     
                                                                                                                
 END ; 