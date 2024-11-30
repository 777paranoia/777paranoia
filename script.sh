#!/bin/sh

# Update system and install dependencies
echo "Updating FreeBSD and installing XFCE dependencies..."
pkg update -f
pkg upgrade -y

# Install XFCE and utilities
pkg install -y xorg xfce xfce4-goodies lightdm lightdm-gtk-greeter dbus

# Enable required services
echo "Enabling required services..."
sysrc dbus_enable="YES"
sysrc hald_enable="YES"
sysrc lightdm_enable="YES"

# Create .xinitrc for manual start if no display manager is used
echo "Creating .xinitrc file for XFCE..."
echo 'exec startxfce4' > ~/.xinitrc

# Configure lightdm greeter
echo "Configuring LightDM..."
sed -i '' 's/^#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /usr/local/etc/lightdm/lightdm.conf

# Start required services
echo "Starting dbus service..."
service dbus start

echo "Installation complete. Reboot your system to start XFCE."