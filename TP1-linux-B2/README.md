# TP1 : (re)Familiaration avec un système GNU/Linux

## 0. Préparation de la machine
 **Setup de deux machines Rocky Linux configurées de façon basique.**

- **un accès internet (via la carte NAT)**
```
[adam@node1 ~]$ ping google.com
PING google.com (216.58.215.46) 56(84) bytes of data.
64 bytes from par21s17-in-f14.1e100.net (216.58.215.46): icmp_seq=1 ttl=63 time=13.8 ms
^C
--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 13.814/13.814/13.814/0.000 ms

[adam@node2 ~]$ ping google.com
PING google.com (216.58.213.142) 56(84) bytes of data.
64 bytes from par21s03-in-f14.1e100.net (216.58.213.142): icmp_seq=1 ttl=63 time=12.5 ms
64 bytes from par21s03-in-f14.1e100.net (216.58.213.142): icmp_seq=2 ttl=63 time=17.9 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 12.527/15.231/17.935/2.704 ms

```
  - carte réseau dédiée
```
[adam@node1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:61:83:53 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 85972sec preferred_lft 85972sec
    inet6 fe80::a00:27ff:fe61:8353/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a7:bc:b2 brd ff:ff:ff:ff:ff:ff
    inet 10.101.1.11/24 brd 10.101.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea7:bcb2/64 scope link 
       valid_lft forever preferred_lft forever

[adam@node2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:01:53:59 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 86248sec preferred_lft 86248sec
    inet6 fe80::a00:27ff:fe01:5359/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:02:40:8c brd ff:ff:ff:ff:ff:ff
    inet 10.101.1.12/24 brd 10.101.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe02:408c/64 scope link 
       valid_lft forever preferred_lft forever
```
  - route par défaut
```
[adam@node1 ~]$ ip r s
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100 
default via 10.101.1.1 dev enp0s8 proto static metric 101 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100 
10.101.1.0/24 dev enp0s8 proto kernel scope link src 10.101.1.11 metric 101 

[adam@node2 ~]$ ip  r s
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100 
default via 10.101.1.1 dev enp0s8 proto static metric 101 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100 
10.101.1.0/24 dev enp0s8 proto kernel scope link src 10.101.1.12 metric 101 
```
- **un accès à un réseau local** (les deux machines peuvent se `ping`) (via la carte Host-Only)
```
[adam@node1 ~]$ ping 10.101.1.12
PING 10.101.1.12 (10.101.1.12) 56(84) bytes of data.
64 bytes from 10.101.1.12: icmp_seq=1 ttl=64 time=0.980 ms
64 bytes from 10.101.1.12: icmp_seq=2 ttl=64 time=0.942 ms
^C
--- 10.101.1.12 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.942/0.961/0.980/0.019 ms

[adam@node2 ~]$ ping 10.101.1.12
PING 10.101.1.12 (10.101.1.12) 56(84) bytes of data.
64 bytes from 10.101.1.12: icmp_seq=1 ttl=64 time=0.040 ms
64 bytes from 10.101.1.12: icmp_seq=2 ttl=64 time=0.131 ms
64 bytes from 10.101.1.12: icmp_seq=3 ttl=64 time=0.111 ms
^C
--- 10.101.1.12 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2062ms
rtt min/avg/max/mdev = 0.040/0.094/0.131/0.039 ms
```
  - carte réseau dédiée (host-only sur VirtualBox)
```
[adam@node1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:61:83:53 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 85901sec preferred_lft 85901sec
    inet6 fe80::a00:27ff:fe61:8353/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a7:bc:b2 brd ff:ff:ff:ff:ff:ff
    inet 10.101.1.11/24 brd 10.101.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea7:bcb2/64 scope link 
       valid_lft forever preferred_lft forever

[adam@node2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:01:53:59 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 86111sec preferred_lft 86111sec
    inet6 fe80::a00:27ff:fe01:5359/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:02:40:8c brd ff:ff:ff:ff:ff:ff
    inet 10.101.1.12/24 brd 10.101.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe02:408c/64 scope link 
       valid_lft forever preferred_lft forever
```
  - les machines doivent posséder une IP statique sur l'interface host-only
