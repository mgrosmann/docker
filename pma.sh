#!/bin/bash
read -p "Port MySQL: " port_sql
read -p "Port phpMyAdmin: " port_pma
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

networks:
  network_$name:
EOF

docker-compose -f "docker-$name.yaml" up -d