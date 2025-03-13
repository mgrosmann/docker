#!/bin/bash
choix=$(dialog --clear --backtitle "Gestion des conteneurs Docker" \
    --title "Menu Principal" \
    --menu "Veuillez choisir une catégorie :" 15 50 4 \
    1 "APACHE" \
    2 "MYSQL+PMA" \
    3 "MYSQL+PMA+GLPI" \
    4 "MYSQL+PMA+NextCloud" \
    5 "Grafana+Prometheus" \
    2>&1 >/dev/tty)
case $choix in
    1)
        apocker
        ;;
    2)
        pma
        ;;
    3)
        glpi
        ;;
    4)
        nextcloud
        ;;
    5)
        grafeus
        ;;
    *)
        dialog --msgbox "Choix invalide. Veuillez réessayer." 6 40
        ;;
esac
clear