```
[adam@node1 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
[sudo] password for adam: 

NAME=enp0s8
DEVICE=enp0s8
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.101.1.11
NETMASK=255.255.255.0
DNS1=1.1.1.1
GATEWAY=10.101.1.1

[adam@node2 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
[sudo] password for adam: 

NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.101.1.12
NETMASK=255.255.255.0
DNS1=1.1.1.1
GATEWAY=10.101.1.1
```
- **vous n'utilisez QUE `ssh` pour administrer les machines**

- **les machines doivent avoir un nom**
**node1**
```
[adam@node1 ~]$ hostname
node1.tp1.b2

[adam@node2 ~]$ hostname
node2.tp1.b2
```
- **utiliser `1.1.1.1` comme serveur DNS**
```
[adam@node1 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
[sudo] password for adam: 

NAME=enp0s8
DEVICE=enp0s8
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.101.1.11
NETMASK=255.255.255.0
DNS1=1.1.1.1
GATEWAY=10.101.1.1
[adam@node1 ~]$ hostname

[adam@node2 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
[sudo] password for adam: 

NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
BOOTPROTO=static
IPADDR=10.101.1.12
NETMASK=255.255.255.0
DNS1=1.1.1.1
GATEWAY=10.101.1.1
```
- vérifier avec le bon fonctionnement avec la commande `dig`
- avec `dig`, demander une résolution du nom `ynov.com`
```
[adam@node1 ~]$ dig ynov.com

; <<>> DiG 9.11.26-RedHat-9.11.26-4.el8_4 <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19243
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		10800	IN	A	92.243.16.143

;; Query time: 36 msec
;; SERVER: 10.0.2.3#53(10.0.2.3)
;; WHEN: Sun Sep 26 22:03:11 CEST 2021
;; MSG SIZE  rcvd: 53

[adam@node2 ~]$ dig ynov.com

; <<>> DiG 9.11.26-RedHat-9.11.26-4.el8_4 <<>> ynov.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59365
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ynov.com.			IN	A

;; ANSWER SECTION:
ynov.com.		7260	IN	A	92.243.16.143

;; Query time: 19 msec
;; SERVER: 10.0.2.3#53(10.0.2.3)
;; WHEN: Mon Sep 27 02:07:01 CEST 2021
;; MSG SIZE  rcvd: 53
```
- mettre en évidence la ligne qui contient la réponse : l'IP qui correspond au nom demandé
```
ynov.com.		10800	IN	A	92.243.16.143
```
- mettre en évidence la ligne qui contient l'adresse IP du serveur qui vous a répondu
```
;; SERVER: 10.0.2.3#53(10.0.2.3)
```
- **les machines doivent pouvoir se joindre par leurs noms respectifs**
- assurez-vous du bon fonctionnement avec des `ping <NOM>`

```
[adam@node1 ~]$ ping node2.tp1.b2
PING node2.tp1.b2 (10.101.1.12) 56(84) bytes of data.
64 bytes from node2.tp1.b2 (10.101.1.12): icmp_seq=1 ttl=64 time=1.05 ms
64 bytes from node2.tp1.b2 (10.101.1.12): icmp_seq=2 ttl=64 time=1.01 ms
^C
--- node2.tp1.b2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 1.005/1.027/1.050/0.039 ms

[adam@node2 ~]$ ping node2.tp1.b2
PING node2.tp1.b2(node2.tp1.b2 (fe80::a00:27ff:fe01:5359%enp0s3)) 56 data bytes
64 bytes from node2.tp1.b2 (fe80::a00:27ff:fe01:5359%enp0s3): icmp_seq=1 ttl=64 time=0.124 ms
64 bytes from node2.tp1.b2 (fe80::a00:27ff:fe01:5359%enp0s3): icmp_seq=2 ttl=64 time=0.125 ms
^C
--- node2.tp1.b2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.124/0.124/0.125/0.011 ms
```
- **le pare-feu est configuré pour bloquer toutes les connexions exceptées celles qui sont nécessaires**
```
[adam@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules:

[adam@node2 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```
## I. Utilisateurs
### 1. Création et configuration

