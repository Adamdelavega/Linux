# TP2 pt. 1 : Gestion de service
# 0. Prérequis
## Checklist
# I. Un premier serveur web
## 1. Installation

**Installer le serveur Apache**

- paquet `httpd`
```
[adam@web ~]$ sudo dnf install -y httpd
[...]
Installed:
  apr-1.6.3-11.el8.1.x86_64                                                     
  apr-util-1.6.1-6.el8.1.x86_64                                                 
  apr-util-bdb-1.6.1-6.el8.1.x86_64                                             
  apr-util-openssl-1.6.1-6.el8.1.x86_64                                         
  httpd-2.4.37-39.module+el8.4.0+571+fd70afb1.x86_64                            
  httpd-filesystem-2.4.37-39.module+el8.4.0+571+fd70afb1.noarch                 
  httpd-tools-2.4.37-39.module+el8.4.0+571+fd70afb1.x86_64                      
  mod_http2-1.15.7-3.module+el8.4.0+553+7a69454b.x86_64                         
  rocky-logos-httpd-84.5-8.el8.noarch                                           

Complete!
```
- la conf se trouve dans `/etc/httpd/`
  - le fichier de conf principal est `/etc/httpd/conf/httpd.conf`
  - je vous conseille **vivement** de virer tous les commentaire du fichier, à défaut de les lire, vous y verrez plus clair
    - avec `vim` vous pouvez tout virer avec `:g/^ *#.*/d`
```
[adam@web ~]$ sudo cat /etc/httpd/conf/httpd.conf

ServerRoot "/etc/httpd"

Listen 8888

Include conf.modules.d/*.conf

User adam
Group adam


ServerAdmin adam@tp2.linux

ServerName web.tp2.linux:8888
[...]
```
**Démarrer le service Apache**

- le service s'appelle `httpd` (raccourci pour `httpd.service` en réalité)
  - démarrez le
```
[adam@web ~]$ sudo systemctl start httpd
[adam@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor pres>
   Active: active (running) since Wed 2021-09-29 17:11:30 CEST; 7s ago
     Docs: man:httpd.service(8)
 Main PID: 26240 (httpd)
   Status: "Started, listening on: port 8888"
    Tasks: 213 (limit: 11378)
   Memory: 25.1M
   CGroup: /system.slice/httpd.service
           ├─26240 /usr/sbin/httpd -DFOREGROUND
           ├─26243 /usr/sbin/httpd -DFOREGROUND
           ├─26244 /usr/sbin/httpd -DFOREGROUND
           ├─26245 /usr/sbin/httpd -DFOREGROUND
           └─26246 /usr/sbin/httpd -DFOREGROUND

Sep 29 17:11:30 web.tp2.linux systemd[1]: Starting The Apache HTTP Server...
Sep 29 17:11:30 web.tp2.linux systemd[1]: Started The Apache HTTP Server.
Sep 29 17:11:30 web.tp2.linux httpd[26240]: Server configured, listening on: po>
lines 1-18/18 (END)
```
  - faites en sorte qu'Apache démarre automatique au démarrage de la machine
```
[adam@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
[adam@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor prese>
   Active: active (running) since Wed 2021-09-29 17:11:30 CEST; 1min 12s ago
     Docs: man:httpd.service(8)
 Main PID: 26240 (httpd)
   Status: "Running, listening on: port 8888"
    Tasks: 213 (limit: 11378)
   Memory: 25.1M
   CGroup: /system.slice/httpd.service
           ├─26240 /usr/sbin/httpd -DFOREGROUND
           ├─26243 /usr/sbin/httpd -DFOREGROUND
           ├─26244 /usr/sbin/httpd -DFOREGROUND
           ├─26245 /usr/sbin/httpd -DFOREGROUND
           └─26246 /usr/sbin/httpd -DFOREGROUND

Sep 29 17:11:30 web.tp2.linux systemd[1]: Starting The Apache HTTP Server...
Sep 29 17:11:30 web.tp2.linux systemd[1]: Started The Apache HTTP Server.
Sep 29 17:11:30 web.tp2.linux httpd[26240]: Server configured, listening on: po>
lines 1-18/18 (END)
```
- ouvrez le port firewall nécessaire
```
[adam@web ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
```
- utiliser une commande `ss` pour savoir sur quel port tourne actuellement Apache

