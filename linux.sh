#!/bin/bash
container_name=$(dialog --inputbox "Sur quel conteneur voulez-vous appliquer des commandes Linux :" 8 50 2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    gestion
    exit
fi
if [ -n "$container_name" ]; then
    docker exec -it "$name" /bin/bash -c "apt-get update && apt-get install -y wget nano"
else
    dialog --msgbox "Nom de conteneur invalide ou vide. Veuillez réessayer." 8 50
fi
clear