Ajouter un utilisateur à la machine, qui sera dédié à son administration. Précisez des options sur la commande d'ajout pour que :

- le répertoire home de l'utilisateur soit précisé explicitement, et se trouve dans `/home`
- le shell de l'utilisateur soit `/bin/bash`
```
[adam@node1 ~]$ sudo useradd admin -m -s /bin/sh
[sudo] password for adam: 
```
```
[adam@node1 home]$ ls
adam  admin  randomUser
```
```
[adam@node2 ~]$ sudo useradd admin -m -s /bin/sh
[sudo] password for adam: 
```
```
[adam@node2 ~]$ ls .. ~
..:
adam  admin  randomUser2

/home/adam:
```
Créer un nouveau groupe `admins` qui contiendra les utilisateurs de la machine ayant accès aux droits de `root` *via* la commande `sudo`.
```
[adam@node1 home]$ sudo groupadd admins
[sudo] password for adam: 
```
```
[adam@node2 ~]$ sudo groupadd admins
[adam@node2 ~]$ 
```
Pour permettre à ce groupe d'accéder aux droits `root` :

- il faut modifier le fichier `/etc/sudoers`
- on ne le modifie jamais directement à la main car en cas d'erreur de syntaxe, on pourrait bloquer notre accès aux droits administrateur
- la commande `visudo` permet d'éditer le fichier, avec un check de syntaxe avant fermeture
- ajouter une ligne basique qui permet au groupe d'avoir tous les droits (inspirez vous de la ligne avec le groupe `wheel`)
```
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
%admins ALL=(ALL)       ALL
```
Ajouter votre utilisateur à ce groupe `admins`.
```
[adam@node1 home]$ sudo usermod -aG admins admin
[sudo] password for adam: 
```
```
[adam@node2 ~]$ sudo usermod -aG admins admin
[adam@node2 ~]$ 
```
```
[adam@node1 ~]$ su admin
Password: 

sh-4.4$ sudo ls -la
total 16
drwx------. 3 adam adam 118 Sep 27 00:02 .
drwxr-xr-x. 5 root root  49 Sep 26 22:18 ..
-rw-------. 1 adam adam   0 Sep 27 00:02 .bash_history
-rw-r--r--. 1 adam adam  18 Jun 17 01:42 .bash_logout
-rw-r--r--. 1 adam adam 141 Jun 17 01:42 .bash_profile
-rw-r--r--. 1 adam adam 376 Jun 17 01:42 .bashrc
drwx------. 2 adam adam  80 Sep 26 23:36 .ssh
-rw-rw-r--. 1 adam adam 381 Sep 26 23:09 authorized_keys
sh-4.4$ 

[adam@node2 ~]$ su admin
Password: 
sh-4.4$ 
sh-4.4$ sudo ls -la

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for admin: 
total 12
drwx------. 2 adam adam  83 Sep 15 17:47 .
drwxr-xr-x. 5 root root  50 Sep 26 22:20 ..
-rw-------. 1 adam adam   0 Sep 15 17:47 .bash_history
-rw-r--r--. 1 adam adam  18 Jun 17 01:42 .bash_logout
-rw-r--r--. 1 adam adam 141 Jun 17 01:42 .bash_profile
-rw-r--r--. 1 adam adam 376 Jun 17 01:42 .bashrc
```

### 2. SSH

