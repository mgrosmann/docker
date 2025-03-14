#!/bin/bash
port_grafana=$(dialog --inputbox "Entrez le port pour Grafana :" 8 50 2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    compose_aio
    exit
fi
port_prometheus=$(dialog --inputbox "Entrez le port pour Prometheus :" 8 50 2>&1 >/dev/tty)
name=$(dialog --inputbox "Entrez le nom du projet :" 8 50 2>&1 >/dev/tty)
cat <<EOF > docker-$name.yaml
services:
  grafana_$name:
    image: grafana/grafana
    container_name: grafana_$name
    ports:
      - "$port_grafana:3000"
    networks:
      - network_$name

  prometheus_$name:
    image: ubuntu/prometheus:2-24.04_stable
    container_name: prometheus_$name
    ports:
      - "$port_prometheus:9090"
    networks:
      - network_$name

networks:
  network_$name:
    driver: bridge
EOF
dialog --msgbox "Le fichier docker-$name.yaml a été créé avec succès !" 8 50
docker compose -f "docker-$name.yaml" up -d
dialog --msgbox "Les conteneurs Grafana et Prometheus pour le projet $name ont été démarrés avec succès !" 8 50
clear
