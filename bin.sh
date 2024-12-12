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
for script in *.sh
do
  mv "$script" "/usr/local/bin/$(basename "$script" .sh)"
done
apt install libapache2-mod-php
sudo chmod 666 /var/run/docker.sock
echo "lancer la commande 'container' pour lancer l'outil centralisé"
