--

select equipment_id
      ,value as min
  from unique_identifier ui
   where equipment_id = 22019
     and unique_identifier_type = 'MIN';
 equipment_id |       min       
--------------+-----------------
        22019 | 000009172339766
(1 row)

update unique_identifier
   set value = '$NEWMIN'
 where equipment_id = $EQUIPID
   and unique_identifier_type = 'MIN'
   AND value = '$CURRMIN';


update unique_identifier
   set value = '$NEWMDN'
 where equipment_id = $EQUIPID
   and unique_identifier_type = 'MDN'
   AND value = '$CURRMDN';




select equipment_id
      ,value as mdn
  from unique_identifier ui
   where equipment_id = 22019
     and unique_identifier_type = 'MDN';
 equipment_id |    mdn     
--------------+------------
        22019 | 9175310297
(1 row)

--

select l.line_id
      ,le.equipment_id
      ,l.radius_username
      ,uim.value as min
      ,uimd.value as mdn
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MIN'
  join unique_identifier uimd on le.equipment_id = uimd.equipment_id and uimd.unique_identifier_type = 'MDN'
 where le.equipment_id IN (22019,27705,39718,39722,20971) order by 2,1;

 line_id | equipment_id |        radius_username         |       min       |    mdn     
---------+--------------+--------------------------------+-----------------+------------
   15671 |        20971 |                                | 000009176871417 | 6466717109
   44214 |        20971 | 5776913546@tsp17.sprintpcs.com | 000009176871417 | 6466717109
   18283 |        22019 |                                | 000009172339766 | 9175310297
   43186 |        22019 | 5885670229@tsp18.sprintpcs.com | 000009172339766 | 9175310297
   26495 |        27705 |                                | 000009172044475 | 9172758450
   43187 |        27705 | 5885670231@tsp18.sprintpcs.com | 000009172044475 | 9172758450
   39945 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774875264      | 5774875264
   45808 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774875264      | 5774875264
   39959 |        39722 |                                | 000009132970828 | 5776927484
   41457 |        39722 | 5774956589@tsp17.sprintpcs.com | 000009132970828 | 5776927484
(10 rows)



./mdn_correct.sh 
START TIMESTAMP: 20181023180331
Username:  5885670229@tsp18.sprintpcs.com    Equip. Id.:  22019    Correct MDN/MIN:   5885670229 / 5885670229
Username:  5885670231@tsp18.sprintpcs.com    Equip. Id.:  27705    Correct MDN/MIN:   5885670231 / 5885670231
Username:  5774870902@tsp17.sprintpcs.com    Equip. Id.:  39718    Correct MDN/MIN:   5774870902 / 5774870902
Username:  5774956589@tsp17.sprintpcs.com    Equip. Id.:  39722    Correct MDN/MIN:   5774956589 / 5774956589
Username:  5776913546@tsp17.sprintpcs.com    Equip. Id.:  20971    Correct MDN/MIN:   5776913546 / 5776913546
Done!
[gordaz@cctlix03 8938_mdn_correction]$


 line_id | equipment_id |        radius_username         |       min       |     mdn      
---------+--------------+--------------------------------+-----------------+--------------
   15671 |        20971 |                                | 000009176871417 | 5776913546\r
   44214 |        20971 | 5776913546@tsp17.sprintpcs.com | 000009176871417 | 5776913546\r
   18283 |        22019 |                                | 000009172339766 | 5885670229\r
   43186 |        22019 | 5885670229@tsp18.sprintpcs.com | 000009172339766 | 5885670229\r
   26495 |        27705 |                                | 000009172044475 | 5885670231\r
   43187 |        27705 | 5885670231@tsp18.sprintpcs.com | 000009172044475 | 5885670231\r
   39945 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774870902      | 5774870902\r
   45808 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774870902      | 5774870902\r
   39959 |        39722 |                                | 000009132970828 | 5774956589\r
   41457 |        39722 | 5774956589@tsp17.sprintpcs.com | 000009132970828 | 5774956589\r
(10 rows)


