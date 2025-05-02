export userDir="/home/$USER"

# Discord
export discord_discord=false
export discord_vesktop=false

# Browser
export browser_firefox=false
export browser_librewolf=false
export browser_chromium=false

# Code
export code_vscodium=false
export code_kate=false
export code_jetbrains_toolbox=false

# Gaming
export steam=false

# Root Check
if [ "$UID" -ne "0" ]; then
    echo "This script needs to be run as root"
    exit 9
fi

# Basic Functions
function confirm() {
  read -rp ":: $1? [Y/n] " response
  case $response in
    [Yy]* )
        return 0
    ;;
    [Nn]* )
        return 1
    ;;
    * )
        return 0
  esac
}


# Discord client selection
function discordClient() {
    echo "What type of discord client would you like to install?"
    PS3=":: Enter number of the discord client: "
    select option in Vesktop Discord None
    do
        dicordClientOption=$option
        break
    done

    case $dicordClientOption in
        Vesktop )
            discord_vesktop=true
        ;;
        Discord )
            discord_discord=true
        ;;

    esac
}
echo ""
discordClient


# Browser Selection
function browser() {
    echo "What type of browser would you like to install?"
    PS3=":: Enter number of the browser "
    select option in Firefox Librewolf Chromium None
    do
        browserOption=$option
        break
    done

    case $browserOption in
        Firefox )
            browser_firefox=true
        ;;
        Librewolf )
            browser_librewolf=true
        ;;
        Chromium )
            browser_chromium=true
        ;;
    esac
}
echo ""
browser


# Code Software installation
function codeSoftware() {
    confirm "Would you like to install vscodium"
    if [ $? == 0 ]; then code_vscodium=true; fi
    echo $code_vscodium

    confirm "Would you like to install kate"
    if [ $? == 0 ]; then code_kate=true; fi
    echo $code_kate

    confirm "Would you like to install jetbrains-toolbox"
    if [ $? == 0 ]; then code_jetbrains_toolbox=true; fi
    echo $code_jetbrains_toolbox
}
echo ""
codeSoftware

# Steam client installation
function steam() {
    confirm "Would you like to install steam"
    if  [ $? == 0 ]; then steam=true; fi
}
echo ""
steam

# Update all packages
sudo pacman -Syu --noconfirm

# Install yay for AUR packages
sudo sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si


# Check discord client installation
if [ discord_vesktop ]; then yay -S --noconfirm --mflags --skipinteg vesktop-bin; fi

if [ discord_discord ]; then sudo pacman -Sy discord --noconfirm; fi


# Browser installation
if [ browser_firefox ]; then sudo pacman -Sy firefox --noconfirm; fi

if [ browser_librewolf ]; then yay -S --noconfirm --mflags --skipinteg librewolf-bin; fi

if [ browser_chromium ]; then sudo pacman -Sy chromium  --noconfirm; fi


# Code installation
if [ code_vscodium ]; then yay -S --noconfirm --mflags --skipinteg vscodium-bin; fi

if [ code_kate ]; then sudo pacman -Sy kate --noconfirm;

if [ code_jetbrains_toolbox ]; then yay -S --noconfirm --mflags --skipinteg jetbrains-toolbox; fi


# Steam installation
if [ steam ]; then
    # Enable multilib repository
    sudo sed -i -e 's/#[multilib]/[multilib]/g' /etc/pacman.conf
    sudo sed -i -e 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf
    sudo pacman -Syyu

    sudo pacman -Sy steam --noconfirm
fi

# ZSH Shell Setup
sudo pacman -Sy zsh --noconfirm

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

rm $userDir/.zshrc
curl -L https://raw.githubusercontent.com/Vxrpenter/dotfiles/main/linux/zsh/.zshrc -O --output-dir $userDir
sudo chsh -s /bin/zsh $USER

# Alacritty
sudo pacman -Sy alacritty --noconfirm

mkdir $userDir/.config/alacritty/
curl -L https://raw.githubusercontent.com/Vxrpenter/dotfiles/main/linux/alacritty/alacritty.toml -O --output-dir $userDir/.config/alacritty/

# Fastfetch
sudo pacman -Sy fastfetch --noconfirm
sudo pacman -Sy imagemagick --noconfirm

mkdir $userDir/.config/fastfetch/
curl -L https://raw.githubusercontent.com/Vxrpenter/dotfiles/main/linux/fastfetch/config.jsonc -O --output-dir $userDir/.config/fastfetch/

curl -L https://raw.githubusercontent.com/Vxrpenter/dotfiles/main/linux/fastfetch/logo.txt -O --output-dir $userDir/.config/fastfetch/

# General Packages
sudo pacman -Sy bat --noconfirm
