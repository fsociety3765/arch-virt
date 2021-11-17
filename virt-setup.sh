#!/bin/bash

echo "-------------------------------------------------"
echo "Starting setup                                   "
echo "-------------------------------------------------"
ISO=$(curl -4 ifconfig.co/country-iso)

echo "-------------------------------------------------"
echo "Setting up the best mirrors for ${ISO}           "
echo "-------------------------------------------------"
sudo reflector -a 48 -c ${ISO} -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

echo "-------------------------------------------------"
echo "Installing virtualization packages               "
echo "-------------------------------------------------"
PKGS=(
  'virt-manager'
  'qemu'
  'qemu-arch-extra'
  'qemu-block-iscsi'
  'bridge-utils'
  'dnsmasq'
  'vde2'
  'openbsd-netcat'
  'iptables-nft'
  'edk2-ovmf'
  'virtualbox'
  'virtualbox-guest-iso'
  'virtualbox-ext-oracle'
  'docker'
  'docker-compose'
  'gnome-boxes'
  'dmidecode'
)

for PKG in "${PKGS[@]}"; do
  echo "Installing: ${PKG}"
  paru -S "$PKG" --needed
done

snap install multipass

echo "-------------------------------------------------"
echo "Adding user (${USER}) to neccessary groups       "
echo "-------------------------------------------------"
sudo usermod -aG libvirt ${USER}
sudo usermod -aG docker ${USER}
sudo usermod -aG vboxusers ${USER}

echo "-------------------------------------------------"
echo "Loading Virtualbox kernel modules                "
echo "-------------------------------------------------"
sudo modprobe vboxdrv vboxnetadp vboxnetflt

echo "-------------------------------------------------"
echo "Whitelisting Virtualbox with Wayland             "
echo "-------------------------------------------------"
gsettings set org.gnome.mutter.wayland xwayland-grab-access-rules "['VirtualBox Machine']"

echo "-------------------------------------------------"
echo "Starting services                                "
echo "-------------------------------------------------"
sudo systemctl enable --now libvirtd
sudo systemctl enable --now docker

echo "-------------------------------------------------"
echo "Installing Portainer & Watchtower                "
echo "-------------------------------------------------"
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sudo docker run -d --name watchtower --restart=always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

echo "-------------------------------------------------"
echo "Complete                                         "
echo "-------------------------------------------------"

