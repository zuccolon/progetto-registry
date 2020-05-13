#!/bin/bash
# INSTALLO POSTFIX
echo "postfix postfix/mailname string dockerbox.ch" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
sudo apt install -y postfix
sudo apt install libsasl2-modules mailutils -y

# CONFIGURO USERNAME E PASSWORD

#

echo "abilita le app meno sicure in google https://www.google.com/settings/security/lesssecureapps"
echo "disabilita il controllo degli accessi https://accounts.google.com/DisplayUnlockCaptcha"

# ACQUISIZIONE INFORMAZIONI
echo ""
echo -n "Postfix domain? es dockerbox.ch: "
read CURRENTDOMAIN
echo ""
echo "Gmail Username?: "
read GMAILUSER
echo ""
echo "Gmail Password?: "
read GMAILPASS


echo hai passato i dati $GMAILUSER utente e come password $GMAILPASS

touch /etc/postfix/sasl/sasl_passwd
echo "[smtp.gmail.com]:587 $GMAILUSER@gmail.com:$GMAILPASS" > /etc/postfix/sasl/sasl_passwd
cat /etc/postfix/sasl/sasl_passwd

# FORMATTO E RESTRINGO ACCESSO ALLE CREDENZIALI
sudo postmap /etc/postfix/sasl/sasl_passwd
sudo chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db

# MODIFICO FILE DI CONFIGURAZIONE
sed -i '/myhostname/d' /etc/postfix/main.cf
sed -i '/relayhost/d' /etc/postfix/main.cf
echo "myhostname = $CURRENTDOMAIN" >> /etc/postfix/main.cf
echo "relayhost = [smtp.gmail.com]:587" >> /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd" >> /etc/postfix/main.cf
echo "smtp_tls_security_level = encrypt" >> /etc/postfix/main.cf
echo "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> /etc/postfix/main.cf
cat /etc/postfix/main.cf

# RIAVVIO IL SERVIZIO
sudo systemctl restart postfix && sudo systemctl enable postfix

echo "Postfix installato e configurato. invio una mail per test"

echo "Ciao, questa mail proviene dalla istanza postfix appena configurata e funzionante" | mail -s "Postfix configurato" zuccolon@gmail.com
