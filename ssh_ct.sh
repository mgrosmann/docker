#!/bin/bash
container_name=$(dialog --inputbox "Entrez le nom du conteneur auquel vous souhaitez accéder :" 8 50 2>&1 >/dev/tty)
if [ -n "$container_name" ]; then
    docker container exec -it "$container_name" /bin/bash
else
    dialog --msgbox "Nom de conteneur invalide ou vide. Veuillez réessayer." 8 50
fi
clear
