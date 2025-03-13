#!/bin/bash
read -p "Port GRAFANA: " port_grafana
read -p "Port Prometheus: " port_prometheus
read -p "Nom du projet: " name

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
docker compose -f "docker-$name.yaml" up -d
