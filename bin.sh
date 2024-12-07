#!/bin/bash
if [ ! -d "mgrosmann" ]; then
  git clone https://github.com/mgrosmann/docker.git
else
  echo "Le répertoire mgrosmann existe déjà."
fi
if ! command -v dos2unix &> /dev/null
then
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
if ! command -v docker &> /dev/null
then
    chmod +x install.sh
    bash install.sh
else
    echo "docker est déjà installé."
fi
cd docker
chmod +x *.sh
dos2unix *.sh
for script in *.sh
do
  mv "$script" "/usr/local/bin/$(basename "$script" .sh)"
done
