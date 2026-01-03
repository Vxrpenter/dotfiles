#!/bin/bash

# Base Values
base_repo="https://codeberg.org/Vxrpenter/dotfiles"
tmp_location="/tmp/dotfiles-vxrpenter/"
delete_tmp=$1

# Defines if the dotfiles repository was already cloned
repo_location="$2"
dofiles_location=""
base_dotfile_location="/linux/dotfiles/"

# Defines the term setup
term_type=$2
shell_type=$3
fastfetch=$4

# Download needed files
if [ "$repo_location" == "" ]; then
    git clone "$base_repo" "$tmp_location"
    repo_location="$tmp_location"
fi

dofiles_location="$repo_location$base_dotfile_location"

# Install base packages and initiate configurations
case $term_type in
    alacritty )
        sudo pacman -Sy alacritty --noconfirm

        cp -rf "$dofiles_location/.config/alacritty/" ~/.config/
    ;;
    * )
        printf "No terminal option found..."
    ;;
esac

case $shell_type in
    zsh )
        sudo pacman -Sy zsh --noconfirm
        # Install oh-my-zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

        # Download plugins
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        # Copy dotfiles
        cp -rf "$dofiles_location/.zshrc" ~/
        sudo rm $userDir/.oh-my-zsh/themes/agnoster.zsh-theme
        cp -rf "$dofiles_location/.oh-my-zsh/" ~/

        # Set as default shell
        sudo chsh -s /bin/zsh $USER
    ;;
    fish )
        sudo pacman -Sy fish --noconfirm
    ;;
    * )
        printf "No shell option found..."
    ;;
esac

if [ "$fastfetch" == "0" ]; then
    # Install base package
    sudo pacman -Sy fastfetch --noconfirm

    # Install fonts
    sudo pacman -Sy noto-fonts --noconfirm
    sudo pacman -Sy noto-fonts-emoji --noconfirm
    sudo pacman -Sy ttf-cascadia-code-nerd --noconfirm

    cp -rf "$dofiles_location/.config/fastfetch" ~/.config/
fi

# Delete tmp location
if [ "$delete_tmp" == "0" ]; then
    rm -rf $tmp_location
fi
