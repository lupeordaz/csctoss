csctoss=# \d location_labels
                Table "csctoss.location_labels"
  Column   |       Type        |           Modifiers           
-----------+-------------------+-------------------------------
 line_id   | integer           | not null
 owner     | character varying | default ''::character varying
 id        | character varying | 
 name      | character varying | default ''::character varying
 address   | character varying | default ''::character varying
 processor | character varying | default ''::character varying
 fwver     | character varying | 
 uptime    | integer           | 
Indexes:
    "location_labels_pk" PRIMARY KEY, btree (line_id)




\d location_labels_vw;
          View "csctoss.location_labels_vw"
       Column        |       Type        | Modifiers 
---------------------+-------------------+-----------
 billing_entity_id   | integer           | 
 billing_entity_name | text              | 
 line_id             | integer           | 
 owner               | character varying | 
 id                  | character varying | 
 name                | character varying | 
 address             | character varying | 
 processor           | character varying | 
 fwver               | character varying | 
 uptime              | integer           | 

csctoss=#





beid,bename,lineid,owner,id,name,address,processor,fwver
4,BancGroup Mortgage Corporation - Buffalo Grove,76,Unassigned,,,,,


$LINEID|$OWNER|$ID|$NAME|$ADDRESS|$PROCSSOR|$FWVER


select *
  from location_labels ll 
  join line l on l.line_id = ll.line_id
  join billing_entity be on l.billing_entity_id = be.billing_entity_id
 where be.billing_entity_id = 699;


--
select * from location_labels where line_id in (
47175,
47256,
47052,
44837,
44859,
47229,
44861,
46279,
44880,
47257)
 line_id |                          owner                           |           id            |             name              |                   address                    |         processor         |   fwver 
  | uptime 
---------+----------------------------------------------------------+-------------------------+-------------------------------+----------------------------------------------+---------------------------+---------
--+--------
   47175 | MetroCom Bleibel                                         |                         |                               |                                              |                           |         
  |       
   47052 | Sirivan Sisouvong, (718) 497-2407                        | Union Beer              | Union Beer                    | 46 Meadowlands Pkwy, Hudson, NJ 07094        | CorPoint                  |         
  |       
   44837 | Akinade Adebukola                                        | Fixlinks Technology LLC | Fixlinks Technology LLC       | 8627 Liberty St, Randallstown, MD            | Fiserv                    | 5.2.17.1
2 |       
   44859 | SAMUEL HERNANDEZ MALDONADO; 415-309-5544                 | CA1301                  | MI RANCHO MARKET CORPORATION  | 90 BELVERDE ST, SAN RAFAEL, CA 94901         | TransFast Remittance, LLC |         
  |       
   47229 | Kevin Tang 562-577-2824                                  | Sectran Security        | Sectran Security              | 3130 Venture Dr, Las Vegas, NV 89101         | Sectran Security          |         
  |       
   44861 | ARLENE SISON 323-335-8652                                | CA1569                  | ALAS CARGO LLC (5)            | 627 N VERMONT AVE, LOS ANGELES,CA 90004      | TransFast Remittance, LLC |         
  |       
   46279 | Bernardo Brea                                            | CMCS Services LLC       | CMCS Services LLC             | 1535 Westchester Ave, Bronx, NY 10472        |                           |         
  |       
   44880 | CARMELITA SUNGA/ELSA CUSTODIO: 626-820-8870/626-820-8871 | CA1592                  | ALAS CARGO LLC (7)            | 1512 E AMAR RD UNIT D, WEST COVINA, CA 91792 | TransFast Remittance, LLC |         
  |       
(8 rows)

[gordaz@cctlix03 9215_update_locations_labels]$ ./9215_updates.sh testdata.txt 
UPDATE 1
UPDATE 0
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 0
[gordaz@cctlix03 9215_update_locations_labels]$ 

 line_id |                          owner                           |           id            |          name           |                   address                    |         processor         |  fwver  | upti
