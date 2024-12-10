#!/bin/bash
read -p "Enter the SQL port: " sql
mysql -u root -p -P$sql <<EOF
CREATE USER 'glpi'@'%' IDENTIFIED BY 'glpi';
CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'nextcloud';
CREATE DATABASE glpi;
CREATE DATABASE nextcloud;
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'%';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';
FLUSH PRIVILEGES;
EOF
