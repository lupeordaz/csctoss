#!/bin/bash
#

psql -q -t -c "select id, nasname, shortname, secret from nas where shortname like 'atl%'" |
while read id nasname shortname secret; 
do
    echo "id        : " $id
    echo "nasname   : " $nasname
    echo "shortname : " $shortname
    echo "secret    : " $secret
done

echo "Bye"

