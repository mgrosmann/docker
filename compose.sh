#!/bin/bash
DIALOG=${DIALOG=dialog}

# Demander les informations utilisateur via des boîtes de dialogue
db_password=$($DIALOG --clear --inputbox "Entrez le mot de passe root pour MySQL :" 8 40 2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    create
    exit
fi
mysql_user=$($DIALOG --clear --inputbox "Entrez le nom d'utilisateur pour MySQL :" 8 40 2>&1 >/dev/tty)
mysql_user_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur MySQL ($mysql_user) :" 8 40 2>&1 >/dev/tty)
ftp_user=$($DIALOG --clear --inputbox "Entrez le nom d'utilisateur FTP :" 8 40 2>&1 >/dev/tty)
ftp_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur FTP ($ftp_user) :" 8 40 2>&1 >/dev/tty)
sftp_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur SFTP ($ftp_user) :" 8 40 2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    echo "Action annulée."
    exit
fi
cat <<EOF > compose.yaml
services:

  db:
    container_name: db
    image: mysql
    ports:
      - "33306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: $db_password
      MYSQL_DATABASE: mysql_db
      MYSQL_USER: $mysql_user
      MYSQL_PASSWORD: $mysql_user_password
    networks:
      - "db_network"

  phpmyadmin:
    container_name: phpmyadmin
    image: phpmyadmin
    ports:
      - "9999:80"
    environment:
      HOST: mysql_db
      USERNAME: $mysql_user
      PASSWORD: $mysql_user_password
    depends_on:
      - "db"
    networks:
      - "db_network"
      
  apache:
    container_name: apache
    image: httpd
    ports:
      - "8000:80"
    networks:
      - "db_network"

  ftp:
    container_name: ftp
    image: fauria/vsftpd
    ports:
      - "7000:21"
      - "21100-21110:21100-21110"
    environment:
      FTP_USER: $ftp_user
      FTP_PASS: $ftp_password
    networks:
      - "db_network"

  sftp:
    container_name: sftp
    image: atmoz/sftp
    ports:
      - "2222:22"
    volumes:
      - ./data:/home/$ftp_user
    environment:
      SFTP_USERS: "$ftp_user:$sftp_password:::uploads"
    networks:
      - "db_network"

networks:
  db_network:
EOF
docker compose up -d
