#!/bin/bash

templateCodeOfConduct="https://codeberg.org/Vxrpenter/dotfiles/raw/branch/main/templates/git/TEMPLATE_CODE_OF_CONDUCT.md"
templateContributing="https://codeberg.org/Vxrpenter/dotfiles/raw/branch/main/templates/git/TEMPLATE_COTRIBUTING.md"

repo_location="$1"


printf "Installing Templates..."
curl --create-dirs -O --output-dir $repo_location "$templateCodeOfConduct"
curl --create-dirs -O --output-dir $repo_location "$templateContributing"
printf "Templates have been installed."
exit 1
