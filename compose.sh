#!/bin/bash
DIALOG=${DIALOG=dialog}
name=$($DIALOG --clear --inputbox "Entrez le nom du container :" 8 40 2>&1 >/dev/tty)
if [ $? -ne 0 ]; then
    create
    exit
fi
db_password=$($DIALOG --clear --inputbox "Entrez le mot de passe root pour MySQL :" 8 40 2>&1 >/dev/tty)
mysql_user=$($DIALOG --clear --inputbox "Entrez le nom d'utilisateur pour MySQL :" 8 40 2>&1 >/dev/tty)
mysql_user_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur MySQL ($mysql_user) :" 8 40 2>&1 >/dev/tty)
db_port=$($DIALOG --clear --inputbox "Entrez le port externe pour MySQL (par exemple : 33306) :" 8 40 2>&1 >/dev/tty)
ftp_user=$($DIALOG --clear --inputbox "Entrez le nom d'utilisateur FTP :" 8 40 2>&1 >/dev/tty)
ftp_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur FTP ($ftp_user) :" 8 40 2>&1 >/dev/tty)
ftp_port=$($DIALOG --clear --inputbox "Entrez le port externe pour FTP (par exemple : 7000) :" 8 40 2>&1 >/dev/tty)
ftp_passive_ports=$($DIALOG --clear --inputbox "Entrez la plage de ports passive pour FTP (par exemple : 21100-21110) :" 8 40 2>&1 >/dev/tty)
sftp_password=$($DIALOG --clear --inputbox "Entrez le mot de passe pour l'utilisateur SFTP ($ftp_user) :" 8 40 2>&1 >/dev/tty)
sftp_port=$($DIALOG --clear --inputbox "Entrez le port externe pour SFTP (par exemple : 2222) :" 8 40 2>&1 >/dev/tty)
phpmyadmin_port=$($DIALOG --clear --inputbox "Entrez le port externe pour phpMyAdmin (par exemple : 9999) :" 8 40 2>&1 >/dev/tty)
apache_port=$($DIALOG --clear --inputbox "Entrez le port externe pour Apache (par exemple : 8000) :" 8 40 2>&1 >/dev/tty)
cat <<EOF > compose.yaml
services:

  db:
    container_name: db_$name
    image: mysql
    ports:
      - "$db_port:3306"
    environment:
      MYSQL_ROOT_PASSWORD: $db_password
      MYSQL_DATABASE: mysql_db
      MYSQL_USER: $mysql_user
      MYSQL_PASSWORD: $mysql_user_password
    networks:
      - "db_network_$name"

  phpmyadmin:
    container_name: phpmyadmin_$name
    image: phpmyadmin
    ports:
      - "$phpmyadmin_port:80"
    environment:
      HOST: mysql_db
      USERNAME: $mysql_user
      PASSWORD: $mysql_user_password
    depends_on:
      - "db_$name"
    networks:
      - "db_network_$name"
      
  apache:
    container_name: apache_$name
    image: httpd
    ports:
      - "$apache_port:80"
    networks:
      - "db_network_$name"

  ftp:
    container_name: ftp_$name
    image: fauria/vsftpd
    ports:
      - "$ftp_port:21"
      - "$ftp_passive_ports:$ftp_passive_ports"
    environment:
      FTP_USER: $ftp_user
      FTP_PASS: $ftp_password
    networks:
      - "db_network_$name"

  sftp:
    container_name: sftp_$name
    image: atmoz/sftp
    ports:
      - "$sftp_port:22"
    volumes:
      - ./data:/home/$ftp_user
    environment:
      SFTP_USERS: "$ftp_user:$sftp_password:::uploads"
    networks:
      - "db_network_$name"

networks:
  db_network_$name:
EOF
docker compose up -d
