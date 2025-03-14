#!/bin/bash

choix_detache=$(dialog --clear --backtitle "Conteneur détaché" \
    --title "Options détachées" \
    --menu "Choisissez un service :" 15 50 9 \
    1 "Apache HTTPD" \
    2 "MySQL" \
    3 "PhpMyAdmin" \
    4 "SSH/SFTP" \
    5 "GLPI" \
    6 "Nextcloud" \
    7 "Prometheus" \
    8 "Grafana" \
    9 "Nginx" \
    2>&1 >/dev/tty)

if [ $? -ne 0 ]; then
    exit
fi

case $choix_detache in
1)
    choix_httpd=$(dialog --clear --backtitle "Apache HTTPD" \
        --title "Options HTTPD" \
        --menu "Choisissez une option :" 15 50 2 \
        1 "Sans volume monté" \
        2 "Avec volume monté" \
        2>&1 >/dev/tty)

    case $choix_httpd in
    1)
        port=$(dialog --inputbox "Entrez le port à utiliser pour Apache HTTPD :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur HTTPD :" 8 40 2>&1 >/dev/tty)
        docker container run -it -p $port:80 --name $name httpd
        ;;
    2)
        port=$(dialog --inputbox "Entrez le port à utiliser pour Apache HTTPD :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur HTTPD :" 8 40 2>&1 >/dev/tty)
        repertory=$(dialog --inputbox "Entrez le chemin du répertoire local à monter :" 8 40 2>&1 >/dev/tty)
        docker container run -it -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
        ;;
    esac
    ;;
2)
    choix_mysql=$(dialog --clear --backtitle "MySQL" \
        --title "Options MySQL" \
        --menu "Choisissez une option :" 15 50 2 \
        1 "Sans mot de passe" \
        2 "Avec mot de passe" \
        2>&1 >/dev/tty)

    case $choix_mysql in
    1)
        port=$(dialog --inputbox "Entrez le port à utiliser pour MySQL :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur MySQL :" 8 40 2>&1 >/dev/tty)
        docker container run -it -p $port:3306 --name $name mysql
        ;;
    2)
        port=$(dialog --inputbox "Entrez le port à utiliser pour MySQL :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur MySQL :" 8 40 2>&1 >/dev/tty)
        root_password=$(dialog --inputbox "Entrez le mot de passe root MySQL :" 8 40 2>&1 >/dev/tty)
        docker container run -it -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
        ;;
    esac
    ;;
3)
    port_sql=$(dialog --inputbox "Entrez le port SQL à utiliser :" 8 40 2>&1 >/dev/tty)
    port_pma=$(dialog --inputbox "Entrez le port PhpMyAdmin à utiliser :" 8 40 2>&1 >/dev/tty)
    mdp_root=$(dialog --inputbox "Entrez le mot de passe root MySQL :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur PhpMyAdmin :" 8 40 2>&1 >/dev/tty)
    docker network create network-$name
    docker run -it --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
    docker run -it --name pma_$name --network network-$name -e PMA_HOST=sql_$name -p $port_pma:80 phpmyadmin/phpmyadmin
    ;;
4)
    port=$(dialog --inputbox "Entrez le port SSH/SFTP à utiliser :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur SSH/SFTP :" 8 40 2>&1 >/dev/tty)
    user=$(dialog --inputbox "Entrez le nom de l'utilisateur :" 8 40 2>&1 >/dev/tty)
    password=$(dialog --inputbox "Entrez le mot de passe de l'utilisateur :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:22 --name $name rastasheep/ubuntu-sshd
    docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
    ;;
5)
    port=$(dialog --inputbox "Entrez le port pour GLPI :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur GLPI :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:80 --name $name diouxx/glpi:latest
    ;;
6)
    port=$(dialog --inputbox "Entrez le port pour Nextcloud :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur Nextcloud :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:80 --name $name nextcloud
    ;;
7)
    port=$(dialog --inputbox "Entrez le port pour Prometheus (par défaut 9090) :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur Prometheus :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:9090 --name $name ubuntu/prometheus:2-24.04_stable
    ;;
8)
    port=$(dialog --inputbox "Entrez le port pour Grafana (par défaut 3000) :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur Grafana :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:3000 --name $name grafana/grafana
    ;;
9)
   choix_nginx=$(dialog --clear --backtitle "Nginx" \
    --title "Options Nginx" \
    --menu "Choisissez une option :" 15 50 2 \
    1 "Sans volume monté" \
    2 "Avec volume monté" \
    2>&1 >/dev/tty)

case $choix_nginx in
1)
    port=$(dialog --inputbox "Entrez le port pour Nginx :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur Nginx :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:80 --name $name nginx
    ;;
2)
    port=$(dialog --inputbox "Entrez le port pour Nginx :" 8 40 2>&1 >/dev/tty)
    name=$(dialog --inputbox "Entrez le nom du conteneur Nginx :" 8 40 2>&1 >/dev/tty)
    repertory=$(dialog --inputbox "Entrez le chemin du répertoire local à monter pour Nginx :" 8 40 2>&1 >/dev/tty)
    docker container run -it -p $port:80 -v $repertory:/usr/share/nginx/html --name $name nginx
    ;;
esac
esac