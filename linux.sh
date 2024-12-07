#!/bin/bash
read -p "Sur quel conteneur voulez-vous appliquer des commandes Linux : " name
docker exec -it "$name" /bin/bash -c "apt-get update && apt-get install -y wget nano"
echo "Commandes Linux installées avec succès dans le conteneur $name"
