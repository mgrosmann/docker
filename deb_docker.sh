#!/bin/bash

# Mettre Ã  jour le systÃ¨me
sudo apt-get update && sudo apt-get upgrade -y

# Installer les dÃ©pendances nÃ©cessaires
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Ajouter la clÃ© GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le dÃ©pÃ´t Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre Ã  jour les informations des dÃ©pÃ´ts
sudo apt-get update

# Installer Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# DÃ©marrer et activer Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajouter l'utilisateur actuel au groupe Docker
sudo usermod -aG docker ${USER}
sudo usermod -aG docker www-data

echo "Docker a Ã©tÃ© installÃ© et configurÃ© avec succÃ¨s. Veuillez vous dÃ©connecter et vous reconnecter pour appliquer les changements de groupe."
