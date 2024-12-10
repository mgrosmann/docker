#!/bin/bash

read -p "Port MySQL: " port_sql
read -p "Port phpMyAdmin: " port_pma
read -p "Port GLPI: " port_glpi
read -p "Nom du projet: " name
read -p "Mot de passe du compte root: " root

cat <<EOF > docker-$name.yaml
services:
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

  glpi_$name:
    image: diouxx/glpi
    container_name: glpi_$name
    restart: always
    hostname: glpi
    ports:
      - "$port_glpi:80"
    environment:
      - TIMEZONE=Europe/Brussels
      - MYSQL_PASSWORD=glpi
      - MYSQL_DATABASE=glpi
      - MYSQL_USER=glpi
      - MYSQL_HOST=db_$name
    networks:
      - network_$name

networks:
  network_$name:
    driver: bridge
EOF

# Run Docker Compose
docker compose -f "docker-$name.yaml" up -d
