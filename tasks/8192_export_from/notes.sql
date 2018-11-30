

DNS Name  : bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com
DB Port   : 5432
DB Name   : bi
DB Schema : bi
DB User   : bi_reader
DB Pass   : qzvuuuv7


mount -t cifs -o username=gordaz //cctnas02/public/ /mnt/

-- Unmount original since it includes all the directories under mnt/public/

sudo  umount mnt/public/
[sudo] password for gordaz: 

--


down vote
One more way:

if [ "$(findmnt ${mount_point})" ] ; then
  #Do something for positive result (exit 0)
else
  #Do something for negative result (exit 1)
fi



