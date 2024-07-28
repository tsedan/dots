#!/usr/bin/env bash

get_install_tools() {
  PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
  if [[ "$PLATFORM" == 'darwin' ]]; then
    # install homebrew if not already installed

    # set package install command
    INSTALL_CMD="brew install"
  else
    # set package install command
    INSTALL_CMD="sudo apt install -y"
  fi
}

get_install_tools
PACKAGES=$(curl -s "https://raw.githubusercontent.com/tsedan/dots/main/reqs.txt")
$INSTALL_CMD $PACKAGES

chsh -s $(which zsh)
git clone https://github.com/tsedan/dots.git ~/dots
cd ~/dots
stow .
