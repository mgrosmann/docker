#!/bin/bash
choix=$(dialog --clear --backtitle "Gestion des conteneurs Docker" \
    --title "Menu Principal" \
    --menu "Veuillez choisir une catégorie :" 15 50 4 \
    1 "APACHE" \
    2 "MYSQL+PMA" \
    3 "MYSQL+PMA+GLPI" \
    4 "Grafana+Prometheus" \
    2>&1 >/dev/tty)
case $choix in
    1)
        dialog --msgbox "Lancement de la commande APACHE " 6 40
        apocker
        ;;
    2)
        dialog --msgbox "Lancement de la commande MYSQL+PMA " 6 40
        pma
        ;;
    3)
        dialog --msgbox "Lancement de la commande MYSQL+PMA+GLPI " 6 40
        glpi
        ;;
    4)
        dialog --msgbox "Lancement de la commande Grafana+Prometheus " 6 40
        grafeus
        ;;
    *)
        dialog --msgbox "Choix invalide. Veuillez réessayer." 6 40
        ;;
esac
clea
