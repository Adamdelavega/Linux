# TP2 pt. 2 : Maintien en condition opérationnelle

## 2. Setup

 **Setup Netdata**

- y'a plein de méthodes d'install pour Netdata
- on va aller au plus simple, exécutez, sur toutes les machines que vous souhaitez monitorer :
**web.tp2.linux**
```
# Passez en root pour cette opération

[adam@web ~]$ sudo su -
[sudo] password for adam: 
[root@web ~]# 


# Install de Netdata via le script officiel statique
[root@web ~]# bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)
 --- Downloading static netdata binary: https://storage.googleapis.com/netdata-nightlies/netdata-latest.gz.run --- 
[/tmp/netdata-kickstart-Gr6SgIehe6]# curl -q -sSL --connect-timeout 10 --retry 3 --output /tmp/netdata-kickstart-Gr6SgIehe6/sha256sum.txt https://storage.googleapis.com/netdata-nightlies/sha256sums.txt 
 OK  
[...]

# Quittez la session de root
[root@web ~]# exit
logout
[adam@web ~]$ 
```
**db.tp2.linux**
```
# Passez en root pour cette opération
[adam@db ~]$ sudo su -
[sudo] password for adam: 
[root@db ~]# 

# Install de Netdata via le script officiel statique
[root@db ~]# bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)
 --- Downloading static netdata binary: https://storage.googleapis.com/netdata-nightlies/netdata-latest.gz.run --- 
[/tmp/netdata-kickstart-uWFxEyiKUJ]# curl -q -sSL --connect-timeout 10 --retry 3 --output /tmp/netdata-kickstart-uWFxEyiKUJ/sha256sum.txt https://storage.googleapis.com/netdata-nightlies/sha256sums.txt 
 OK  

# Quittez la session de root
[root@db ~]# exit
logout
[adam@db ~]$ 
```
**Manipulation du *service* Netdata**
- un *service* `netdata` a été créé
- la conf de netdata se trouve dans `/opt/netdata/etc/netdata/` (pas directement dans `/etc/netdata/`)
  - ceci est du à la méthode d'install peu orthodoxe que je vous fais utiliser
