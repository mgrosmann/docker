#!/bin/bash
#If doesn't work execute command "DOCKER_BUILDKIT=0
read -p "nom du conteneur: " name
read -p "port du conteneur: " portd
read -p "port a utiliser: " portd
docker image build -t $name .
docker container run -it -p $port:$portd $name
