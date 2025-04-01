#!/bin/bash
#If doesn't work execute command "DOCKER_BUILDKIT=0
read -p "quel dockerfile utiliser ? " folder
read -p "nom du conteneur: " name
read -p "port du conteneur: " portd
read -p "port a utiliser: " port
cd $folder/
docker image build -t $name .
docker container run -d -p $port:$portd $name