- déterminer s'il est actif, et s'il est paramétré pour démarrer au boot de la machine
```
[adam@web ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
   Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-10-11 16:21:44 CEST; 4min 11s ago
  Process: 3808 ExecStartPre=/bin/chown -R netdata:netdata /opt/netdata/var/run/netdata (code=exited, status=0/SUCCESS)
  Process: 3806 ExecStartPre=/bin/mkdir -p /opt/netdata/var/run/netdata (code=exited, status=0/SUCCESS)
  Process: 3803 ExecStartPre=/bin/chown -R netdata:netdata /opt/netdata/var/cache/netdata (code=exited, status=0/SUCCESS)
  Process: 3802 ExecStartPre=/bin/mkdir -p /opt/netdata/var/cache/netdata (code=exited, status=0/SUCCESS)
 Main PID: 3809 (netdata)
    Tasks: 36 (limit: 11391)

[adam@db ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
   Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-10-11 15:54:10 CEST; 31min ago
  Process: 2149 ExecStartPre=/bin/chown -R netdata:netdata /opt/netdata/var/run/netdata (code=exited, status=0/SUCCESS)
  Process: 2147 ExecStartPre=/bin/mkdir -p /opt/netdata/var/run/netdata (code=exited, status=0/SUCCESS)
  Process: 2145 ExecStartPre=/bin/chown -R netdata:netdata /opt/netdata/var/cache/netdata (code=exited, status=0/SUCCESS)
  Process: 2144 ExecStartPre=/bin/mkdir -p /opt/netdata/var/cache/netdata (code=exited, status=0/SUCCESS)
 Main PID: 2152 (netdata)
    Tasks: 34 (limit: 11378)
```
- si ce n'est pas le cas, faites en sorte qu'il démarre au boot de la machine
- déterminer à l'aide d'une commande `ss` sur quel port Netdata écoute
```
[adam@web ~]$ sudo ss -alntp
State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port  Process                                                                                                                            
LISTEN   0        128              0.0.0.0:22             0.0.0.0:*      users:(("sshd",pid=877,fd=5))                                                                                                     
LISTEN   0        128            127.0.0.1:8125           0.0.0.0:*      users:(("netdata",pid=3809,fd=35))                                                                                                
LISTEN   0        128              0.0.0.0:19999          0.0.0.0:*      users:(("netdata",pid=3809,fd=5))                                                                                                 
LISTEN   0        128                    *:80                   *:*      users:(("httpd",pid=2814,fd=4),("httpd",pid=1334,fd=4),("httpd",pid=1333,fd=4),("httpd",pid=1332,fd=4),("httpd",pid=1226,fd=4))   
LISTEN   0        128                 [::]:22                [::]:*      users:(("sshd",pid=877,fd=7))                                                                                                     
LISTEN   0        128                [::1]:8125              [::]:*      users:(("netdata",pid=3809,fd=34))                                                                                                
LISTEN   0        128                 [::]:19999             [::]:*      users:(("netdata",pid=3809,fd=6))                                                                                                 
LISTEN   0        80                     *:3306                 *:*      users:(("mysqld",pid=977,fd=22))                                                                                                  
[adam@web ~]$ 
```
```
[adam@db ~]$ sudo ss -alntp
State               Recv-Q              Send-Q                             Local Address:Port                              Peer Address:Port              Process                                          
LISTEN              0                   128                                      0.0.0.0:22                                     0.0.0.0:*                  users:(("sshd",pid=877,fd=5))                   
LISTEN              0                   128                                    127.0.0.1:8125                                   0.0.0.0:*                  users:(("netdata",pid=2152,fd=35))              
LISTEN              0                   128                                      0.0.0.0:19999                                  0.0.0.0:*                  users:(("netdata",pid=2152,fd=5))               
LISTEN              0                   80                                             *:3306                                         *:*                  users:(("mysqld",pid=968,fd=24))                
LISTEN              0                   128                                         [::]:22                                        [::]:*                  users:(("sshd",pid=877,fd=7))                   
LISTEN              0                   128                                        [::1]:8125                                      [::]:*                  users:(("netdata",pid=2152,fd=34))              
LISTEN              0                   128                                         [::]:19999                                     [::]:*                  users:(("netdata",pid=2152,fd=6))               
[adam@db ~]$           
```
- autoriser ce port dans le firewall
```
[adam@web ~]$ sudo firewall-cmd --add-port=19999/tcp
success
[adam@web ~]$ sudo firewall-cmd --add-port=19999/tcp --permanent
success

[adam@db ~]$ sudo firewall-cmd --add-port=19999/tcp
success
[adam@db ~]$ sudo firewall-cmd --add-port=19999/tcp --permanent
success
```

**Setup Alerting**

- ajustez la conf de Netdata pour mettre en place des alertes Discord
  - *ui ui c'est bien ça :* vous recevrez un message Discord quand un seul critique est atteint
