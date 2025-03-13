#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
PINK='\033[1;35m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
BROWN='\033[0;33m'
GRAY='\033[1;30m'
NC='\033[0m'

echo -e "${LIGHT_GREEN}Veuillez choisir une catégorie :${NC}"
echo -e "${RED}1)${NC} APACHE" # apocker
echo -e "${RED}2)${NC} MYSQL+PMA" # pma
echo -e "${RED}3)${NC} MYSQL+PMA+GLPI" # glpi
echo -e "${RED}4)${NC} Grafana+Prometheus" # grafana et prometheus
read -p "Entrez le numéro de votre choix : " compose

if [ "$compose" -eq 1 ]; then
    apocker
elif [ "$compose" -eq 2 ]; then
    pma
elif [ "$compose" -eq 3 ]; then
    glpi
elif [ "$compose" -eq 4 ]; then
    nextcloud
elif [ "$compose" -eq 5 ]; then
    grafeus
else
    echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
fi