me 
---------+----------------------------------------------------------+-------------------------+-------------------------+----------------------------------------------+---------------------------+---------+-----
---
   47175 | MetroCom Bleibel                                         |                         | TBD                     |                                              |                           | Managed |     
  
   47052 | Sirivan Sisouvong, (718) 497-2407                        | Union Beer              | Union Beer              | 46 Meadowlands Pkwy, Hudson, NJ 07094        | CorPoint                  | Managed |     
  
   44837 | Akinade Adebukola, (301) 919-5909                        | MD0165                  | Fixlinks Technology LLC | 8627 Liberty St, Randallstown, MD            | Fiserv                    | Managed |     
  
   44859 | Alex Tullo, (551) 427-6183                               | Flying T                | Flying T Truck Stop     | 1 North Hackensack Ave, Kearny, NJ 07032     | TransFast Remittance, LLC | Managed |     
  
   47229 | Alex Williams                                            | Hammer Williams Company | Hammer Williams Company | 3001 N 14th St, Ponca City, OK 74601         | Sectran Security          | Managed |     
  
   44861 | ARLENE SISON 323-335-8652                                | CA1569                  | ALAS CARGO LLC (5)      | 627 N VERMONT AVE, LOS ANGELES,CA 90004      | TransFast Remittance, LLC | Managed |     
  
   46279 | Bernardo Brea, (347) 218-9242                            | 2454                    | CMCS Services LLC       | 1535 Westchester Ave, Bronx, NY 10472        |                           | Managed |     
  
   44880 | CARMELITA SUNGA/ELSA CUSTODIO: 626-820-8870/626-820-8871 | CA1592                  | ALAS CARGO LLC (7)      | 1512 E AMAR RD UNIT D, WEST COVINA, CA 91792 | TransFast Remittance, LLC | Managed |     
  
(8 rows)

--

./9215_updates.sh newPipe.txt denoss01.contournetworks.net

[gordaz@cctlix03 9215_update_locations_labels]$ ./9215_updates.sh newPipe.txt denoss01.contournetworks.net
denoss01.contournetworks.net
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
UPDATE 1
[gordaz@cctlix03 9215_update_locations_labels]$ 

line_id   | integer           | not null
owner     | character varying | default ''::character varying
id        | character varying | 
name      | character varying | default ''::character varying
address   | character varying | default ''::character varying
processor | character varying | default ''::character varying
fwver    

select line_id  
      ,owner    
      ,id       
      ,name     
      ,address  
      ,processor
      ,fwver   
  from location_labels 
 where line_id in (
47175,
47256,
47052,
44837,
44859,
47229,
44861,
46279,
44880,
47257,
47258,
47259,
44872,
44881,
47176,
44873,
46261,
46262,
46683,
44889,
46271,
44843,
44844,
44892,
44867,
46278,
44862,
44884,
46272,
46277,
44890,
44886,
46426,
46740,
44848,
44853,
44842,
46267,
44847,
44866,
44838,
44894,
44883,
46789,
44877,
44891,
46276,
47178,
47148,
47172,
47173,
47177,
44845,
44840,
44878,
44864,
46688,
46269,
47088,
47147,
46750,
46751,
46752,
46753,
44876,
44893,
46260,
44863,
44849,
44839,
44885,
46274,
44855,
44879,
44874,
44887,
44851,
44865,
44835,
44857,
47087,
44870,
44846,
44856,
44869,
46275,
44852,
44871,
44882,
47310,
47311,
47312,
46641,
46270,
47146,
44858,
46672,
46266,
46268,
44850,
44868,
47038,
44836,
47282,
47283,
44841,
46273,
44860,
44875,
38559,
38560,
44854,
45502,
46429);

 line_id |                                             owner                                              |                                 id                                  |                                na
