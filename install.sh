#!/bin/bash
read -p "Veuillez entrer votre distribution Linux (1 pour Ubuntu et 2 pour Debian) : " distribution

# Appliquer chmod en fonction de la distribution
if [ "$distribution" = "1" ]; then
    chmod +x Docker.sh
    bash Docker.sh
elif [ "$distribution" = "2" ]; then
    chmod +x deb_docker.sh
    bash deb_docker.sh
else
    echo "Choix non pris en compte"
fi
