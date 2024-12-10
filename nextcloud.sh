#!/bin/bash
read -p "Port MySQL: " port_sql
read -p "Port phpMyAdmin: " port_pma
read -p "Port Nextcloud: " port_nextcloud
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

  nextcloud_$name:
    image: nextcloud
    container_name: nextcloud_$name
    restart: always
    ports:
      - "$port_nextcloud:80"
    environment:
      - MYSQL_PASSWORD=nextcloud
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db_$name
    networks:
      - network_$name

networks:
  network_$name:
    driver: bridge
EOL

docker compose -f "docker-$name.yaml" up -d

sleep 20 

docker exec -i db_$name mysql -u root -p$root <<EOF
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';
FLUSH PRIVILEGES;
EXIT;
EOF