me                                 |                                      address                                       |         processor          |  fwver  
---------+------------------------------------------------------------------------------------------------+---------------------------------------------------------------------+----------------------------------
-----------------------------------+------------------------------------------------------------------------------------+----------------------------+---------
   47175 | MetroCom Bleibel                                                                               |                                                                     | TBD                              
                                   |                                                                                    |                            | Managed
   47256 | Alex Williams                                                                                  | Hammer Williams Company                                             | TBD                              
                                   | 3001 N 14th St, Pnca City, OK 74601                                                | CorPoint                   | Managed
   47052 | Sirivan Sisouvong, (718) 497-2407                                                              | Union Beer                                                          | Union Beer                       
                                   | 46 Meadowlands Pkwy, Hudson, NJ 07094                                              | CorPoint                   | Managed
   44837 | Akinade Adebukola, (301) 919-5909                                                              | MD0165                                                              | Fixlinks Technology LLC          
                                   | 8627 Liberty St, Randallstown, MD                                                  | Fiserv                     | Managed
   44859 | Alex Tullo, (551) 427-6183                                                                     | Flying T                                                            | Flying T Truck Stop              
                                   | 1 North Hackensack Ave, Kearny, NJ 07032                                           | TransFast Remittance, LLC  | Managed
   47229 | Alex Williams                                                                                  | Hammer Williams Company                                             | Hammer Williams Company          
                                   | 3001 N 14th St, Ponca City, OK 74601                                               | Sectran Security           | Managed
   44861 | ARLENE SISON 323-335-8652                                                                      | CA1569                                                              | ALAS CARGO LLC (5)               
                                   | 627 N VERMONT AVE, LOS ANGELES,CA 90004                                            | TransFast Remittance, LLC  | Managed
   46279 | Bernardo Brea, (347) 218-9242                                                                  | 2454                                                                | CMCS Services LLC                
                                   | 1535 Westchester Ave, Bronx, NY 10472                                              |                            | Managed
   44880 | CARMELITA SUNGA/ELSA CUSTODIO: 626-820-8870/626-820-8871                                       | CA1592                                                              | ALAS CARGO LLC (7)               
                                   | 1512 E AMAR RD UNIT D, WEST COVINA, CA 91792                                       | TransFast Remittance, LLC  | Managed
   47257 | Choice Money- Undeployed                                                                       | Choice Money- Undeployed                                            | Choice Money- Undeployed         
                                   | Choice Money- Undeployed                                                           |                            | Managed
   47258 | Choice Money- Undeployed                                                                       | Choice Money- Undeployed                                            | Choice Money- Undeployed         
                                   | Choice Money- Undeployed                                                           |                            | Managed
   47259 | Choice Money- Undeployed                                                                       | Choice Money- Undeployed                                            | Choice Money- Undeployed         
                                   | Choice Money- Undeployed                                                           |                            | Managed
   44872 | Christopher Shock, (415) 559-3101                                                              | Brooklyn                                                            | HNY Ferry, LLC                   
                                   | 63 Flushing Ave, Brooklyn, NY, 11205  (415) 559-3101                               |                            | Managed
   44881 | Christopher Shock, (415) 559-3101                                                              | Wall Street                                                         | HNY Ferry, LLC                   
                                   | 110 Wall St, New York, NY 10005 (415) 559-3101                                     |                            | Managed
   47176 | Christopher Stang 972.392.6220                                                                 | Howard Hughes - Pier 17                                             | Howard Hughes - Pier 17          
                                   | 89 South St, Pier 17, F Bldg, New York, NY 10038                                   |                            | Managed
   44873 | CINTHIA NOHEMEY/ DINA LIQUEZ; 718-314-4574                                                     | NY1864                                                              | MULTI SERVICES JIREH CORP        
                                   | 507 39TH ST , BROOKLYN, NY 11232                                                   | TransFast Remittance, LLC  | Managed
   46261 | Claudia Arenas, (908) 598-1999                                                                 | NJ0788                                                              | Carenas Multiservice LLC         
                                   | 1 Ashwood Ave, Summit, NJ                                                          | Fiserv                     | Managed
   46262 | Claudia Arenas, (908) 598-1999                                                                 | 884                                                                 | Carenas Multiservice LLC         
                                   | 1 Ashwood Ave, Summit, NJ                                                          | Fiserv                     | Managed
   46683 | Daniel Grgornic                                                                                | Audemars Piguet - Bal Harbour                                       | Audemars Piguet - Bal Harbour    
                                   | 9700 Collins Ave, Bal Harbour, Florida, 33154                                      | Audemars Piguet            | Managed
   44889 | Daniel Ibarra - 214.274.2006                                                                   | LAU004                                                              | LA Union 4 LLC                   
                                   | 621 N Moore Ave, Moore, OK 73160                                                   |                            | Managed
   46271 | Dioni Gomez, (631) 727-3715                                                                    | 1460                                                                | Riverhead International Calling C
