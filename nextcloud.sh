#!/bin/bash
port_nextcloud=$(dialog --inputbox "Entrez le port Nextcloud :" 8 50 2>&1 >/dev/tty)
name=$(dialog --inputbox "Entrez le nom du projet :" 8 50 2>&1 >/dev/tty)
root=$(dialog --inputbox "Entrez le mot de passe du compte root MySQL :" 8 50 2>&1 >/dev/tty)
port_sql=$(dialog --inputbox "Entrez le port SQL :" 8 50 2>&1 >/dev/tty)
port_pma=$(dialog --inputbox "Entrez le port phpMyAdmin :" 8 50 2>&1 >/dev/tty)
cat > docker-$name.yaml <<EOL
services:

  nextcloud_$name:
    image: nextcloud
    container_name: nextcloud_$name
    restart: always
    ports:
      - "$port_nextcloud:80"
    networks:
      - network_$name
      
  mysql_$name:
    image: mysql
    container_name: db_$name
    environment:
      MYSQL_ROOT_PASSWORD: $root
    ports:
      - "$port_sql:3306"
    networks:
      - network_$name

  phpmyadmin_$name:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin_$name
    environment:
      PMA_HOST: db_$name
      MYSQL_ROOT_PASSWORD: $root
    ports:
      - "$port_pma:80"
    networks:
      - network_$name  

networks:
  network_$name:
    driver: bridge
EOL

dialog --msgbox "Le fichier docker-$name.yaml a été créé avec succès !" 8 50

docker compose -f "docker-$name.yaml" up -d

dialog --msgbox "Les conteneurs Nextcloud, MySQL et phpMyAdmin pour le projet $name ont été démarrés avec succès !" 8 50
clear
