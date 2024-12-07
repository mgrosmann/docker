#!/bin/bash

# Mettre à jour le système
sudo apt-get update && sudo apt-get upgrade -y

# Installer les dépendances nécessaires
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajouter le dépôt Docker
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Installer Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Démarrer et activer Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajouter l'utilisateur actuel au groupe Docker
sudo usermod -aG docker ${USER}

echo "Docker a été installé et configuré avec succès. Veuillez vous déconnecter et vous reconnecter pour appliquer les changements de groupe."
