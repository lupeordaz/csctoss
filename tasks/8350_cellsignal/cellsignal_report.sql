

select esn
      ,cellsignal
      ,substring(cellsignal,1,(locate(" ",cellsignal) - 1)) as signal_strength
      ,substring(cellsignal,(locate("(",cellsignal)+1)
                           ,((locate("%",cellsignal)) - (locate("(",cellsignal) + 1))) as signal_pct
      ,from_unixtime(timestamp)
  from cellsignal
 where timestamp between unix_timestamp('2018-07-01')
   and unix_timestamp('2018-07-31 23:59:59')
 order by esn, from_unixtime(timestamp) limit 2000;
 


select esn
      ,cellsignal       
      ,substring(cellsignal,1,(locate(" ",cellsignal) - 1)) as signal_strength       
      ,substring(cellsignal,(locate("(",cellsignal)+1)                            
                           ,((locate("%",cellsignal)) - (locate("(",cellsignal) + 1))) as signal_pct           
      ,from_unixtime(timestamp)   
  from cellsignal  
 where timestamp >= (SELECT CURRENT_DATE - INTERVAL 1 YEAR);
   and cellsignal <> 'No Signal'
  INTO '/tmp/cellsignal_strength.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
limit 200;


select esn
      ,cellsignal       
      ,substring(cellsignal,1,(locate(" ",cellsignal) - 1)) as signal_strength       
      ,substring(cellsignal,(locate("(",cellsignal)+1)                            
                           ,((locate("%",cellsignal)) - (locate("(",cellsignal) + 1))) as signal_pct           
      ,from_unixtime(timestamp)   
  from cellsignal  
 where from_unixtime(timestamp) BETWEEN (SELECT CURRENT_DATE - INTERVAL 1 YEAR) AND (SELECT CURRENT_DATE - INTERVAL 11 MONTH)
   and cellsignal <> 'No Signal';


select esn
      ,cellsignal       
      ,substring(cellsignal,1,(locate(" ",cellsignal) - 1)) as signal_strength       
      ,substring(cellsignal,(locate("(",cellsignal)+1)                            
                           ,((locate("%",cellsignal)) - (locate("(",cellsignal) + 1))) as signal_pct           
      ,from_unixtime(timestamp)   
  from cellsignal  
 where from_unixtime(timestamp) BETWEEN (SELECT CURRENT_DATE - INTERVAL 1 YEAR) AND (SELECT CURRENT_DATE - INTERVAL 11 MONTH)
   and cellsignal <> 'No Signal'
  INTO OUTFILE '/tmp/cellsignal_strength.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
 LINES TERMINATED BY '\n';



select esn
      ,cellsignal       
      ,substring(cellsignal,1,(locate(" ",cellsignal) - 1)) as signal_strength       
      ,substring(cellsignal,(locate("(",cellsignal)+1)                            
                           ,((locate("%",cellsignal)) - (locate("(",cellsignal) + 1))) as signal_pct           
      ,from_unixtime(timestamp)   
  from cellsignal  
 where from_unixtime(timestamp) >= (SELECT CURRENT_DATE - INTERVAL 1 YEAR)
   and cellsignal <> 'No Signal'
  INTO OUTFILE '/tmp/cellsignal_strength.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
 LINES TERMINATED BY '\n';


