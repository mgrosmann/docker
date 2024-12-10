#!/bin/bash
if ! command -v docker &> /dev/null
then
    chmod +x install.sh
    bash install.sh
else
    echo "docker est déjà installé."
fi
if ! command -v dos2unix &> /dev/null
then
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
    fi
if ! command -v apache2 &> /dev/null
then
    sudo apt-get install -y apache2
else
    echo "dos2unix est déjà installé."
fi
chmod +x *.sh
dos2unix *.sh
mv docker.sh docker1.sh
for script in *.sh
do
  mv "$script" "/usr/local/bin/$(basename "$script" .sh)"
done
apt install libapache2-mod-php
mv web /var/www/docker
usermod -aG docker www-data
sudo chmod 666 /var/run/docker.sock
cd /etc/apache2/sites-available
cat <<EOF > docker.conf
<VirtualHost *:9003>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/docker
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
cd /etc/apache2/
echo "Listen 9003" >> ports.conf
a2ensite docker
systemctl restart apache2
systemctl reload apache2
ip= hostname -I | awk '{print $1}'
echo "l'interface web est maintenant pres veuillez vous rendre sur $ip:9003"
echo "lancer la commande 'container' pour lancer l'outil centralisé"
