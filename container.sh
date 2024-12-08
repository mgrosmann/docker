#!/bin/bash

# Couleurs pour la mise en forme
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PINK='\033[1;35m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
GRAY='\033[1;30m'
ORANGE='\033[0;33m'
NC='\033[0m'

# Menu principal : Choix de la catégorie
echo -e "${LIGHT_GREEN}Veuillez choisir une catégorie :${NC}"
echo -e "${RED}1)${NC} Création/installation de conteneurs"
echo -e "${RED}2)${NC} Gestion des conteneurs existants"
echo -e "${RED}3)${NC} Outils de gestion Docker"
echo -e "Vous pouvez egalement vous rendre sur l'${RED}interface web${NC} au port ${RED}9999${NC}"
read -p "Entrez le numéro de votre choix : " categorie

# Selon le choix de catégorie
if [ "$categorie" -eq 1 ]; then 
    echo -e " ${LIGHT_GREEN}Création/installation de conteneurs :${NC}" 
    echo -e " ${RED}1)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${BLUE}HTTPD${NC} ou en modifier un ${GREEN}existant${NC}" 
    echo -e " ${RED}2)${NC} Installer le ${GREEN}conteneur multi-service${NC} (${PINK}MySQL${NC}, ${GRAY}phpMyAdmin${NC}, ${ORANGE}FTP${NC}, ${LIGHT_BLUE}APACHE${NC})" 
    echo -e " ${RED}3)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${PINK}MySQL${NC} et ${GRAY}phpMyAdmin${NC}" 
    echo -e " ${RED}4)${NC} Installer un ${GREEN}conteneur${NC} (${PINK}MySQL${NC}, ${BLUE}HTTPD${NC}, ${GRAY}phpMyAdmin${NC}) en ${RED}session interactive${NC} ou ${ORANGE}détaché${NC}" 
    echo -e " ${RED}5)${NC} Supprimer un ${GREEN}conteneur${NC}" 
    echo -e " ${RED}6)${NC} Supprimer une ${GREEN}image Docker${NC}" read -p "Entrez le numéro de votre choix : " choix
    if [ "$choix" -eq 1 ]; then
        apocker
    elif [ "$choix" -eq 2 ]; then
        compose
    elif [ "$choix" -eq 3 ]; then
        pma
    elif [ "$choix" -eq 4 ]; then
        docker_aio
    elif [ "$choix" -eq 5 ]; then
        read -p "Entrez l'ID ou le nom du conteneur à supprimer : " container_id
        confirm
        docker rm -f $container_id
    elif [ "$choix" -eq 6 ]; then
        read -p "Entrez l'ID ou le nom de l'image Docker à supprimer : " image_id
        confirm
        docker rmi $image_id
    else
        echo -e "${RED}Choix invalide dans cette catégorie.${NC}"
    fi

elif [ "$categorie" -eq 2 ]; then
    echo -e "\n${LIGHT_GREEN}Gestion des conteneurs existants :${NC}"
    echo -e "  ${RED}1)${NC} Se connecter à un ${GREEN}conteneur${NC}"
    echo -e "  ${RED}2)${NC} Démarrer tous les ${GREEN}conteneurs${NC}"
    echo -e "  ${RED}3)${NC} Arrêter tous les ${GREEN}conteneurs${NC}"
    echo -e "  ${RED}4)${NC} Installer ${BLUE}nano${NC} et ${YELLOW}wget${NC} sur un ${GREEN}conteneur${NC}"
    echo -e "  ${RED}5)${NC} Vérifier et recréer les ${GREEN}réseaux Docker manquants${NC} pour les conteneurs arrêtés"
    echo -e "  ${RED}6)${NC} Supprimer tous les ${GREEN}conteneurs arrêtés${NC}"
    echo -e "  ${RED}7)${NC} Recréer les ${GREEN}conteneurs arrêtés${NC} basés sur le fichier de configuration"
    read -p "Entrez le numéro de votre choix : " choix
    if [ "$choix" -eq 1 ]; then
        read -p "À quel conteneur voulez-vous accéder ? " container_name
        docker container exec -it $container_name /bin/bash
    elif [ "$choix" -eq 2 ]; then
        for file in *.yaml
        do
          docker compose -f $file start ;
        done
        docker ps -q | xargs -r docker start
    elif [ "$choix" -eq 3 ]; then
        for file in *.yaml
        do
          docker compose -f $file stop ;
        done
        docker ps -q | xargs -r docker stop
    elif [ "$choix" -eq 4 ]; then
        read -p "Sur quel conteneur voulez-vous appliquer des commandes Linux : " name
        docker exec -it "$name" /bin/bash -c "apt-get update && apt-get install -y wget nano"
        echo "Commandes Linux installées avec succès dans le conteneur $name"
    elif [ "$choix" -eq 5 ]; then
        network
    elif [ "$choix" -eq 6 ]; then
        docker container prune -f
    elif [ "$choix" -eq 7 ]; then
        docker-compose up -d
    else
        echo -e "${RED}Choix invalide dans cette catégorie.${NC}"
    fi

elif [ "$categorie" -eq 3 ]; then
    echo -e "\n${LIGHT_GREEN}Outils de gestion Docker :${NC}"
    echo -e "  ${RED}1)${NC} Afficher les ${GREEN}logs${NC} d'un conteneur"
    echo -e "  ${RED}2)${NC} Lister tous les ${GREEN}volumes${NC}"
    echo -e "  ${RED}3)${NC} Lister toutes les ${GREEN}images${NC}"
    echo -e "  ${RED}4)${NC} Lister tous les ${GREEN}conteneurs${NC}"
    echo -e "  ${RED}5)${NC} Afficher les ${GREEN}statistiques Docker${NC}"
    echo -e "  ${RED}6)${NC} Inspecter un ${GREEN}conteneur${NC}"
    echo -e "  ${RED}7)${NC} Sauvegarder et restaurer un ${GREEN}conteneur${NC}"
    read -p "Entrez le numéro de votre choix : " choix
    if [ "$choix" -eq 1 ]; then
        read -p "Entrez l'ID ou le nom du conteneur : " container_id
        docker logs $container_id
    elif [ "$choix" -eq 2 ]; then
        docker volume ls
    elif [ "$choix" -eq 3 ]; then
        docker images
    elif [ "$choix" -eq 4 ]; then
        docker ps -a
    elif [ "$choix" -eq 5 ]; then
        docker stats
    elif [ "$choix" -eq 6 ]; then
        read -p "Entrez l'ID ou le nom du conteneur : " container_id
        docker inspect $container_id
    elif [ "$choix" -eq 7 ]; then
        echo -e "${LIGHT_GREEN}1) Sauvegarder un conteneur"
        echo -e "2) Restaurer un conteneur${NC}"
        read -p "Entrez le numéro de votre choix : " sub_choix
        if [ "$sub_choix" -eq 1 ]; then
            read -p "Entrez l'ID ou le nom du conteneur : " container_id
            docker commit $container_id ${container_id}_backup
            docker save -o ${container_id}_backup.tar ${container_id}_backup
        elif [ "$sub_choix" -eq 2 ]; then
            read -p "Entrez le chemin du fichier de sauvegarde : " backup_path
            docker load -i $backup_path
        else
            echo -e "${RED}Choix invalide.${NC}"
        fi
    else
        echo -e "${RED}Choix invalide dans cette catégorie.${NC}"
    fi
else
    echo -e "${RED}Choix de catégorie invalide. Veuillez réessayer.${NC}"
fi
