export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

zstyle ':omz:update' mode auto

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting command-not-found)

source $ZSH/oh-my-zsh.sh

# Run Fastfetch
if [[ -o interactive ]]; then
    fastfetch
fi
