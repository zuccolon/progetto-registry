#!/bin/bash

# INSTALLO MMONIT
apt-get update -y
apt-get install monit -y

systemctl start monit
systemctl enable monit

# FORMATTO IL FILE DI CONFIGURAZIONE
sudo cat <<EOF > /etc/monit/monitrc
set daemon 60 # check services at 1-minute intervals
set log /var/log/monit.log
set idfile /var/lib/monit/id
set statefile /var/lib/monit/state
set eventqueue
   basedir /var/lib/monit/events # set the base directory where events will be stored
   slots 100                     # optionally limit the queue size
include /etc/monit/conf.d/*
include /etc/monit/conf-enabled/*

set httpd port 8080 and
    allow admin:monit

set mailserver 127.0.0.1
set alert zuccolon@cscs.ch

# REGOLE
check system \$HOST
 if memory usage > 80% for 4 cycles then alert
 if swap usage > 20% for 4 cycles then alert
 # Test the user part of CPU usage
 if cpu usage (user) > 80% for 2 cycles then alert
 # Test the system part of CPU usage
 if cpu usage (system) > 20% for 2 cycles then alert
 # Test the i/o wait part of CPU usage
 if cpu usage (wait) > 80% for 2 cycles then alert

 check process sshd with pidfile /var/run/sshd.pid
   start program "/etc/init.d/ssh start"
   stop program "/etc/init.d/ssh stop"
   if failed port 22 protocol ssh then restart
   if 5 restarts within 5 cycles then timeout

check host dockerbox.ch with address dockerbox.ch
 if failed port 80 protocol http for 2 cycles then alert

 check host dockerbox
   with address dockerbox.ch
   if failed
     host dockerbox.ch
     port 443
     type TCPSSL
     protocol https
   then alert

EOF

# CONTROLLO IL FILE E RIAVVIO IL SERVIZIO
sudo monit -t
systemctl restart monit
echo "MMonit installato e fruibile alla porta 8080"
