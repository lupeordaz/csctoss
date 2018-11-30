
csctoss=# select count(*) from ( select notes from line where notes NOT like 'SO%' ) as total;
 count 
-------
  2510
(1 row)

-- OSS
select *
  from line 
 where line_id = 43612
   and end_date is null;
 line_id | billing_entity_id |       start_date       | static_ip_address |  notes   

---------+-------------------+------------------------+-------------------+----------
   43612 |               577 | 2016-06-05 18:00:00-06 |                   | SO-10747
(1 row)


-- JBILL

jbilling=# select * from prov_line where line_id = 43612;
-[ RECORD 1 ]---+---------------------
id              | 78367
order_id        | 49604						**
item_id         | 5600
line_id         | 43612
esn_hex         | A100004387E0CE
username        | 4049893390@vzw3g.com
start_date      | 2016-06-06
end_date        | 
optlock         | 0
acct_start_date | 2016-06-19
archived        | 
renewed_id      | 
sn              | 945380
archived_date   | 
archived_reason | 


select * from purchase_order where id = 49604;
-[ RECORD 1 ]------+------------------------
id                 | 49604
user_id            | 1584
period_id          | 2
billing_type_id    | 2
active_since       | 2016-06-06
active_until       | 
cycle_start        | 2011-10-01
create_datetime    | 2016-06-03 15:08:29.973
next_billable_day  | 
created_by         | 2194
status_id          | 16
currency_id        | 1
deleted            | 0
notify             | 1
last_notified      | 
notification_step  | 
due_date_unit_id   | 3
due_date_value     | 
df_fm              | 0
anticipate_periods | 
own_invoice        | 0
notes              | 
notes_in_invoice   | 0
is_current         | 0
use_static         | 0
use_privatenetwork | 1
include_sales_tax  | 0
include_comm_tax   | 1
shipping_method    | UPS Ground
processor          | RBS World Pay
public_number      | SO-10747				**
optlock            | 0
tracking_num       | 
oss_synced         | 
renewal            | 
shipping_cost      | 

--

var_dblink_sql := '
	SELECT public_number 
	  FROM purchase_order 
	 WHERE id = (select order_id 
	 			   from prov_line 
	 			  WHERE esn_hex = '''||var_esn_hex||''' 
	 			    AND line_id = '''||var_line_id||''' 
	 			    and archived is null )'  ;



SELECT public_number 
  INTO var_so 
  FROM public.dblink(fetch_jbilling_conn(), var_dblink_sql) AS rec_type (public_number text) ;

