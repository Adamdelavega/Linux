# TP3 : Your own shiet
## TP

**Mise en place de l'infrastructure**

- Pour chaques machines de ce projet la **Checklist** suivante à été vérifié.
    - La machine peu communiquer sur le réseau Local
    - La machine peu communiquer sur le réseau Internet
    - La machine peu communiquer sur le Web
    - La machine est administré via ssh
```
[adam@server ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:31:59:33 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.2/24 brd 10.1.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe31:5933/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:61:81:82 brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.2/24 brd 10.2.1.255 scope global dynamic noprefixroute enp0s9
       valid_lft 585sec preferred_lft 585sec
    inet6 fe80::a00:27ff:fe61:8182/64 scope link 
       valid_lft forever preferred_lft forever

[adam@router ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a5:93:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 83842sec preferred_lft 83842sec
    inet6 fe80::a00:27ff:fea5:93cf/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:ce:ec:99 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.254/24 brd 10.1.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fece:ec99/64 scope link 
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:63:96:bb brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.254/24 brd 10.2.1.255 scope global noprefixroute enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe63:96bb/64 scope link 
       valid_lft forever preferred_lft forever

[adam@syslog ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:74:b0:96 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.3/24 brd 10.1.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe74:b096/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:f4:c7:3d brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.3/24 brd 10.2.1.255 scope global dynamic noprefixroute enp0s9
       valid_lft 571sec preferred_lft 571sec
    inet6 fe80::a00:27ff:fef4:c73d/64 scope link 
       valid_lft forever preferred_lft forever
```
```
[adam@server ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8

NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.1.1.2
NETMASK=255.255.255.0
GATEWAY=10.1.1.254
[adam@server ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s9
NAME=enp0s9
DEVICE=enp0s9

BOOTPROTO=dhcp
ONBOOT=yes

[adam@server ~]$ 


[adam@router ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8

NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
IPADDR=10.1.1.254
NETMASK=255.255.255.0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
PREFIX=24
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
UUID=00cb8299-feb9-55b6-a378-3fdc720e0bc6
ZONE=public
[adam@router ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s9
NAME=enp0s9
DEVICE=enp0s9
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.2.1.254
NETMASK=255.255.255.0
DNS1=1.1.1.1

[adam@syslog ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8

NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.1.1.3
NETMASK=255.255.255.0
GATEWAY=10.1.1.254
[adam@syslog ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s9
NAME=enp0s9
DEVICE=enp0s9

BOOTPROTO=dhcp
ONBOOT=yes
```
```
[adam@server ~]$ ping 10.2.1.254
PING 10.2.1.254 (10.2.1.254) 56(84) bytes of data.
64 bytes from 10.2.1.254: icmp_seq=1 ttl=64 time=0.970 ms
64 bytes from 10.2.1.254: icmp_seq=2 ttl=64 time=1.15 ms
[adam@server ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=15.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=61 time=21.8 ms
[adam@server ~]$ ping google.com
PING google.com (172.217.18.206) 56(84) bytes of data.
64 bytes from ham02s14-in-f206.1e100.net (172.217.18.206): icmp_seq=1 ttl=61 time=13.6 ms
64 bytes from ham02s14-in-f206.1e100.net (172.217.18.206): icmp_seq=2 ttl=61 time=16.7 ms
[adam@server ~]$ dig ynov.com

; <<>> DiG 9.11.26-RedHat-9.11.26-4.el8_4 <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53100
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		10800	IN	A	92.243.16.143

;; Query time: 21 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Thu Nov 11 23:31:04 CET 2021
;; MSG SIZE  rcvd: 53



[adam@router ~]$ ping 10.2.1.2
PING 10.2.1.2 (10.2.1.2) 56(84) bytes of data.
64 bytes from 10.2.1.2: icmp_seq=1 ttl=64 time=1.17 ms
64 bytes from 10.2.1.2: icmp_seq=2 ttl=64 time=1.19 ms
[adam@router ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=63 time=16.4 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=63 time=13.7 ms
[adam@router ~]$ ping google.com
PING google.com (142.250.75.238) 56(84) bytes of data.
64 bytes from par10s41-in-f14.1e100.net (142.250.75.238): icmp_seq=1 ttl=63 time=13.10 ms
64 bytes from par10s41-in-f14.1e100.net (142.250.75.238): icmp_seq=2 ttl=63 time=13.2 ms
[adam@router ~]$ dig ynov.com

; <<>> DiG 9.11.26-RedHat-9.11.26-4.el8_4 <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28997
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		10800	IN	A	92.243.16.143

;; Query time: 30 msec
;; SERVER: 10.0.2.3#53(10.0.2.3)
;; WHEN: Thu Nov 11 23:30:25 CET 2021
;; MSG SIZE  rcvd: 53


[adam@syslog ~]$ ping server
PING server (10.2.1.2) 56(84) bytes of data.
64 bytes from server (10.2.1.2): icmp_seq=1 ttl=64 time=1.63 ms
64 bytes from server (10.2.1.2): icmp_seq=2 ttl=64 time=0.966 ms
[adam@syslog ~]$ ping router
PING router (10.2.1.254) 56(84) bytes of data.
64 bytes from router (10.2.1.254): icmp_seq=1 ttl=64 time=0.920 ms
64 bytes from router (10.2.1.254): icmp_seq=2 ttl=64 time=1.04 ms
[adam@syslog ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=61 time=17.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=61 time=16.2 ms
[adam@syslog ~]$ ping google.com
PING google.com (172.217.18.206) 56(84) bytes of data.
64 bytes from par10s38-in-f14.1e100.net (172.217.18.206): icmp_seq=1 ttl=61 time=12.10 ms
64 bytes from par10s38-in-f14.1e100.net (172.217.18.206): icmp_seq=2 ttl=61 time=18.1 ms
[adam@syslog ~]$ dig ynov.com

; <<>> DiG 9.11.26-RedHat-9.11.26-4.el8_4 <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16958
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		10800	IN	A	92.243.16.143

;; Query time: 21 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Thu Nov 11 23:35:43 CET 2021
;; MSG SIZE  rcvd: 53
```
```
[adam@server ~]$ hostname
server.tp3.linux
[adam@server ~]$ 

[adam@router ~]$ hostname
router.tp2.linux
[adam@router ~]$ 
```

