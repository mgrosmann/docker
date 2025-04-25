#!/bin/bash
choix=$(dialog --clear --backtitle "ipconfig" \
    --title "Menu Principal" \
    --menu "Quel type de configuration IP souhaitez-vous ?" 15 50 2 \
    1 "Statique" \
    2 "DHCP" \
    2>&1 >/dev/tty)
if [ "$choix" -eq 1 ]; then
    interface=$(dialog --inputbox "Entrez l'interface réseau à configurer :" 8 50 2>&1 >/dev/tty)
    ip=$(dialog --inputbox "Entrez l'adresse IP à affecter (format CIDR, ex: 192.168.1.1/24) :" 8 50 2>&1 >/dev/tty)
    gateway=$(dialog --inputbox "Entrez la passerelle par défaut :" 8 50 2>&1 >/dev/tty)
    dns=$(dialog --inputbox "Entrez le serveur DNS principal :" 8 50 2>&1 >/dev/tty)
    linux=$(dialog --clear --backtitle "Distribution Linux" \
        --title "Choix de la distribution Linux" \
        --menu "Quelle distribution Linux utilisez-vous ?" 15 50 2 \
        1 "Debian" \
        2 "Ubuntu" \
        2>&1 >/dev/tty)
    if [ "$linux" -eq 1 ]; then
        echo "  # Configuration réseau statique
  source /etc/network/interfaces.d/*
  
  auto lo
  iface lo inet loopback

  allow-hotplug $interface
  iface $interface inet static
      address $ip
      gateway $gateway
      dns-nameservers $dns" > /etc/network/interfaces
        systemctl restart networking.service
    else
        echo "network:
    version: 2
    ethernets:
      $interface:
        addresses:
          - $ip
        routes:
          - to: default
            via: $gateway
        nameservers:
          addresses:
            - $dns" > /etc/netplan/50-cloud-init.yaml
        apt install openvswitch-switch -y
        netplan apply
    fi
else
    interface=$(dialog --inputbox "Entrez l'interface réseau à configurer :" 8 50 2>&1 >/dev/tty)
    linux=$(dialog --clear --backtitle "Distribution Linux" \
        --title "Choix de la distribution Linux" \
        --menu "Quelle distribution Linux utilisez-vous ?" 15 50 2 \
        1 "Debian" \
        2 "Ubuntu" \
        2>&1 >/dev/tty)
    if [ "$linux" -eq 1 ]; then
        echo "# Configuration réseau DHCP
  source /etc/network/interfaces.d/*
  
  auto lo
  iface lo inet loopback

  allow-hotplug $interface
  iface $interface inet dhcp" > /etc/network/interfaces
        systemctl restart networking.service
    else
        echo "network:
    version: 2
    ethernets:
      $interface:
        dhcp4: true" > /etc/netplan/50-cloud-init.yaml
        apt install openvswitch-switch -y
        netplan apply
    fi
fi
echo "Configuration IP appliquée"
hostname -I
