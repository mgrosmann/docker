#!/bin/bash
DIALOG=${DIALOG=dialog}

categorie=$($DIALOG --clear --backtitle "Gestion Docker" \
    --title "Gestion centralisé Docker" \
    --menu "Veuillez choisir une catégorie :" 15 50 3 \
    1 "Création/installation de conteneurs" \
    2 "Gestion des conteneurs existants" \
    3 "Outils Docker" \
    2>&1 >/dev/tty)
clear

case $categorie in
    1) create ;;  
    2) gestion ;; 
    3) utils ;;   
esac
