                                                                      prosrc                                                                       
---------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                                                                                  +
 DECLARE                                                                                                                                          +
                                                                                                                                                  +
   var_interval                 interval := $1 * interval '1 HOUR' ;                                                                              +
   var_prev_username            varchar  := 'x' ;                                                                                                 +
   var_incident_id              integer ;                                                                                                         +
                                                                                                                                                  +
   rec_inci                     record ;                                                                                                          +
   rec_mrac                     record ;                                                                                                          +
                                                                                                                                                  +
 BEGIN                                                                                                                                            +
                                                                                                                                                  +
   -- go through existing incidents and check for successful disconnection                                                                        +
   FOR rec_inci IN SELECT inci.incident_id                                                                                                        +
                         ,idet.pod_master_radacctid                                                                                               +
                         ,mrac.acctstoptime                                                                                                       +
                     FROM csctmon.incident inci                                                                                                   +
                     JOIN csctmon.incident_detail idet USING (incident_id)                                                                        +
                     JOIN csctmon.master_radacct mrac ON (idet.pod_master_radacctid = mrac.master_radacctid)                                      +
                    WHERE idet.pod_status = 'WORKING'                                                                                             +
                 ORDER BY inci.incident_id                                                                                                        +
                         ,idet.pod_master_radacctid                                                                                               +
   LOOP                                                                                                                                           +
                                                                                                                                                  +
     IF rec_inci.acctstoptime IS NULL THEN                                                                                                        +
       RETURN NEXT 'Incident ID '||rec_inci.incident_id::text||' Master Radaccid '||rec_inci.pod_master_radacctid||' has not disconnected.' ;     +
     ELSE                                                                                                                                         +
       UPDATE csctmon.incident_detail                                                                                                             +
          SET pod_status = 'DISCONNECTED'                                                                                                         +
        WHERE incident_id = rec_inci.incident_id                                                                                                  +
          AND pod_master_radacctid = rec_inci.pod_master_radacctid ;                                                                              +
     END IF ;                                                                                                                                     +
                                                                                                                                                  +
   END LOOP ;                                                                                                                                     +
                                                                                                                                                  +
   -- close appropriate incidents                                                                                                                 +
   UPDATE csctmon.incident                                                                                                                        +
      SET status = 'CLOSED'                                                                                                                       +
    WHERE status = 'OPEN'                                                                                                                         +
      AND (select count(*)                                                                                                                        +
             from incident_detail                                                                                                                 +
            where incident_id = incident.incident_id                                                                                              +
              and pod_status = 'WORKING') = 0 ;                                                                                                   +
                                                                                                                                                  +
   -- this is the pass for new incidents                                                                                                          +
   FOR rec_mrac IN SELECT mrac.username                                                                                                           +
                         ,mrac.master_radacctid                                                                                                   +
                         ,mrac.acctsessionid                                                                                                      +
                         ,mrac.acctuniqueid                                                                                                       +
                         ,mrac.acctstarttime                                                                                                      +
                         ,mrac.acctstoptime                                                                                                       +
                         ,mrac.framedipaddress                                                                                                    +
                         ,mrac.nasidentifier                                                                                                      +
                     FROM csctmon.master_radacct mrac                                                                                             +
                    WHERE acctstoptime IS NULL                                                                                                    +
                      AND acctstarttime >= (current_timestamp - var_interval)                                                                     +
                      AND nasidentifier IS NOT NULL                                                                                               +
                      AND NOT EXISTS (select true                                                                                                 +
                                        from csctmon.incident                                                                                     +
                                       where retained_master_radacctid = mrac.master_radacctid                                                    +
                                         and status = 'OPEN')                                                                                     +
                      AND NOT EXISTS (select true                                                                                                 +
                                        from csctmon.incident_detail                                                                              +
                                       where pod_master_radacctid = mrac.master_radacctid                                                         +
                                         and pod_status = 'WORKING')                                                                              +
                                                                                                                                                  +
                      AND mrac.username in                                                                                                        +
                          ( select username                                                                                                       +
                              from csctmon.username_monitor                                                                                       +
                              join csctmon.master_radacct using (username)                                                                        +
                             where acctstoptime is null                                                                                           +
                               and acctstarttime >= (current_timestamp - var_interval)                                                            +
                          group by username                                                                                                       +
                            having count(*) > 1                                                                                                   +
                          )                                                                                                                       +
                 ORDER BY mrac.username                                                                                                           +
                         ,mrac.master_radacctid desc                                                                                              +
   LOOP                                                                                                                                           +
                                                                                                                                                  +
     -- determine if this is a new incident                                                                                                       +
     IF rec_mrac.username <> var_prev_username THEN                                                                                               +
                                                                                                                                                  +
       var_incident_id := nextval('incident_incident_id_seq') ;                                                                                   +
                                                                                                                                                  +
       INSERT INTO csctmon.incident                                                                                                               +
                  (incident_id                                                                                                                    +
                  ,username                                                                                                                       +
                  ,retained_master_radacctid                                                                                                      +
                  ,incident_timestamp                                                                                                             +
                  ,status)                                                                                                                        +
           VALUES (var_incident_id                                                                                                                +
                  ,rec_mrac.username                                                                                                              +
                  ,rec_mrac.master_radacctid                                                                                                      +
                  ,current_timestamp                                                                                                              +
                  ,'OPEN') ;                                                                                                                      +
     ELSE                                                                                                                                         +
                                                                                                                                                  +
       -- existing incident, these records queued for POD                                                                                         +
       INSERT INTO csctmon.incident_detail                                                                                                        +
                  (incident_id                                                                                                                    +
                  ,pod_master_radacctid                                                                                                           +
                  ,pod_sent                                                                                                                       +
                  ,pod_timestamp                                                                                                                  +
                  ,pod_status)                                                                                                                    +
           VALUES (var_incident_id                                                                                                                +
                  ,rec_mrac.master_radacctid                                                                                                      +
                  ,false                                                                                                                          +
                  ,current_timestamp                                                                                                              +
                  ,'WORKING') ;                                                                                                                   +
                                                                                                                                                  +
     END IF ;                                                                                                                                     +
                                                                                                                                                  +
     var_prev_username := rec_mrac.username ;                                                                                                     +
                                                                                                                                                  +
   END LOOP ;                                                                                                                                     +
                                                                                                                                                  +
   --PERFORM * FROM csctmon.packet_of_disconnect() ;                                                                                              +
                                                                                                                                                  +
   RETURN NEXT 'SUCCESS' ;                                                                                                                        +
   RETURN ;                                                                                                                                       +
                                                                                                                                                  +
 END ;                                                                                                                                            +
                                                                                                                                                  +
 
                                                                                                                                                  +
 DECLARE                                                                                                                                          +
                                                                                                                                                  +
   par_interval                 interval := $1 * interval '1 HOUR' ;                                                                              +
   par_threshold                integer  := $2 ;                                                                                                  +
                                                                                                                                                  +
   var_prev_username            varchar  := 'x' ;                                                                                                 +
   var_incident_id              integer ;                                                                                                         +
                                                                                                                                                  +
   rec_inci                     record ;                                                                                                          +
   rec_mrac                     record ;                                                                                                          +
                                                                                                                                                  +
 BEGIN                                                                                                                                            +
                                                                                                                                                  +
   -- go through existing incidents and check for successful disconnection                                                                        +
   FOR rec_inci IN SELECT inci.incident_id                                                                                                        +
                         ,inci.incident_counter                                                                                                   +
                         ,idet.pod_master_radacctid                                                                                               +
                         ,mrac.acctstoptime                                                                                                       +
                     FROM csctmon.incident inci                                                                                                   +
                     JOIN csctmon.incident_detail idet USING (incident_id)                                                                        +
                     JOIN csctmon.master_radacct mrac ON (idet.pod_master_radacctid = mrac.master_radacctid)                                      +
                    WHERE idet.pod_status = 'WORKING'                                                                                             +
                      AND inci.incident_type = 'DUPLICATE SESSION'                                                                                +
                 ORDER BY inci.incident_id                                                                                                        +
                         ,idet.pod_master_radacctid                                                                                               +
   LOOP                                                                                                                                           +
                                                                                                                                                  +
     IF rec_inci.acctstoptime IS NULL THEN                                                                                                        +
       IF rec_inci.incident_counter < par_threshold THEN                                                                                          +
         RETURN NEXT 'DS Incident ID '||rec_inci.incident_id::text||' Master Radaccid '||rec_inci.pod_master_radacctid||' has not disconnected.' ;+
         UPDATE csctmon.incident                                                                                                                  +
            SET incident_counter = incident_counter + 1                                                                                           +
          WHERE incident_id = rec_inci.incident_id ;                                                                                              +
       ELSE                                                                                                                                       +
         RETURN NEXT 'DS Incident ID '||rec_inci.incident_id::text||' COUNT EXPIRED. '||par_threshold::text||' iterations exhausted.' ;           +
         UPDATE csctmon.incident_detail                                                                                                           +
            SET pod_status = 'COUNT EXPIRED'                                                                                                      +
          WHERE incident_id = rec_inci.incident_id ;                                                                                              +
         UPDATE csctmon.incident                                                                                                                  +
            SET status = 'COUNT EXPIRED'                                                                                                          +
          WHERE incident_id = rec_inci.incident_id ;                                                                                              +
         UPDATE csctmon.master_radacct                                                                                                            +
            SET acctstoptime = current_timestamp                                                                                                  +
          WHERE master_radacctid = rec_inci.pod_master_radacctid ;                                                                                +
       END IF ;                                                                                                                                   +
     ELSE                                                                                                                                         +
       UPDATE csctmon.incident_detail                                                                                                             +
          SET pod_status = 'DISCONNECTED'                                                                                                         +
        WHERE incident_id = rec_inci.incident_id                                                                                                  +
          AND pod_master_radacctid = rec_inci.pod_master_radacctid ;                                                                              +
     END IF ;                                                                                                                                     +
                                                                                                                                                  +
   END LOOP ;                                                                                                                                     +
                                                                                                                                                  +
   -- close appropriate incidents                                                                                                                 +
   UPDATE csctmon.incident                                                                                                                        +
      SET status = 'CLOSED'                                                                                                                       +
    WHERE status = 'OPEN'                                                                                                                         +
      AND incident_type = 'DUPLICATE SESSION'                                                                                                     +
      AND (select count(*)                                                                                                                        +
             from incident_detail                                                                                                                 +
            where incident_id = incident.incident_id                                                                                              +
              and pod_status = 'WORKING') = 0 ;                                                                                                   +
                                                                                                                                                  +
   -- this is the pass for new incidents                                                                                                          +
   FOR rec_mrac IN SELECT mrac.username                                                                                                           +
                         ,mrac.master_radacctid                                                                                                   +
                         ,mrac.acctsessionid                                                                                                      +
                         ,mrac.acctuniqueid                                                                                                       +
                         ,mrac.acctstarttime                                                                                                      +
                         ,mrac.acctstoptime                                                                                                       +
                         ,mrac.framedipaddress                                                                                                    +
                         ,mrac.nasidentifier                                                                                                      +
                     FROM csctmon.master_radacct mrac                                                                                             +
                    WHERE acctstoptime IS NULL                                                                                                    +
                      AND acctstarttime >= (current_timestamp - par_interval)                                                                     +
                      AND nasidentifier IS NOT NULL                                                                                               +
                      AND NOT EXISTS (select true                                                                                                 +
                                        from csctmon.incident                                                                                     +
                                       where retained_master_radacctid = mrac.master_radacctid                                                    +
                                         and status = 'OPEN')                                                                                     +
                      AND NOT EXISTS (select true                                                                                                 +
                                        from csctmon.incident_detail                                                                              +
                                       where pod_master_radacctid = mrac.master_radacctid                                                         +
                                         and pod_status = 'WORKING')                                                                              +
                                                                                                                                                  +
                      AND mrac.username in                                                                                                        +
                          ( select username                                                                                                       +
                              from csctmon.master_radacct                                                                                         +
                             where 1=1                                                                                                            +
                               and acctstarttime >= (current_timestamp - par_interval)                                                            +
                               and acctstoptime is null                                                                                           +
                          group by username                                                                                                       +
                            having count(*) > 1                                                                                                   +
                          )                                                                                                                       +
                 ORDER BY mrac.username                                                                                                           +
                         ,mrac.master_radacctid desc                                                                                              +
   LOOP                                                                                                                                           +
                                                                                                                                                  +
     -- determine if this is a new incident                                                                                                       +
     IF rec_mrac.username <> var_prev_username THEN                                                                                               +
                                                                                                                                                  +
       var_incident_id := nextval('incident_incident_id_seq') ;                                                                                   +
                                                                                                                                                  +
       INSERT INTO csctmon.incident                                                                                                               +
                  (incident_id                                                                                                                    +
                  ,incident_type                                                                                                                  +
                  ,username                                                                                                                       +
                  ,retained_master_radacctid                                                                                                      +
                  ,incident_timestamp                                                                                                             +
                  ,status)                                                                                                                        +
           VALUES (var_incident_id                                                                                                                +
                  ,'DUPLICATE SESSION'                                                                                                            +
                  ,rec_mrac.username                                                                                                              +
                  ,rec_mrac.master_radacctid                                                                                                      +
                  ,current_timestamp                                                                                                              +
                  ,'OPEN') ;                                                                                                                      +
     ELSE                                                                                                                                         +
                                                                                                                                                  +
       -- existing incident, these records queued for POD                                                                                         +
       INSERT INTO csctmon.incident_detail                                                                                                        +
                  (incident_id                                                                                                                    +
                  ,pod_master_radacctid                                                                                                           +
                  ,pod_sent                                                                                                                       +
                  ,pod_timestamp                                                                                                                  +
                  ,pod_status)                                                                                                                    +
           VALUES (var_incident_id                                                                                                                +
                  ,rec_mrac.master_radacctid                                                                                                      +
                  ,false                                                                                                                          +
                  ,current_timestamp                                                                                                              +
                  ,'WORKING') ;                                                                                                                   +
                                                                                                                                                  +
     END IF ;                                                                                                                                     +
                                                                                                                                                  +
     var_prev_username := rec_mrac.username ;                                                                                                     +
                                                                                                                                                  +
   END LOOP ;                                                                                                                                     +
                                                                                                                                                  +
   --PERFORM * FROM csctmon.packet_of_disconnect() ;                                                                                              +
                                                                                                                                                  +
   RETURN NEXT 'SUCCESS' ;                                                                                                                        +
   RETURN ;                                                                                                                                       +
                                                                                                                                                  +
 END ;                                                                                                                                            +
                                                                                                                                                  +
 
(2 rows)

