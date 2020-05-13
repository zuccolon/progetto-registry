#!/bin/bash

# IMPOSTAZIONE DELLA TIMEZONE
sudo timedatectl set-timezone Europe/Zurich

# AGGIORNAMENTO DEI SOFTWARE
sudo apt update -y
sudo apt dist-upgrade -y

# INSTALLAZIONE DI GITLAB
#sudo apt install curl openssh-server ca-certificates -y
#curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
#sudo apt install gitlab-ce -y

# MODIFICA E CONFIGURAZIONE DEL FILE gitlab.rb
#sudo sed -i "s/http\:\/\/gitlab.example.com/https\:\/\/dockerbox.ch/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['enable'\] = nil/letsencrypt\['enable'\] = true/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['contact_emails'\] = \[\]/letsencrypt\['contact_emails'\] = \['zuccolon@cscs.ch'\]/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['group'\] = 'root'/letsencrypt\['group'\] = 'root'/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['key_size'\] = 2048/letsencrypt\['key_size'\] = 2048/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['owner'\] = 'root'/letsencrypt\['owner'\] = 'root'/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['wwwroot'\] = '\/var\/opt\/gitlab\/nginx\/www'/letsencrypt\['wwwroot'\] = '\/var\/opt\/gitlab\/nginx\/www'/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['auto_renew'\] = true/letsencrypt\['auto_renew'\] = true/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['auto_renew_hour'\] = 0/letsencrypt\['auto_renew_hour'\] = 2/g" /etc/gitlab/gitlab.rb
#sudo sed -i "s/\# letsencrypt\['auto_renew_day_of_month'\] = \"\*\/4\"/letsencrypt\['auto_renew_day_of_month'\] = \"\*\/4\"/g" /etc/gitlab/gitlab.rb

# RICONFIGURAZIONE DI GITLAB
#sudo gitlab-ctl reconfigure
