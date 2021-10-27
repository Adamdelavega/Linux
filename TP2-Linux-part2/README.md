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

[adam@db ~]$ sudo /opt/netdata/etc/netdata/edit-config health_alarm_notify.conf
[sudo] password for adam: 
Editing '/opt/netdata/etc/netdata/health_alarm_notify.conf' ...
[adam@db ~]$ 
```
```



