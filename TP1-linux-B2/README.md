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

🌞 Utilisez LVM pour :

- agréger les deux disques en un seul *volume group*
- créer 3 *logical volumes* de 1 Go chacun
- formater ces partitions en `ext4`
- monter ces partitions pour qu'elles soient accessibles aux points de montage `/mnt/part1`, `/mnt/part2` et `/mnt/part3`.

## III. Gestion de services