**Configuration du serveur Rsyslog**

- Rsyslog est déjà installé sur rocky linux, on peut accéder au fichier de conf via /etc/rsyslog.conf
- activer la collecte de logs udp et tcp
```
[adam@syslog ~]$ cat /etc/rsyslog.conf
[...]
# Provides UDP syslog reception
# for parameters see http://www.rsyslog.com/doc/imudp.html
module(load="imudp") # needs to be done just once
input(type="imudp" port="514")

# Provides TCP syslog reception
# for parameters see http://www.rsyslog.com/doc/imtcp.html
module(load="imtcp") # needs to be done just once
input(type="imtcp" port="514")
[...]
```
- redémarer le service rsyslog
```
[adam@syslog ~]$ sudo systemctl restart rsyslog
[sudo] password for adam: 
[adam@syslog ~]$ sudo systemctl status rsyslog
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2021-11-11 23:43:02 CET; 8s ago
     Docs: man:rsyslogd(8)
           https://www.rsyslog.com/doc/
 Main PID: 1860 (rsyslogd)
    Tasks: 4 (limit: 2725)
   Memory: 1.2M
   CGroup: /system.slice/rsyslog.service
           └─1860 /usr/sbin/rsyslogd -n

Nov 11 23:43:02 syslog.tp3.linux systemd[1]: Starting System Logging Service...
Nov 11 23:43:02 syslog.tp3.linux rsyslogd[1860]: [origin software="rsyslogd" swVersion="8.1911.0-7.el8_4.2" x-pid="1860" x-info="https://www.rsyslog.com"] start
Nov 11 23:43:02 syslog.tp3.linux systemd[1]: Started System Logging Service.
Nov 11 23:43:02 syslog.tp3.linux rsyslogd[1860]: imjournal: journal files changed, reloading...  [v8.1911.0-7.el8_4.2 try https://www.rsyslog.com/e/0 ]
[adam@syslog ~]$ 
```
- Activer le service
```
[adam@syslog ~]$ sudo systemctl enable rsyslog
```
- Rsyslog est prêt à recevoir des logs
```
[adam@syslog ~]$ sudo ss -alntp
State               Recv-Q               Send-Q                             Local Address:Port                             Peer Address:Port              Process                                          
LISTEN              0                    128                                      0.0.0.0:22                                    0.0.0.0:*                  users:(("sshd",pid=878,fd=5))                   
LISTEN              0                    25                                       0.0.0.0:514                                   0.0.0.0:*                  users:(("rsyslogd",pid=2595,fd=6))              
LISTEN              0                    128                                         [::]:22                                       [::]:*                  users:(("sshd",pid=878,fd=7))                   
LISTEN              0                    25                                          [::]:514                                      [::]:*                  users:(("rsyslogd",pid=2595,fd=7))              
[adam@syslog ~]$ 
```