enter Inc                          | 74 W Main St, Riverhead, NY 11901                                                  |                            | Managed
   44843 | EDIS M RODRIGUEZ; 805-407-3951                                                                 | CA1183                                                              | SIERRA CC SALES                  
                                   | 550 S BROADWAY, LOS ANGELES, CA 90013                                              | TransFast Remittance, LLC  | Managed
   44844 | "EFREN HERRERA (OWNER)/IVETT HERRERA    484.319.1473 / 484.319.1800"                           | PA0332                                                              | Los Alquisiras Inc               
                                   | "501 E Gay St   West Chester    PA      19380"                                     | TransFast Remittance, LLC  | Managed
   44892 | EFREN HERRERA (OWNER)/IVETT HERRERA, 484.319.1473 / 484.319.1800                               | PA0332                                                              | Los Alquisiras Inc               
                                   | 501 E Gay St., West Chester, PA 19380                                              | TransFast Remittance, LLC  | Managed
   44867 | Eleno Ramos ;203-487-0436                                                                      | 2141                                                                | Marinero Cargo LLC               
                                   | "809 E Main St  Stamford        CT      06902"                                     | Choice Money Transfer, Inc | Managed
   46278 | Eleno Ramos, (203) 614-8936                                                                    | 2308                                                                | Pronto Professional Services Inc 
                                   | 83 Stillwater Ave, Stamford, Connecticut 06902                                     |                            | Managed
   44862 | ETHEL FRANCISCO / TESS CRUZ / MELANIE CASTILLO: 951-485-1095/ 951-443-5232                     | CA0701                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 24021 ALESSANDRO BLVD., #103 A, MORENO VALLEY, CA 92553                            | TransFast Remittance, LLC  | Managed
   44884 | FELIX ALFREDO VAZQUEZ; 408-427-5113                                                            | CA0350                                                              | LA PLACITA                       
                                   | 7822 MONTEREY ST, GILROY, CA 95020,                                                | TransFast Remittance, LLC  | Managed
   46272 | Felix Gutierrez, (973) 754-1200                                                                | NY0515                                                              | Gutierrez Money Transfer Inc II  
                                   | 70 Lexington Ave, Passaic, NJ 07055                                                |                            | Managed
   46277 | Felix Gutierrez, (973) 754-1200                                                                | NJ0515                                                              | Gutierrez Money Transfer Inc     
                                   | 359 Grand St, 2 Fl, Paterson, NJ 07505                                             |                            | Managed
   44890 | Fernando Ibarra - 214.236.5245                                                                 | LAU006                                                              | LA Union 6 LLC                   
                                   | "1 SE 59th St,  Oklahoma City,  OK      73129"                                     |                            | Managed
   44886 | Franklyn Arcos, (973) 732-5151                                                                 | 2622                                                                | Costamar Express Multiservices In
