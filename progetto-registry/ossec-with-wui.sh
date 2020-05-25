#!/bin/bash
# INSTALLAZIONE DELLE DIPENDENZE OSSEC
sudo apt install -y \
make \
wget \
unzip \
make \
gcc \
build-essential \
git \
g++ \
libgtk-3-dev \
gtk-doc-tools \
gnutls-bin \
valac \
intltool \
libpcre2-dev \
libglib3.0-cil-dev \
libgnutls28-dev \
libgirepository1.0-dev \
libxml2-utils \
gperf \
libssl-dev \
apache2 \
php \
php-cli \
php-common \
libapache2-mod-php \
apache2-utils \
sendmail \
libevent-dev \
inotify-tools

wget -P /root http://archive.ubuntu.com/ubuntu/pool/main/g/gcc-defaults/gcc_7.3.0-3ubuntu2_amd64.deb
dpkg -i /root/gcc_7.3.0-3ubuntu2_amd64.deb

# INSTALLAZIONE DI OSSEC
wget -P /root https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
tar -xvzf /root/3.6.0.tar.gz
cd /root/ossec-hids-3.6.0
sh /root/ossec-hids-3.6.0/install.sh

# CONTROLLO VERSIONE INSTALLATA
cat /etc/ossec-init.conf

# AVVIO SERVIZIO
sudo /var/ossec/bin/ossec-control start


# Installo la ossec WUI
rm /var/www/html/index.html
sudo git clone https://github.com/ossec/ossec-wui.git /var/www/html
# INSERIRE UTENTE,PASSWORD, www-data
sudo sh /var/www/html/setup.sh
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo a2enmod rewrite
sudo systemctl restart apache2
# ripreso da https://www.osradar.com/install-ossec-hids-ubuntu-18-04/

sed -i "s/Listen 80/Listen 8080/g" /etc/apache2/ports.conf
sed -i "s/\<VirtualHost \*\:80\>/VirtualHost \*\:8080/g" /etc/apache2/sites-available/000-default.conf
service apache2 restart

# CONTROLLO
sudo netstat -tulpn | grep apache2

echo "Installazione di ossec terminata"
echo "ora puoi raggiungere la interfaccia web presso la porta 8080"
