# Arch-Virt
A bash script for Arch Linux to install packages for virtualization and containerization. 

## Prerequisites
1. Paru AUR Helper - https://aur.archlinux.org/packages/paru-bin

## Steps
1. Clone the git repo  
```git clone https://github.com/fsociety3765/arch-virt``` 
2. Move into the git repo and make all scripts executable  
```cd arch-virt/ && chmod +x *.sh```  
3. Run the `virt-setup.sh` script  
```./virt-setup.sh```  
4. Follow prompts until the setup is complete.

## NOTE
During the installation of VirtualBox you will be asked to choose a package to provide host modules. This will depend on the kernel you're running.
- for the `linux` kernel, choose `virtualbox-host-modules-arch`
- for any other kernel (including `linux-lts`), choose `virtualbox-host-dkms`  

To compile the VirtualBox modules provided by `virtualbox-host-dkms`, it will also be necessary to install the appropriate headers package(s) for your installed kernel(s) (e.g. `linux-lts-headers` for `linux-lts`). When either VirtualBox or the kernel is updated, the kernel modules will be automatically recompiled thanks to the DKMS Pacman hook.

See https://wiki.archlinux.org/title/VirtualBox for further information. 
