select CASE WHEN hour='Totals: ' THEN hour ELSE lpad(hour,2,'0') END as "Hr", ar_count_spr as "Admin Reset", ne_count_spr as "NAS Error", ss_count_spr as "Short Session",this_space as "--", ar_count_usc as "Admin Reset", ne_count_usc as "NAS Error", ss_count_usc as "Short Session" from csctoss.TERM_REQUEST_BY_HOUR();

