SELECT CASE WHEN ((SELECT count(*) AS count 
      	             FROM master_radacct 
      	            WHERE ((master_radacct.username)::text = line.radius_username)) = 0) 
            THEN 'NO'::text 
            ELSE 
                CASE WHEN ((SELECT count(*) AS count 
                     	        FROM master_radacct mrad 
                     	       WHERE (
                                       (
                                          (
                                                ((mrad.username)::text = line.radius_username) 
                     	                      AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval))
                                          ) 
                                          AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max 
                     	                	                                  FROM master_radacct mrad2 
                     	                	                                 WHERE ((mrad2.username)::text = (mrad.username)::text)
                                                                       )
                                              )
                                        ) 
                     	               AND (mrad.acctstoptime IS NULL)
                                   )
                             ) = 1
                          ) 
                     THEN 'YES'::text 
                     ELSE 'NO'::text 
                END 
       END;