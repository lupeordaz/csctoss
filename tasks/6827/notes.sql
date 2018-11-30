select line_id
      , start_date
      , end_date
      , order_id 
  from line 
 where end_date is null 
 order by 1 
 limit 10;

 line_id |       start_date       | end_date | order_id 
---------+------------------------+----------+----------
      38 | 2009-03-25 00:00:00-06 |          |         
      43 | 2008-01-11 00:00:00-07 |          |         
      50 | 2008-01-21 17:00:00-07 |          |         
      86 | 2008-01-29 17:00:00-07 |          |         
     341 | 2008-02-27 17:00:00-07 |          |         
     807 | 2008-06-18 18:00:00-06 |          |         
     808 | 2008-06-18 18:00:00-06 |          |         
     809 | 2008-06-18 18:00:00-06 |          |         
     811 | 2008-06-18 18:00:00-06 |          |         
     812 | 2008-06-18 18:00:00-06 |          |         
(10 rows)






 line_id |       start_date       |           radius_username            |                                    notes                                     
---------+------------------------+--------------------------------------+------------------------------------------------------------------------------
      38 | 2009-03-25 00:00:00-06 | 3123883734@uscc.net                  | 
      43 | 2008-01-11 00:00:00-07 | 7201111111@csctus.net                | Randy McClellan Testing
      50 | 2008-01-21 17:00:00-07 | 3122179638@uscc.net                  | Justice Obrey - Testing
      86 | 2008-01-29 17:00:00-07 | 3122177187@uscc.net                  | CSCT Denver - card swap 2/27/08
     341 | 2008-02-27 17:00:00-07 | 3122179758@uscc.net                  | Currently on trial with CSCT with possibility of becoming a reseller/partner
     807 | 2008-06-18 18:00:00-06 | 3123882024@uscc.net                  | TEC : replaced due to USCC billing plan change error. UAT testing update.
     808 | 2008-06-18 18:00:00-06 | 3123881862@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     809 | 2008-06-18 18:00:00-06 | 3123881861@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     811 | 2008-06-18 18:00:00-06 | 3123882027@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     812 | 2008-06-18 18:00:00-06 | 3123881821@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     818 | 2008-06-18 18:00:00-06 | 3123882032@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     819 | 2008-06-18 18:00:00-06 | 3123881883@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     824 | 2008-06-18 18:00:00-06 | 3123881920@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     825 | 2008-06-18 18:00:00-06 | 3123881956@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     829 | 2008-06-18 18:00:00-06 | 3123882038@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     835 | 2008-06-18 18:00:00-06 | 3123881795@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     839 | 2008-06-18 18:00:00-06 | 3123881785@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     842 | 2008-06-18 18:00:00-06 | 3123881892@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     843 | 2008-06-18 18:00:00-06 | 3123881844@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     844 | 2008-06-18 18:00:00-06 | 3123881837@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     845 | 2008-06-18 18:00:00-06 | 3123882018@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     851 | 2008-06-18 18:00:00-06 | 3123881890@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     855 | 2008-06-18 18:00:00-06 | 3123881865@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     856 | 2008-06-18 18:00:00-06 | 3123881869@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     876 | 2008-08-14 18:00:00-06 | 3123882083@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     880 | 2008-09-18 18:00:00-06 | 3123882101@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     881 | 2008-09-18 18:00:00-06 | 3123882184@uscc.net                  | 
     882 | 2008-09-18 18:00:00-06 | 3123882185@uscc.net                  | 
     885 | 2008-09-18 18:00:00-06 | 3123882193@uscc.net                  | 
     888 | 2008-09-18 18:00:00-06 | 3123882217@uscc.net                  | 
     891 | 2008-09-18 18:00:00-06 | 3123882135@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     894 | 2008-09-18 18:00:00-06 | 3123882134@uscc.net                  | TEC : replaced due to USCC billing plan change error.
     896 | 2008-09-18 18:00:00-06 | 3123882146@uscc.net                  | 
     915 | 2008-09-18 18:00:00-06 | 3123882118@uscc.net                  | TEC : replaced due to USCC billing plan change error.
    1467 | 2008-06-18 18:00:00-06 | 3123886106@uscc.net                  | TEC : replacement for USCC billing plan change error.
    1482 | 2008-06-18 18:00:00-06 | 3123886167@uscc.net                  | TEC : replacement for USCC billing plan change error.
    2565 | 2008-10-06 18:00:00-06 | 3122178352@contournetworks.net       | Randy testing airjack-1.0.12 code
    2595 | 2009-06-26 18:00:00-06 | 3123881791@uscc.net                  | Monitoring for TEC VRF
    3784 | 2009-08-13 18:00:00-06 | 3125469753@uscc.net                  | SO-281
    5646 | 2009-11-18 17:00:00-07 | 3123889205@uscc.net                  | SO-537
   12663 | 2010-07-22 18:00:00-06 | 3123883728@uscc.net                  | SO-01572
   13745 | 2010-09-12 18:00:00-06 | 6463164573@tsp18.sprintpcs.com       | MetroPCS Testing (MASS UPDATE 20110124)
   13746 | 2010-09-12 18:00:00-06 | 7199631144@tsp17.sprintpcs.com       | NON MetroPCS Testing (MASS UPDATE 20110124)
   16757 | 2011-01-23 17:00:00-07 | 6464182214@contournetworks.com       | MASS UPDATE 20110124
   18368 | 2010-12-31 17:00:00-07 |                                      | 
   36818 | 2014-01-21 17:00:00-07 |                                      | SO-8181
   36895 | 2014-01-28 17:00:00-07 |                                      | SO-8204
   36897 | 2014-01-28 17:00:00-07 |                                      | SO-8204
   36905 | 2014-01-28 17:00:00-07 |                                      | SO-8204
   36906 | 2014-01-28 17:00:00-07 |                                      | SO-8204
   36907 | 2014-01-28 17:00:00-07 |                                      | SO-8204
   39648 | 2014-08-06 18:00:00-06 | 882393253310308@m2m01.contournet.net | 
   39649 | 2014-08-06 18:00:00-06 | 882393253310307@m2m01.contournet.net | 
   39650 | 2014-08-06 18:00:00-06 | 882393253310306@m2m01.contournet.net | 
   39651 | 2014-08-06 18:00:00-06 | 882393253310305@m2m01.contournet.net | 
   46669 | 2018-04-16 18:00:00-06 | 5662086739@tsp17.sprintpcs.com       | SO-12169
(56 rows)





