#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root (e.g., sudo ./install-de.sh)"
  exit 1
fi

echo "Updating package repository..."
pkg update

echo "Installing essential utilities..."
pkg install -y sudo nano vim bash wget curl

echo "Adding your user to the 'wheel' group for sudo access..."
read -p "Enter your username: " user_name
pw groupmod wheel -m "$user_name"

# Configure sudo for wheel group
echo "Enabling sudo for users in the wheel group..."
echo "%wheel ALL=(ALL) ALL" >> /usr/local/etc/sudoers

echo "Installing Xorg and Intel GPU drivers..."
pkg install -y xorg drm-kmod

# Enable Intel GPU driver
echo "Enabling Intel GPU driver (i915kms)..."
sysrc kld_list="/boot/modules/i915kms.ko"

# Enable system services
echo "Enabling and starting required services (dbus, hald)..."
sysrc dbus_enable="YES"
sysrc hald_enable="YES"
service dbus start
service hald start

echo "Installing XFCE and slim (login manager)..."
pkg install -y xfce slim
sysrc slim_enable="YES"

# Configure .xinitrc for XFCE
echo "Configuring XFCE startup for user $user_name..."
echo "exec startxfce4" > /home/"$user_name"/.xinitrc
chown "$user_name:$user_name" /home/"$user_name"/.xinitrc

echo "Installation complete. Please reboot your system."