**Configuration du client rsyslog (server.tp3.linux)**

- Allez dans /etc/rsyslog.conf
- En dessous j'ai fait en sorte d'enregistrer les logs et de les transmettre au mon serveur syslog.
```
#Target="remote_host" Port="XXX" Protocol="tcp")
*.*                 @10.2.1.4:514
*.*                @@10.2.1.4:514
```
(oui le serveur syslog est maintant en 10.2.1.4)
- redémarer et activer le service rsyslog
```
[adam@server ~]$ sudo systemctl restart rsyslog
[adam@server ~]$ sudo systemctl enable rsyslog
[adam@server ~]$ sudo systemctl status rsyslog
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2021-11-12 00:54:01 CET; 15s ago
     Docs: man:rsyslogd(8)
           https://www.rsyslog.com/doc/
 Main PID: 3678 (rsyslogd)
    Tasks: 4 (limit: 2725)
   Memory: 1.3M
   CGroup: /system.slice/rsyslog.service
           └─3678 /usr/sbin/rsyslogd -n

Nov 12 00:54:01 server.tp3.linux systemd[1]: rsyslog.service: Succeeded.
Nov 12 00:54:01 server.tp3.linux systemd[1]: Stopped System Logging Service.
Nov 12 00:54:01 server.tp3.linux systemd[1]: Starting System Logging Service...
Nov 12 00:54:01 server.tp3.linux rsyslogd[3678]: [origin software="rsyslogd" swVersion="8.1911.0-7.el8_4.2" x-pid="3678" x-info="https://www.rsyslog.com"] start
Nov 12 00:54:01 server.tp3.linux systemd[1]: Started System Logging Service.
Nov 12 00:54:01 server.tp3.linux rsyslogd[3678]: imjournal: journal files changed, reloading...  [v8.1911.0-7.el8_4.2 try https://www.rsyslog.com/e/0 ]
```
**TEST**

- Sur la machine client syslog je génère des logs pour tester la configuration
```
[adam@server ~]$ logger "Test de log"
[adam@server ~]$ 
```
- Sur la machine serveur syslog je vérifie les logs
```
[adam@syslog ~]$ sudo !!
sudo tail -f /var/log/messages
[sudo] password for adam: 
Nov 12 00:55:29 server systemd[1]: Started Network Manager Script Dispatcher Service.
Nov 12 00:55:29 server NetworkManager[856]: <info>  [1636674929.3632] dhcp4 (enp0s9): state changed extended -> extended, address=10.2.1.2
Nov 12 00:55:29 server dbus-daemon[820]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service' requested by ':1.7' (uid=0 pid=856 comm="/usr/sbin/NetworkManager --no-daemon " label="system_u:system_r:NetworkManager_t:s0")
Nov 12 00:55:29 server systemd[1]: Starting Network Manager Script Dispatcher Service...
Nov 12 00:55:29 server dbus-daemon[820]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Nov 12 00:55:29 server systemd[1]: Started Network Manager Script Dispatcher Service.
Nov 12 00:55:39 server systemd[1]: NetworkManager-dispatcher.service: Succeeded.
Nov 12 00:55:39 server systemd[1]: NetworkManager-dispatcher.service: Succeeded.
Nov 12 00:55:39 server adam[3732]: Test de log
Nov 12 00:55:39 server adam[3732]: Test de log
```

