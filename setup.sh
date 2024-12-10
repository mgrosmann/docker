#!/bin/bash
if ! command -v git &> /dev/null
then
    apt update
    apt install git
else
    echo "git est déjà installé."
fi
git clone https://github.com/mgrosmann/docker.git
cd docker
chmod +x bin.sh
bash bin.sh
