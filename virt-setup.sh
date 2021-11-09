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
echo "Installing desktop environment packages          "
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
