#!/bin/bash

# Base Values
base_repo="https://codeberg.org/Vxrpenter/dotfiles"
tmp_location="/tmp/dotfiles-vxrpenter/"
repo_location=""

# Root Check
if [ "$UID" -ne "0" ]; then
    echo "This script needs to be run as root"
    exit 9
fi

# Logo
prompt_logo() {
    clear
}
prompt_logo

# Basic Functions
confirm() {
    if [ "$2" == ""  ] || [ "$2" == 0 ]; then
        printf ":: $1? [Y/n] "
        option=0
    elif [ "$2" == 1 ]; then
        printf ":: $1? [y/N] "
        option=1
    fi

    read -rp "" response
    case $response in
        [Yy]* ) return 0 ;;
        [Nn]* ) return 1 ;;
        * )
            if [ "$option" == "0" ]; then return 0
            else return 1; fi
        ;;
    esac
}

# DE selection
printf "What type DE would you like to install/configure?\n"
PS3=":: Enter number of the DE: "
select option in KDE niri None
do
    DEOptions=$option
    break
done

case $DEOptions in
    KDE ) DE="kde" ;;
    niri ) DE="niri" ;;
esac
prompt_logo

# Terminal selection
printf "What type terminal would you like to install?\n"
PS3=":: Enter number of the terminal: "
select option in Alacritty None
do
    terminalOptions=$option
    break
done

case $terminalOptions in
    Alacritty ) terminal="alacritty" ;;
esac
prompt_logo

# Shell selection
printf "What type shell would you like to install?\n"
PS3=":: Enter number of the shell: "
select option in Zsh Fish None
do
    shellOptions=$option
    break
done

case $shellOptions in
    Zsh ) terminal="zsh" ;;
    Fish ) shell="fish" ;;
esac

# Fastfetch selection
confirm "Would you like to install fastfetch"
if [ "$?" == "0" ]; then fastfetch=0; fi
prompt_logo

# Discord client selection
printf "What type of discord client would you like to install?\n"
PS3=":: Enter number of the discord client: "
select option in Vesktop Discord None
do
    dicordClientOption=$option
    break
done

case $dicordClientOption in
    Vesktop ) discord="vesktop" ;;
    Discord ) discord="discord" ;;
esac
prompt_logo

# Browser Selection
printf "What type of browser would you like to install?\n"
PS3=":: Enter number of the browser "
select option in Firefox Librewolf Chromium None
do
    browserOption=$option
    break
done

case $browserOption in
    Firefox ) browser="firefox" ;;
    Librewolf ) browser="librewolf" ;;
    Chromium ) browser="chromium" ;;
esac
prompt_logo

# Code Software installation
confirm "Would you like to install vscodium" 1
if [ "$?" == "0" ]; then code_vscodium=0; fi
confirm "Would you like to install kate" 1
if [ "$?" == "0" ]; then code_kate=0; fi
confirm "Would you like to install jetbrains-toolbox" 1
if [ "$?" == "0" ]; then code_jetbrains_toolbox=0; fi
prompt_logo

# Steam installation
confirm "Would you like to install steam"
if [ "$?" == "0" ]; then steam=0; fi
prompt_logo

# Define git data (username and email)
confirm "Would you like to configure git data (username & email)"
if  [ "$?" == "0" ]; then
    confirm "Would you like to set the git username"
    if [ "$?" == "0" ]; then
        read -rp ":: Please enter your desired git username: " git_username
    fi

    confirm "Would you like to set the git email"
    if [ "$?" == "0" ]; then
        read -rp ":: Please enter your desired git email " git_email
    fi

    confirm "Would you like to set the git signkey"
    if [ "$?" == "0" ]; then
        read -rp ":: Please enter your desired git signkey (gpg) " git_signKey

        confirm "Set up signing"
        if [ "$?" == "0" ]; then git_signing=0; fi
    fi
fi
prompt_logo

# Last resort
confirm "Do you want to write the data (last resort)"
if [ "$?" == 1 ]; then exit 1; fi

# Update all packages
sudo pacman -Syu --noconfirm

# Install yay for AUR packages
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Check discord client installation
case $discord in
    vesktop ) yay -S --noconfirm --mflags --skipinteg vesktop-bin ;;
    discord ) sudo pacman -Sy discord --noconfirm ;;
esac

# Browser installation
case $browser in
    firefox ) sudo pacman -Sy firefox --noconfirm ;;
    librewolf ) yay -S --noconfirm --mflags --skipinteg librewolf-bin ;;
    chromium ) sudo pacman -Sy chromium  --noconfirm ;;
esac


# Code installation
if [ "$code_vscodium" == "0" ]; then yay -S --noconfirm --mflags --skipinteg vscodium-bin; fi
if [ "$code_kate" == "0" ]; then sudo pacman -Sy kate --noconfirm; fi
if [ "$git_username" == "0" ]; then yay -S --noconfirm --mflags --skipinteg jetbrains-toolbox; fi

# Steam installation
if [ "$steam" == "0" ]; then
    # Enable multilib repository
    sudo sed -i -e 's/#[multilib]/[multilib]/g' /etc/pacman.conf
    sudo sed -i -e 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf
    sudo pacman -Syyu

    sudo pacman -Sy steam --noconfirm
fi

# Set git data
if [ ! "$git_username" == "" ]; then git config --global user.name $git_username; fi
if [ ! "$git_username" == "" ]; then git config --global user.email $git_email; fi
if [ ! "$code_jetbrains_toolbox" == "" ]; then git config --global user.signingkey $git_signkey; fi

if [ "$git_signing" == "0" ]; then
    git config --global commit.gpgsign true
    git config --global gpg.program gpg

    # To prevent possible bugs
    [ -f ~/.bashrc ] && echo -e '\nexport GPG_TTY=$(tty)' >> ~/.bashrc
fi

# General Packages
sudo pacman -Sy bat --noconfirm

# Setup dotfiles repository
cd scripts
if [ "$?" == "0" ]; then
    cd ..
    cd ..
    repo_location="$PWD" > /dev/null 2>&1;
    cd -
else
    rm -rf $tmp_location
    git clone $base_repo $tmp_location
    repo_location="$tmp_location/dotfiles/"
fi

# Setup DE
if [ ! "$DE" == "" ]; then
    case $DE in
        kde )
            kde_install_script_location="$repo_location/linux/scripts/setup-kde.sh"
            chmod +x $kde_install_script_location
            bash $kde_install_script_location 1 $repo_location
        ;;
        niri )
            niri_install_script_location="$repo_location/linux/scripts/setup-niri.sh"
            chmod +x $niri_install_script_location
            bash $niri_install_script_location 1 $repo_location
        ;;
    esac
fi

# Install term and shell
if [ ! "$terminal" == "" ]; then
    term_install_script_location="$repo_location/linux/scripts/setup-term.sh"

    chmod +x $term_install_script_location
    bash $term_install_script_location 1 $repo_location $terminal $shell $fastfetch
fi
