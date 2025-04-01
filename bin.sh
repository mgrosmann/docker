#!/bin/bash
mkdir -p /root/bin
wget mgrosmann.vercel.app/script/perso/hello-world
cp hello-world.sh /root/bin/
if ! command -v hello-wolrd &> /dev/null; then
   echo "export PATH=$PATH:/root/bin" >> /root/.bashrc
    source .bashrc
fi
if ! command -v docker &> /dev/null; then
    chmod +x docker.sh
    bash docker.sh
else
    echo "docker est déjà installé."
fi
if ! command -v dos2unix &> /dev/null; then
    apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
if ! command -v apache2 &> /dev/null; then
    apt-get install -y apache2
else
    echo "dos2unix est déjà installé."
fi
if ! command -v dialog &> /dev/null; then
    apt install -y dialog
else
    echo "dialog est déjà installé."
fi
rm Docker.sh
rm deb_docker.sh
chmod +x *.sh
dos2unix *.sh
for script in *.sh
do
  mv "$script" "/root/bin/$(basename "$script" .sh)"
done
cd ..
rm -r docker
echo "lancer la commande 'dcs' pour lancer l'outil centralisé"
