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
read -p "Entrez le numéro de votre choix : " categorie

# Selon le choix de catégorie
if [ "$categorie" -eq 1 ]; then
    echo -e "\n${LIGHT_GREEN}Création/installation de conteneurs :${NC}"
    echo -e "  ${RED}1)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${BLUE}HTTPD${NC} ou en modifier un ${GREEN}existant${NC}"
    echo -e "  ${RED}2)${NC} Installer le ${GREEN}conteneur multi-service${NC} (${PINK}MySQL${NC}, ${GRAY}phpMyAdmin${NC}, ${ORANGE}FTP${NC}, ${LIGHT_BLUE}APACHE${NC})"
    echo -e "  ${RED}3)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${PINK}MySQL${NC} et ${GRAY}phpMyAdmin${NC}"
    echo -e "  ${RED}4)${NC} Installer un ${GREEN}conteneur${NC} (${PINK}MySQL${NC}, ${BLUE}HTTPD${NC}, ${GRAY}phpMyAdmin${NC}) en ${RED}session interactive${NC} ou ${ORANGE}détaché${NC}"
    read -p "Entrez le numéro de votre choix : " choix
    if [ "$choix" -eq 1 ]; then
        ct-httpd
    elif [ "$choix" -eq 2 ]; then
        ct-setup
    elif [ "$choix" -eq 3 ]; then
        pma
    elif [ "$choix" -eq 4 ]; then
        docker_aio
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
    read -p "Entrez le numéro de votre choix : " choix
    if [ "$choix" -eq 1 ]; then
        ct-connect
    elif [ "$choix" -eq 2 ]; then
        ct-start
    elif [ "$choix" -eq 3 ]; then
        ct-stop
    elif [ "$choix" -eq 4 ]; then
        ct-linux
    elif [ "$choix" -eq 5 ]; then
        network
    elif [ "$choix" -eq 6 ]; then
        remove
    else
        echo -e "${RED}Choix invalide dans cette catégorie.${NC}"
    fi
else
    echo -e "${RED}Choix de catégorie invalide. Veuillez réessayer.${NC}"
fi
