#!/bin/bash
read -p "Port Nextcloud: " port_nextcloud
read -p "Nom du projet: " name
read -p "Mot de passe du compte root: " root
read -p "port sql: " port_sql
read -p "port pma: " port_pma

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
docker compose -f "docker-$name.yaml" up -d
