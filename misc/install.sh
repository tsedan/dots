#!/usr/bin/env bash

cprint() {
  printf "\033[34m$1\033[0m\n"
}

eprint() {
  printf "\033[31m$1\033[0m\n"
}

cprint "Authenticating"
sudo -v

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
  else
    OS=$(uname -s)
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="MacOS"
else
  OS="unknown"
fi

if [[ "$OS" == "Ubuntu" || "$OS" == "Debian GNU/Linux" ]]; then
  cprint "Updating packages"
  sudo apt update -qq && sudo apt upgrade -qq
  INSTALL_CMD="sudo apt install -qqq -y"
elif [[ "$OS" == "MacOS" ]]; then
  if ! type brew &>/dev/null; then
    cprint "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  cprint "Updating packages"
  brew update -q && brew upgrade -q
  INSTALL_CMD="brew install -q"
else
  eprint "Unsupported OS: $OS"
  exit 1
fi

if [[ ! -d ~/dots ]]; then
  cprint "Installing dependencies"
  PACKAGES=$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/main/misc/reqs.txt)
  $INSTALL_CMD $PACKAGES

  cprint "Cloning dotfiles repo"
  git clone --recurse-submodules https://github.com/tsedan/dots.git ~/dots

  cprint "Setting default shell"
  sudo sh -c "echo $(which zsh) >> /etc/shells"
  chsh -s $(which zsh)
else
  cprint "Updating dotfiles"
  cd ~/dots
  stow -D .
  git pull
  git submodule update --init --recursive
fi

stow .

cprint "Validating dependencies"
PACKAGES=$(cat ~/dots/misc/reqs.txt)
$INSTALL_CMD $PACKAGES
