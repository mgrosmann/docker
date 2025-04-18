#!/bin/bash
if ! command -v hw &> /dev/null; then
   if [ ! -f /root/bin/hw ]; then
       mkdir -p /root/bin
       echo "#!/bin/bash" > /root/bin/hw
       echo 'echo "hello world !!!" ' >> /root/bin/hw
       chmod +x /root/bin/*
   fi
   echo "export PATH=$PATH:/root/bin" >> /root/.bashrc
   source ~/.bashrc
   hello-world
else
    echo "le PATH est fonctionnel pour l'outil"
fi
if ! command -v docker &> /dev/null; then
    chmod +x docker.sh
    bash docker.sh
else
    echo "docker est déjà installé."
fi
if ! command -v dos2unix &> /dev/null; then
    apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
if ! command -v dialog &> /dev/null; then
    apt install -y dialog
else
    echo "dialog est déjà installé."
fi
rm Docker.sh
chmod +x *.sh
dos2unix *.sh
for script in *.sh
do
  mv "$script" "/root/bin/$(basename "$script" .sh)"
done
cd ..
rm -r docker
echo "lancer la commande 'dcs' pour lancer l'outil centralisé"
echo "réeffectuez un 'source ~/.bashrc'"
