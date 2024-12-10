#!/bin/bash
read -p "Port Nextcloud: " port_nextcloud
read -p "Nom du projet: " name
read -p "Mot de passe du compte root: " root

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

networks:
  network_$name:
    driver: bridge
EOL

docker compose -f "docker-$name.yaml" up -d