- [c'est là que ça se passe dans la doc de Netdata](https://learn.netdata.cloud/docs/agent/health/notifications/discord)
  - noubliez pas que la conf se trouve pour nous dans `/opt/netdata/etc/netdata/`
- vérifiez le bon fonctionnement de l'alerting sur Discord
  - en suivant [cette section de la doc](https://learn.netdata.cloud/docs/agent/health/notifications#testing-notifications)
```
[adam@web netdata]$ ls
charts.d  custom-plugins.d  ebpf.d  edit-config  go.d  health.d  netdata.conf  node.d  orig  python.d  ssl  statsd.d
[adam@web netdata]$ pwd
/opt/netdata/etc/netdata
[adam@web netdata]$ 

[adam@db netdata]$ ls
charts.d  custom-plugins.d  ebpf.d  edit-config  go.d  health.d  netdata.conf  node.d  orig  python.d  ssl  statsd.d
[adam@db netdata]$ pwd
/opt/netdata/etc/netdata
[adam@db netdata]$ 
```
```
[adam@web ~]$ sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf
[sudo] password for adam: 
Editing '/opt/netdata/etc/netdata/health_alarm_notify.conf' ...
[adam@web ~]$ 

###############################################################################
# sending discord notifications

# note: multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/897462669416759356/xdWF8sYxj4GYzL2qxOW2NlMvyev9Uz3h0_xbf7YOSYMWv1L4AGTSkkOB2WN2n1PMjhCY"


# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alarms"
```
```
[adam@db ~]$ sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf
[sudo] password for adam: 
Editing '/opt/netdata/etc/netdata/health_alarm_notify.conf' ...
[adam@db ~]$ 

###############################################################################
# sending discord notifications

# note: multiple recipients can be given like this:
#                  "CHANNEL1 CHANNEL2 ..."

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/897466272747507724/v-IN50aDItaNF0UC3O6GSgEaWi2woBy1ZdX9kR8pVJ38tosNSTG1O5TY5Uktap5ln4Wa"


# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alarms"
```
```
[adam@web ~]$ sudo su -s /bin/bash netdata
bash-4.4$ export NETDATA_ALARM_NOTIFY_DEBUG=1
bash-4.4$ /usr/libexec/netdata/plugins.d/alarm-notify.sh test
bash: /usr/libexec/netdata/plugins.d/alarm-notify.sh: No such file or directory
bash-4.4$ /opt/netdata/usr/libexec/netdata/plugins.d/alarm-notify.sh test

# SENDING TEST WARNING ALARM TO ROLE: sysadmin
2021-11-05 14:20:07: alarm-notify.sh: DEBUG: Loading config file '/opt/netdata/usr/lib/netdata/conf.d/health_alarm_notify.conf'...
2021-11-05 14:20:07: alarm-notify.sh: DEBUG: Loading config file '/opt/netdata/etc/netdata/health_alarm_notify.conf'...
[...]
2021-11-05 14:20:09: alarm-notify.sh: INFO: sent discord notification for: web.tp2.linux test.chart.test_alarm is CLEAR to 'alarms'
# OK
```
```
[adam@db ~]$ sudo su -s /bin/bash netdata
bash-4.4$ export NETDATA_ALARM_NOTIFY_DEBUG=1
bash-4.4$ /usr/libexec/netdata/plugins.d/alarm-notify.sh test
bash: /usr/libexec/netdata/plugins.d/alarm-notify.sh: No such file or directory
bash-4.4$ /opt/netdata/usr/libexec/netdata/plugins.d/alarm-notify.sh test

# SENDING TEST WARNING ALARM TO ROLE: sysadmin
2021-11-05 14:20:07: alarm-notify.sh: DEBUG: Loading config file '/opt/netdata/usr/lib/netdata/conf.d/health_alarm_notify.conf'...
2021-11-05 14:20:07: alarm-notify.sh: DEBUG: Loading config file '/opt/netdata/etc/netdata/health_alarm_notify.conf'...
[...]
2021-11-05 14:20:09: alarm-notify.sh: INFO: sent discord notification for: db.tp2.linux test.chart.test_alarm is CLEAR to 'alarms'
# OK
```

**Config alerting**

- créez une nouvelle alerte pour recevoir une alerte à 50% de remplissage de la RAM
- testez que votre alerte fonctionne
  - il faudra remplir artificiellement la RAM pour voir si l'alerte remonte correctement
  - sur Linux, on utilise la commande `stress` pour ça
  - soyez patient, et laissez durer le stress test (pas la journée non plus)
```
[adam@web netdata]$ sudo touch health.d/ram-usage.conf
[adam@web netdata]$ sudo ./edit-config health.d/ram-usage.conf 
Editing '/opt/netdata/etc/netdata/health.d/ram-usage.conf' ...
alarm: ram_usage
    on: system.ram
lookup: average -1m percentage of used
 units: %
 every: 1m
  warn: $this > 50
  crit: $this > 90
  info: The percentage of RAM being used by the system.

[adam@db netdata]$ sudo touch health.d/ram-usage.conf
[adam@db netdata]$ sudo ./edit-config health.d/ram-usage.conf 
Editing '/opt/netdata/etc/netdata/health.d/ram-usage.conf' ...
 alarm: ram_usage
    on: system.ram
lookup: average -1m percentage of used
 units: %
 every: 1m
  warn: $this > 50
  crit: $this > 90
  info: The percentage of RAM being used by the system.
```
```
[adam@web ~]$ sudo killall -USR2 netdata

[adam@db ~]$ sudo killall -USR2 netdata
```
```
[adam@web netdata]$ stress --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.98;}' < /proc/meminfo)k --vm-keep -m 1
stress: info: [2783] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd

[adam@db netdata]$ stress --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.98;}' < /proc/meminfo)k --vm-keep -m 1
stress: info: [2223] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
```
```
web.tp2.linux is critical, mem.available (system), ram available = 1.67%
  ram available = 1.67%
  Percentage of an estimated amount of RAM available for userspace processes, without causing swapping. Low amount of available memory. It may affect the performance of applications. If there is no swap space available, OOM Killer can start killing processes. You might want to check per-process memory usage to find the top consumers.
  mem.available
  system
  Image

  web.tp2.linux•Aujourd’hui à 16:30
  web.tp2.linux needs attention, system.ram (ram), ram in use = 92.8%
  ram in use = 92.8%
  Percentage of used RAM. High RAM utilization. It may affect the performance of applications. If there is no swap space available, OOM Killer can start killing processes. You might want to check per-process memory usage to find the top consumers.
  system.ram
  ram
  Image

  web.tp2.linux•Aujourd’hui à 16:30
```

# II. Backup

## 1. Intwo bwo

## 2. Partage NFS

**Setup environnement**

- créer un dossier `/srv/backups/`
- il contiendra un sous-dossier pour chaque machine du parc
  - commencez donc par créer le dossier `/srv/backups/web.tp2.linux/`
- il existera un partage NFS pour chaque machine (principe du moindre privilège)
```
[adam@backup backups]$ ls
db.tp2.linux  web.tp2.linux
[adam@backup backups]$
```
```
[adam@backup backups]$ history
    1  cd /
    2  mkdir srv
    3  cd srv
    4  ls
    5  mkdir backups
    6  sudo mkdir backups
    7  cd backups/
    8  sudo mkdir web.tp2.linux db.tp2.linux
    9  ls
   10  history
[adam@backup backups]$ 
```

**Setup partage NFS**

- je crois que vous commencez à connaître la chanson... Google "nfs server rocky linux"
  - [ce lien me semble être particulièrement simple et concis](https://www.server-world.info/en/note?os=Rocky_Linux_8&p=nfs&f=1)
  
```
[adam@backup backups]$ history
11  sudo dnf -y install nfs-utils 
12  sudo vim /etc/idmapd.conf 
13  sudo vim /etc/exports
14  sudo systemctl enable --now rpcbind nfs-server
[...]
22  sudo firewall-cmd --add-service=nfs
```

**Setup points de montage sur `web.tp2.linux`**

- [sur le même site, y'a ça](https://www.server-world.info/en/note?os=Rocky_Linux_8&p=nfs&f=2)
- monter le dossier `/srv/backups/web.tp2.linux` du serveur NFS dans le dossier `/srv/backup/` du serveur Web
- vérifier...
  - avec une commande `mount` que la partition est bien montée
  - avec une commande `df -h` qu'il reste de la place
  - avec une commande `touch` que vous avez le droit d'écrire dans cette partition

```
[adam@web ~]$ sudo mount -t nfs backup.tp2.linux:/srv/backups/web.tp2.linux /srv/backup
[adam@web ~]$ sudo df -hT
Filesystem                                  Type      Size  Used Avail Use% Mounted on
devtmpfs                                    devtmpfs  890M     0  890M   0% /dev
tmpfs                                       tmpfs     909M  400K  909M   1% /dev/shm
tmpfs                                       tmpfs     909M  8.6M  901M   1% /run
tmpfs                                       tmpfs     909M     0  909M   0% /sys/fs/cgroup
/dev/mapper/rl_bastion--ovh1fr-root         xfs        14G  4.0G  9.5G  30% /
/dev/sda1                                   xfs      1014M  265M  750M  27% /boot
tmpfs                                       tmpfs     182M     0  182M   0% /run/user/1000
backup.tp2.linux:/srv/backups/web.tp2.linux nfs4       14G  2.1G   12G  16% /srv/backup
[adam@web ~]$ cd /srv/backup/
[adam@web backup]$ sudo touch test1
[adam@web backup]$ ls
test1
[adam@web backup]$ 

[adam@backup ~]$ cd /srv/backups/web.tp2.linux/
[adam@backup web.tp2.linux]$ ls
test1
[adam@backup web.tp2.linux]$ 
```
- faites en sorte que cette partition se monte automatiquement grâce au fichier `/etc/fstab`

```
[adam@web backup]$ cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Wed Sep 15 13:33:40 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl_bastion--ovh1fr-root /                       xfs     defaults        0 0
UUID=386dd067-80e5-4f1c-8a2a-116c972b093e /boot                   xfs     defaults        0 0
/dev/mapper/rl_bastion--ovh1fr-swap none                    swap    defaults        0 0

backup.tp2.linux:/srv/backups/web.tp2.linux /srv/backup     nfs     defaults        0 0
[adam@web backup]$ 
```
## 3. Backup de fichiers

**Tester le bon fonctionnement**

- exécuter le script sur le dossier de votre choix
- prouvez que la backup s'est bien exécutée
```
[adam@backup srv]$ sudo ./tp2_backup.sh /srv/backup-script/ /srv/backups/web.tp2.linux/test1 
[OK] archive /srv/tp2_backup_20211118-181359.tar.gz created.
[OK] Archive /srv/tp2_backup_20211118-181359.tar.gz synchronized to /srv/backup-script/.
[adam@backup srv]$ 
```
- **tester de restaurer les données**
- récupérer l'archive générée, et vérifier son contenu
```
[adam@backup backup-script]$ ls
tp2_backup_20211118-181359.tar.gz
[adam@backup backup-script]$ sudo tar -xf tp2_backup_20211118-181359.tar.gz 
[adam@backup backup-script]$ ls
srv  tp2_backup_20211118-181359.tar.gz
[adam@backup backup-script]$ cd srv/
[adam@backup srv]$ ls
backups
[adam@backup srv]$ cd backups/
[adam@backup backups]$ ls
web.tp2.linux
[adam@backup backups]$ cd web.tp2.linux/
[adam@backup web.tp2.linux]$ ls
test1
[adam@backup web.tp2.linux]$ 
```

## 4. Unité de service

### A. Unité de service

**Créer une *unité de service*** pour notre backup

- c'est juste un fichier texte hein
- doit se trouver dans le dossier `/etc/systemd/system/`
- doit s'appeler `tp2_backup.service`

```
[adam@backup system]$ cat tp2_backup.service 
[Unit]
Description=Our own lil backup service (TP2)

[Service]
ExecStart=/srv/tp2_backup.sh /srv/backup-script/ /srv/backups/web.tp2.linux
Type=oneshot
RemainAfterExit=no

[Install]
WantedBy=multi-user.target

[adam@backup system]$ 
```

**Tester le bon fonctionnement**

- n'oubliez pas d'exécuter `sudo systemctl daemon-reload` à chaque ajout/modification d'un *service*
- essayez d'effectuer une sauvegarde avec `sudo systemctl start backup`
- prouvez que la backup s'est bien exécutée
  - vérifiez la présence de la nouvelle archive
```
[adam@backup ~]$ sudo systemctl daemon-reload
[sudo] password for adam: 
[adam@backup ~]$ sudo systemctl start tp2_backup
[adam@backup ~]$ 
```
```
[adam@backup ~]$ ls -l /srv/backup-script/
total 8
-rw-r--r--. 1 root root 132 Nov 18 18:13 tp2_backup_20211118-181359.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:29 tp2_backup_20211118-182958.tar.gz
[adam@backup ~]$ 

[adam@backup backup-script]$ sudo tar -xf tp2_backup_20211118-182958.tar.gz 
[adam@backup backup-script]$ ls
srv  tp2_backup_20211118-181359.tar.gz  tp2_backup_20211118-182958.tar.gz
[adam@backup backup-script]$ ls srv/backups/web.tp2.linux/
test1
[adam@backup backup-script]$ 
```

### B. Timer

**Créer le *timer* associé à notre `tp2_backup.service`**

- toujours juste un fichier texte
- dans le dossier `/etc/systemd/system/` aussi
- fichier `tp2_backup.timer`

```
[adam@backup system]$ cat tp2_backup.timer 
[Unit]
Description=Periodically run our TP2 backup script
Requires=tp2_backup.service

[Timer]
Unit=tp2_backup.service
OnCalendar=*-*-* *:*:00

[Install]
WantedBy=timers.target

[adam@backup system]$ 
```

**Activez le timer**

- démarrer le *timer* : `sudo systemctl start tp2_backup.timer`
- activer le au démarrage avec une autre commande `systemctl`
- prouver que...
  - le *timer* est actif actuellement
  - qu'il est paramétré pour être actif dès que le système boot
```
[adam@backup ~]$ sudo systemctl daemon-reload
[adam@backup ~]$ sudo systemctl start tp2_backup.timer
[adam@backup ~]$ sudo systemctl enable tp2_backup.timer
Created symlink /etc/systemd/system/timers.target.wants/tp2_backup.timer → /etc/systemd/system/tp2_backup.timer.
[adam@backup ~]$ sudo systemctl status tp2_backup.timer
● tp2_backup.timer - Periodically run our TP2 backup script
   Loaded: loaded (/etc/systemd/system/tp2_backup.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Thu 2021-11-18 18:42:43 CET; 1min 0s ago
  Trigger: Thu 2021-11-18 18:44:00 CET; 15s left

Nov 18 18:42:43 backup.tp2.linux systemd[1]: Started Periodically run our TP2 backup script.
[adam@backup ~]$ 
```
**Tests !**

- avec la ligne `OnCalendar=*-*-* *:*:00`, le *timer* déclenche l'exécution du *service* toutes les minutes
- vérifiez que la backup s'exécute correctement
```
[adam@backup backup-script]$ ls -l
total 32
drwxr-xr-x. 3 root root  21 Nov 18 18:34 srv
-rw-r--r--. 1 root root 132 Nov 18 18:13 tp2_backup_20211118-181359.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:29 tp2_backup_20211118-182958.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:42 tp2_backup_20211118-184243.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:43 tp2_backup_20211118-184303.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:44 tp2_backup_20211118-184408.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:44 tp2_backup_20211118-184454.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:45 tp2_backup_20211118-184508.tar.gz
-rw-r--r--. 1 root root 164 Nov 18 18:46 tp2_backup_20211118-184602.tar.gz
[adam@backup backup-script]$ 
```

### C. Contexte

**Faites en sorte que...**

- votre backup s'exécute sur la machine `web.tp2.linux`
- le dossier sauvegardé est celui qui contient le site NextCloud (quelque part dans `/var/`)
- la destination est le dossier NFS monté depuis le serveur `backup.tp2.linux`
- la sauvegarde s'exécute tous les jours à 03h15 du matin
- prouvez avec la commande `sudo systemctl list-timers` que votre *service* va bien s'exécuter la prochaine fois qu'il sera 03h15
```
[adam@web scripts]$ sudo systemctl status tp2_backup.service 
● tp2_backup.service - Our own lil backup service (TP2)
   Loaded: loaded (/etc/systemd/system/tp2_backup.service; disabled; vendor preset: disabled)
   Active: inactive (dead)

Nov 18 19:17:29 web.tp2.linux systemd[1]: Starting Our own lil backup service (TP2)...
Nov 18 19:17:29 web.tp2.linux tp2_backup.sh[31987]: [ERROR] Target /var/www/sub-domains/linux.tp2.nextcloud/html is not accessible.
Nov 18 19:17:29 web.tp2.linux systemd[1]: tp2_backup.service: Main process exited, code=exited, status=1/FAILURE
Nov 18 19:17:29 web.tp2.linux systemd[1]: tp2_backup.service: Failed with result 'exit-code'.
Nov 18 19:17:29 web.tp2.linux systemd[1]: Failed to start Our own lil backup service (TP2).
Nov 18 19:23:25 web.tp2.linux systemd[1]: Starting Our own lil backup service (TP2)...
Nov 18 19:23:57 web.tp2.linux tp2_backup.sh[32691]: [OK] archive //tp2_backup_20211118-192325.tar.gz created.
Nov 18 19:24:02 web.tp2.linux tp2_backup.sh[32691]: [OK] Archive //tp2_backup_20211118-192325.tar.gz synchronized to /srv/backup.
Nov 18 19:24:02 web.tp2.linux systemd[1]: tp2_backup.service: Succeeded.
Nov 18 19:24:02 web.tp2.linux systemd[1]: Started Our own lil backup service (TP2).
[adam@web scripts]$ sudo systemctl start tp2_backup.service
```

# III. Reverse Proxy

## 1. Introooooo

## 2. Setup simple

