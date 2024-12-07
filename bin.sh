#!/bin/bash
if ! command -v apache2 &> /dev/null
then
    echo "apache2 n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y apache2
else
    echo "apache2 est déjà installé."
fi
if ! command -v dos2unix &> /dev/null
then
    echo "dos2unix n'est pas installé. Installation en cours..."
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
if ! ls -r | grep -q "mgrosmann"; then
  git clone https://github.com/mgrosmann/mgrosmann.git
fi
cd mgrosmann/docker
chmod +x /*.sh
dos2unix *.sh
for script in *.sh
do
  mv "$file" "/usr/local/bin/$(basename "$file" .sh)"
done