2018-10-24 10:13:36 MDT 10.249.17.102(54782) csctoss_owner 28899 0LOG:  connection authorized: user=csctoss_owner database=csctoss
2018-10-24 10:13:36 MDT 10.249.17.102(54782) csctoss_owner 28899 5051209LOG:  statement: SELECT public.set_change_log_staff_id (3);
	             update unique_identifier
	                set value = '5885670229'
	              where equipment_id = 22019
	                and unique_identifier_type = 'MIN'
	                AND value = '9172339766'
2018-10-24 10:13:36 MDT 10.249.17.102(54782) csctoss_owner 28899 0LOG:  duration: 3.867 ms
2018-10-24 10:13:36 MDT 10.249.17.102(54782) csctoss_owner 28899 0LOG:  disconnection: session time: 0:00:00.01 user=csctoss_owner database=csctoss host=10.249.17.102 port=54782
2018-10-24 10:13:36 MDT  [unknown] 28900 0LOG:  connection received: host=10.249.17.102 port=54784
2018-10-24 10:13:36 MDT 10.249.17.102(54784) csctoss_owner 28900 0LOG:  connection authorized: user=csctoss_owner database=csctoss
2018-10-24 10:13:36 MDT 10.249.17.102(54784) csctoss_owner 28900 0FATAL:  unrecognized configuration parameter "application_name"
2018-10-24 10:13:36 MDT  [unknown] 28901 0LOG:  connection received: host=10.249.17.102 port=54786
2018-10-24 10:13:36 MDT 10.249.17.102(54786) csctoss_owner 28901 0LOG:  connection authorized: user=csctoss_owner database=csctoss
2018-10-24 10:13:36 MDT 10.249.17.102(54786) csctoss_owner 28901 5051211LOG:  statement: SELECT public.set_change_log_staff_id (3);
	             update unique_identifier
'	                set value = '5885670229
	              where equipment_id = 22019
	                and unique_identifier_type = 'MDN'
	                AND value = '9175310297'
2018-10-24 10:13:36 MDT 10.249.17.102(54786) csctoss_owner 28901 0LOG:  duration: 3.121 ms
2018-10-24 10:13:36 MDT 10.249.17.102(54786) csctoss_owner 28901 0LOG:  disconnection: session time: 0:00:00.01 user=csctoss_owner database=csctoss host=10.249.17.102 port=54786



Username:  5885670229@tsp18.sprintpcs.com    Equip. Id.:  22019    Correct MDN/MIN:   5885670229 / 5885670229

	             update unique_identifier
	                set value = '5885670229'
	              where equipment_id = 22019
	                and unique_identifier_type = 'MIN'
	                AND value = '9172339766'

--

select equipment_id, value as mdn
  from unique_identifier 
 where equipment_id in (22019,27705) 
   and unique_identifier_type = 'MDN';
 equipment_id |     mdn      
--------------+--------------
        22019 | 5885670229\r
        27705 | 5885670231\r
(2 rows)


select equipment_id, value as min
  from unique_identifier 
 where equipment_id in (22019,27705) 
   and unique_identifier_type = 'MIN';
 equipment_id |       min       
--------------+-----------------
        22019 | 5885670229
        27705 | 000009172044475
(2 rows)

[gordaz@cctlix03 8938_mdn_correction]$ . mdn_correct.sh 
START TIMESTAMP: 20181024113713
Username:  5885670229@tsp18.sprintpcs.com    Equip. Id.:  22019    Correct MDN/MIN:   5885670229 / 5885670229
Username:  5885670231@tsp18.sprintpcs.com    Equip. Id.:  27705    Correct MDN/MIN:   5885670231 / 5885670231
Done!
[gordaz@cctlix03 8938_mdn_correction]$ 


--

 equipment_id |    value     
--------------+--------------
        39718 | 5774870902\r
        39722 | 5774956589\r
        20971 | 5776913546\r
        22019 | 5885670229\r
        27705 | 5885670231\r
(5 rows)


select public.set_change_log_staff_id(3);

update unique_identifier set value = '' where equipment_id = 39718 and unique_identifier_type = 'MDN';
update unique_identifier set value = '5774870902' where equipment_id = 39718 and unique_identifier_type = 'MDN';

