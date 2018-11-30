[gordaz@cctlix03 ~]$ poss1
ssh: connect to host denoss01.contournetworks.net port 22: Network is unreachable
[gordaz@cctlix03 ~]$ \q
bash: q: command not found...
[gordaz@cctlix03 ~]$ ssh postgres@atlrad26.contournetworks.net
ssh: connect to host atlrad26.contournetworks.net port 22: Network is unreachable
[gordaz@cctlix03 ~]$ ssh postgres@atlrad26.contournetworks.net
postgres@atlrad26.contournetworks.net's password: 
Last login: Sat Apr  2 09:19:41 2016 from yshibuya-atl.contournetworks.net
[postgres@atlrad26 ~]$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_atlrad26-lv_root
                       24G   20G  3.2G  86% /
tmpfs                 2.1G     0  2.1G   0% /dev/shm
/dev/sda1             477M   71M  381M  16% /boot
/dev/mapper/vg_atlrad26-LogVol02
                      2.4G  1.2G  1.2G  50% /var
[postgres@atlrad26 ~]$ cd /
[postgres@atlrad26 /]$ du -sh *
6.6M	bin
du: cannot read directory `boot/lost+found': Permission denied
69M	boot
172K	dev
du: cannot read directory `etc/ntp/crypto': Permission denied
du: cannot read directory `etc/audisp': Permission denied
du: cannot read directory `etc/dhcp': Permission denied
du: cannot read directory `etc/nagios/objects': Permission denied
du: cannot read directory `etc/nagios/conf.d': Permission denied
du: cannot read directory `etc/nagios/private': Permission denied
du: cannot read directory `etc/audit': Permission denied
du: cannot read directory `etc/sudoers.d': Permission denied
du: cannot read directory `etc/sssd': Permission denied
du: cannot read directory `etc/selinux/targeted/modules/active': Permission denied
du: cannot read directory `etc/pki/rsyslog': Permission denied
du: cannot read directory `etc/pki/CA/private': Permission denied
du: cannot read directory `etc/lvm/backup': Permission denied
du: cannot read directory `etc/lvm/archive': Permission denied
du: cannot read directory `etc/lvm/cache': Permission denied
17M	etc
du: cannot read directory `home/freeradius': Permission denied
du: cannot read directory `home/jp': Permission denied
960M	home
389M	lib
26M	lib64
du: cannot read directory `lost+found': Permission denied
16K	lost+found
4.0K	media
0	misc
4.0K	mnt
0	net
du: cannot read directory `opt/freeradius/etc/raddb/sites-enabled': Permission denied
du: cannot read directory `opt/freeradius/etc/raddb/sites-available': Permission denied
du: cannot read directory `opt/freeradius/etc/raddb/certs': Permission denied
du: cannot read directory `opt/freeradius/etc/raddb/modules': Permission denied
du: cannot read directory `opt/freeradius/etc/raddb/sql': Permission denied
du: cannot read directory `opt/freeradius/var/log/radius': Permission denied
du: cannot read directory `opt/freeradius-3.0.5/etc/raddb': Permission denied
du: cannot read directory `opt/freeradius-3.0.5/var/log/radius': Permission denied
17G	opt
du: cannot read directory `proc/tty/driver': Permission denied
du: cannot read directory `proc/1/task/1/fd': Permission denied
du: cannot read directory `proc/1/task/1/fdinfo': Permission denied
du: cannot read directory `proc/1/task/1/ns': Permission denied
du: cannot read directory `proc/1/fd': Permission denied
du: cannot read directory `proc/1/fdinfo': Permission denied
du: cannot read directory `proc/1/ns': Permission denied
du: cannot read directory `proc/2/task/2/fd': Permission denied
du: cannot read directory `proc/2/task/2/fdinfo': Permission denied
du: cannot read directory `proc/2/task/2/ns': Permission denied
du: cannot read directory `proc/2/fd': Permission denied
du: cannot read directory `proc/2/fdinfo': Permission denied
du: cannot read directory `proc/2/ns': Permission denied
du: cannot read directory `proc/3/task/3/fd': Permission denied
du: cannot read directory `proc/3/task/3/fdinfo': Permission denied
du: cannot read directory `proc/3/task/3/ns': Permission denied
du: cannot read directory `proc/3/fd': Permission denied
du: cannot read directory `proc/3/fdinfo': Permission denied
du: cannot read directory `proc/3/ns': Permission denied
du: cannot read directory `proc/4/task/4/fd': Permission denied
du: cannot read directory `proc/4/task/4/fdinfo': Permission denied
du: cannot read directory `proc/4/task/4/ns': Permission denied
du: cannot read directory `proc/4/fd': Permission denied
du: cannot read directory `proc/4/fdinfo': Permission denied
du: cannot read directory `proc/4/ns': Permission denied
du: cannot read directory `proc/5/task/5/fd': Permission denied
du: cannot read directory `proc/5/task/5/fdinfo': Permission denied
du: cannot read directory `proc/5/task/5/ns': Permission denied
du: cannot read directory `proc/5/fd': Permission denied
du: cannot read directory `proc/5/fdinfo': Permission denied
du: cannot read directory `proc/5/ns': Permission denied
du: cannot read directory `proc/6/task/6/fd': Permission denied
du: cannot read directory `proc/6/task/6/fdinfo': Permission denied
du: cannot read directory `proc/6/task/6/ns': Permission denied
du: cannot read directory `proc/6/fd': Permission denied
du: cannot read directory `proc/6/fdinfo': Permission denied
du: cannot read directory `proc/6/ns': Permission denied
du: cannot read directory `proc/7/task/7/fd': Permission denied
du: cannot read directory `proc/7/task/7/fdinfo': Permission denied
du: cannot read directory `proc/7/task/7/ns': Permission denied
du: cannot read directory `proc/7/fd': Permission denied
du: cannot read directory `proc/7/fdinfo': Permission denied
du: cannot read directory `proc/7/ns': Permission denied
du: cannot read directory `proc/8/task/8/fd': Permission denied
du: cannot read directory `proc/8/task/8/fdinfo': Permission denied
du: cannot read directory `proc/8/task/8/ns': Permission denied
du: cannot read directory `proc/8/fd': Permission denied
du: cannot read directory `proc/8/fdinfo': Permission denied
du: cannot read directory `proc/8/ns': Permission denied
du: cannot read directory `proc/9/task/9/fd': Permission denied
du: cannot read directory `proc/9/task/9/fdinfo': Permission denied
du: cannot read directory `proc/9/task/9/ns': Permission denied
du: cannot read directory `proc/9/fd': Permission denied
du: cannot read directory `proc/9/fdinfo': Permission denied
du: cannot read directory `proc/9/ns': Permission denied
du: cannot read directory `proc/10/task/10/fd': Permission denied
du: cannot read directory `proc/10/task/10/fdinfo': Permission denied
du: cannot read directory `proc/10/task/10/ns': Permission denied
du: cannot read directory `proc/10/fd': Permission denied
du: cannot read directory `proc/10/fdinfo': Permission denied
du: cannot read directory `proc/10/ns': Permission denied
du: cannot read directory `proc/11/task/11/fd': Permission denied
du: cannot read directory `proc/11/task/11/fdinfo': Permission denied
du: cannot read directory `proc/11/task/11/ns': Permission denied
du: cannot read directory `proc/11/fd': Permission denied
du: cannot read directory `proc/11/fdinfo': Permission denied
du: cannot read directory `proc/11/ns': Permission denied
du: cannot read directory `proc/12/task/12/fd': Permission denied
du: cannot read directory `proc/12/task/12/fdinfo': Permission denied
du: cannot read directory `proc/12/task/12/ns': Permission denied
du: cannot read directory `proc/12/fd': Permission denied
du: cannot read directory `proc/12/fdinfo': Permission denied
du: cannot read directory `proc/12/ns': Permission denied
du: cannot read directory `proc/13/task/13/fd': Permission denied
du: cannot read directory `proc/13/task/13/fdinfo': Permission denied
du: cannot read directory `proc/13/task/13/ns': Permission denied
du: cannot read directory `proc/13/fd': Permission denied
du: cannot read directory `proc/13/fdinfo': Permission denied
du: cannot read directory `proc/13/ns': Permission denied
du: cannot read directory `proc/14/task/14/fd': Permission denied
du: cannot read directory `proc/14/task/14/fdinfo': Permission denied
du: cannot read directory `proc/14/task/14/ns': Permission denied
du: cannot read directory `proc/14/fd': Permission denied
du: cannot read directory `proc/14/fdinfo': Permission denied
du: cannot read directory `proc/14/ns': Permission denied
du: cannot read directory `proc/15/task/15/fd': Permission denied
du: cannot read directory `proc/15/task/15/fdinfo': Permission denied
du: cannot read directory `proc/15/task/15/ns': Permission denied
du: cannot read directory `proc/15/fd': Permission denied
du: cannot read directory `proc/15/fdinfo': Permission denied
du: cannot read directory `proc/15/ns': Permission denied
du: cannot read directory `proc/16/task/16/fd': Permission denied
du: cannot read directory `proc/16/task/16/fdinfo': Permission denied
du: cannot read directory `proc/16/task/16/ns': Permission denied
du: cannot read directory `proc/16/fd': Permission denied
du: cannot read directory `proc/16/fdinfo': Permission denied
du: cannot read directory `proc/16/ns': Permission denied
du: cannot read directory `proc/17/task/17/fd': Permission denied
du: cannot read directory `proc/17/task/17/fdinfo': Permission denied
du: cannot read directory `proc/17/task/17/ns': Permission denied
du: cannot read directory `proc/17/fd': Permission denied
du: cannot read directory `proc/17/fdinfo': Permission denied
du: cannot read directory `proc/17/ns': Permission denied
du: cannot read directory `proc/18/task/18/fd': Permission denied
du: cannot read directory `proc/18/task/18/fdinfo': Permission denied
du: cannot read directory `proc/18/task/18/ns': Permission denied
du: cannot read directory `proc/18/fd': Permission denied
du: cannot read directory `proc/18/fdinfo': Permission denied
du: cannot read directory `proc/18/ns': Permission denied
du: cannot read directory `proc/19/task/19/fd': Permission denied
du: cannot read directory `proc/19/task/19/fdinfo': Permission denied
du: cannot read directory `proc/19/task/19/ns': Permission denied
du: cannot read directory `proc/19/fd': Permission denied
du: cannot read directory `proc/19/fdinfo': Permission denied
du: cannot read directory `proc/19/ns': Permission denied
du: cannot read directory `proc/20/task/20/fd': Permission denied
du: cannot read directory `proc/20/task/20/fdinfo': Permission denied
du: cannot read directory `proc/20/task/20/ns': Permission denied
du: cannot read directory `proc/20/fd': Permission denied
du: cannot read directory `proc/20/fdinfo': Permission denied
du: cannot read directory `proc/20/ns': Permission denied
du: cannot read directory `proc/21/task/21/fd': Permission denied
du: cannot read directory `proc/21/task/21/fdinfo': Permission denied
du: cannot read directory `proc/21/task/21/ns': Permission denied
du: cannot read directory `proc/21/fd': Permission denied
du: cannot read directory `proc/21/fdinfo': Permission denied
du: cannot read directory `proc/21/ns': Permission denied
du: cannot read directory `proc/22/task/22/fd': Permission denied
du: cannot read directory `proc/22/task/22/fdinfo': Permission denied
du: cannot read directory `proc/22/task/22/ns': Permission denied
du: cannot read directory `proc/22/fd': Permission denied
du: cannot read directory `proc/22/fdinfo': Permission denied
du: cannot read directory `proc/22/ns': Permission denied
du: cannot read directory `proc/23/task/23/fd': Permission denied
du: cannot read directory `proc/23/task/23/fdinfo': Permission denied
du: cannot read directory `proc/23/task/23/ns': Permission denied
du: cannot read directory `proc/23/fd': Permission denied
du: cannot read directory `proc/23/fdinfo': Permission denied
du: cannot read directory `proc/23/ns': Permission denied
du: cannot read directory `proc/24/task/24/fd': Permission denied
du: cannot read directory `proc/24/task/24/fdinfo': Permission denied
du: cannot read directory `proc/24/task/24/ns': Permission denied
du: cannot read directory `proc/24/fd': Permission denied
du: cannot read directory `proc/24/fdinfo': Permission denied
du: cannot read directory `proc/24/ns': Permission denied
du: cannot read directory `proc/25/task/25/fd': Permission denied
du: cannot read directory `proc/25/task/25/fdinfo': Permission denied
du: cannot read directory `proc/25/task/25/ns': Permission denied
du: cannot read directory `proc/25/fd': Permission denied
du: cannot read directory `proc/25/fdinfo': Permission denied
du: cannot read directory `proc/25/ns': Permission denied
du: cannot read directory `proc/26/task/26/fd': Permission denied
du: cannot read directory `proc/26/task/26/fdinfo': Permission denied
du: cannot read directory `proc/26/task/26/ns': Permission denied
du: cannot read directory `proc/26/fd': Permission denied
du: cannot read directory `proc/26/fdinfo': Permission denied
du: cannot read directory `proc/26/ns': Permission denied
du: cannot read directory `proc/27/task/27/fd': Permission denied
du: cannot read directory `proc/27/task/27/fdinfo': Permission denied
du: cannot read directory `proc/27/task/27/ns': Permission denied
du: cannot read directory `proc/27/fd': Permission denied
du: cannot read directory `proc/27/fdinfo': Permission denied
du: cannot read directory `proc/27/ns': Permission denied
du: cannot read directory `proc/28/task/28/fd': Permission denied
du: cannot read directory `proc/28/task/28/fdinfo': Permission denied
du: cannot read directory `proc/28/task/28/ns': Permission denied
du: cannot read directory `proc/28/fd': Permission denied
du: cannot read directory `proc/28/fdinfo': Permission denied
du: cannot read directory `proc/28/ns': Permission denied
du: cannot read directory `proc/29/task/29/fd': Permission denied
du: cannot read directory `proc/29/task/29/fdinfo': Permission denied
du: cannot read directory `proc/29/task/29/ns': Permission denied
du: cannot read directory `proc/29/fd': Permission denied
du: cannot read directory `proc/29/fdinfo': Permission denied
du: cannot read directory `proc/29/ns': Permission denied
du: cannot read directory `proc/30/task/30/fd': Permission denied
du: cannot read directory `proc/30/task/30/fdinfo': Permission denied
du: cannot read directory `proc/30/task/30/ns': Permission denied
du: cannot read directory `proc/30/fd': Permission denied
du: cannot read directory `proc/30/fdinfo': Permission denied
du: cannot read directory `proc/30/ns': Permission denied
du: cannot read directory `proc/33/task/33/fd': Permission denied
du: cannot read directory `proc/33/task/33/fdinfo': Permission denied
du: cannot read directory `proc/33/task/33/ns': Permission denied
du: cannot read directory `proc/33/fd': Permission denied
du: cannot read directory `proc/33/fdinfo': Permission denied
du: cannot read directory `proc/33/ns': Permission denied
du: cannot read directory `proc/34/task/34/fd': Permission denied
du: cannot read directory `proc/34/task/34/fdinfo': Permission denied
du: cannot read directory `proc/34/task/34/ns': Permission denied
du: cannot read directory `proc/34/fd': Permission denied
du: cannot read directory `proc/34/fdinfo': Permission denied
du: cannot read directory `proc/34/ns': Permission denied
du: cannot read directory `proc/35/task/35/fd': Permission denied
du: cannot read directory `proc/35/task/35/fdinfo': Permission denied
du: cannot read directory `proc/35/task/35/ns': Permission denied
du: cannot read directory `proc/35/fd': Permission denied
du: cannot read directory `proc/35/fdinfo': Permission denied
du: cannot read directory `proc/35/ns': Permission denied
du: cannot read directory `proc/36/task/36/fd': Permission denied
du: cannot read directory `proc/36/task/36/fdinfo': Permission denied
du: cannot read directory `proc/36/task/36/ns': Permission denied
du: cannot read directory `proc/36/fd': Permission denied
du: cannot read directory `proc/36/fdinfo': Permission denied
du: cannot read directory `proc/36/ns': Permission denied
du: cannot read directory `proc/37/task/37/fd': Permission denied
du: cannot read directory `proc/37/task/37/fdinfo': Permission denied
du: cannot read directory `proc/37/task/37/ns': Permission denied
du: cannot read directory `proc/37/fd': Permission denied
du: cannot read directory `proc/37/fdinfo': Permission denied
du: cannot read directory `proc/37/ns': Permission denied
du: cannot read directory `proc/38/task/38/fd': Permission denied
du: cannot read directory `proc/38/task/38/fdinfo': Permission denied
du: cannot read directory `proc/38/task/38/ns': Permission denied
du: cannot read directory `proc/38/fd': Permission denied
du: cannot read directory `proc/38/fdinfo': Permission denied
du: cannot read directory `proc/38/ns': Permission denied
du: cannot read directory `proc/45/task/45/fd': Permission denied
du: cannot read directory `proc/45/task/45/fdinfo': Permission denied
du: cannot read directory `proc/45/task/45/ns': Permission denied
du: cannot read directory `proc/45/fd': Permission denied
du: cannot read directory `proc/45/fdinfo': Permission denied
du: cannot read directory `proc/45/ns': Permission denied
du: cannot read directory `proc/46/task/46/fd': Permission denied
du: cannot read directory `proc/46/task/46/fdinfo': Permission denied
du: cannot read directory `proc/46/task/46/ns': Permission denied
du: cannot read directory `proc/46/fd': Permission denied
du: cannot read directory `proc/46/fdinfo': Permission denied
du: cannot read directory `proc/46/ns': Permission denied
du: cannot read directory `proc/48/task/48/fd': Permission denied
du: cannot read directory `proc/48/task/48/fdinfo': Permission denied
du: cannot read directory `proc/48/task/48/ns': Permission denied
du: cannot read directory `proc/48/fd': Permission denied
du: cannot read directory `proc/48/fdinfo': Permission denied
du: cannot read directory `proc/48/ns': Permission denied
du: cannot read directory `proc/49/task/49/fd': Permission denied
du: cannot read directory `proc/49/task/49/fdinfo': Permission denied
du: cannot read directory `proc/49/task/49/ns': Permission denied
du: cannot read directory `proc/49/fd': Permission denied
du: cannot read directory `proc/49/fdinfo': Permission denied
du: cannot read directory `proc/49/ns': Permission denied
du: cannot read directory `proc/50/task/50/fd': Permission denied
du: cannot read directory `proc/50/task/50/fdinfo': Permission denied
du: cannot read directory `proc/50/task/50/ns': Permission denied
du: cannot read directory `proc/50/fd': Permission denied
du: cannot read directory `proc/50/fdinfo': Permission denied
du: cannot read directory `proc/50/ns': Permission denied
du: cannot read directory `proc/83/task/83/fd': Permission denied
du: cannot read directory `proc/83/task/83/fdinfo': Permission denied
du: cannot read directory `proc/83/task/83/ns': Permission denied
du: cannot read directory `proc/83/fd': Permission denied
du: cannot read directory `proc/83/fdinfo': Permission denied
du: cannot read directory `proc/83/ns': Permission denied
du: cannot read directory `proc/84/task/84/fd': Permission denied
du: cannot read directory `proc/84/task/84/fdinfo': Permission denied
du: cannot read directory `proc/84/task/84/ns': Permission denied
du: cannot read directory `proc/84/fd': Permission denied
du: cannot read directory `proc/84/fdinfo': Permission denied
du: cannot read directory `proc/84/ns': Permission denied
du: cannot read directory `proc/115/task/115/fd': Permission denied
du: cannot read directory `proc/115/task/115/fdinfo': Permission denied
du: cannot read directory `proc/115/task/115/ns': Permission denied
du: cannot read directory `proc/115/fd': Permission denied
du: cannot read directory `proc/115/fdinfo': Permission denied
du: cannot read directory `proc/115/ns': Permission denied
du: cannot read directory `proc/254/task/254/fd': Permission denied
du: cannot read directory `proc/254/task/254/fdinfo': Permission denied
du: cannot read directory `proc/254/task/254/ns': Permission denied
du: cannot read directory `proc/254/fd': Permission denied
du: cannot read directory `proc/254/fdinfo': Permission denied
du: cannot read directory `proc/254/ns': Permission denied
du: cannot read directory `proc/257/task/257/fd': Permission denied
du: cannot read directory `proc/257/task/257/fdinfo': Permission denied
du: cannot read directory `proc/257/task/257/ns': Permission denied
du: cannot read directory `proc/257/fd': Permission denied
du: cannot read directory `proc/257/fdinfo': Permission denied
du: cannot read directory `proc/257/ns': Permission denied
du: cannot read directory `proc/265/task/265/fd': Permission denied
du: cannot read directory `proc/265/task/265/fdinfo': Permission denied
du: cannot read directory `proc/265/task/265/ns': Permission denied
du: cannot read directory `proc/265/fd': Permission denied
du: cannot read directory `proc/265/fdinfo': Permission denied
du: cannot read directory `proc/265/ns': Permission denied
du: cannot read directory `proc/266/task/266/fd': Permission denied
du: cannot read directory `proc/266/task/266/fdinfo': Permission denied
du: cannot read directory `proc/266/task/266/ns': Permission denied
du: cannot read directory `proc/266/fd': Permission denied
du: cannot read directory `proc/266/fdinfo': Permission denied
du: cannot read directory `proc/266/ns': Permission denied
du: cannot read directory `proc/267/task/267/fd': Permission denied
du: cannot read directory `proc/267/task/267/fdinfo': Permission denied
du: cannot read directory `proc/267/task/267/ns': Permission denied
du: cannot read directory `proc/267/fd': Permission denied
du: cannot read directory `proc/267/fdinfo': Permission denied
du: cannot read directory `proc/267/ns': Permission denied
du: cannot read directory `proc/371/task/371/fd': Permission denied
du: cannot read directory `proc/371/task/371/fdinfo': Permission denied
du: cannot read directory `proc/371/task/371/ns': Permission denied
du: cannot read directory `proc/371/fd': Permission denied
du: cannot read directory `proc/371/fdinfo': Permission denied
du: cannot read directory `proc/371/ns': Permission denied
du: cannot read directory `proc/373/task/373/fd': Permission denied
du: cannot read directory `proc/373/task/373/fdinfo': Permission denied
du: cannot read directory `proc/373/task/373/ns': Permission denied
du: cannot read directory `proc/373/fd': Permission denied
du: cannot read directory `proc/373/fdinfo': Permission denied
du: cannot read directory `proc/373/ns': Permission denied
du: cannot read directory `proc/391/task/391/fd': Permission denied
du: cannot read directory `proc/391/task/391/fdinfo': Permission denied
du: cannot read directory `proc/391/task/391/ns': Permission denied
du: cannot read directory `proc/391/fd': Permission denied
du: cannot read directory `proc/391/fdinfo': Permission denied
du: cannot read directory `proc/391/ns': Permission denied
du: cannot read directory `proc/392/task/392/fd': Permission denied
du: cannot read directory `proc/392/task/392/fdinfo': Permission denied
du: cannot read directory `proc/392/task/392/ns': Permission denied
du: cannot read directory `proc/392/fd': Permission denied
du: cannot read directory `proc/392/fdinfo': Permission denied
du: cannot read directory `proc/392/ns': Permission denied
du: cannot read directory `proc/449/task/449/fd': Permission denied
du: cannot read directory `proc/449/task/449/fdinfo': Permission denied
du: cannot read directory `proc/449/task/449/ns': Permission denied
du: cannot read directory `proc/449/fd': Permission denied
du: cannot read directory `proc/449/fdinfo': Permission denied
du: cannot read directory `proc/449/ns': Permission denied
du: cannot read directory `proc/462/task/462/fd': Permission denied
du: cannot read directory `proc/462/task/462/fdinfo': Permission denied
du: cannot read directory `proc/462/task/462/ns': Permission denied
du: cannot read directory `proc/462/fd': Permission denied
du: cannot read directory `proc/462/fdinfo': Permission denied
du: cannot read directory `proc/462/ns': Permission denied
du: cannot read directory `proc/467/task/467/fd': Permission denied
du: cannot read directory `proc/467/task/467/fdinfo': Permission denied
du: cannot read directory `proc/467/task/467/ns': Permission denied
du: cannot read directory `proc/467/fd': Permission denied
du: cannot read directory `proc/467/fdinfo': Permission denied
du: cannot read directory `proc/467/ns': Permission denied
du: cannot read directory `proc/478/task/478/fd': Permission denied
du: cannot read directory `proc/478/task/478/fdinfo': Permission denied
du: cannot read directory `proc/478/task/478/ns': Permission denied
du: cannot read directory `proc/478/fd': Permission denied
du: cannot read directory `proc/478/fdinfo': Permission denied
du: cannot read directory `proc/478/ns': Permission denied
du: cannot access `proc/489/task/489/fd/4': No such file or directory
du: cannot access `proc/489/task/489/fdinfo/4': No such file or directory
du: cannot access `proc/489/fd/4': No such file or directory
du: cannot access `proc/489/fdinfo/4': No such file or directory
du: cannot read directory `proc/653/task/653/fd': Permission denied
du: cannot read directory `proc/653/task/653/fdinfo': Permission denied
du: cannot read directory `proc/653/task/653/ns': Permission denied
du: cannot read directory `proc/653/fd': Permission denied
du: cannot read directory `proc/653/fdinfo': Permission denied
du: cannot read directory `proc/653/ns': Permission denied
du: cannot read directory `proc/798/task/798/fd': Permission denied
du: cannot read directory `proc/798/task/798/fdinfo': Permission denied
du: cannot read directory `proc/798/task/798/ns': Permission denied
du: cannot read directory `proc/798/fd': Permission denied
du: cannot read directory `proc/798/fdinfo': Permission denied
du: cannot read directory `proc/798/ns': Permission denied
du: cannot read directory `proc/838/task/838/fd': Permission denied
du: cannot read directory `proc/838/task/838/fdinfo': Permission denied
du: cannot read directory `proc/838/task/838/ns': Permission denied
du: cannot read directory `proc/838/fd': Permission denied
du: cannot read directory `proc/838/fdinfo': Permission denied
du: cannot read directory `proc/838/ns': Permission denied
du: cannot read directory `proc/839/task/839/fd': Permission denied
du: cannot read directory `proc/839/task/839/fdinfo': Permission denied
du: cannot read directory `proc/839/task/839/ns': Permission denied
du: cannot read directory `proc/839/fd': Permission denied
du: cannot read directory `proc/839/fdinfo': Permission denied
du: cannot read directory `proc/839/ns': Permission denied
du: cannot read directory `proc/840/task/840/fd': Permission denied
du: cannot read directory `proc/840/task/840/fdinfo': Permission denied
du: cannot read directory `proc/840/task/840/ns': Permission denied
du: cannot read directory `proc/840/fd': Permission denied
du: cannot read directory `proc/840/fdinfo': Permission denied
du: cannot read directory `proc/840/ns': Permission denied
du: cannot read directory `proc/841/task/841/fd': Permission denied
du: cannot read directory `proc/841/task/841/fdinfo': Permission denied
du: cannot read directory `proc/841/task/841/ns': Permission denied
du: cannot read directory `proc/841/fd': Permission denied
du: cannot read directory `proc/841/fdinfo': Permission denied
du: cannot read directory `proc/841/ns': Permission denied
du: cannot read directory `proc/879/task/879/fd': Permission denied
du: cannot read directory `proc/879/task/879/fdinfo': Permission denied
du: cannot read directory `proc/879/task/879/ns': Permission denied
du: cannot read directory `proc/879/fd': Permission denied
du: cannot read directory `proc/879/fdinfo': Permission denied
du: cannot read directory `proc/879/ns': Permission denied
du: cannot read directory `proc/1090/task/1090/fd': Permission denied
du: cannot read directory `proc/1090/task/1090/fdinfo': Permission denied
du: cannot read directory `proc/1090/task/1090/ns': Permission denied
du: cannot read directory `proc/1090/fd': Permission denied
du: cannot read directory `proc/1090/fdinfo': Permission denied
du: cannot read directory `proc/1090/ns': Permission denied
du: cannot read directory `proc/1312/task/1312/fd': Permission denied
du: cannot read directory `proc/1312/task/1312/fdinfo': Permission denied
du: cannot read directory `proc/1312/task/1312/ns': Permission denied
du: cannot read directory `proc/1312/task/1313/fd': Permission denied
du: cannot read directory `proc/1312/task/1313/fdinfo': Permission denied
du: cannot read directory `proc/1312/task/1313/ns': Permission denied
du: cannot read directory `proc/1312/fd': Permission denied
du: cannot read directory `proc/1312/fdinfo': Permission denied
du: cannot read directory `proc/1312/ns': Permission denied
du: cannot read directory `proc/1334/task/1334/fd': Permission denied
du: cannot read directory `proc/1334/task/1334/fdinfo': Permission denied
du: cannot read directory `proc/1334/task/1334/ns': Permission denied
du: cannot read directory `proc/1334/task/1335/fd': Permission denied
du: cannot read directory `proc/1334/task/1335/fdinfo': Permission denied
du: cannot read directory `proc/1334/task/1335/ns': Permission denied
du: cannot read directory `proc/1334/task/1337/fd': Permission denied
du: cannot read directory `proc/1334/task/1337/fdinfo': Permission denied
du: cannot read directory `proc/1334/task/1337/ns': Permission denied
du: cannot read directory `proc/1334/task/1338/fd': Permission denied
du: cannot read directory `proc/1334/task/1338/fdinfo': Permission denied
du: cannot read directory `proc/1334/task/1338/ns': Permission denied
du: cannot read directory `proc/1334/fd': Permission denied
du: cannot read directory `proc/1334/fdinfo': Permission denied
du: cannot read directory `proc/1334/ns': Permission denied
du: cannot read directory `proc/1363/task/1363/fd': Permission denied
du: cannot read directory `proc/1363/task/1363/fdinfo': Permission denied
du: cannot read directory `proc/1363/task/1363/ns': Permission denied
du: cannot read directory `proc/1363/fd': Permission denied
du: cannot read directory `proc/1363/fdinfo': Permission denied
du: cannot read directory `proc/1363/ns': Permission denied
du: cannot read directory `proc/1379/task/1379/fd': Permission denied
du: cannot read directory `proc/1379/task/1379/fdinfo': Permission denied
du: cannot read directory `proc/1379/task/1379/ns': Permission denied
du: cannot read directory `proc/1379/fd': Permission denied
du: cannot read directory `proc/1379/fdinfo': Permission denied
du: cannot read directory `proc/1379/ns': Permission denied
du: cannot read directory `proc/1380/task/1380/fd': Permission denied
du: cannot read directory `proc/1380/task/1380/fdinfo': Permission denied
du: cannot read directory `proc/1380/task/1380/ns': Permission denied
du: cannot read directory `proc/1380/fd': Permission denied
du: cannot read directory `proc/1380/fdinfo': Permission denied
du: cannot read directory `proc/1380/ns': Permission denied
du: cannot read directory `proc/1381/task/1381/fd': Permission denied
du: cannot read directory `proc/1381/task/1381/fdinfo': Permission denied
du: cannot read directory `proc/1381/task/1381/ns': Permission denied
du: cannot read directory `proc/1381/fd': Permission denied
du: cannot read directory `proc/1381/fdinfo': Permission denied
du: cannot read directory `proc/1381/ns': Permission denied
du: cannot read directory `proc/1382/task/1382/fd': Permission denied
du: cannot read directory `proc/1382/task/1382/fdinfo': Permission denied
du: cannot read directory `proc/1382/task/1382/ns': Permission denied
du: cannot read directory `proc/1382/fd': Permission denied
du: cannot read directory `proc/1382/fdinfo': Permission denied
du: cannot read directory `proc/1382/ns': Permission denied
du: cannot read directory `proc/1383/task/1383/fd': Permission denied
du: cannot read directory `proc/1383/task/1383/fdinfo': Permission denied
du: cannot read directory `proc/1383/task/1383/ns': Permission denied
du: cannot read directory `proc/1383/fd': Permission denied
du: cannot read directory `proc/1383/fdinfo': Permission denied
du: cannot read directory `proc/1383/ns': Permission denied
du: cannot read directory `proc/1384/task/1384/fd': Permission denied
du: cannot read directory `proc/1384/task/1384/fdinfo': Permission denied
du: cannot read directory `proc/1384/task/1384/ns': Permission denied
du: cannot read directory `proc/1384/fd': Permission denied
du: cannot read directory `proc/1384/fdinfo': Permission denied
du: cannot read directory `proc/1384/ns': Permission denied
du: cannot read directory `proc/1385/task/1385/fd': Permission denied
du: cannot read directory `proc/1385/task/1385/fdinfo': Permission denied
du: cannot read directory `proc/1385/task/1385/ns': Permission denied
du: cannot read directory `proc/1385/fd': Permission denied
du: cannot read directory `proc/1385/fdinfo': Permission denied
du: cannot read directory `proc/1385/ns': Permission denied
du: cannot read directory `proc/1407/task/1407/fd': Permission denied
du: cannot read directory `proc/1407/task/1407/fdinfo': Permission denied
du: cannot read directory `proc/1407/task/1407/ns': Permission denied
du: cannot read directory `proc/1407/fd': Permission denied
du: cannot read directory `proc/1407/fdinfo': Permission denied
du: cannot read directory `proc/1407/ns': Permission denied
du: cannot read directory `proc/1442/task/1442/fd': Permission denied
du: cannot read directory `proc/1442/task/1442/fdinfo': Permission denied
du: cannot read directory `proc/1442/task/1442/ns': Permission denied
du: cannot read directory `proc/1442/task/1443/fd': Permission denied
du: cannot read directory `proc/1442/task/1443/fdinfo': Permission denied
du: cannot read directory `proc/1442/task/1443/ns': Permission denied
du: cannot read directory `proc/1442/fd': Permission denied
du: cannot read directory `proc/1442/fdinfo': Permission denied
du: cannot read directory `proc/1442/ns': Permission denied
du: cannot read directory `proc/1493/task/1493/fd': Permission denied
du: cannot read directory `proc/1493/task/1493/fdinfo': Permission denied
du: cannot read directory `proc/1493/task/1493/ns': Permission denied
du: cannot read directory `proc/1493/task/1494/fd': Permission denied
du: cannot read directory `proc/1493/task/1494/fdinfo': Permission denied
du: cannot read directory `proc/1493/task/1494/ns': Permission denied
du: cannot read directory `proc/1493/task/1495/fd': Permission denied
du: cannot read directory `proc/1493/task/1495/fdinfo': Permission denied
du: cannot read directory `proc/1493/task/1495/ns': Permission denied
du: cannot read directory `proc/1493/task/1498/fd': Permission denied
du: cannot read directory `proc/1493/task/1498/fdinfo': Permission denied
du: cannot read directory `proc/1493/task/1498/ns': Permission denied
du: cannot read directory `proc/1493/task/1501/fd': Permission denied
du: cannot read directory `proc/1493/task/1501/fdinfo': Permission denied
du: cannot read directory `proc/1493/task/1501/ns': Permission denied
du: cannot read directory `proc/1493/fd': Permission denied
du: cannot read directory `proc/1493/fdinfo': Permission denied
du: cannot read directory `proc/1493/ns': Permission denied
du: cannot read directory `proc/1513/task/1513/fd': Permission denied
du: cannot read directory `proc/1513/task/1513/fdinfo': Permission denied
du: cannot read directory `proc/1513/task/1513/ns': Permission denied
du: cannot read directory `proc/1513/fd': Permission denied
du: cannot read directory `proc/1513/fdinfo': Permission denied
du: cannot read directory `proc/1513/ns': Permission denied
du: cannot read directory `proc/1530/task/1530/fd': Permission denied
du: cannot read directory `proc/1530/task/1530/fdinfo': Permission denied
du: cannot read directory `proc/1530/task/1530/ns': Permission denied
du: cannot read directory `proc/1530/fd': Permission denied
du: cannot read directory `proc/1530/fdinfo': Permission denied
du: cannot read directory `proc/1530/ns': Permission denied
du: cannot read directory `proc/1541/task/1541/fd': Permission denied
du: cannot read directory `proc/1541/task/1541/fdinfo': Permission denied
du: cannot read directory `proc/1541/task/1541/ns': Permission denied
du: cannot read directory `proc/1541/fd': Permission denied
du: cannot read directory `proc/1541/fdinfo': Permission denied
du: cannot read directory `proc/1541/ns': Permission denied
du: cannot read directory `proc/1552/task/1552/fd': Permission denied
du: cannot read directory `proc/1552/task/1552/fdinfo': Permission denied
du: cannot read directory `proc/1552/task/1552/ns': Permission denied
du: cannot read directory `proc/1552/fd': Permission denied
du: cannot read directory `proc/1552/fdinfo': Permission denied
du: cannot read directory `proc/1552/ns': Permission denied
du: cannot read directory `proc/1573/task/1573/fd': Permission denied
du: cannot read directory `proc/1573/task/1573/fdinfo': Permission denied
du: cannot read directory `proc/1573/task/1573/ns': Permission denied
du: cannot read directory `proc/1573/fd': Permission denied
du: cannot read directory `proc/1573/fdinfo': Permission denied
du: cannot read directory `proc/1573/ns': Permission denied
du: cannot read directory `proc/1583/task/1583/fd': Permission denied
du: cannot read directory `proc/1583/task/1583/fdinfo': Permission denied
du: cannot read directory `proc/1583/task/1583/ns': Permission denied
du: cannot read directory `proc/1583/fd': Permission denied
du: cannot read directory `proc/1583/fdinfo': Permission denied
du: cannot read directory `proc/1583/ns': Permission denied
du: cannot read directory `proc/1619/task/1619/fd': Permission denied
du: cannot read directory `proc/1619/task/1619/fdinfo': Permission denied
du: cannot read directory `proc/1619/task/1619/ns': Permission denied
du: cannot read directory `proc/1619/fd': Permission denied
du: cannot read directory `proc/1619/fdinfo': Permission denied
du: cannot read directory `proc/1619/ns': Permission denied
du: cannot read directory `proc/1644/task/1644/fd': Permission denied
du: cannot read directory `proc/1644/task/1644/fdinfo': Permission denied
du: cannot read directory `proc/1644/task/1644/ns': Permission denied
du: cannot read directory `proc/1644/fd': Permission denied
du: cannot read directory `proc/1644/fdinfo': Permission denied
du: cannot read directory `proc/1644/ns': Permission denied
du: cannot read directory `proc/1714/task/1714/fd': Permission denied
du: cannot read directory `proc/1714/task/1714/fdinfo': Permission denied
du: cannot read directory `proc/1714/task/1714/ns': Permission denied
du: cannot read directory `proc/1714/fd': Permission denied
du: cannot read directory `proc/1714/fdinfo': Permission denied
du: cannot read directory `proc/1714/ns': Permission denied
du: cannot read directory `proc/1723/task/1723/fd': Permission denied
du: cannot read directory `proc/1723/task/1723/fdinfo': Permission denied
du: cannot read directory `proc/1723/task/1723/ns': Permission denied
du: cannot read directory `proc/1723/fd': Permission denied
du: cannot read directory `proc/1723/fdinfo': Permission denied
du: cannot read directory `proc/1723/ns': Permission denied
du: cannot read directory `proc/1727/task/1727/fd': Permission denied
du: cannot read directory `proc/1727/task/1727/fdinfo': Permission denied
du: cannot read directory `proc/1727/task/1727/ns': Permission denied
du: cannot read directory `proc/1727/fd': Permission denied
du: cannot read directory `proc/1727/fdinfo': Permission denied
du: cannot read directory `proc/1727/ns': Permission denied
du: cannot read directory `proc/1731/task/1731/fd': Permission denied
du: cannot read directory `proc/1731/task/1731/fdinfo': Permission denied
du: cannot read directory `proc/1731/task/1731/ns': Permission denied
du: cannot read directory `proc/1731/fd': Permission denied
du: cannot read directory `proc/1731/fdinfo': Permission denied
du: cannot read directory `proc/1731/ns': Permission denied
du: cannot read directory `proc/1735/task/1735/fd': Permission denied
du: cannot read directory `proc/1735/task/1735/fdinfo': Permission denied
du: cannot read directory `proc/1735/task/1735/ns': Permission denied
du: cannot read directory `proc/1735/fd': Permission denied
du: cannot read directory `proc/1735/fdinfo': Permission denied
du: cannot read directory `proc/1735/ns': Permission denied
du: cannot read directory `proc/1861/task/1861/fd': Permission denied
du: cannot read directory `proc/1861/task/1861/fdinfo': Permission denied
du: cannot read directory `proc/1861/task/1861/ns': Permission denied
du: cannot read directory `proc/1861/fd': Permission denied
du: cannot read directory `proc/1861/fdinfo': Permission denied
du: cannot read directory `proc/1861/ns': Permission denied
du: cannot read directory `proc/1863/task/1863/fd': Permission denied
du: cannot read directory `proc/1863/task/1863/fdinfo': Permission denied
du: cannot read directory `proc/1863/task/1863/ns': Permission denied
du: cannot read directory `proc/1863/fd': Permission denied
du: cannot read directory `proc/1863/fdinfo': Permission denied
du: cannot read directory `proc/1863/ns': Permission denied
du: cannot read directory `proc/1865/task/1865/fd': Permission denied
du: cannot read directory `proc/1865/task/1865/fdinfo': Permission denied
du: cannot read directory `proc/1865/task/1865/ns': Permission denied
du: cannot read directory `proc/1865/fd': Permission denied
du: cannot read directory `proc/1865/fdinfo': Permission denied
du: cannot read directory `proc/1865/ns': Permission denied
du: cannot read directory `proc/1867/task/1867/fd': Permission denied
du: cannot read directory `proc/1867/task/1867/fdinfo': Permission denied
du: cannot read directory `proc/1867/task/1867/ns': Permission denied
du: cannot read directory `proc/1867/fd': Permission denied
du: cannot read directory `proc/1867/fdinfo': Permission denied
du: cannot read directory `proc/1867/ns': Permission denied
du: cannot read directory `proc/1868/task/1868/fd': Permission denied
du: cannot read directory `proc/1868/task/1868/fdinfo': Permission denied
du: cannot read directory `proc/1868/task/1868/ns': Permission denied
du: cannot read directory `proc/1868/fd': Permission denied
du: cannot read directory `proc/1868/fdinfo': Permission denied
du: cannot read directory `proc/1868/ns': Permission denied
du: cannot read directory `proc/1870/task/1870/fd': Permission denied
du: cannot read directory `proc/1870/task/1870/fdinfo': Permission denied
du: cannot read directory `proc/1870/task/1870/ns': Permission denied
du: cannot read directory `proc/1870/fd': Permission denied
du: cannot read directory `proc/1870/fdinfo': Permission denied
du: cannot read directory `proc/1870/ns': Permission denied
du: cannot read directory `proc/1871/task/1871/fd': Permission denied
du: cannot read directory `proc/1871/task/1871/fdinfo': Permission denied
du: cannot read directory `proc/1871/task/1871/ns': Permission denied
du: cannot read directory `proc/1871/fd': Permission denied
du: cannot read directory `proc/1871/fdinfo': Permission denied
du: cannot read directory `proc/1871/ns': Permission denied
du: cannot read directory `proc/1873/task/1873/fd': Permission denied
du: cannot read directory `proc/1873/task/1873/fdinfo': Permission denied
du: cannot read directory `proc/1873/task/1873/ns': Permission denied
du: cannot read directory `proc/1873/fd': Permission denied
du: cannot read directory `proc/1873/fdinfo': Permission denied
du: cannot read directory `proc/1873/ns': Permission denied
du: cannot read directory `proc/31060/task/31060/fd': Permission denied
du: cannot read directory `proc/31060/task/31060/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31060/ns': Permission denied
du: cannot read directory `proc/31060/task/31062/fd': Permission denied
du: cannot read directory `proc/31060/task/31062/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31062/ns': Permission denied
du: cannot read directory `proc/31060/task/31063/fd': Permission denied
du: cannot read directory `proc/31060/task/31063/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31063/ns': Permission denied
du: cannot read directory `proc/31060/task/31064/fd': Permission denied
du: cannot read directory `proc/31060/task/31064/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31064/ns': Permission denied
du: cannot read directory `proc/31060/task/31065/fd': Permission denied
du: cannot read directory `proc/31060/task/31065/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31065/ns': Permission denied
du: cannot read directory `proc/31060/task/31066/fd': Permission denied
du: cannot read directory `proc/31060/task/31066/fdinfo': Permission denied
du: cannot read directory `proc/31060/task/31066/ns': Permission denied
du: cannot read directory `proc/31060/fd': Permission denied
du: cannot read directory `proc/31060/fdinfo': Permission denied
du: cannot read directory `proc/31060/ns': Permission denied
du: cannot read directory `proc/32508/task/32508/fd': Permission denied
du: cannot read directory `proc/32508/task/32508/fdinfo': Permission denied
du: cannot read directory `proc/32508/task/32508/ns': Permission denied
du: cannot read directory `proc/32508/fd': Permission denied
du: cannot read directory `proc/32508/fdinfo': Permission denied
du: cannot read directory `proc/32508/ns': Permission denied
du: cannot read directory `proc/32515/task/32515/fd': Permission denied
du: cannot read directory `proc/32515/task/32515/fdinfo': Permission denied
du: cannot read directory `proc/32515/task/32515/ns': Permission denied
du: cannot read directory `proc/32515/fd': Permission denied
du: cannot read directory `proc/32515/fdinfo': Permission denied
du: cannot read directory `proc/32515/ns': Permission denied
0	proc
du: cannot read directory `root': Permission denied
4.0K	root
16M	sbin
0	selinux
4.0K	srv
0	sys
16M	tmp
du: cannot read directory `usr/lib64/audit': Permission denied
763M	usr
du: cannot read directory `var/lost+found': Permission denied
du: cannot read directory `var/empty/sshd': Permission denied
du: cannot read directory `var/log/audit': Permission denied
du: cannot read directory `var/log/httpd': Permission denied
du: cannot read directory `var/log/sssd': Permission denied
du: cannot read directory `var/log/nagios': Permission denied
du: cannot read directory `var/log/samba': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/2': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/10': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/6': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/3': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/13': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/4': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/12': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/11': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/7': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/8': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/5': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/9': Permission denied
du: cannot read directory `var/lib/yum/history/2014-12-02/1': Permission denied
du: cannot read directory `var/lib/dav': Permission denied
du: cannot read directory `var/lib/php/session': Permission denied
du: cannot read directory `var/lib/net-snmp/mib_indexes': Permission denied
du: cannot read directory `var/lib/rsyslog': Permission denied
du: cannot read directory `var/lib/certmonger/cas': Permission denied
du: cannot read directory `var/lib/certmonger/local': Permission denied
du: cannot read directory `var/lib/certmonger/requests': Permission denied
du: cannot read directory `var/lib/nfs/statd': Permission denied
du: cannot read directory `var/lib/authconfig': Permission denied
du: cannot read directory `var/lib/samba/private': Permission denied
du: cannot read directory `var/lib/samba/winbindd_privileged': Permission denied
du: cannot read directory `var/lib/sss/db': Permission denied
du: cannot read directory `var/lib/sss/keytabs': Permission denied
du: cannot read directory `var/lib/sss/pipes/private': Permission denied
du: cannot read directory `var/lib/postfix': Permission denied
du: cannot read directory `var/spool/clientmqueue': Permission denied
du: cannot read directory `var/spool/mqueue': Permission denied
du: cannot read directory `var/spool/cron': Permission denied
du: cannot read directory `var/spool/nagios/checkresults': Permission denied
du: cannot read directory `var/spool/postfix/bounce': Permission denied
du: cannot read directory `var/spool/postfix/private': Permission denied
du: cannot read directory `var/spool/postfix/active': Permission denied
du: cannot read directory `var/spool/postfix/maildrop': Permission denied
du: cannot read directory `var/spool/postfix/hold': Permission denied
du: cannot read directory `var/spool/postfix/trace': Permission denied
du: cannot read directory `var/spool/postfix/incoming': Permission denied
du: cannot read directory `var/spool/postfix/defer': Permission denied
du: cannot read directory `var/spool/postfix/public': Permission denied
du: cannot read directory `var/spool/postfix/flush': Permission denied
du: cannot read directory `var/spool/postfix/deferred': Permission denied
du: cannot read directory `var/spool/postfix/corrupt': Permission denied
du: cannot read directory `var/spool/postfix/saved': Permission denied
du: cannot read directory `var/db/sudo': Permission denied
du: cannot read directory `var/cache/rpcbind': Permission denied
du: cannot read directory `var/cache/ldconfig': Permission denied
du: cannot read directory `var/cache/mod_proxy': Permission denied
du: cannot read directory `var/ossec': Permission denied
du: cannot read directory `var/run/httpd': Permission denied
du: cannot read directory `var/run/certmonger/.config': Permission denied
du: cannot read directory `var/run/certmonger/.pki': Permission denied
du: cannot read directory `var/run/mdadm': Permission denied
du: cannot read directory `var/run/lvm': Permission denied
du: cannot read directory `var/run/nagios': Permission denied
du: cannot read directory `var/lock/lvm': Permission denied
1.1G	var
[postgres@atlrad26 /]$ whoami
postgres
[postgres@atlrad26 /]$ su -
Password: 
[root@atlrad26 ~]# 
[root@atlrad26 ~]# 
[root@atlrad26 ~]# 
[root@atlrad26 ~]# 
[root@atlrad26 ~]# cd / 
[root@atlrad26 /]# 
[root@atlrad26 /]# 
[root@atlrad26 /]# 
[root@atlrad26 /]# 
[root@atlrad26 /]# 
[root@atlrad26 /]# du -sh *
6.6M	bin
69M	boot
172K	dev
30M	etc
960M	home
389M	lib
26M	lib64
16K	lost+found
4.0K	media
0	misc
4.0K	mnt
0	net
17G	opt
du: cannot access `proc/526/task/526/fd/4': No such file or directory
du: cannot access `proc/526/task/526/fdinfo/4': No such file or directory
du: cannot access `proc/526/fd/4': No such file or directory
du: cannot access `proc/526/fdinfo/4': No such file or directory
0	proc
202M	root
16M	sbin
0	selinux
4.0K	srv
0	sys
16M	tmp
763M	usr
1.1G	var
[root@atlrad26 /]# cd /opt/
[root@atlrad26 opt]# ll
total 12
drwxr-xr-x. 9 root root 4096 Mar 16  2015 freeradius
drwxr-xr-x. 9 root root 4096 Dec  4  2014 freeradius-3.0.5
drwxr-xr-x. 8 root root 4096 Dec  3  2014 pgsql
[root@atlrad26 opt]# du -sh *
59M	freeradius
27M	freeradius-3.0.5
17G	pgsql
[root@atlrad26 opt]# cd pgsql/
[root@atlrad26 pgsql]# ll
total 36
drwxr-xr-x.  2 root     root      4096 Dec  3  2014 bin
drwx------. 14 postgres postgres  4096 Aug  7 12:45 data
drwxr-xr-x.  6 root     root      4096 Dec  3  2014 include
drwxr-xr-x.  3 root     root      4096 Dec  3  2014 lib
drwxr-xr-x.  2 postgres postgres 12288 Aug  7 12:45 log
-rw-r--r--.  1 root     root       673 Dec  4  2014 logfile
drwxr-xr-x.  6 root     root      4096 Dec  3  2014 share
[root@atlrad26 pgsql]# du -sh *
8.2M	bin
17G	data
4.3M	include
5.4M	lib
8.0M	log
4.0K	logfile
3.1M	share
[root@atlrad26 pgsql]# cd data/
[root@atlrad26 data]# du -sh *
17G	base
528K	global
20M	pg_clog
8.0K	pg_hba.conf
8.0K	pg_hba.conf.orig
4.0K	pg_ident.conf
28K	pg_multixact
12K	pg_notify
4.0K	pg_serial
4.0K	pg_snapshots
28K	pg_stat_tmp
116K	pg_subtrans
4.0K	pg_tblspc
4.0K	pg_twophase
4.0K	PG_VERSION
81M	pg_xlog
20K	postgresql.conf
20K	postgresql.conf.orig
4.0K	postmaster.opts
4.0K	postmaster.pid
40K	serverlog
[root@atlrad26 data]# cd base/
[root@atlrad26 base]# du -sh *
6.3M	1
6.3M	12865
6.3M	12870
7.1M	16388
17G	16681
[root@atlrad26 base]# logout
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ 
[postgres@atlrad26 /]$ psql 
psql (9.2.2)
Type "help" for help.

radiusdb=> \dt
                     List of relations
  Schema  |          Name          | Type  |     Owner      
----------+------------------------+-------+----------------
 radiusdb | attribute              | table | radiusdb_owner
 radiusdb | attribute_type         | table | radiusdb_owner
 radiusdb | groupname              | table | radiusdb_owner
 radiusdb | nas                    | table | radiusdb_owner
 radiusdb | radacct                | table | radiusdb_owner
 radiusdb | radcheck               | table | radiusdb_owner
 radiusdb | radgroupcheck          | table | radiusdb_owner
 radiusdb | radgroupreply          | table | radiusdb_owner
 radiusdb | radius_change_log      | table | radiusdb_owner
 radiusdb | radius_last_change_log | table | radiusdb_owner
 radiusdb | radpostauth            | table | radiusdb_owner
 radiusdb | radreply               | table | radiusdb_owner
 radiusdb | replication_failure    | table | radiusdb_owner
 radiusdb | replication_parameter  | table | slony
 radiusdb | usergroup              | table | radiusdb_owner
 radiusdb | username               | table | radiusdb_owner
(16 rows)

radiusdb=> SELECT nspname || '.' || relname AS "relation",
radiusdb->     pg_size_pretty(pg_relation_size(C.oid)) AS "size"
radiusdb->   FROM pg_class C
radiusdb->   LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
radiusdb->   WHERE nspname NOT IN ('pg_catalog', 'information_schema')
radiusdb->   ORDER BY pg_relation_size(C.oid) DESC
radiusdb->   LIMIT 20;
           relation            |    size    
-------------------------------+------------
 pg_toast.pg_toast_2618        | 320 kB
 pg_toast.pg_toast_1255        | 24 kB
 pg_toast.pg_toast_2619_index  | 16 kB
 pg_toast.pg_toast_2618_index  | 16 kB
 pg_toast.pg_toast_1255_index  | 16 kB
 pg_toast.pg_toast_2619        | 16 kB
 pg_toast.pg_toast_12465_index | 8192 bytes
 pg_toast.pg_toast_12455_index | 8192 bytes
 pg_toast.pg_toast_12470_index | 8192 bytes
 pg_toast.pg_toast_2396_index  | 8192 bytes
 pg_toast.pg_toast_2606_index  | 8192 bytes
 pg_toast.pg_toast_3596_index  | 8192 bytes
 pg_toast.pg_toast_2620_index  | 8192 bytes
 pg_toast.pg_toast_12460_index | 8192 bytes
 pg_toast.pg_toast_2609_index  | 8192 bytes
 pg_toast.pg_toast_2604_index  | 8192 bytes
 pg_toast.pg_toast_16449_index | 8192 bytes
 pg_toast.pg_toast_2964_index  | 8192 bytes
 radiusdb.nas_id_seq           | 8192 bytes
 pg_toast.pg_toast_12475_index | 8192 bytes
(20 rows)

radiusdb=> \dn
      List of schemas
   Name   |     Owner      
----------+----------------
 public   | postgres
 radiusdb | radiusdb_owner
(2 rows)

radiusdb=> show search_path ;
            search_path             
------------------------------------
 "$user",public,radiusdb,usccsprint
(1 row)

radiusdb=> \l
                                           List of databases
    Name    |     Owner      | Encoding |   Collate   |    Ctype    |         Access privileges         
------------+----------------+----------+-------------+-------------+-----------------------------------
 postgres   | postgres       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 radiusdb   | radiusdb_owner | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/radiusdb_owner               +
            |                |          |             |             | radiusdb_owner=CTc/radiusdb_owner+
            |                |          |             |             | slony=CTc/radiusdb_owner
 template0  | postgres       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                      +
            |                |          |             |             | postgres=CTc/postgres
 template1  | postgres       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                      +
            |                |          |             |             | postgres=CTc/postgres
 usccsprint | radiusdb_owner | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(5 rows)

radiusdb=> \q
[postgres@atlrad26 /]$ psql ucsssprint
psql: FATAL:  database "ucsssprint" does not exist
[postgres@atlrad26 /]$ psql usccprint
psql: FATAL:  database "usccprint" does not exist
[postgres@atlrad26 /]$ psql usccsprint
psql (9.2.2)
Type "help" for help.

usccsprint=> SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  ORDER BY pg_relation_size(C.oid) DESC
  LIMIT 20;
                     relation                      |  size   
---------------------------------------------------+---------
 radiusdb.radpostauth                              | 8325 MB
 radiusdb.radius_change_log                        | 5202 MB
 radiusdb.radpostauth_pkey                         | 1712 MB
 radiusdb.radius_change_log_pkey                   | 1712 MB
 radiusdb.radcheck                                 | 2824 kB
 radiusdb.username                                 | 2744 kB
 radiusdb.usergroup                                | 2672 kB
 radiusdb.radcheck_uk1                             | 2512 kB
 radiusdb.usergroup_username_groupname_priority_uk | 2376 kB
 radiusdb.radcheck_username                        | 2352 kB
 radiusdb.usergroup_username_priority_uk           | 1800 kB
 radiusdb.radreply                                 | 1768 kB
 radiusdb.username_pkey                            | 1544 kB
 radiusdb.usergroup_username                       | 1536 kB
 radiusdb.radreply_uk1                             | 1480 kB
 radiusdb.radreply_username                        | 1264 kB
 radiusdb.radcheck_pkey                            | 704 kB
 radiusdb.radreply_pkey                            | 464 kB
 pg_toast.pg_toast_2618                            | 320 kB
 radiusdb.radgroupreply_uk1                        | 72 kB
(20 rows)

usccsprint=> select count(*) from radpostauth;
  count   
----------
 79903940
(1 row)

usccsprint=> \d radpostauth
                                           Table "radiusdb.radpostauth"
  Column  |           Type           |                                 Modifiers                                  
----------+--------------------------+----------------------------------------------------------------------------
 id       | bigint                   | not null default nextval('radpostauth_id_seq'::regclass)
 username | character varying(64)    | not null
 pass     | character varying(128)   | 
 reply    | character varying(32)    | 
 authdate | timestamp with time zone | not null default '2007-11-29 19:11:54.884507+00'::timestamp with time zone
Indexes:
    "radpostauth_pkey" PRIMARY KEY, btree (id)
Triggers:
    radpostauth_change_log_trig AFTER INSERT OR UPDATE ON radpostauth FOR EACH ROW EXECUTE PROCEDURE radpostauth_change_log()

usccsprint=> select * from radpostauth limit 30;
 id |           username            |     pass      |     reply     |           authdate            
----+-------------------------------+---------------+---------------+-------------------------------
  1 | 3128545337@cn01.sprintpcs.com | m0UXyg        | Access-Accept | 2015-03-17 03:53:38.295144+00
  2 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:47:09.746649+00
  3 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:47:23.196683+00
  4 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:47:36.748571+00
  5 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:47:47.656933+00
  6 | 3124375724@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:47:49.713667+00
  7 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:05.216396+00
  8 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:11.208977+00
  9 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:23.191414+00
 10 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:35.487045+00
 11 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:36.232689+00
 12 | 3122179234@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:48:41.678597+00
 13 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:09.304011+00
 14 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:21.458138+00
 15 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:38.112444+00
 16 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:40.444738+00
 17 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:44.540846+00
 18 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:50.53103+00
 19 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:49:55.435585+00
 20 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:00.804387+00
 21 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:13.011998+00
 22 | 3123887458@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:15.717762+00
 23 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:17.451356+00
 24 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:20.329263+00
 25 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:22.743439+00
 26 | 3124372734@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:36.970619+00
 27 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:47.347798+00
 28 | 3124376212@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:50.33801+00
 29 | 3124371829@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:54.816404+00
 30 | 3124376184@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2015-03-17 04:50:58.725581+00
(30 rows)

usccsprint=> select count(*) from radpostauth;
  count   
----------
 79904019
(1 row)

usccsprint=> SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  ORDER BY pg_relation_size(C.oid) DESC
  LIMIT 20;
                     relation                      |  size   
---------------------------------------------------+---------
 radiusdb.radpostauth                              | 8325 MB
 radiusdb.radius_change_log                        | 5202 MB
 radiusdb.radpostauth_pkey                         | 1712 MB
 radiusdb.radius_change_log_pkey                   | 1712 MB
 radiusdb.radcheck                                 | 2824 kB
 radiusdb.username                                 | 2744 kB
 radiusdb.usergroup                                | 2672 kB
 radiusdb.radcheck_uk1                             | 2512 kB
 radiusdb.usergroup_username_groupname_priority_uk | 2376 kB
 radiusdb.radcheck_username                        | 2352 kB
 radiusdb.usergroup_username_priority_uk           | 1800 kB
 radiusdb.radreply                                 | 1768 kB
 radiusdb.username_pkey                            | 1544 kB
 radiusdb.usergroup_username                       | 1536 kB
 radiusdb.radreply_uk1                             | 1480 kB
 radiusdb.radreply_username                        | 1264 kB
 radiusdb.radcheck_pkey                            | 704 kB
 radiusdb.radreply_pkey                            | 464 kB
 pg_toast.pg_toast_2618                            | 320 kB
 radiusdb.radgroupreply_uk1                        | 72 kB
(20 rows)

usccsprint=> select * from radpostauth order by 1 desc limit 30;
    id    |            username             |     pass      |     reply     |           authdate            
----------+---------------------------------+---------------+---------------+-------------------------------
 83524085 | 3123888685@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:10.16401+00
 83524084 | 3123888592@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:07.998028+00
 83524083 | 3124377142@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:06.18489+00
 83524082 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 22:45:03.799297+00
 83524081 | 3125467623@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:03.589315+00
 83524080 | 3124377747@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:03.54027+00
 83524079 | 3124377132@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:02.969682+00
 83524078 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:02.932945+00
 83524077 | 3124372654@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:02.719901+00
 83524076 | 3125467623@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:01.512166+00
 83524075 | 3122178327@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:45:00.660826+00
 83524074 | 3124375658@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:57.487204+00
 83524073 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:57.244457+00
 83524072 | 3124373358@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:55.027586+00
 83524071 | 3124372487@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:54.360256+00
 83524070 | 3125460602@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:53.56624+00
 83524069 | 3124377747@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:52.912082+00
 83524068 | 3123889622@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:52.284251+00
 83524067 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:51.798092+00
 83524066 | 3124377232@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:51.265445+00
 83524065 | 3124377132@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:50.650273+00
 83524064 | 3126711408@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:49.425531+00
 83524063 | 3123888799@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:49.409978+00
 83524062 | 3124372654@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:45.796925+00
 83524061 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:43.485916+00
 83524060 | 3125460555@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:42.492672+00
 83524059 | 3124378081@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:41.834756+00
 83524058 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:41.455957+00
 83524057 | 3124372487@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 22:44:41.086594+00
 83524056 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 22:44:40.106703+00
(30 rows)

usccsprint=> set timezone TO MST7MDT;
SET
usccsprint=> select * from radpostauth order by 1 desc limit 30;
    id    |            username             |     pass      |     reply     |           authdate            
----------+---------------------------------+---------------+---------------+-------------------------------
 83524099 | 3124377142@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:29.245336-06
 83524098 | 3126711336@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:27.05786-06
 83524097 | 3126712029@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:26.756395-06
 83524096 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 16:45:26.389273-06
 83524095 | 3124376941@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:25.410094-06
 83524094 | 3125460246@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:23.858017-06
 83524093 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:21.696252-06
 83524092 | 3123888592@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:19.393681-06
 83524091 | 3124377038@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:19.098653-06
 83524090 | 3122179445@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:16.994623-06
 83524089 | 3124373358@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:16.444265-06
 83524088 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 16:45:15.50312-06
 83524087 | 3124379061@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:12.094729-06
 83524086 | 3124375784@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:10.786379-06
 83524085 | 3123888685@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:10.16401-06
 83524084 | 3123888592@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:07.998028-06
 83524083 | 3124377142@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:06.18489-06
 83524082 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 16:45:03.799297-06
 83524081 | 3125467623@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:03.589315-06
 83524080 | 3124377747@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:03.54027-06
 83524079 | 3124377132@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:02.969682-06
 83524078 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:02.932945-06
 83524077 | 3124372654@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:02.719901-06
 83524076 | 3125467623@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:01.512166-06
 83524075 | 3122178327@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:45:00.660826-06
 83524074 | 3124375658@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:44:57.487204-06
 83524073 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:44:57.244457-06
 83524072 | 3124373358@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:44:55.027586-06
 83524071 | 3124372487@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:44:54.360256-06
 83524070 | 3125460602@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:44:53.56624-06
(30 rows)

usccsprint=> select * from radpostauth order by 1 desc limit 30;
    id    |            username             |     pass      |     reply     |           authdate            
----------+---------------------------------+---------------+---------------+-------------------------------
 83524353 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:07.352569-06
 83524352 | 3123888592@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:06.771595-06
 83524351 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:06.394193-06
 83524350 | 3126712029@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:06.202178-06
 83524349 | 3124372654@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:05.599606-06
 83524348 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:05.369978-06
 83524347 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:04.863694-06
 83524346 | 3123888592@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:04.781686-06
 83524345 | 3124377142@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:04.536793-06
 83524344 | 3125460602@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:04.241732-06
 83524343 | 3125462213@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:03.575702-06
 83524342 | 3125467623@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:02.519115-06
 83524341 | 3124376652@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:00.488135-06
 83524340 | 3125460555@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:49:00.026697-06
 83524339 | 312217=15694@cn01.sprintpcs.com | Chap-Password | Access-Reject | 2018-08-07 16:48:59.54167-06
 83524338 | 3124377747@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:58.651589-06
 83524337 | 3124376941@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:58.442726-06
 83524336 | 3124377038@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:57.902762-06
 83524335 | 3124377747@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:57.674074-06
 83524334 | 3122178327@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:56.739841-06
 83524333 | 3122178327@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:56.717255-06
 83524332 | 3124376941@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:56.383048-06
 83524331 | 3126712029@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:55.615157-06
 83524330 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:55.417339-06
 83524329 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:55.272176-06
 83524328 | 3128545332@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:55.059347-06
 83524327 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:54.390631-06
 83524326 | 3122178327@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:53.636801-06
 83524325 | 3124378289@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:53.379752-06
 83524324 | 3124375682@cn01.sprintpcs.com   | Chap-Password | Access-Accept | 2018-08-07 16:48:53.227522-06
(30 rows)

usccsprint=> select * from radpostauth where username = '3124377142@cn01.sprintpcs.com' order by 1 desc limit 30;
    id    |           username            |     pass      |     reply     |           authdate            
----------+-------------------------------+---------------+---------------+-------------------------------
 83524380 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:27.334019-06
 83524363 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:15.196279-06
 83524345 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:04.536793-06
 83524287 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:33.084663-06
 83524285 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:31.005431-06
 83524265 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:20.542775-06
 83524250 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:08.092454-06
 83524209 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:36.994585-06
 83524205 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:34.935727-06
 83524198 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:18.951685-06
 83524179 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:00.888769-06
 83524111 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:44.924337-06
 83524099 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:29.245336-06
 83524083 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:06.18489-06
 83524047 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:44:32.865423-06
 83524013 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:48.7994-06
 83523996 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:32.715376-06
 83523961 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:00.185547-06
 83523924 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:42:18.675063-06
 83523914 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:42:01.663553-06
 83523904 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:50.063508-06
 83523888 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:33.977277-06
 83523871 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:16.518517-06
 83523840 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:46.796408-06
 83523826 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:33.557528-06
 83523798 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:09.385532-06
 83523796 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:07.32788-06
 83523757 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:39:39.060852-06
 83523694 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:38:42.907634-06
 83523678 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:38:29.364991-06
(30 rows)

usccsprint=> 
usccsprint=> select * from radpostauth where username = '3124377142@cn01.sprintpcs.com' order by 1 desc limit 30;
    id    |           username            |     pass      |     reply     |           authdate            
----------+-------------------------------+---------------+---------------+-------------------------------
 83524440 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:50:08.252054-06
 83524401 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:41.326504-06
 83524380 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:27.334019-06
 83524363 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:15.196279-06
 83524345 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:49:04.536793-06
 83524287 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:33.084663-06
 83524285 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:31.005431-06
 83524265 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:20.542775-06
 83524250 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:48:08.092454-06
 83524209 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:36.994585-06
 83524205 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:34.935727-06
 83524198 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:18.951685-06
 83524179 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:47:00.888769-06
 83524111 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:44.924337-06
 83524099 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:29.245336-06
 83524083 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:45:06.18489-06
 83524047 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:44:32.865423-06
 83524013 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:48.7994-06
 83523996 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:32.715376-06
 83523961 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:43:00.185547-06
 83523924 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:42:18.675063-06
 83523914 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:42:01.663553-06
 83523904 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:50.063508-06
 83523888 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:33.977277-06
 83523871 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:41:16.518517-06
 83523840 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:46.796408-06
 83523826 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:33.557528-06
 83523798 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:09.385532-06
 83523796 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:40:07.32788-06
 83523757 | 3124377142@cn01.sprintpcs.com | Chap-Password | Access-Accept | 2018-08-07 16:39:39.060852-06
(30 rows)

usccsprint=> DELETE FROM radpostauth where authdate < '2018-01-01 00:00:00'::timestamp with time zone;
^CCancel request sent
ERROR:  canceling statement due to user request
usccsprint=> 
usccsprint=> 
usccsprint=> 
usccsprint=> DELETE FROM radpostauth where authdate < '2016-01-01 00:00:00'::timestamp with time zone;
DELETE 16161302
usccsprint=> DELETE FROM radpostauth where authdate < '2017-01-01 00:00:00'::timestamp with time zone;
DELETE 26051398
usccsprint=> DELETE FROM radpostauth where authdate < '2018-01-01 00:00:00'::timestamp with time zone;
DELETE 23748675
usccsprint=> vacuum verbose analyze radpostauth;
INFO:  vacuuming "radiusdb.radpostauth"
INFO:  scanned index "radpostauth_pkey" to remove 11184525 row versions
DETAIL:  CPU 2.17s/11.20u sec elapsed 23.89 sec.
INFO:  "radpostauth": removed 11184525 row versions in 149127 pages
DETAIL:  CPU 3.71s/2.26u sec elapsed 18.44 sec.
INFO:  scanned index "radpostauth_pkey" to remove 11184525 row versions
DETAIL:  CPU 1.92s/13.76u sec elapsed 23.79 sec.
INFO:  "radpostauth": removed 11184525 row versions in 149127 pages
DETAIL:  CPU 2.26s/1.74u sec elapsed 14.66 sec.
INFO:  scanned index "radpostauth_pkey" to remove 11184525 row versions
DETAIL:  CPU 1.67s/11.96u sec elapsed 21.93 sec.
INFO:  "radpostauth": removed 11184525 row versions in 149127 pages
DETAIL:  CPU 3.58s/2.15u sec elapsed 19.00 sec.
INFO:  scanned index "radpostauth_pkey" to remove 11184525 row versions
DETAIL:  CPU 1.84s/10.42u sec elapsed 27.13 sec.
INFO:  "radpostauth": removed 11184525 row versions in 149127 pages
DETAIL:  CPU 0.83s/1.08u sec elapsed 6.40 sec.
INFO:  scanned index "radpostauth_pkey" to remove 11184525 row versions
DETAIL:  CPU 2.11s/8.69u sec elapsed 33.54 sec.
INFO:  "radpostauth": removed 11184525 row versions in 149127 pages
DETAIL:  CPU 1.85s/1.35u sec elapsed 11.57 sec.
INFO:  scanned index "radpostauth_pkey" to remove 8733139 row versions
DETAIL:  CPU 1.17s/6.30u sec elapsed 19.25 sec.
INFO:  "radpostauth": removed 8733139 row versions in 116639 pages
DETAIL:  CPU 0.53s/0.80u sec elapsed 4.81 sec.
INFO:  index "radpostauth_pkey" now contains 13944371 row versions in 219100 pages
DETAIL:  54776775 index row versions were removed.
180757 index pages have been deleted, 30484 are currently reusable.
CPU 0.00s/0.00u sec elapsed 0.49 sec.
INFO:  "radpostauth": found 23761996 removable, 48508 nonremovable row versions in 880358 out of 1065636 pages
DETAIL:  0 dead row versions cannot be removed yet.
There were 1320835 unused item pointers.
0 pages are entirely empty.
CPU 33.16s/80.54u sec elapsed 308.23 sec.
INFO:  analyzing "radiusdb.radpostauth"
INFO:  "radpostauth": scanned 30000 of 1065636 pages, containing 386646 live rows and 0 dead rows; 30000 rows in sample, 13896723 estimated total rows
VACUUM
usccsprint=> 