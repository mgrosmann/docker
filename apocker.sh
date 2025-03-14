#!/bin/bash
choix=$(dialog --clear --backtitle "Gestion des sites et conteneurs Docker" \
    --title "Menu Principal" \
    --menu "Voulez-vous créer un nouveau conteneur/site ou associer un dossier existant ?" 15 50 2 \
    1 "Créer un nouveau conteneur/site" \
    2 "Associer un dossier existant" \
    2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    compose_aio
    exit
fi
    
if [ "$choix" -eq 1 ]; then
    site_name=$(dialog --inputbox "Entrez le nom du nouveau conteneur/site :" 8 50 2>&1 >/dev/tty)
    site_port=$(dialog --inputbox "Entrez le port pour le nouveau site :" 8 50 2>&1 >/dev/tty)

    cat <<EOF > compose_$site_name.yaml
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
    dialog --msgbox "Le nouveau conteneur/site $site_name a été créé et configuré avec succès sur le port $site_port." 8 50

elif [ "$choix" -eq 2 ]; then
    repertory_html=$(dialog --inputbox "Entrez le répertoire du dossier à importer :" 8 50 2>&1 >/dev/tty)
    site_name=$(dialog --inputbox "Entrez le nom du conteneur à associer au dossier importé :" 8 50 2>&1 >/dev/tty)
    FILE_PATH="/usr/local/apache2/htdocs"
    docker exec "$site_name" rm -rf "$FILE_PATH"
    docker cp "$repertory_html" "$site_name:/usr/local/apache2/htdocs"
    dialog --msgbox "Le dossier $repertory_html a été associé avec succès au site $site_name." 8 50

else
    dialog --msgbox "Choix incorrect. Veuillez réessayer." 8 50
fi

clear