update unique_identifier set value = '' where equipment_id = 39722 and unique_identifier_type = 'MDN';
update unique_identifier set value = '5774956589' where equipment_id = 39722 and unique_identifier_type = 'MDN';


update unique_identifier set value = '' where equipment_id = 20971 and unique_identifier_type = 'MDN';
update unique_identifier set value = '5776913546' where equipment_id = 20971 and unique_identifier_type = 'MDN';

update unique_identifier set value = '' where equipment_id = 22019 and unique_identifier_type = 'MDN';
update unique_identifier set value = '5885670229' where equipment_id = 22019 and unique_identifier_type = 'MDN';

update unique_identifier set value = '' where equipment_id = 27705 and unique_identifier_type = 'MDN';
update unique_identifier set value = '5885670231' where equipment_id = 27705 and unique_identifier_type = 'MDN';


-- In production

[postgres@denoss01 8938]$ . mdn_correct.sh 
START TIMESTAMP: 20181024225030
Username:  5885670229@tsp18.sprintpcs.com    Equip. Id.:  22019    Correct MDN/MIN:   5885670229 / 5885670229
Username:  5885670231@tsp18.sprintpcs.com    Equip. Id.:  27705    Correct MDN/MIN:   5885670231 / 5885670231
Username:  5774870902@tsp17.sprintpcs.com    Equip. Id.:  39718    Correct MDN/MIN:   5774870902 / 5774870902
Username:  5774956589@tsp17.sprintpcs.com    Equip. Id.:  39722    Correct MDN/MIN:   5774956589 / 5774956589
Username:  5776913546@tsp17.sprintpcs.com    Equip. Id.:  20971    Correct MDN/MIN:   5776913546 / 5776913546
Username:  4704212393@vzw3g.com    Equip. Id.:  42149    Correct MDN/MIN:   8032924268 / 4704212393
Username:  4704212196@vzw3g.com    Equip. Id.:  42150    Correct MDN/MIN:   8032925096 / 4704212196
Username:  4704212208@vzw3g.com    Equip. Id.:  42151    Correct MDN/MIN:   8032925048 / 4704212208
Username:  4704212189@vzw3g.com    Equip. Id.:  42152    Correct MDN/MIN:   8032925128 / 4704212189
Username:  4704212172@vzw3g.com    Equip. Id.:  42153    Correct MDN/MIN:   8032925223 / 4704212172
Username:  4704212181@vzw3g.com    Equip. Id.:  42154    Correct MDN/MIN:   8032925177 / 4704212181
Username:  4704212185@vzw3g.com    Equip. Id.:  42155    Correct MDN/MIN:   8032925148 / 4704212185
Username:  4704212184@vzw3g.com    Equip. Id.:  42156    Correct MDN/MIN:   8032925149 / 4704212184
Username:  4704212203@vzw3g.com    Equip. Id.:  42159    Correct MDN/MIN:   8032925065 / 4704212203
Username:  4704212214@vzw3g.com    Equip. Id.:  42160    Correct MDN/MIN:   8032925020 / 4704212214
Username:  4704212191@vzw3g.com    Equip. Id.:  42161    Correct MDN/MIN:   8032925121 / 4704212191
Username:  4704212173@vzw3g.com    Equip. Id.:  42162    Correct MDN/MIN:   8032925219 / 4704212173
Username:  4704212218@vzw3g.com    Equip. Id.:  42165    Correct MDN/MIN:   8032925006 / 4704212218
Username:  4704212179@vzw3g.com    Equip. Id.:  42166    Correct MDN/MIN:   8032925186 / 4704212179
Username:  4704212221@vzw3g.com    Equip. Id.:  42167    Correct MDN/MIN:   8032924997 / 4704212221
Username:  4704212227@vzw3g.com    Equip. Id.:  42169    Correct MDN/MIN:   8032924979 / 4704212227
Username:  4704212228@vzw3g.com    Equip. Id.:  42170    Correct MDN/MIN:   8032924978 / 4704212228
Username:  4704212219@vzw3g.com    Equip. Id.:  42171    Correct MDN/MIN:   8032925003 / 4704212219
Username:  4704212222@vzw3g.com    Equip. Id.:  42172    Correct MDN/MIN:   8032924996 / 4704212222
Username:  4704212229@vzw3g.com    Equip. Id.:  42173    Correct MDN/MIN:   8032924977 / 4704212229
Username:  4704212322@vzw3g.com    Equip. Id.:  42174    Correct MDN/MIN:   8032924598 / 4704212322
Username:  4704212257@vzw3g.com    Equip. Id.:  42176    Correct MDN/MIN:   8032924832 / 4704212257
Username:  4704212315@vzw3g.com    Equip. Id.:  42177    Correct MDN/MIN:   8032924614 / 4704212315
Username:  4704212260@vzw3g.com    Equip. Id.:  42178    Correct MDN/MIN:   8032924819 / 4704212260
Username:  4704212301@vzw3g.com    Equip. Id.:  42179    Correct MDN/MIN:   8032924682 / 4704212301
Username:  4704212251@vzw3g.com    Equip. Id.:  42180    Correct MDN/MIN:   8032924861 / 4704212251
Username:  4704212247@vzw3g.com    Equip. Id.:  42181    Correct MDN/MIN:   8032924893 / 4704212247
Username:  4704212261@vzw3g.com    Equip. Id.:  42182    Correct MDN/MIN:   8032924818 / 4704212261
Username:  4704212241@vzw3g.com    Equip. Id.:  42183    Correct MDN/MIN:   8032924921 / 4704212241
Username:  4704212246@vzw3g.com    Equip. Id.:  42184    Correct MDN/MIN:   8032924895 / 4704212246
Username:  4704212252@vzw3g.com    Equip. Id.:  42185    Correct MDN/MIN:   8032924852 / 4704212252
Username:  4704212255@vzw3g.com    Equip. Id.:  42186    Correct MDN/MIN:   8032924839 / 4704212255
Username:  4704212256@vzw3g.com    Equip. Id.:  42188    Correct MDN/MIN:   8032924835 / 4704212256
Username:  4704212271@vzw3g.com    Equip. Id.:  42189    Correct MDN/MIN:   8032925419 / 4704212271
Username:  4704212288@vzw3g.com    Equip. Id.:  42191    Correct MDN/MIN:   8032924758 / 4704212288
Username:  4704212298@vzw3g.com    Equip. Id.:  42192    Correct MDN/MIN:   8032924703 / 4704212298
Username:  4704212297@vzw3g.com    Equip. Id.:  42193    Correct MDN/MIN:   8032924711 / 4704212297
Username:  4704212299@vzw3g.com    Equip. Id.:  42194    Correct MDN/MIN:   8032924701 / 4704212299
Username:  4704212308@vzw3g.com    Equip. Id.:  42196    Correct MDN/MIN:   8032924647 / 4704212308
Username:  4704212258@vzw3g.com    Equip. Id.:  42197    Correct MDN/MIN:   8032924831 / 4704212258
Username:  4704212275@vzw3g.com    Equip. Id.:  42198    Correct MDN/MIN:   8032925415 / 4704212275
Username:  4704212263@vzw3g.com    Equip. Id.:  42199    Correct MDN/MIN:   8032924812 / 4704212263
Username:  4704212407@vzw3g.com    Equip. Id.:  42200    Correct MDN/MIN:   8032922054 / 4704212407
Username:  4704212328@vzw3g.com    Equip. Id.:  42201    Correct MDN/MIN:   8032924586 / 4704212328
Username:  4704212343@vzw3g.com    Equip. Id.:  42202    Correct MDN/MIN:   8032924551 / 4704212343
Username:  4704212338@vzw3g.com    Equip. Id.:  42203    Correct MDN/MIN:   8032924565 / 4704212338
Username:  4704212347@vzw3g.com    Equip. Id.:  42204    Correct MDN/MIN:   8032924537 / 4704212347
Username:  4704212344@vzw3g.com    Equip. Id.:  42205    Correct MDN/MIN:   8032924548 / 4704212344
Username:  4704212362@vzw3g.com    Equip. Id.:  42206    Correct MDN/MIN:   8032924484 / 4704212362
Username:  4704212337@vzw3g.com    Equip. Id.:  42207    Correct MDN/MIN:   8032924572 / 4704212337
Username:  4704212368@vzw3g.com    Equip. Id.:  42208    Correct MDN/MIN:   8032924451 / 4704212368
Username:  4704212422@vzw3g.com    Equip. Id.:  42209    Correct MDN/MIN:   8032922002 / 4704212422
Username:  4704212391@vzw3g.com    Equip. Id.:  42210    Correct MDN/MIN:   8032924285 / 4704212391
Username:  4704212382@vzw3g.com    Equip. Id.:  42211    Correct MDN/MIN:   8032924342 / 4704212382
Username:  4704212381@vzw3g.com    Equip. Id.:  42212    Correct MDN/MIN:   8032924344 / 4704212381
Username:  4704212408@vzw3g.com    Equip. Id.:  42214    Correct MDN/MIN:   8032922051 / 4704212408
Username:  4704212413@vzw3g.com    Equip. Id.:  42215    Correct MDN/MIN:   8032922034 / 4704212413
Username:  4704212409@vzw3g.com    Equip. Id.:  42216    Correct MDN/MIN:   8032922049 / 4704212409
Username:  4704212394@vzw3g.com    Equip. Id.:  42218    Correct MDN/MIN:   8032924266 / 4704212394
Username:  4704212374@vzw3g.com    Equip. Id.:  42219    Correct MDN/MIN:   8032924402 / 4704212374
Username:  4704212421@vzw3g.com    Equip. Id.:  42220    Correct MDN/MIN:   8032922012 / 4704212421
Username:  4704212398@vzw3g.com    Equip. Id.:  42221    Correct MDN/MIN:   8032924216 / 4704212398
Username:  4704212329@vzw3g.com    Equip. Id.:  42222    Correct MDN/MIN:   8032924584 / 4704212329
Username:  4704212380@vzw3g.com    Equip. Id.:  42223    Correct MDN/MIN:   8032924372 / 4704212380
Username:  4704212386@vzw3g.com    Equip. Id.:  42224    Correct MDN/MIN:   8032924313 / 4704212386
Username:  4704212400@vzw3g.com    Equip. Id.:  42225    Correct MDN/MIN:   8032924194 / 4704212400
Username:  4704212373@vzw3g.com    Equip. Id.:  42226    Correct MDN/MIN:   8032924416 / 4704212373
Username:  4704212390@vzw3g.com    Equip. Id.:  42227    Correct MDN/MIN:   8032924289 / 4704212390
Username:  5668562785@tsp18.sprintpcs.com    Equip. Id.:  40134    Correct MDN/MIN:   5668562785 / 5668562785
Username:  5774871212@tsp17.sprintpcs.com    Equip. Id.:  25305    Correct MDN/MIN:   5774871212 / 5774871212
Done!

