#!/bin/bash
DIALOG=${DIALOG=dialog}

choix=$($DIALOG --clear --backtitle "Création/installation de conteneurs" \
    --title "Choisissez une action" \
    --menu "Veuillez choisir une option :" 15 50 5 \
    1 "Créer un conteneur avec fichier yaml" \
    2 "Installer un conteneur LAMP+FTP" \
    3 "Installer un conteneur en session interactif" \
    4 "Installer un conteneur en session détaché" \
    2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    dcs
    exit
fi
clear

case $choix in
    1) compose_aio ;;
    2) compose ;;
    3) interactif ;;
    4) detache
esac
