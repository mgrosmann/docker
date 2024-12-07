#!/bin/bash
read -p "À quel conteneur voulez-vous accéder ? " container_name
docker container exec -it $container_name /bin/bash



