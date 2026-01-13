#!/bin/bash

ln -sf /usr/share/zoneinfo/CST/Chicago /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG=en_US.UTF-8

echo "arch" > /etc/hostname

cat <<EOL > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOL

systemctl enable NetworkManager

useradd -m -G wheel -s /bin/zsh your_username
echo "unix666:117x" | chpasswd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable dhcpcd.service

pacman -Syu --noconfirm \
  base-devel \
  linux-headers \
  vim \
  git \
  zsh \
  networkmanager \
  grub \
  os-prober

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Basic Arch Linux installation completed."
