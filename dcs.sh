#!/bin/bash
DIALOG=${DIALOG=dialog}
categorie=$($DIALOG --clear --backtitle "Gestion Docker" \
    --title "Gestion centralisé Docker" \
    --menu "Veuillez choisir une catégorie :" 15 50 3 \
    1 "Création/installation de conteneurs" \
    2 "Gestion des conteneurs existants" \
    3 "Outils de gestion Docker" \
    2>&1 >/dev/tty)
clear
case $categorie in
    1)
        choix=$($DIALOG --clear --backtitle "Création/installation de conteneurs" \
            --title "Choisissez une action" \
            --menu "Veuillez choisir une option :" 15 50 5 \
            1 "Créer un conteneur avec fichier yaml" \
            2 "Installer un conteneur multi-service (MySQL, phpMyAdmin, FTP, Apache)" \
            3 "Installer un conteneur en session interactive ou détaché" \
            4 "Supprimer un conteneur" \
            5 "Supprimer une image Docker" \
            2>&1 >/dev/tty)
        clear
        case $choix in
            1) compose_aio ;;
            2) compose ;;
            3) docker_aio ;;
            4) container_id=$($DIALOG --inputbox "Entrez l'ID ou le nom du conteneur à supprimer :" 8 40 2>&1 >/dev/tty)
               confirm && docker rm -f $container_id ;;
            5) image_id=$($DIALOG --inputbox "Entrez l'ID ou le nom de l'image Docker à supprimer :" 8 40 2>&1 >/dev/tty)
               confirm && docker rmi $image_id ;;
        esac ;;
    2)
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
            2>&1 >/dev/tty)
        clear
        case $choix in
            1) ssh_ct ;;
            2) start ;;
            3) stop && docker ps -q | xargs -r docker stop ;;
            4) linux ;;
            5) network ;;
            6) remove ;;
            7) docker-compose up -d ;;
        esac ;;
    3)
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
        esac ;;
esac