c                                  | 204 Ferry St, Newark, NJ                                                           | Fiserv                     | Managed
   46426 | GABRIEL NICHOLE CABRITO 310-834-4384/310-834-4384                                              | CA1566                                                              | ALAS CARGO LLC                   
                                   | 117 E 223RD ST, CARSON, CA 90745                                                   | TransFast Remittance, LLC  | Managed
   46740 | Hank Dalrymple, (607) 738-2124                                                                 | Seneca Stone                                                        | Seneca Stone Corporation         
                                   | 2747 County Rd 121, Seneca Falls, NY, 13148                                        | CorPoint                   | Managed
   44848 | IBETH ARRIAGA / MARIA MARTINEZ; 818-481-99-11                                                  | CA0568                                                              | BETSY STORE                      
                                   | 24313 MAIN ST, NEWHALL, CA 91321                                                   | TransFast Remittance, LLC  | Managed
   44853 | IBRAHEIM BERNAL; 510-693-0455                                                                  | CA0695                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 31840 ALVARADO BLVD. UNIT 100, UNION CITY, CA 94587                                | TransFast Remittance, LLC  | Managed
   44842 | JAMINE NARIO / EDRALIN HERNANDEZ; 858-653-3818                                                 | CA1021                                                              | ATLAS EXPRESS PADALA INC         
                                   | 8955-A MIRA MESA BLVD, SAN DIEGO, CA 92126                                         | TransFast Remittance, LLC  | Managed
   46267 | Jeffery Moreno, (203) 261-3123                                                                 | Wheels of CT - Southbury                                            | Wheels of CT - Southbury         
                                   | 1411 Soutford RD, Southbury, CT                                                    | Fiserv                     | Managed
   44847 | JENNILYN SINGSON/NANCY CHUA 562-809-5070                                                       | CA1584                                                              | ALAS CARGO                       
                                   | 18933 NORWALK BLVD, ARTESIA, CA 90701                                              | TransFast Remittance, LLC  | Managed
   44866 | Jorge Santoyo - 405.213.8308/ 405.535.6759                                                     | LAU005                                                              | LA Union 5 LLC                   
                                   | 4475 NW 50th, Oklahoma City, OK 73127                                              |                            | Managed
   44838 | Jose A Gonzalez, (201) 864-2226                                                                | RUM1                                                                | Unexpress                        
                                   | 1905 Bergenline Ave Union City, NJ 07087                                           |                            | Managed
   44894 | Jose Felipe Castro, (212) 828-3311                                                             | 2822                                                                | Danielito Business Services Inc  
                                   | 2124 2nd Ave, New York, NY                                                         | Fiserv                     | Managed
   44883 | Jose Ibarra - 539.777.2014                                                                     |  LAU000                                                             | LA Union Corp                    
                                   | 4704 NW 23rd St, Oklahoma City, OK 73127                                           |                            | Managed
   46789 | Joseph Abdallah, (917) 755-2422                                                                | Conduit Laundry Inc - Springfield Gardens                           | Conduit Laundry Inc - Springfield
 Gardens                           | 219-03 N. Conduit Ave, Springfield Gardens, New York 11413                         | CorPoint                   | Managed
   44877 | JUDITH CRUZ; 707-319-4085                                                                      | CA0696                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 3495-C SONOMA BLVD., VALLEJO, CA 94590                                             | TransFast Remittance, LLC  | Managed
   44891 | Kanoly Martinez (347) 590-6490                                                                 | 2687                                                                | M&K Multiservice Corp            
                                   | 87 W Fordham Rd Bronx NY 10468                                                     | Choice Money Transfer, Inc | Managed
   46276 | Karen Camacho, (914) 964-6969                                                                  | 1869                                                                | Pago Express                     
                                   | 366 S Broadway, Yonkers, NY 10705                                                  |                            | Managed
   47178 | Kevin Tang, 562.577.2824                                                                       | SecTran Security                                                    | SecTran Security                 
                                   | 3130 Venture Dr, Las Vegas, NV, 89101                                              |                            | Managed
   47148 | Khalid Bleibel, (714) 583-3737                                                                 | Metrocom Bleibel - Hoook Blvd                                       | Metrocom Bleibel - Hook Blvd     
                                   | 15362 Hook Blvd, Victorvile, CA 92394                                              |                            | Managed
   47172 | Khalid Bleibel, (714) 583-3737                                                                 | Metrocom Bleibel - Compton                                          | Metrocom Bleibel - Compton       
                                   | 1550 W RosenCrans Ave, Compton, CA 90220                                           |                            | Managed
   47173 | Khalid Bleibel, (714) 583-3737                                                                 | Metrocom Bleibel - Hesperia                                         | Metrocom Bleibel - Hesperia      
                                   | 15461 Main Street, Hesperia, CA, 92345                                             |                            | Managed
   47177 | Khalid Bleibel, (714) 583-3737                                                                 | Metrocom Bleibel -  Mariposa Rd                                     | Metrocom Bleibel -  Mariposa Rd  
                                   | 12253 Mariposa Rd, Victorville, CA 92395                                           |                            | Managed
   44845 | LISIENI PUSPO: 215-755-5094                                                                    | PA0164                                                              | FRIENDLY WHOLESALE LLC           
                                   | 1515 MORRIS ST, PHILADELPHIA, PA 19145                                             | TransFast Remittance, LLC  | Managed
   44840 | Luis F Ortiz, (204) 487-1018                                                                   | RIN2                                                                | Rinconcito Musical Corp II       
                                   | 340 Main St, Hackensack, NJ                                                        | Fiserv                     | Managed
   44878 | "Luz Dari Zapata        973-361-1702"                                                          | 875                                                                 | Dover Discount                   
                                   | "23 W Blackwell St      Dover   NJ      07801"                                     | Choice Money Transfer, Inc | Managed
   44864 | Magda Higuera: 718-821-1870                                                                    | 599                                                                 | Knickerbocker Multiservices      
                                   | 683 Knickerbocker Ave, Brooklyn, NY 11221                                          | Choice Money Transfer, Inc | Managed
   46688 | Marty Hendrickson                                                                              | DEMO UNIT                                                           | DEMO UNIT                        
                                   | Tidel Engineering: 2025 West Belt Line Rd. Carrollton, TX 75006 US (United States) |                            | Managed

   46269 | Mauricio Gomez, (305) 371-8833                                                                 | 2960                                                                | Centro Envios Inc                
                                   | 255 E Flagler St Ste 100, Miami, FL                                                | Fiserv                     | Managed
   47088 | Michael Schmitt (540)379-4425                                                                  | CanMedLabs - Irvine                                                 | CanMedLabs - Irvine              
                                   | 32 Mauchly Ste A, Irvine CA 92618-2336                                             |                            | Managed
   47147 | Michael Schmitt (540)379-4425                                                                  | CanMedLabs - Sacramento                                             | CanMedLabs - Sacramento          
                                   | 8735 FOLSOM BLVD,SACRAMENTO CA 95826                                               |                            | Managed
   46750 | Miguel Quezada, (516) 333-6454                                                                 | Westbury Meat Market - Westbury                                     | Westbury Meat Market - Westbury  
                                   | 595 Old Country Rd, Westbury, New York 11590                                       | CorPoint                   | Managed
   46751 | Miguel Quezada, (516) 333-6454                                                                 | Westbury Meat Market - Woodside                                     | Westbury Meat Market - Woodside  
                                   | 61-10 Queens Blvd, Woodside, New York, 11377                                       | CorPoint                   | Managed
   46752 | Miguel Quezada, (516) 333-6454                                                                 | Westbury Meat Market - Jamaica                                      | Westbury Meat Market - Jamaica   
                                   | 108-30 Merrick Blvd, Jamaica, New York 11433                                       | CorPoint                   | Managed
   46753 | Miguel Quezada, (516) 333-6454                                                                 | Westbury Meat Market - Staten Island                                | Westbury Meat Market - Staten Isl
