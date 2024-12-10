#!/bin/bash
read -p "Port MySQL: " port_sql
read -p "Port phpMyAdmin: " port_pma
read -p "Port GLPI: " port_glpi
read -p "Nom du projet: " name
read -p "Mot de passe du compte root: " root

cat > docker-$name.yaml <<EOL
services:
  mysql_$name:
    image: mysql
    container_name: db_$name
    environment:
      MYSQL_ROOT_PASSWORD: $root
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: nextcloud
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
    image: elestio/glpi:latest
    container_name: glpi_$name
    restart: always
    hostname: glpi
    ports:
      - "$port_glpi:80"
    environment:
      - TIMEZONE=Europe/Brussels
    networks:
      - network_$name

networks:
  network_$name:
    driver: bridge
EOL

docker compose -f "docker-$name.yaml" up -d

# Initialiser les privilèges de la base de données pour Nextcloud
sleep 20 # Attendre que les conteneurs soient complètement démarrés

docker exec -i db_$name mysql -u root -p$root <<EOF
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'%';
FLUSH PRIVILEGES;
EXIT;
EOF