**Configuration du client rsyslog (router.tp3.linux)**

```
[adam@router ~]$ sudo vim /etc/rsyslog.conf 
[sudo] password for adam: 
[...]
# Provides UDP syslog reception
# for parameters see http://www.rsyslog.com/doc/imudp.html
module(load="imudp") # needs to be done just once
input(type="imudp" port="514")

# Provides TCP syslog reception
# for parameters see http://www.rsyslog.com/doc/imtcp.html
module(load="imtcp") # needs to be done just once
input(type="imtcp" port="514")
[...]
#Target="remote_host" Port="XXX" Protocol="tcp")
*.*                             @10.2.1.4:514
*.*                             @@10.2.1.4:514
```
```
[adam@router ~]$ sudo systemctl restart rsyslog
[adam@router ~]$ sudo systemctl status rsyslog
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2021-11-14 13:17:26 CET; 2s ago
     Docs: man:rsyslogd(8)
           https://www.rsyslog.com/doc/
 Main PID: 1478 (rsyslogd)
    Tasks: 9 (limit: 2725)
   Memory: 1.6M
   CGroup: /system.slice/rsyslog.service
           └─1478 /usr/sbin/rsyslogd -n

[...]
```
**TEST2**

```
[adam@router ~]$ logger "Test2 génération de logs"
[adam@router ~]$ 
```
```
[adam@syslog ~]$ sudo tail -f /var/log/messages 
Nov 14 13:35:37 server dhclient[1744]: bound to 192.168.60.3 -- renewal in 286 seconds.
Nov 14 13:35:43 syslog systemd[1]: NetworkManager-dispatcher.service: Succeeded.
Nov 14 13:35:44 router adam[1624]: Test2
Nov 14 13:35:44 router adam[1624]: Test2
```
Super ! Les logs sont bien transmises, nous voyen bien que les log proviennes du router, de syslog et egalement de server.
Nous allons donc paufiner la configuration de nos client rsyslog en deployant un serveur web afin de le monitorer.

**Installation de Apache et gestion de logs pour serveur web**

- Installation du paquet httpd.
```
[adam@server ~]$ sudo dnf install -y httpd
[...]
Installed:
  apr-1.6.3-11.el8.1.x86_64                                          apr-util-1.6.1-6.el8.1.x86_64                                 apr-util-bdb-1.6.1-6.el8.1.x86_64                                      
  apr-util-openssl-1.6.1-6.el8.1.x86_64                              httpd-2.4.37-39.module+el8.4.0+655+f2bfd6ee.1.x86_64          httpd-filesystem-2.4.37-39.module+el8.4.0+655+f2bfd6ee.1.noarch        
  httpd-tools-2.4.37-39.module+el8.4.0+655+f2bfd6ee.1.x86_64         mod_http2-1.15.7-3.module+el8.4.0+553+7a69454b.x86_64         rocky-logos-httpd-84.5-8.el8.noarch                                    

Complete!
```
- Faire en sorte que le service soit démaré aux prochains démarages et lancez-le.
```
[adam@server ~]$ sudo systemctl enable httpd --now
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
[adam@server ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2021-11-14 13:47:27 CET; 9s ago
     Docs: man:httpd.service(8)
```
- Nous pouvon voir que les logs sont bien transmise à la centralisation ci-dessous
```
Nov 14 17:49:50 server http_error [Sun Nov 14 17:49:50.465326 2021] [suexec:notice] [pid 35991:tid 140489571789120] AH01232: suEXEC mechanism enabled (wrapper: /usr/sbin/suexec)
Nov 14 17:49:50 server http_error [Sun Nov 14 17:49:50.464584 2021] [core:notice] [pid 35991:tid 140489571789120] SELinux policy enabled; httpd running as context system_u:system_r:httpd_t:s0
Nov 14 17:49:50 server httpd[35991]: Server configured, listening on: port 80
```

