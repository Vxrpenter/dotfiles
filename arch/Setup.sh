# Type of discord client installation
export discord_discord=false
export discord_vesktop=false

export steam=false

export browser_firefox=false
export browser_librewolf=false
export browser_chromium=false

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
        * )
            echo "No discord client selected..."
    esac
}
echo ""
discordClient

# Steam client installation
function steam() {
    confirm "Would you like to install steam"
    if  [ $? == 0 ]; then steam=true; fi
}
echo ""
steam

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
        * )
            echo "No browser selected..."
    esac
}
echo ""
browser

# Update all packages
sudo pacman -Syu --noconfirm

# Install yay for AUR packages
sudo pacman -Sy yay --noconfirm

# Check discord client installation
if [ discord_vesktop ]; then yay -S --noconfirm --mflags --skipinteg vesktop-bin; fi

if [ discord_discord ]; then sudo pacman -Sy discord --noconfirm; fi

#Browser Installation
if [ browser_firefox ]; then sudo pacman -Sy firefox --noconfirm; fi

if [ browser_librewolf ]; then yay -S --noconfirm --mflags --skipinteg librewolf; fi

if [ browser_chromium ]; then sudo pacman -Sy chromium  --noconfirm; fi

# Steam installation
if [ steam ]; then
    # Enable multilib repository
    sudo sed -i -e 's/#[multilib]/[multilib]/g' /etc/pacman.conf
    sudo sed -i -e 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf
    sudo pacman -Syyu

    sudo pacman -Sy steam --noconfirm
fi
