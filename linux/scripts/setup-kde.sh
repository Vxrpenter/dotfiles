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
sudo pacman -S plasma --noconfirm

# Remove packages
sudo pacman -R konsole --noconfirm
