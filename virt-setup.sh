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
echo "Installing packages                              "
echo "-------------------------------------------------"
PKGS=(
  'virt-manager'
  'qemu'
  'qemu-arch-extra'
  'edk2-ovmf'
  'virtualbox'
  'docker'
  'docker-compose'
)

for PKG in "${PKGS[@]}"; do
  echo "Installing: ${PKG}"
  paru -S "$PKG" --noconfirm --needed
done

echo "-------------------------------------------------"
echo "Adding user (${USER}) to neccessary groups       "
echo "-------------------------------------------------"
sudo usermod -aG libvirt ${USER}
sudo usermod -aG docker ${USER}

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
