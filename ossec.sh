#!/bin/bash
# INSTALLAZIONE DELLE DIPENDENZE OSSEC
sudo apt install -y \
make \
build-essential \
libz-dev \
libssl-dev \
libpcre2-dev \
libevent-dev \
inotify-tools

#wget -P /root http://archive.ubuntu.com/ubuntu/pool/main/g/gcc-defaults/gcc_7.3.0-3ubuntu2_amd64.deb
#dpkg -i /root/gcc_7.3.0-3ubuntu2_amd64.deb

# INSTALLAZIONE DI OSSEC
wget -P /root https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
tar -xvzf /root/3.6.0.tar.gz
cd /root/ossec-hids-3.6.0
sh /root/ossec-hids-3.6.0/install.sh

# CONTROLLO VERSIONE INSTALLATA
cat /etc/ossec-init.conf

# AVVIO SERVIZIO
sudo /var/ossec/bin/ossec-control start

# IMPOSTO CHECK OGNI 10 MINUTI
sudo sed -i "s/79200/600/g" /var/ossec/etc/ossec.conf

# AGGIUNGO ULTERIORI REGOLE
sed -i "/<\!-- EOF -->/d" /var/ossec/rules/local_rules.xml

cat <<EOT >> /var/ossec/rules/local_rules.xml
<group name="syslog,sshd,authentication_success,">
  <rule id="105715" level="3">
    <if_sid>5715</if_sid>
    <options>alert_by_email</options>
    <description>ssh login</description>
  </rule>
</group>
<group name="syslog,authentication_success,">
  <rule id="105303" level="3">
    <if_sid>5303</if_sid>
    <options>alert_by_email</options>
    <description>root activity</description>
  </rule>
</group>
<group name="snap_loop_devices_alerts_suppression,">
  <rule id="105305" level="0">
       <if_sid>531</if_sid>
       <regex>'df -P':\s+/dev/loop\d+\s+\d+\s+\d+\s+0\s+100%\s+/snap/\w+/\d+</regex>
       <description>Ignore full snap loop devices in Ubuntu 18.04</description>
  </rule>
</group>

<!-- EOF -->
EOT

# COPIA RESOLV CONF
cp /etc/resolv.conf /var/ossec/etc/resolv.conf
systemctl restart ossec
echo "Installazione di ossec avvenuta"
