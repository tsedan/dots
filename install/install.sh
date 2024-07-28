#!/usr/bin/env bash

fprint() {
  echo "\e[34m$1\e[0m"
}

get_install_tools() {
  PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
  if [[ "$PLATFORM" == 'darwin' ]]; then
    # install homebrew if not already installed
    if ! command -v brew &>/dev/null; then
      fprint "Installing brew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # set package install command
    INSTALL_CMD="brew install"
  else
    # set package install command
    INSTALL_CMD="sudo apt install -y"
  fi
}

get_install_tools
fprint "Installing packages"
$INSTALL_CMD "$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/main/install/reqs.txt)"

fprint "Switching shell to zsh"
chsh -s $(which zsh)

fprint "Cloning dotfiles repo"
git clone https://github.com/tsedan/dots.git ~/dots

fprint "Stowing dotfiles"
cd ~/dots
stow .