SELECT public_number
  FROM dblink(fetch_jbilling_conn(),
  'SELECT public_number
     FROM purchase_order
    WHERE id = (select order_id
                  from prov_line
                 WHERE esn_hex = ''A000001F54BFF6''
                   AND line_id = ''21050''
                   and archived is null )') as rec_type (public_number text);

 public_number 
---------------
 SO-3345
(1 row)


--

psql -q \
     -t \
     -c \
"
SELECT public_number
  FROM dblink(fetch_jbilling_conn(),
  'SELECT public_number 
     FROM purchase_order 
    WHERE id = (select order_id 
                  from prov_line 
                 WHERE esn_hex = '''||var_esn_hex||''' 
                   AND line_id = '''||var_line_id||''' 
                   and archived is null )' AS rec_type (public_number text)
"



select l.line_id
      ,ui.value
  from line l
  join line_equipment le on le.line_id = l.line_id
  join unique_identifier ui on le.equipment_id = ui.equipment_id and ui.unique_identifier_type = 'ESN HEX'
 where l.notes NOT like 'SO%'
   and l.end_date is null
 order by 1;






Line Id:  65 ESN Hex:  | 37C6DFEC Shipping Order:


select po.public_number
  from prov_line pl
  join purchase_order po on po.id = pl.order_id
 WHERE pl.esn_hex = $ESN 
   and pl.line_id = $line_id





      38 | F613B906
      50 | 37C6DEBC
      86 | 37C6DFF0
      86 | 37C6DFF4
     341 | 37C6E006
     807 | F610D6C2
     808 | F610D728
     809 | F610D6F5
     811 | F610D6C4
     812 | F610D6E9
     818 | F610D725
     819 | F610D729
     824 | F610D6F8
     825 | F610D72D
     829 | F610D6B5
     835 | F610D706
     839 | F610D6E1
     842 | F610D6B7
     843 | F610D6F0
     844 | F610D71A
     845 | F610D707
     851 | F610D6FD
     855 | F610D6F7
     856 | F610D71E
     876 | F611BB7C
     880 | F611BC3E
     881 | F611BC14
     882 | F611BC2B
     885 | F611BBCA
     888 | F611BC16
     891 | F611BBA1
     894 | F611BC29
     896 | F611BC43
     915 | F611BBA2
    1467 | F6145174
    1482 | F61452C8
    2565 | 37C6DEB9
    2595 | F610D709
   13745 | 608293B7
   13746 | 608039A2
   16757 | 60804EA9

---

select line_id, end_date, notes 
  from line
 where line_id in (
38,
50,
86,
86,
341,
807,
808,
809,
811,
812,
818,
819,
824,
825,
829,
835,
839,
842,
843,
844,
845,
851,
855,
856,
876,
880,
881,
882,
885,
888,
891,
894,
896,
915,
1467,
1482,
2565,
2595,
13745,
16757);

 line_id | end_date |                                    notes                                     
---------+----------+------------------------------------------------------------------------------
      38 |          | 
      50 |          | Justice Obrey - Testing
      86 |          | CSCT Denver - card swap 2/27/08
     341 |          | Currently on trial with CSCT with possibility of becoming a reseller/partner
     807 |          | TEC : replaced due to USCC billing plan change error. UAT testing update.
     808 |          | TEC : replaced due to USCC billing plan change error.
     809 |          | TEC : replaced due to USCC billing plan change error.
     811 |          | TEC : replaced due to USCC billing plan change error.
     812 |          | TEC : replaced due to USCC billing plan change error.
     818 |          | TEC : replaced due to USCC billing plan change error.
     819 |          | TEC : replaced due to USCC billing plan change error.
     824 |          | TEC : replaced due to USCC billing plan change error.
     825 |          | TEC : replaced due to USCC billing plan change error.
     829 |          | TEC : replaced due to USCC billing plan change error.
     835 |          | TEC : replaced due to USCC billing plan change error.
     839 |          | TEC : replaced due to USCC billing plan change error.
     842 |          | TEC : replaced due to USCC billing plan change error.
     843 |          | TEC : replaced due to USCC billing plan change error.
     844 |          | TEC : replaced due to USCC billing plan change error.
     845 |          | TEC : replaced due to USCC billing plan change error.
     851 |          | TEC : replaced due to USCC billing plan change error.
     855 |          | TEC : replaced due to USCC billing plan change error.
     856 |          | TEC : replaced due to USCC billing plan change error.
     876 |          | TEC : replaced due to USCC billing plan change error.
     880 |          | TEC : replaced due to USCC billing plan change error.
     881 |          | 
     882 |          | 
     885 |          | 
     888 |          | 
     891 |          | TEC : replaced due to USCC billing plan change error.
     894 |          | TEC : replaced due to USCC billing plan change error.
     896 |          | 
     915 |          | TEC : replaced due to USCC billing plan change error.
    1467 |          | TEC : replacement for USCC billing plan change error.
    1482 |          | TEC : replacement for USCC billing plan change error.
    2565 |          | Randy testing airjack-1.0.12 code
    2595 |          | Monitoring for TEC VRF
   13745 |          | MetroPCS Testing (MASS UPDATE 20110124)
   13746 |          | NON MetroPCS Testing (MASS UPDATE 20110124)
   16757 |          | MASS UPDATE 20110124
(40 rows)

csctoss=# 