- il faut générer une clé sur le poste client de l'administrateur qui se connectera à distance (vous :) )
```
# Je sais que je peux créer des clé ssh avec cette commande mais j'ai préférer garder la clé que j'avais déjà
ssh-keygen -t rsa
```
```
adam@X1-Carbon:~/.ssh$ sudo cat id_rsa.pub
[sudo] password for adam: 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDStntmQPnQEyP3EYPTBH6lg8LZ6OBkyWKBCPtorVk+chdnnjtLEQ/xGsEbN331O5dqNToHv0t1JoOS3gSJbfGDoZ2ECq0gIe1kDy2eoUqiQ/+FElBzS66xI0WtOkpkgq8bT88rIzN1c8HQDfOCGjJvee+jcQFxXpghNSsNkUA0jcozPjlsGZZGxMTtDcDw1zIS68R7Vp5rwiM7XiZ5PvqT+vT45mIDePkcMRJu2Cq2rQ9VyKCE5UXmbh3YJyaLOHwrBsRedXlVCsACSmY9EhwmYRt0yhLIoQv6D9N1Sbm7tvIE+t2wsoClLXcsvaOTjMQCnnEO3r9RCvPdrtb1vOKD adam@X1-Carbon
```
- déposer la clé dans le fichier `/home/<USER>/.ssh/authorized_keys` de la machine que l'on souhaite administrer
  - vous utiliserez l'utilisateur que vous avez créé dans la partie précédente du TP
  - on peut le faire à la main
  - ou avec la commande `ssh-copy-id`
```
adam@X1-Carbon:~/.ssh$ ssh-copy-id admin@10.101.1.11
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
admin@10.101.1.11's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'admin@10.101.1.11'"
and check to make sure that only the key(s) you wanted were added.


adam@X1-Carbon:~/.ssh$ ssh-copy-id admin@10.101.1.12
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
admin@10.101.1.12's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'admin@10.101.1.12'"
and check to make sure that only the key(s) you wanted were added.
```
Assurez vous que la connexion SSH est fonctionnelle, sans avoir besoin de mot de passe.
```
adam@X1-Carbon:~/.ssh$ ssh admin@10.101.1.11
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Mon Sep 27 02:15:53 2021
[admin@node1 ~]$ 

adam@X1-Carbon:~/.ssh$ ssh admin@10.101.1.12
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Mon Sep 27 02:16:49 2021
[admin@node2 ~]$ 
```

## II. Partitionnement
**Uniquement sur `node1.tp1.b2`.**
### 1. Préparation de la VM
### 2. Partitionnement

**Uniquement sur `node1.tp1.b2`.**

Utilisez LVM pour :

- agréger les deux disques en un seul *volume group*
```
[adam@node1 ~]$ sudo vgextend adam /dev/sdc
  Volume group "adam" successfully extended

[adam@node1 ~]$ sudo vgextend adam /dev/sdb
  Volume group "adam" successfully extended
```
```
[adam@node1 ~]$ sudo pvs
  PV         VG                Fmt  Attr PSize   PFree 
  /dev/sda2  rl_bastion-ovh1fr lvm2 a--  <15.00g     0 
  /dev/sdb   adam              lvm2 a--   <3.00g <3.00g
  /dev/sdc   adam              lvm2 a--   <3.00g <3.00g

[adam@node1 ~]$ sudo vgs
  VG                #PV #LV #SN Attr   VSize   VFree
  adam                2   0   0 wz--n-   5.99g 5.99g
  rl_bastion-ovh1fr   1   2   0 wz--n- <15.00g    0 
```
- créer 3 *logical volumes* de 1 Go chacun
```
[adam@node1 ~]$ sudo lvcreate -L 1G adam -n data1
  Logical volume "data1" created.

[adam@node1 ~]$ sudo lvcreate -L 1G adam -n data2
  Logical volume "data2" created.

[adam@node1 ~]$ sudo lvcreate -L 1G adam -n data3
  Logical volume "data3" created.
```
```
[adam@node1 ~]$ sudo lvs
  LV    VG                Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  data1 adam              -wi-a-----  1.00g                                                    
  data2 adam              -wi-a-----  1.00g                                                    
  data3 adam              -wi-a-----  1.00g                                                    
  root  rl_bastion-ovh1fr -wi-ao---- 13.39g                                                    
  swap  rl_bastion-ovh1fr -wi-ao----  1.60g                                    
```
- formater ces partitions en `ext4`
```
[adam@node1 ~]$ sudo mkfs -t ext4 /dev/adam/data1
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: c7bf0a84-2f73-4f93-bd92-1bb6513169ba
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

[adam@node1 ~]$ sudo mkfs -t ext4 /dev/adam/data2
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: ddc12638-96c5-4a14-8e1a-10f784f96cc3
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

[adam@node1 ~]$ sudo mkfs -t ext4 /dev/adam/data3
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 0836a0fc-b15d-4631-8111-58cbe48d8b4f
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```
- monter ces partitions pour qu'elles soient accessibles aux points de montage `/mnt/part1`, `/mnt/part2` et `/mnt/part3`.
```
[adam@node1 ~]$ sudo mount /dev/adam/data1 /mnt/
[adam@node1 ~]$ 

[adam@node1 ~]$ sudo mount /dev/adam/data2 /mnt/
[adam@node1 ~]$ 

[adam@node1 ~]$ sudo mount /dev/adam/data3 /mnt/
[adam@node1 ~]$ 
```
```
[adam@node1 ~]$ mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=910324k,nr_inodes=227581,mode=755)
[...]
/dev/mapper/adam-data1 on /mnt type ext4 (rw,relatime,seclabel)
/dev/mapper/adam-data2 on /mnt type ext4 (rw,relatime,seclabel)
/dev/mapper/adam-data3 on /mnt type ext4 (rw,relatime,seclabel)
```
Grâce au fichier `/etc/fstab`, faites en sorte que cette partition soit montée automatiquement au démarrage du système.
```
[adam@node1 ~]$ sudo cat /etc/fstab

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
/dev/adam/data1 /mnt ext4 defaults 0 0
/dev/adam/data3	/mnt ext4 defaults 0 0
/dev/adam/data2	/mnt ext4 defaults 0 0
```

