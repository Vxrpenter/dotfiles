#!/bin/bash

# Base Values
base_repo="https://codeberg.org/Vxrpenter/dotfiles"
tmp_location="/tmp/dotfiles-vxrpenter/"
delete_tmp=$1

# Defines if the dotfiles repository was already cloned
repo_location="$2"
dofiles_location=""
base_dotfile_location="/linux/dotfiles/"

# Download needed files
if [ "$repo_location" == "" ]; then
    git clone "$base_repo" "$tmp_location"
    repo_location="$tmp_location"
fi

dofiles_location="$dofiles_location$base_dotfile_location"

# Install base packages
sudo pacman --noconfirm -Sy fuzzel
sudo pacman --noconfirm -Sy mako
sudo pacman --noconfirm -Sy waybar
sudo pacman --noconfirm -Sy xdg-desktop-portal-gtk
sudo pacman --noconfirm -Sy xdg-desktop-portal-gnome
sudo pacman --noconfirm -Sy alacritty
sudo pacman --noconfirm -Sy swaybg
sudo pacman --noconfirm -Sy swayidle
sudo pacman --noconfirm -Sy swaylock
sudo pacman --noconfirm -Sy xwayland-satellite
sudo pacman --noconfirm -Sy udiskie

# Copy dotfiles to configs
cp -rf "$dofiles_location/.config/niri/" ~/.config/
cp -rf "$dofiles_location/.config/fuzzel/" ~/.config/
cp -rf "$dofiles_location/.config/mako/" ~/.config/

# Setup waybar
sudo pacman -Sy waybar --noconfirm
sudo pacman -Sy cava --noconfirm
yay -S --noconfirm --mflags --skipinteg waybar-niri-taskbar

git clone "https://github.com/calico32/waybar-niri-windows" "$tmp_location"
sudo pacman -Sy go --noconfirm
sudo pacman -S gtk3 --noconfirm
make $tmp_location/waybar-niri-windows/
cp -f waybar-niri-windows.so /usr/lib/waybar/

yay -S --noconfirm --mflags --skipinteg niri_window_buttons

cp -rf "$dofiles_location/.config/waybar/" ~/.config/

# Delete tmp location
if [ "$delete_tmp" == "0" ]; then
    rm -rf $tmp_location
fi
