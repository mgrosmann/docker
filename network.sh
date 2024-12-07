#!/bin/bash
stopped_containers=$(docker ps -a -f "status=exited" -q)
for container in $stopped_containers; do
  networks=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}' $container)
  for network_id in $networks; do
    network_name=$(docker network inspect --format '{{.Name}}' "$network_id")
    if ! docker network ls --format '{{.Name}}' | grep -wq "$network_name"; then
      docker network create "$network_name"
    else
      echo "Le réseau '$network_name' existe déjà."
    fi
  done
done
echo "Vérification terminée."
