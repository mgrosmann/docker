#!/bin/bash
read -p "Voulez-vous créer un nouveau conteneur/site (1) ou associer un dossier existant (2) ? " choice
if [ "$choice" -eq 1 ]; then
  read -p "Entrez le nom du nouveau conteneur/site : " site_name
  read -p "Entrez le port pour le nouveau site : " site_port
  cat <<EOF >> compose_$site_name.yaml
services:
  $site_name:
    container_name: $site_name
    image: httpd
    ports:
      - "$site_port:80"
    networks:
      - "apache_network"
networks:
  apache_network:
EOF
  mkdir -p "docker_webfile/$site_name"
  echo "bienvenue sur $site_name situe sur le port $site_port" > "docker_webfile/$site_name/index.html"
  docker compose -f "compose_$site_name.yaml" up -d
  FILE_PATH="/usr/local/apache2/htdocs"
  docker exec "$site_name" rm -rf "$FILE_PATH"
  docker cp "docker_webfile/$site_name" "$site_name:/usr/local/apache2/htdocs"
elif [ "$choice" -eq 2 ]; then
  read -p "Entrez le repertoire du dossier a importer : " repertory_html
  read -p "Entrez le nom du conteneur sur lequel appliquer le code HTML importé : " site_name
    FILE_PATH="/usr/local/apache2/htdocs"
    docker exec "$site_name" rm -rf "$FILE_PATH"
    docker cp "$repertory_html" "$site_name:/usr/local/apache2/htdocs"
    echo "Dossier $repertory_html associé avec succès au site $site_name."
else
  echo "Choix incorrect, veuillez réessayer."
fi