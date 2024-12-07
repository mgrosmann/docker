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
echo -e "${RED}1)${NC} Conteneur interactif"
echo -e "${RED}2)${NC} Conteneur détaché"

read -p "Entrez le numéro de votre choix : " categorie

if [ "$categorie" -eq 1 ]; then
    echo -e "\n${LIGHT_GREEN}Conteneur interactif :${NC}"
    echo -e "${LIGHT_GREEN}1)${NC} Apache HTTPD"
    echo -e "${LIGHT_GREEN}2)${NC} MySQL"
    echo -e "${LIGHT_GREEN}3)${NC} PhpMyAdmin"
    echo -e "${LIGHT_GREEN}4)${NC} SSH/SFTP"

    read -p "Entrez le numéro de votre choix : " choix_interactif

    if [ "$choix_interactif" -eq 1 ]; then
        echo -e "${LIGHT_GREEN}Apache HTTPD :${NC}"
        echo -e "  ${LIGHT_GREEN}1)${NC} Sans volume monté"
        echo -e "  ${LIGHT_GREEN}2)${NC} Avec volume monté"
        read -p "Entrez le numéro de votre choix : " choix_httpd
        if [ "$choix_httpd" -eq 1 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            docker container run -it -p $port:80 --name $name httpd
        elif [ "$choix_httpd" -eq 2 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            read -p "Entrez le nom du répertoire : " repertory
            docker container run -it -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
        else
            echo -e "${RED}Choix invalide pour HTTPD.${NC}"
        fi

    elif [ "$choix_interactif" -eq 2 ]; then
        echo -e "${LIGHT_GREEN}MySQL :${NC}"
        echo -e "  ${LIGHT_GREEN}1)${NC} Sans mot de passe"
        echo -e "  ${LIGHT_GREEN}2)${NC} Avec mot de passe"
        read -p "Entrez le numéro de votre choix : " choix_mysql
        if [ "$choix_mysql" -eq 1 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            docker container run -it -p $port:3306 --name $name mysql
        elif [ "$choix_mysql" -eq 2 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            read -p "Entrez le mot de passe root MySQL : " root_password
            docker container run -it -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
        else
            echo -e "${RED}Choix invalide pour MySQL.${NC}"
        fi

    elif [ "$choix_interactif" -eq 3 ]; then
        read -p "Entrez le port SQL à utiliser : " port_sql
        read -p "Entrez le port PhpMyAdmin à utiliser : " port_pma
        read -p "Entrez le mot de passe root MySQL : " mdp_root
        read -p "Entrez le nom du conteneur : " name
        docker network create network-$name
        docker run -d --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
        docker run -it --name pma_$name --network network-$name -e PMA_HOST=sql_$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_pma:80 phpmyadmin/phpmyadmin

    elif [ "$choix_interactif" -eq 4 ]; then
        read -p "Entrez le port SSH à utiliser : " port
        read -p "Entrez le nom du conteneur : " name
        read -p "Entrez le nom de l'utilisateur : " user
        read -p "Entrez le mot de passe : " password
        docker container run -it -p $port:22 --name $name rastasheep/ubuntu-sshd && \
        docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
    else
        echo -e "${RED}Choix invalide pour les conteneurs interactifs.${NC}"
    fi

elif [ "$categorie" -eq 2 ]; then
    echo -e "\n${LIGHT_GREEN}Conteneur détaché :${NC}"
    echo -e "${LIGHT_GREEN}1)${NC} Apache HTTPD"
    echo -e "${LIGHT_GREEN}2)${NC} MySQL"
    echo -e "${LIGHT_GREEN}3)${NC} PhpMyAdmin"
    echo -e "${LIGHT_GREEN}4)${NC} SSH/SFTP"

    read -p "Entrez le numéro de votre choix : " choix_detache

    if [ "$choix_detache" -eq 1 ]; then
        echo -e "${LIGHT_GREEN}Apache HTTPD :${NC}"
        echo -e "  ${LIGHT_GREEN}1)${NC} Sans volume monté"
        echo -e "  ${LIGHT_GREEN}2)${NC} Avec volume monté"
        read -p "Entrez le numéro de votre choix : " choix_httpd
        if [ "$choix_httpd" -eq 1 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            docker container run -d -p $port:80 --name $name httpd
        elif [ "$choix_httpd" -eq 2 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            read -p "Entrez le nom du répertoire : " repertory
            docker container run -d -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
        else
            echo -e "${RED}Choix invalide pour HTTPD.${NC}"
        fi

    elif [ "$choix_detache" -eq 2 ]; then
        echo -e "${LIGHT_GREEN}MySQL :${NC}"
        echo -e "  ${LIGHT_GREEN}1)${NC} Sans mot de passe"
        echo -e "  ${LIGHT_GREEN}2)${NC} Avec mot de passe"
        read -p "Entrez le numéro de votre choix : " choix_mysql
        if [ "$choix_mysql" -eq 1 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            docker container run -d -p $port:3306 --name $name mysql
        elif [ "$choix_mysql" -eq 2 ]; then
            read -p "Entrez le port à utiliser : " port
            read -p "Entrez le nom du conteneur : " name
            read -p "Entrez le mot de passe root MySQL : " root_password
            docker container run -d -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
        else
            echo -e "${RED}Choix invalide pour MySQL.${NC}"
        fi

    elif [ "$choix_detache" -eq 3 ]; then
        read -p "Entrez le port SQL à utiliser : " port_sql
        read -p "Entrez le port PhpMyAdmin à utiliser : " port_pma
        read -p "Entrez le mot de passe root MySQL : " mdp_root
        read -p "Entrez le nom du conteneur : " name
        docker network create network-$name
        docker run -d --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
        docker run -d --name pma_$name --network network-$name -e PMA_HOST=sql_$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_pma:80 phpmyadmin/phpmyadmin

    elif [ "$choix_detache" -eq 4 ]; then
        read -p "Entrez le port SSH à utiliser : " port
        read -p "Entrez le nom du conteneur : " name
        read -p "Entrez le nom de l'utilisateur : " user
        read -p "Entrez le mot de passe : " password
        docker container run -d -p $port:22 --name $name rastasheep/ubuntu-sshd && \
        docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
    else
        echo -e "${RED}Choix invalide pour les conteneurs détachés.${NC}"
    fi
else
    echo -e "${RED}Catégorie invalide.${NC}"
fi