**Backup**
 
- Backup des log rsyslog du serveur de centralisation, en prenant en compte que le fichier peut être conséquent
```
[adam@syslog ~]$ cat backup.sh 
#!/bin/bash

# This script do a backup
# Adam 18/11/2021

############################
#                          #
#                          #
# BACKUP TO LOG RSYSLOG    #
#                          #
############################

# src path
backup_files="/var/log/messages"

# dest_path
dest="/home/adam/backup/"

# Create archive filename
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# message of backup
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files with tar
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date
[adam@syslog ~]$ 
```
- Allocation des bon droit
```
[adam@syslog ~]$ chmod +x backup.sh 
[adam@syslog ~]$ 
```
- avant la backup
```
[adam@syslog ~]$ pwd
/home/adam
[adam@syslog ~]$ ls backup
[adam@syslog ~]$ 
```
- Execution de la backup
```
[adam@syslog ~]$ sudo ./backup.sh
Backing up /var/log/messages to /home/adam/backup//syslog-Sunday.tgz
Sun Nov 14 19:39:42 CET 2021

tar: Removing leading `/' from member names

Backup finished
Sun Nov 14 19:39:42 CET 2021
[adam@syslog ~]$ 
```   
- Apres la backup
```
[adam@syslog ~]$ ls backup
syslog-Sunday.tgz
[adam@syslog ~]$ tar -xzvf backup/syslog-Sunday.tgz 
var/log/messages
[adam@syslog ~]$ cat backup/var/log/messages 
[...]
Nov 14 19:38:06 router dhcpd[1103]: DHCPACK on 10.2.1.4 to 08:00:27:f4:c7:3d (syslog) via enp0s9
Nov 14 19:39:03 syslog systemd[1]: NetworkManager-dispatcher.service: Succeeded.
```
- Petit plus, une vrai backup se lance automatiquement, par exemple avec crontab
```
[adam@syslog ~]$ cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
0 *  /2 *  *  *            /home/adam/backup/./backup.sh
[adam@syslog ~]$ 
```

**Automatisation de la solution**

- Pour le test je supprime rsyslog
```
[adam@server ~]$ sudo dnf -y remove rsyslog
[sudo] password for adam: 
Failed to set locale, defaulting to C.UTF-8
Dependencies resolved.
===========================================================================================================================================================================================================
 Package                                         Architecture                               Version                                                   Repository                                      Size
===========================================================================================================================================================================================================
Removing:
 rsyslog                                         x86_64                                     8.1911.0-7.el8_4.2                                        @appstream                                     2.3 M
Removing unused dependencies:
[...]
Removed:
  libestr-0.1.10-1.el8.x86_64                                     libfastjson-0.99.8-2.el8.x86_64                                     rsyslog-8.1911.0-7.el8_4.2.x86_64                                    

Complete!
```
- Je donne les drois d'execution à mon script et fait en sorte que seul un utilisateur ayant des droit root puisse le manipuler
```
[adam@server ~]$ sudo chmod 700 script.sh 
[adam@server ~]$ ls -l
total 4
-rwx------. 1 root root 678 Nov 16 00:53 script.sh
[adam@server ~]$ 
```
- Execution du script
```
[adam@server ~]$ sudo ./script.sh
Failed to set locale, defaulting to C.UTF-8
Last metadata expiration check: 0:59:31 ago on Tue Nov 16 00:46:07 2021.
Dependencies resolved.
===========================================================================================================================================================================================================
 Package                                           Architecture                                 Version                                              Repository                                       Size