## III. Gestion de services
## 1. Interaction avec un service existant

**Uniquement sur `node1.tp1.b2`.**

 Assurez-vous que :

- l'unité est démarrée
```
[adam@node1 ~]$ sudo systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor >
   Active: active (running) since Mon 2021-09-27 01:59:23 CEST; 1h 4min ago
     Docs: man:firewalld(1)
 Main PID: 884 (firewalld)
    Tasks: 2 (limit: 11378)
   Memory: 30.5M
   CGroup: /system.slice/firewalld.service
           └─884 /usr/libexec/platform-python -s /usr/sbin/firewalld --nofork >

Sep 27 01:59:22 node1.tp1.b2 systemd[1]: Starting firewalld - dynamic firewall>
Sep 27 01:59:23 node1.tp1.b2 systemd[1]: Started firewalld - dynamic firewall >
Sep 27 01:59:23 node1.tp1.b2 firewalld[884]: WARNING: AllowZoneDrifting is ena>
lines 1-13/13 (END)
```
- l'unitée est activée (elle se lance automatiquement au démarrage)
```
Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor >
```

## 2. Création de service

**Uniquement sur `node1.tp1.b2`.**

### A. Unité simpliste

Créer un fichier qui définit une unité de service `web.service` dans le répertoire `/etc/systemd/system`.
```
[adam@node1 system]$ sudo touch web.service
[adam@node1 system]$ pwd
/etc/systemd/system
[adam@node1 system]$ ls
basic.target.wants                          network-online.target.wants
dbus-org.fedoraproject.FirewallD1.service   remote-fs.target.wants
dbus-org.freedesktop.nm-dispatcher.service  sockets.target.wants
dbus-org.freedesktop.timedate1.service      sysinit.target.wants
default.target                              syslog.service
default.target.wants                        systemd-timedated.service
getty.target.wants                          timers.target.wants
graphical.target.wants                      web.service
multi-user.target.wants
```