and                                | 244 Arden Ave, Staten Island, New York, 10312                                      | CorPoint                   | Managed
   44876 | Miguela Almonte, 908-265-4863                                                                  | 3287                                                                | International Multiservices - Atl
anta                               | 4166 Buford Hwy NE Ste B5, Atlanta, Georgia 30345-1081                             | CorPoint                   | Managed
   44893 | Miguela Almonte, 908-265-4863                                                                  | 3288                                                                | International Multiservices - Tuc
ker                                | 3210 Tucker Norcross Rd, Suite D, Tucker, Georgia 30084-2126                       | CorPoint                   | Managed
   46260 | Miguela Almonte, 908-265-4863                                                                  | 3289                                                                | International Multiservices - Mar
ietta                              | 641 S Marietta Pkwy SE, Marietta, Georgia 30060-2748                               | CorPoint                   | Managed
   44863 | "Mody Mamadou   718-783-8811"                                                                  | 248                                                                 | Kawral Fouta Business            
                                   | "1182 Fulton St Brooklyn        NY      11216"                                     | Choice Money Transfer, Inc | Managed
   44849 | "MONICA ALARCON / HERNAN HERRERA        484-5298905/610-5078108"                               | PA0089                                                              | Mundo Latino Services            
                                   | "610 Greenwich St, Suite 634    Reading PA      19601"                             | TransFast Remittance, LLC  | Managed
   44839 | MONIQUE GUEVARRA; 408-254-9297                                                                 | CA1266                                                              | ATLAS EXPRESS PADALA INC         
                                   | 1535 LANDESS AVENUE SUITE #101, MILPITAS, CA 95035                                 | TransFast Remittance, LLC  | Managed
   44885 | MONIQUE GUEVARRA; 408-254-9297                                                                 | CA0694                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 3065 MCKEE ROAD , SAN JOSE, CA 95127                                               | TransFast Remittance, LLC  | Managed
   46274 | Mucio Lucero, (973) 383-6075                                                                   | NJ0111                                                              | LA MEXICANITA GROCERY & DELI 2 LL
C                                  | 179 Spring St, Newton, NJ 07860                                                    | CorPoint                   | Managed
   44855 | MYLEN MODENA; 415-488-3323                                                                     | CA1115                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 3571 CALLAN BLVD, SOUTH SAN FRANCISCO, CA 94080                                    | TransFast Remittance, LLC  | Managed
   44879 | Nancy Chua / Carmelita Sunga 714-826-2527                                                      | CA1666                                                              | Alas Cargo Orange County         
                                   | 4700 Lincoln Ave, Cypress CA 90630                                                 | TransFast Remittance, LLC  | Managed
   44874 | NATHALIE MENEZ / BENJIE SISON: 949-251-0778                                                    | CA1138                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 2180 BARRANCA PKWY UNIT 130, IRVINE, CA 92606                                      | TransFast Remittance, LLC  | Managed
   44887 | "Nawele Nekere  347-591-0505"                                                                  | 1509                                                                | Nekere Business Place            
                                   | "196 E 167th St Bronx   NY      10456"                                             | Choice Money Transfer, Inc | Managed
   44851 | NELIA CABUENOS 805-847-1264                                                                    | CA1577                                                              | ALAS CARGO LLC (6)               
                                   | 4833 S ROSE AVE, OXNARD,CA 93033                                                   | TransFast Remittance, LLC  | Managed
   44865 | Nicolas Saucedo,(937) 220-9600                                                                 | OH0180                                                              | Leos Mexican Market LLC dba La Mi