--
select l.line_id
      ,le.equipment_id
      ,l.radius_username
      ,uim.value as min
      ,uimd.value as mdn
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MIN'
  join unique_identifier uimd on le.equipment_id = uimd.equipment_id and uimd.unique_identifier_type = 'MDN'
 where le.equipment_id IN (22019,
27705,
39718,
39722,
20971,
42149,
42150,
42151,
42152,
42153,
42154,
42155,
42156,
42159,
42160,
42161,
42162,
42165,
42166,
42167,
42169,
42170,
42171,
42172,
42173,
42174,
42176,
42177,
42178,
42179,
42180,
42181,
42182,
42183,
42184,
42185,
42186,
42188,
42189,
42191,
42192,
42193,
42194,
42196,
42197,
42198,
42199,
42200,
42201,
42202,
42203,
42204,
42205,
42206,
42207,
42208,
42209,
42210,
42211,
42212,
42214,
42215,
42216,
42218,
42219,
42220,
42221,
42222,
42223,
42224,
42225,
42226,
42227,
40134,
25305) order by 2,1;

 line_id | equipment_id |        radius_username         |       min       |     mdn      
---------+--------------+--------------------------------+-----------------+--------------
   15671 |        20971 |                                | 000009176871417 | 5776913546\r
   44214 |        20971 | 5776913546@tsp17.sprintpcs.com | 000009176871417 | 5776913546\r
   18283 |        22019 |                                | 000009172339766 | 5885670229\r
   43186 |        22019 | 5885670229@tsp18.sprintpcs.com | 000009172339766 | 5885670229\r
   22536 |        25305 |                                | 000009174978259 | 5774871212\r
   46972 |        25305 | 5774871212@tsp17.sprintpcs.com | 000009174978259 | 5774871212\r
   26495 |        27705 |                                | 000009172044475 | 5885670231\r
   43187 |        27705 | 5885670231@tsp18.sprintpcs.com | 000009172044475 | 5885670231\r
   39945 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774870902      | 5774870902\r
   45808 |        39718 | 5774870902@tsp17.sprintpcs.com | 5774870902      | 5774870902\r
   39959 |        39722 |                                | 000009132970828 | 5774956589\r
   41457 |        39722 | 5774956589@tsp17.sprintpcs.com | 000009132970828 | 5774956589\r
   34674 |        40134 | 5668562785@tsp18.sprintpcs.com | 000009134873323 | 5668562785\r
   35278 |        40134 | 9178583243@tsp17.sprintpcs.com | 000009134873323 | 5668562785\r
   38315 |        40134 |                                | 000009134873323 | 5668562785\r
   44281 |        42149 | 4704212393@vzw3g.com           | 8032924268      | 4704212393\r
   44282 |        42150 | 4704212196@vzw3g.com           | 8032925096      | 4704212196\r
   44283 |        42151 | 4704212208@vzw3g.com           | 8032925048      | 4704212208\r
   44284 |        42152 | 4704212189@vzw3g.com           | 8032925128      | 4704212189\r
   44285 |        42153 | 4704212172@vzw3g.com           | 8032925223      | 4704212172\r
   44286 |        42154 | 4704212181@vzw3g.com           | 8032925177      | 4704212181\r
   44287 |        42155 | 4704212185@vzw3g.com           | 8032925148      | 4704212185\r
   44288 |        42156 | 4704212184@vzw3g.com           | 8032925149      | 4704212184\r
   44291 |        42159 | 4704212203@vzw3g.com           | 8032925065      | 4704212203\r
   44292 |        42160 | 4704212214@vzw3g.com           | 8032925020      | 4704212214\r
   44293 |        42161 | 4704212191@vzw3g.com           | 8032925121      | 4704212191\r
   44294 |        42162 | 4704212173@vzw3g.com           | 8032925219      | 4704212173\r
   44296 |        42165 | 4704212218@vzw3g.com           | 8032925006      | 4704212218\r
   44297 |        42166 | 4704212179@vzw3g.com           | 8032925186      | 4704212179\r
   44298 |        42167 | 4704212221@vzw3g.com           | 8032924997      | 4704212221\r
   44299 |        42169 | 4704212227@vzw3g.com           | 8032924979      | 4704212227\r
   44300 |        42170 | 4704212228@vzw3g.com           | 8032924978      | 4704212228\r
   44301 |        42171 | 4704212219@vzw3g.com           | 8032925003      | 4704212219\r
   44302 |        42172 | 4704212222@vzw3g.com           | 8032924996      | 4704212222\r
   44303 |        42173 | 4704212229@vzw3g.com           | 8032924977      | 4704212229\r
   44304 |        42174 | 4704212322@vzw3g.com           | 8032924598      | 4704212322\r
   44305 |        42176 | 4704212257@vzw3g.com           | 8032924832      | 4704212257\r
   44306 |        42177 | 4704212315@vzw3g.com           | 8032924614      | 4704212315\r
   44307 |        42178 | 4704212260@vzw3g.com           | 8032924819      | 4704212260\r
   44308 |        42179 | 4704212301@vzw3g.com           | 8032924682      | 4704212301\r
   44309 |        42180 | 4704212251@vzw3g.com           | 8032924861      | 4704212251\r
   44310 |        42181 | 4704212247@vzw3g.com           | 8032924893      | 4704212247\r
   44311 |        42182 | 4704212261@vzw3g.com           | 8032924818      | 4704212261\r
   44312 |        42183 | 4704212241@vzw3g.com           | 8032924921      | 4704212241\r
   44313 |        42184 | 4704212246@vzw3g.com           | 8032924895      | 4704212246\r
   44314 |        42185 | 4704212252@vzw3g.com           | 8032924852      | 4704212252\r
   44315 |        42186 | 4704212255@vzw3g.com           | 8032924839      | 4704212255\r
   44317 |        42188 | 4704212256@vzw3g.com           | 8032924835      | 4704212256\r
   44318 |        42189 | 4704212271@vzw3g.com           | 8032925419      | 4704212271\r
   44319 |        42191 | 4704212288@vzw3g.com           | 8032924758      | 4704212288\r
   44320 |        42192 | 4704212298@vzw3g.com           | 8032924703      | 4704212298\r
   44321 |        42193 | 4704212297@vzw3g.com           | 8032924711      | 4704212297\r
   44322 |        42194 | 4704212299@vzw3g.com           | 8032924701      | 4704212299\r
   44324 |        42196 | 4704212308@vzw3g.com           | 8032924647      | 4704212308\r
   44325 |        42197 | 4704212258@vzw3g.com           | 8032924831      | 4704212258\r
   44326 |        42198 | 4704212275@vzw3g.com           | 8032925415      | 4704212275\r
   44327 |        42199 | 4704212263@vzw3g.com           | 8032924812      | 4704212263\r
   44328 |        42200 | 4704212407@vzw3g.com           | 8032922054      | 4704212407\r
   44329 |        42201 | 4704212328@vzw3g.com           | 8032924586      | 4704212328\r
   44330 |        42202 | 4704212343@vzw3g.com           | 8032924551      | 4704212343\r
   44331 |        42203 | 4704212338@vzw3g.com           | 8032924565      | 4704212338\r
   44332 |        42204 | 4704212347@vzw3g.com           | 8032924537      | 4704212347\r
   44333 |        42205 | 4704212344@vzw3g.com           | 8032924548      | 4704212344\r
   44334 |        42206 | 4704212362@vzw3g.com           | 8032924484      | 4704212362\r
   44335 |        42207 | 4704212337@vzw3g.com           | 8032924572      | 4704212337\r
   44336 |        42208 | 4704212368@vzw3g.com           | 8032924451      | 4704212368\r
   44337 |        42209 | 4704212422@vzw3g.com           | 8032922002      | 4704212422\r
   44338 |        42210 | 4704212391@vzw3g.com           | 8032924285      | 4704212391\r
   44339 |        42211 | 4704212382@vzw3g.com           | 8032924342      | 4704212382\r
   44340 |        42212 | 4704212381@vzw3g.com           | 8032924344      | 4704212381\r
   44341 |        42214 | 4704212408@vzw3g.com           | 8032922051      | 4704212408\r
   44342 |        42215 | 4704212413@vzw3g.com           | 8032922034      | 4704212413\r
   44343 |        42216 | 4704212409@vzw3g.com           | 8032922049      | 4704212409\r
   44344 |        42218 | 4704212394@vzw3g.com           | 8032924266      | 4704212394\r
   44345 |        42219 | 4704212374@vzw3g.com           | 8032924402      | 4704212374\r
   44346 |        42220 | 4704212421@vzw3g.com           | 8032922012      | 4704212421\r
   44347 |        42221 | 4704212398@vzw3g.com           | 8032924216      | 4704212398\r
   44348 |        42222 | 4704212329@vzw3g.com           | 8032924584      | 4704212329\r
   44349 |        42223 | 4704212380@vzw3g.com           | 8032924372      | 4704212380\r
   44350 |        42224 | 4704212386@vzw3g.com           | 8032924313      | 4704212386\r
   44351 |        42225 | 4704212400@vzw3g.com           | 8032924194      | 4704212400\r
   44352 |        42226 | 4704212373@vzw3g.com           | 8032924416      | 4704212373\r
   44353 |        42227 | 4704212390@vzw3g.com           | 8032924289      | 4704212390\r
(83 rows)