===========================================================================================================================================================================================================
Installing:
 rsyslog                                           x86_64                                       8.2102.0-5.el8                                       appstream                                       751 k
Installing dependencies:
 libestr                                           x86_64                                       0.1.10-1.el8                                         appstream                                        26 k
 libfastjson                                       x86_64                                       0.99.9-1.el8                                         appstream                                        37 k

Transaction Summary
===========================================================================================================================================================================================================
Install  3 Packages

Total download size: 814 k
Installed size: 2.5 M
Downloading Packages:
(1/3): libestr-0.1.10-1.el8.x86_64.rpm                                                                                                                                      46 kB/s |  26 kB     00:00    
(2/3): libfastjson-0.99.9-1.el8.x86_64.rpm                                                                                                                                  64 kB/s |  37 kB     00:00    
(3/3): rsyslog-8.2102.0-5.el8.x86_64.rpm                                                                                                                                   744 kB/s | 751 kB     00:01    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                      578 kB/s | 814 kB     00:01     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                   1/1 
  Installing       : libfastjson-0.99.9-1.el8.x86_64                                                                                                                                                   1/3 
  Running scriptlet: libfastjson-0.99.9-1.el8.x86_64                                                                                                                                                   1/3 
  Installing       : libestr-0.1.10-1.el8.x86_64                                                                                                                                                       2/3 
  Running scriptlet: libestr-0.1.10-1.el8.x86_64                                                                                                                                                       2/3 
  Installing       : rsyslog-8.2102.0-5.el8.x86_64                                                                                                                                                     3/3 
  Running scriptlet: rsyslog-8.2102.0-5.el8.x86_64                                                                                                                                                     3/3 
  Verifying        : libestr-0.1.10-1.el8.x86_64                                                                                                                                                       1/3 
  Verifying        : libfastjson-0.99.9-1.el8.x86_64                                                                                                                                                   2/3 
  Verifying        : rsyslog-8.2102.0-5.el8.x86_64                                                                                                                                                     3/3 

Installed:
  libestr-0.1.10-1.el8.x86_64                                      libfastjson-0.99.9-1.el8.x86_64                                      rsyslog-8.2102.0-5.el8.x86_64                                     

Complete!
Please enter the IP of server
10.2.1.4
Warning: ALREADY_ENABLED: '514:udp' already in 'public'
success
Warning: ALREADY_ENABLED: '514:udp' already in 'public'
success
script complete !
```
**Verification**

- Pour commencer vérifion si rsyslog est bien lancé
```
[adam@server ~]$ sudo systemctl status rsyslog.service 
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2021-11-16 01:53:29 CET; 28s ago
     Docs: man:rsyslogd(8)
           https://www.rsyslog.com/doc/
 Main PID: 3959 (rsyslogd)
    Tasks: 4 (limit: 2725)
   Memory: 1.3M
   CGroup: /system.slice/rsyslog.service
           └─3959 /usr/sbin/rsyslogd -n

