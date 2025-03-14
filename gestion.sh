#!/bin/bash
DIALOG=${DIALOG=dialog}

choix=$($DIALOG --clear --backtitle "Gestion des conteneurs existants" \
    --title "Choisissez une action" \
    --menu "Veuillez choisir une option :" 15 50 7 \
    1 "Se connecter à un conteneur" \
    2 "Démarrer tous les conteneurs" \
    3 "Arrêter tous les conteneurs" \
    4 "Installer nano et wget sur un conteneur" \
    5 "Vérifier et recréer les réseaux Docker manquants" \
    6 "Supprimer tous les conteneurs arrêtés" \
    7 "Recréer les conteneurs arrêtés" \
    8 "Supprimer un conteneur" \
    9 "Supprimer une image Docker" \
    2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    dcs
    exit
fi
clear

case $choix in
    1) ssh_ct ;;
    2) start ;;
    3) stop && docker ps -q | xargs -r docker stop ;;
    4) linux ;;
    5) network ;;
    6) remove ;;
    7) docker-compose up -d ;;
    8) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur à supprimer :" 8 40 2>&1 >/dev/tty)
    if [ $? -ne 0 ]; then
    gestion
    exit
    fi
       docker rm -f $container_id ;;
    9) image_id=$($DIALOG --inputbox "Entrez l'ID ou le nom de l'image Docker à supprimer :" 8 40 2>&1 >/dev/tty)
    if [ $? -ne 0 ]; then
        gestion
        exit
    fi
       docker rmi $image_id ;;   
esac