choacana Mexican Market 5          | 748 Troy St, Dayton, OH                                                            | Fiserv                     | Managed
   44835 | Patrick Moore, 800.835.6011 ext: 116                                                           | TEST  SAFE                                                          | Armor Safe Technologies          
                                   | 5916 Stone Creek Drive, Suite 100, The Colony, TX 75056                            | Fiserv Cash And Logistics  | Managed
   44857 | Peter Segovia Sy, (562) 290-0872                                                               | CA1568                                                              | Alas Cargo LLC (4)               
                                   | 3300 Atlantic Ave, Long Beach, CA                                                  | Fiserv                     | Managed
   47087 | Rachel Weaver                                                                                  | PIONEEER ELECTRIC COOPERATIVE -Urbana                               | PIONEEER ELECTRIC COOPERATIVE -Ur
bana                               | 767 Three Mile Rd Urbana, OH 43078                                                 |                            | Managed
   44870 | "Ramon Martinez 732-442-5532"                                                                  | 1250                                                                | CIBAO Plaza Inc                  
                                   | "295 State St   Perth Amboy     NJ      08861"                                     | Choice Money Transfer, Inc | Managed
   44846 | REA GUILAS; 626-589-0597                                                                       | CA0700                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 1525 Amar Rd, West Covina, CA  91792                                               | TransFast Remittance, LLC  | Managed
   44856 | RICARDO MENDOZA ; 805-407-3951                                                                 | CA0761                                                              | DISCOTECA MI PUEBLITO            
                                   | 146 SOUTH OJAI ST , SANTA PAULA, CA 93060                                          | TransFast Remittance, LLC  | Managed
   44869 | Ritchelle Bonifacio/ Czarina Abenir/ Melissa Dela Cruz/ Angelica Basa (206) 724-1291           | WA0008                                                              | Atlas Express Padala Inc.        
                                   | 1368 Southcenter Mal, Suite 120, Seattle, WA 98188                                 | TransFast Remittance, LLC  | Managed
   46275 | Robert Gerson, (201) 941-1053                                                                  | NJ0485                                                              | Xclusive Brands Inc dba Xtra-Tel 
                                   | 300 Anderson Ave, Fairview, NJ, 07022                                              |                            | Managed
   44852 | RODRIGO SAN ROQUE / JOHN CHRISTOPHER BATISTER / ROSENIA MEJIA; 619-470-1023                    | CA1614                                                              | TNS LOGISTICS CORPORATION DBA ALA
S CARGO SAN DIEGO                  | 3126 E PLAZA LVD STE F, NATIONAL CITY, CA 91950                                    | TransFast Remittance, LLC  | Managed
   44871 | ROSALBA OROZCO /EDGAR GUTIERREZ/ ARNOLDO GUTIEREZ, 818-427-9856 ROSALBA / 818-262-7431 ARNOLDO | CA1588                                                              | Rosy S Electronics Inc           
                                   | 14556 Nordhoff St, Panorama City, CA 91402                                         | TransFast Remittance, LLC  | Managed
   44882 | Rosemary Gonzales (954) 449-0206                                                               | 2687                                                                | Popular Express LLC              
                                   | 291 Madison Ave, Suite 3 Perth Amboy, NJ 08861                                     | CorPoint                   | Managed
   47310 | Choice Money Transfer                                                                          | undeployed router                                                   |                                  
                                   |                                                                                    |                            | Managed
   47311 | Choice Money Transfer                                                                          | undeployed router                                                   |                                  
                                   |                                                                                    |                            | Managed
   47312 | Choice Money Transfer                                                                          | undeployed router                                                   |                                  
                                   |                                                                                    |                            | Managed
   46641 | TransFast Remittance, LLC, LA MICHOACANA MEXICAN MARKET # 4 LLC (8)                            | TransFast Remittance, LLC, LA MICHOACANA MEXICAN MARKET # 4 LLC (8) | TransFast Remittance, LLC, LA MIC