Nov 16 01:53:29 server.tp3.linux systemd[1]: Starting System Logging Service...
Nov 16 01:53:29 server.tp3.linux rsyslogd[3959]: [origin software="rsyslogd" swVersion="8.2102.0-5.el8" x-pid="3959" x-info="https://www.rsyslog.com"] start
Nov 16 01:53:29 server.tp3.linux systemd[1]: Started System Logging Service.
Nov 16 01:53:29 server.tp3.linux rsyslogd[3959]: imjournal: journal files changed, reloading...  [v8.2102.0-5.el8 try https://www.rsyslog.com/e/0 ]
[adam@server ~]$ 
```
- Ensuite vérifion si les log sont bien envoyé au serveur de centralisation
   - Test_1
   ```
   [adam@server ~]$ logger "Test1"
   [adam@server ~]$ logger "Test1"
   [adam@syslog ~]$ sudo tail -f /var/log/messages
   [sudo] password for adam: 
   Nov 16 01:56:28 syslog systemd[1]: Started Network Manager Script Dispatcher Service.
   Nov 16 01:56:28 router dhcpd[1098]: Wrote 2 leases to leases file.
   Nov 16 01:56:28 router dhcpd[1098]: DHCPREQUEST for 10.2.1.4 from 08:00:27:f4:c7:3d (syslog) via enp0s9
   Nov 16 01:56:28 router dhcpd[1098]: DHCPACK on 10.2.1.4 to 08:00:27:f4:c7:3d (syslog) via enp0s9
   Nov 16 01:56:28 router dhcpd[1098]: Wrote 2 leases to leases file.
   Nov 16 01:56:28 router dhcpd[1098]: DHCPREQUEST for 10.2.1.4 from 08:00:27:f4:c7:3d (syslog) via enp0s9
   Nov 16 01:56:28 router dhcpd[1098]: DHCPACK on 10.2.1.4 to 08:00:27:f4:c7:3d (syslog) via enp0s9
   Nov 16 01:56:38 syslog systemd[1]: NetworkManager-dispatcher.service: Succeeded.
   Nov 16 01:57:11 server adam[4038]: Test1
   Nov 16 01:57:24 server adam[4041]: Test1
   ```
   - Test2
   ```
   [adam@server ~]$ sudo nmcli con down enp0s9
   [sudo] password for adam: 
   Connection 'enp0s9' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
   [adam@server ~]$ 
   Nov 16 02:04:09 server NetworkManager[857]: <info>  [1637024649.8708] device (enp0s9): state change: deactivating -> disconnected (reason 'user-requested', sys-iface-state: 'managed')
   Nov 16 02:04:09 server NetworkManager[857]: <info>  [1637024649.8760] dhcp4 (enp0s9): canceled DHCP transaction
   Nov 16 02:04:09 server NetworkManager[857]: <info>  [1637024649.8760] dhcp4 (enp0s9): state changed extended -> done

   [adam@server ~]$ sudo nmcli con up enp0s9
   [sudo] password for adam: 
   Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)
   [adam@server ~]$ 

   Nov 16 02:18:02 server NetworkManager[857]: <info>  [1637025482.4846] device (enp0s9): Activation: successful, device activated.
   Nov 16 02:18:02 server systemd[1]: iscsi.service: Unit cannot be reloaded because it is inactive.
   Nov 16 02:18:02 router dhcpd[1098]: DHCPDISCOVER from 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPOFFER on 10.2.1.2 to 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPREQUEST for 10.2.1.2 (10.2.1.254) from 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPACK on 10.2.1.2 to 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPDISCOVER from 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPOFFER on 10.2.1.2 to 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPREQUEST for 10.2.1.2 (10.2.1.254) from 08:00:27:61:81:82 (server) via enp0s9
   Nov 16 02:18:02 router dhcpd[1098]: DHCPACK on 10.2.1.2 to 08:00:27:61:81:82 (server) via enp0s9


Nous voyons bien que nous avon eu l'alerte dans les logs pour le down et pour l'échange DORA lors de l'activation de l'interface réseau

### Conclusion

| Nom de machine|         Adresse IP          |           Port(s)           |
|---------------|-----------------------------|-----------------------------|
| `server`      | `10.1.1.2` / `10.2.1.2`     | `22/tcp` `80/tcp` `514/udp` | 
| `router`      | `10.1.1.254` / `10.2.1.254` | `22/tcp` `514/udp` `dhcp`   |
| `syslog`      | `10.1.1.3` / `10.2.1.4`     | `22/tcp` `514/udp`          |

| Nom du réseau | Adresse du réseau | Masque            |
|---------------|-------------------|-------------------|
| `managment`   | `10.1.1.0/24`     | `255.255.255.0`   |
| `client`      | `10.2.1.0/24`     | `255.255.255.0`   |

Nous avons dans ce TP3 une solution fonctionnelle, les bonne pratique qui sont réspectées, 
une automatiqation de notre solution pour l'envoi de log, et du maintien en condition opérationnelle.