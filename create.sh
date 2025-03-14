#!/bin/bash
DIALOG=${DIALOG=dialog}

choix=$($DIALOG --clear --backtitle "Création/installation de conteneurs" \
    --title "Choisissez une action" \
    --menu "Veuillez choisir une option :" 15 50 5 \
    1 "Créer un conteneur avec fichier yaml" \
    2 "Installer un conteneur multi-service (MySQL, phpMyAdmin, FTP, Apache)" \
    3 "Installer un conteneur en session interactive ou détaché" \
    4 "Supprimer un conteneur" \
    5 "Supprimer une image Docker" \
    2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    dcs
    exit
fi
clear

case $choix in
    1) compose_aio ;;
    2) compose ;;
    3) docker_aio ;;
    4) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur à supprimer :" 8 40 2>&1 >/dev/tty)
    if [ $? -ne 0 ]; then
    dcs
    exit
    fi
       docker rm -f $container_id ;;
    5) image_id=$($DIALOG --inputbox "Entrez l'ID ou le nom de l'image Docker à supprimer :" 8 40 2>&1 >/dev/tty)
    if [ $? -ne 0 ]; then
        dcs
        exit
    fi
       docker rmi $image_id ;;
esac
