#!/bin/bash
read -p "Port GLPI: " port_glpi
read -p "Nom du projet: " name
read -p "Mot de passe du compte root: " root

cat > docker-$name.yaml <<EOL
services:
  glpi_$name:
    image: diouxx/glpi:latest
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
