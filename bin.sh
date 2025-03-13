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
if ! command -v dialog &> /dev/null;
then
    sudo apt install -y dialog
else
    echo "dialog est déjà installé."
fi
rm Docker.sh
rm deb_docker.sh
chmod +x *.sh
dos2unix *.sh
for script in *.sh
do
  mv "$script" "/usr/local/bin/$(basename "$script" .sh)"
done
cd ..
rm -r docker
echo "lancer la commande 'dcs' pour lancer l'outil centralisé"
