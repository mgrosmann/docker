#!/bin/bash
if ! command -v git &> /dev/null; then
    apt-get update && sudo apt-get install git -y
else
    echo "Git est déjà installé."
fi
apt install git -y && git clone https://github.com/mgrosmann/docker.git
cd docker && chmod +x bin.sh && bash bin.sh
echo "lancer la commande 'container'"