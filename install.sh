#!/bin/bash
if [ -f /etc/debian_version ]; then
  OS="Debian"
elif [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
  if [ "$DISTRIB_ID" == "Ubuntu" ]; then
    OS="Ubuntu"
  fi
else
  echo "Ce script ne supporte que Debian et Ubuntu."
  exit 1
fi
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg
if [ "$OS" == "Debian" ]; then
  apt install sudo
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [ "$OS" == "Ubuntu" ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}
echo "Docker a été installé et configuré avec succès. Veuillez vous déconnecter et vous reconnecter pour appliquer les changements de groupe."
