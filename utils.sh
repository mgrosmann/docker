#!/bin/bash
DIALOG=${DIALOG=dialog}

choix=$($DIALOG --clear --backtitle "Outils de gestion Docker" \
    --title "Choisissez une action" \
    --menu "Veuillez choisir une option :" 15 50 7 \
    1 "Afficher les logs d'un conteneur" \
    2 "Lister tous les volumes" \
    3 "Lister toutes les images" \
    4 "Lister tous les conteneurs" \
    5 "Afficher les statistiques Docker" \
    6 "Inspecter un conteneur" \
    7 "Sauvegarder et restaurer un conteneur" \
    2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    dcs
    exit
fi
clear

case $choix in
    1) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur :" 8 40 2>&1 >/dev/tty)
       docker logs $container_id ;;
    2) docker volume ls ;;
    3) docker images ;;
    4) docker ps -a ;;
    5) docker stats ;;
    6) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur :" 8 40 2>&1 >/dev/tty)
       docker inspect $container_id ;;
    7) sub_choix=$($DIALOG --clear --backtitle "Sauvegarde et restauration" \
        --title "Choisissez une option" \
        --menu "Veuillez choisir une option :" 10 40 2 \
        1 "Sauvegarder un conteneur" \
        2 "Restaurer un conteneur" \
        2>&1 >/dev/tty)
       clear
       case $sub_choix in
           1) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur :" 8 40 2>&1 >/dev/tty)
              docker commit $container_id ${container_id}_backup
              docker save -o ${container_id}_backup.tar ${container_id}_backup ;;
           2) backup_path=$($DIALOG --inputbox "Entrez le chemin du fichier de sauvegarde :" 8 40 2>&1 >/dev/tty)
              docker load -i $backup_path ;;
       esac ;;
esac