HOACANA MEXICAN MARKET # 4 LLC (8) | 5445 BETHEL SAWMILL CENTER, COLUMBUS, OH 43235                                     |                            | Managed
   46270 | Sandra Vazquez, (718) 606-0484                                                                 | 2906                                                                | OK Multiservices Queens #4       
                                   | 108-09A 52nd Ave, Corona, NY 11368                                                 |                            | Managed
   47146 | Shikshya Bhattachan, (917) 345-4397                                                            | Prabhu Group                                                        | Prabhu Group                     
                                   | 3715 73rd St, Jackson Heights, NY 11372                                            |                            | Managed
   44858 | SILVERIO PEREZ: 770-895-3165                                                                   | GA0012                                                              | ALL STAR WESTERN APPAREL INC     
                                   | 1245 VETERANS MEMORIAL HWY SW  SUITE. #36, MABLETON, GA 30126                      | TransFast Remittance, LLC  | Managed
   46672 | Tadd Sutton (704) 807-0715                                                                     | Quality Data Systems, Inc                                           | Quality Data Systems, Inc        
                                   | 8655 Crown Crescent Ct, Charlotte, NC 28227                                        |                            | Managed
   46266 | Tadd Sutton, (704) 807-0715                                                                    | MOORE_COURT                                                         | Moore County Clerk of Court      
                                   | 102 Monroe St, Carthage, NC                                                        | Fiserv                     | Managed
   46268 | Tadd Sutton, (704) 807-0715                                                                    | ROWAN_COURT                                                         | Rowan County Clerk of Court      
                                   | 210 N Main, Salisbury, NC                                                          | Fiserv                     | Managed
   44850 | TESS CRUZ / APRIL ILLESCAS: 909-362-0600 / 260206-8875                                         | CA0976                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 11098 FOOTHILL BLVD. , RANCHO CUCAMONGA, CA 91730                                  | TransFast Remittance, LLC  | Managed
   44868 | "Theirno Ndiaye 309-797-7933"                                                                  | 1864                                                                | Faabu Beauty Supply              
                                   | "3106 Ave of the Cities Moline  IL      61265"                                     | Choice Money Transfer, Inc | Managed
   47038 | Tom Stefanik, (603) 652-1994                                                                   | Test Safe                                                           | Choice ATMs and SmartSafes       
                                   | 1100 Hooksett Rd, Suite 102 Hooksett NH 03106                                      |                            | Managed
   44836 | TOMAS ROLANDO, (718) 853-4266                                                                  | NY2064                                                              | R B TRAVEL CORP  (2)             
                                   | 3501 14TH AVENUE, BROOKLYN, NY 11218                                               | TransFast Remittance, LLC  | Managed
   47282 | Undeployed - LA Union Corp LLC                                                                 | Undeployed - Supermercados Morelos                                  | Undeployed - Supermercados Morelo
s                                  | Undeployed- 4704 NW 23 St, Oklahoma City, OK 73127                                 |                            | Managed
   47283 | UNDEPLOYED-LA Union 5 LLC                                                                      | UNDEPLOYED-Supermercados Morelos                                    | UNDEPLOYED-Supermercados Morelos 
                                   | UNDEPLOYED-4475 NW 50th St, Oklahoma City, OK 73112                                |                            | Managed
   44841 | VICENTE JIMENEZ: 831-324-35-73                                                                 | CA0275                                                              | JIMENEZ FASHION                  
                                   | 1034 BROADWAY AVE, SEASIDE, CA 93955                                               | TransFast Remittance, LLC  | Managed
   46273 | Victor Mejia, (908) 756-1602                                                                   | NJ1018                                                              | Furia Multiservices LLC          
                                   | 102 E Front St, Plainfield, NJ, 07060                                              |                            | Managed
   44860 | ZENAIDA M CARPIO / ROBERT ANTHONY M CARPIO; 650 714 6981 / 510 416 3498                        | CA0851                                                              | PINAY ANGEL                      
                                   | 39 ST FRANCIS SQUARE, DALY CITY, CA 94015                                          | TransFast Remittance, LLC  | Managed
   44875 | ZYE CATILTIL; 925-771-4647                                                                     | CA0697                                                              | ATLAS EXPRESS PADALA INC.        
                                   | 2030 DIAMOND BLVD. SUITE 55, CONCORD, CA 94520                                     | TransFast Remittance, LLC  | Managed
   38559 | Unassigned                                                                                     |                                                                     |                                  
                                   |                                                                                    |                            | 
   38560 | Unassigned                                                                                     |                                                                     |                                  
                                   |                                                                                    |                            | 
   44854 | FILIBERTO SAUCEDO; 614-792-5400                                                                | OH0192                                                              | LA MICHOACANA MEXICAN MARKET # 4 
LLC (8)                            | 5445 BETHEL SAWMILL CENTER, COLUMBUS, OH 43235                                     | TransFast Remittance, LLC  | 
   45502 | Brian Miller                                                                                   | Demo Unit                                                           | Hamilton Safe Company            
                                   | 25 Walnut Street - #12 Lexington, OH 44904                                         | Fiserv Cash & Logistics    | 
   46429 | Daniel Grgornic                                                                                | Audemars Piguet - Bal Harbour                                       | Audemars Piguet - Bal Harbour    
                                   | 9700 Collins Ave, Bal Harbour, Florida, 33154                                      | Audemars Piguet            | 
(114 rows)