Déposer le contenu suivant :
```
[adam@node1 system]$ cat web.service 
[Unit]
Description=Very simple web service

[Service]
ExecStart=/bin/python3 -m http.server 8888

[Install]
WantedBy=multi-user.target
```
**N'oubliez pas d'[ouvrir ce port](../../cours/memo/rocky_network.md#interagir-avec-le-firewall).**
```
[adam@node1 system]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success

[adam@node1 ~]$ sudo firewall-cmd --add-port=8888/udp --permanent
success
```
Une fois l'unité de service créée, il faut demander à *systemd* de relire les fichiers de configuration :
```
[adam@node1 system]$ sudo systemctl daemon-reload
[adam@node1 system]$ 

[adam@node1 system]$ sudo systemctl status web
● web.service - Very simple web service
   Loaded: loaded (/etc/systemd/system/web.service; disabled; vendor preset: d>
   Active: inactive (dead)

[adam@node1 system]$ sudo systemctl start web
[adam@node1 system]$ 

[adam@node1 system]$ sudo systemctl enable web
Created symlink /etc/systemd/system/multi-user.target.wants/web.service → /etc/systemd/system/web.service.
```
```
[adam@node1 ~]$ sudo systemctl status web
● web.service - Very simple web service
   Loaded: loaded (/etc/systemd/system/web.service; enabled; vendor preset:>
   Active: active (running) since Mon 2021-09-27 03:52:26 CEST; 8s ago
 Main PID: 30157 (python3)
    Tasks: 1 (limit: 11378)
   Memory: 9.8M
   CGroup: /system.slice/web.service
           └─30157 /bin/python3 -m http.server 8888

Sep 27 03:52:26 node1.tp1.b2 systemd[1]: Started Very simple web service.
```
Une fois le service démarré, assurez-vous que pouvez accéder au serveur web : avec un navigateur ou la commande `curl` sur l'IP de la VM, port 8888.
```
[adam@node1 ~]$ curl 10.101.1.11:8888
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="dev/">dev/</a></li>
<li><a href="etc/">etc/</a></li>
<li><a href="home/">home/</a></li>
<li><a href="lib/">lib@</a></li>
<li><a href="lib64/">lib64@</a></li>
<li><a href="media/">media/</a></li>
<li><a href="mnt/">mnt/</a></li>
<li><a href="opt/">opt/</a></li>
<li><a href="proc/">proc/</a></li>
<li><a href="root/">root/</a></li>
<li><a href="run/">run/</a></li>
<li><a href="sbin/">sbin@</a></li>
<li><a href="srv/">srv/</a></li>
<li><a href="sys/">sys/</a></li>
<li><a href="tmp/">tmp/</a></li>
<li><a href="usr/">usr/</a></li>
<li><a href="var/">var/</a></li>
</ul>
<hr>
</body>
</html>
```

### B. Modification de l'unité

 Créer un utilisateur `web`.
```
[adam@node1 ~]$ sudo useradd web
[adam@node1 ~]$ sudo passwd web
Changing password for user web.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.
```
Modifiez l'unité de service `web.service` créée précédemment en ajoutant les clauses :

- `User=` afin de lancer le serveur avec l'utilisateur `web` dédié
- `WorkingDirectory=` afin de lancer le serveur depuis un dossier spécifique, choisissez un dossier que vous avez créé dans `/srv`
- ces deux clauses sont à positionner dans la section `[Service]` de votre unité
```
[adam@node1 ~]$ sudo cat /etc/systemd/system/web.service
#!/usr/bin/python3
[Unit]
Description=Very simple web service

[Service]
ExecStart=/bin/python3 -m http.server 8888
User=web
WorkingDirectory=/srv/work

[Install]
WantedBy=multi-user.target
```

Placer un fichier de votre choix dans le dossier créé dans `/srv` et tester que vous pouvez y accéder une fois le service actif. Il faudra que le dossier et le fichier qu'il contient appartiennent à l'utilisateur `web`.
```
[adam@node1 work]$ ls -l
total 8
-rw-r--r--. 1 root root 5 Sep 27 04:03 userAdam.txt
-rw-r--r--. 1 web  root 4 Sep 27 04:06 userWeb.txt
```
Vérifier le bon fonctionnement avec une commande `curl`
```
[adam@node1 work]$ curl http://localhost:8888/srv/work/userWeb.txt
Web
```