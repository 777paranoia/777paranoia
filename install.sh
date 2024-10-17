#!/bin/bash

# Set up the basic environment
echo "Setting up Arch Linux..."

# Set time zone
ln -sf /usr/share/zoneinfo/CST/Chicago /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG=en_US.UTF-8

# Set up hostname
echo "arch" > /etc/hostname

# Create hosts file
cat <<EOL > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOL

# Network configuration
systemctl enable NetworkManager

# Create user and set password
useradd -m -G wheel -s /bin/zsh your_username
echo "unix666:117x" | chpasswd

# Grant sudo privileges
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Enable essential services
systemctl enable dhcpcd.service

# Install base packages
pacman -Syu --noconfirm \
  base-devel \
  linux-headers \
  vim \
  git \
  zsh \
  networkmanager \
  grub \
  os-prober

# Install GRUB and configure boot loader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Finalize the script
echo "Basic Arch Linux installation completed."
echo "You can now reboot into your new system!"
