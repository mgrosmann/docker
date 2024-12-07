#!/bin/bash
cat <<EOF > compose.yaml
services:

  db:
    container_name: db
    image: mysql
    ports:
      - "33306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mysql_db
      MYSQL_USER: mgrosmann
      MYSQL_PASSWORD: password
    networks:
      - "db_network"

  phpmyadmin:
    container_name: phpmyadmin
    image: phpmyadmin
    ports:
      - "9999:80"
    environment:
      HOST: mysql_db
      USERNAME: mgrosmann
      PASSWORD: password
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
      FTP_USER: mgrosmann
      FTP_PASS: password
    networks:
      - "db_network"

  sftp:
    container_name: sftp
    image: atmoz/sftp
    ports:
      - "2222:22"
    volumes:
      - ./data:/home/mgrosmann
    environment:
      SFTP_USERS: "mgrosmann:password:::uploads"
    networks:
      - "db_network"

networks:
  db_network:
EOF

docker compose up -d
