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

wget http://archive.ubuntu.com/ubuntu/pool/main/g/gcc-defaults/gcc_7.3.0-3ubuntu2_amd64.deb
dpkg -i gcc_7.3.0-3ubuntu2_amd64.deb

# INSTALLAZIONE DI OSSEC
wget https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
tar -xvzf 3.6.0.tar.gz
cd ossec-hids-3.6.0
sh install.sh

# AVVIO SERVIZIO
sudo /var/ossec/bin/ossec-control start

# Installo la ossec WUI

cd /var/www/html
sudo git clone https://github.com/ossec/ossec-wui.git
cd ossec-wui
sudo ./setup
sudo chown -R www-data:www-data /var/www/html/ossec-wui/
sudo chmod -R 755 /var/www/html/ossec-wui/
sudo a2enmod rewrite
sudo systemctl restart apache2

# ripreso da https://www.osradar.com/install-ossec-hids-ubuntu-18-04/
