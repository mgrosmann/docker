#!/bin/bash
 detache=$(dialog --clear --backtitle "Conteneur detache" \
        --title "Options detache" \
        --menu "Choisissez un service :" 15 50 4 \
        1 "Apache HTTPD" \
        2 "MySQL" \
        3 "PhpMyAdmin" \
        4 "SSH/SFTP" \
        5 "glpi" \
        6 "nextcoud" \
        7 "prometheus" \
        8 "grafana" \
        9 "nginx" \
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
            port=$(dialog --inputbox "Entrez le port à utiliser :" 8 40 2>&1 >/dev/tty)
            name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
            docker container run -d -p $port:80 --name $name httpd
            ;;
        2)
            port=$(dialog --inputbox "Entrez le port à utiliser :" 8 40 2>&1 >/dev/tty)
            name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
            repertory=$(dialog --inputbox "Entrez le chemin du répertoire local à monter :" 8 40 2>&1 >/dev/tty)
            docker container run -d -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
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
            port=$(dialog --inputbox "Entrez le port à utiliser :" 8 40 2>&1 >/dev/tty)
            name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
            docker container run -d -p $port:3306 --name $name mysql
            ;;
        2)
            port=$(dialog --inputbox "Entrez le port à utiliser :" 8 40 2>&1 >/dev/tty)
            name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
            root_password=$(dialog --inputbox "Entrez le mot de passe root MySQL :" 8 40 2>&1 >/dev/tty)
            docker container run -d -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
            ;;
        esac
                ;;
    3)
        port_sql=$(dialog --inputbox "Entrez le port SQL à utiliser :" 8 40 2>&1 >/dev/tty)
        port_pma=$(dialog --inputbox "Entrez le port PhpMyAdmin à utiliser :" 8 40 2>&1 >/dev/tty)
        mdp_root=$(dialog --inputbox "Entrez le mot de passe root MySQL :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
        docker network create network-$name
        docker run -d --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
        docker run -d --name pma_$name --network network-$name -e PMA_HOST=sql_$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_pma:80 phpmyadmin/phpmyadmin
        ;;
    4)
        port=$(dialog --inputbox "Entrez le port SSH à utiliser :" 8 40 2>&1 >/dev/tty)
        name=$(dialog --inputbox "Entrez le nom du conteneur :" 8 40 2>&1 >/dev/tty)
        user=$(dialog --inputbox "Entrez le nom de l'utilisateur :" 8 40 2>&1 >/dev/tty)
        password=$(dialog --inputbox "Entrez le mot de passe de l'utilisateur :" 8 40 2>&1 >/dev/tty)
        docker container run -d -p $port:22 --name $name rastasheep/ubuntu-sshd
        docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
        ;;
    esac
    ;;
esac
