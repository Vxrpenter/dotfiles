#!/bin/bash

templateCodeOfConduct="https://codeberg.org/Vxrpenter/dotfiles/raw/branch/main/templates/git/TEMPLATE_CODE_OF_CONDUCT.md"
templateContributing="https://codeberg.org/Vxrpenter/dotfiles/raw/branch/main/templates/git/TEMPLATE_COTRIBUTING.md"

repo_location="$1"

printf "Installing Templates...\n"
curl --create-dirs -O --output-dir $repo_location/CODE_OF_CONDUCT.md "$templateCodeOfConduct" > /dev/null 2>&1
curl --create-dirs -O --output-dir $repo_location/CONTRIBUTING.md "$templateContributing" > /dev/null 2>&1
printf "Templates have been installed."
exit 1
