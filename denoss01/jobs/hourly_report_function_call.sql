SELECT 
  CASE WHEN hour='Totals: ' 
    THEN hour ELSE lpad(hour,2,0) 
  END AS "Hr", 
  ar_count_spr AS "Admin Reset", 
  ne_count_spr AS "NAS Error", 
  ss_count_spr AS "Short Session", 
  this_space AS "--", 
  ar_count_usc AS "Admin Reset", 
  ne_count_usc AS "NAS Error", 
  ss_count_usc AS "Short Session ", 
  this_space AS "--", 
  ar_count_vzw AS "Admin Reset", 
  ne_count_vzw AS "NAS Error", 
  ss_count_vzw AS "Short Session " 
from csctoss.TERM_REQUEST_BY_HOUR_NEW(true);
