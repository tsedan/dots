#!/usr/bin/env bash

cprint() {
  printf "\033[34m$1\033[0m\n"
}

eprint() {
  printf "\033[31m$1\033[0m\n"
}

detect_os() {
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
}

get_package_tools() {
  if [[ "$OS" == "Ubuntu" || "$OS" == "Debian GNU/Linux" ]]; then
    cprint "Updating packages"
    sudo apt update
    sudo apt upgrade
    INSTALL_CMD="sudo apt install -y"
    CHECK_CMD="dpkg -s"
  elif [[ "$OS" == "MacOS" ]]; then
    if ! type brew &>/dev/null; then
      cprint "Installing homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    cprint "Updating packages"
    brew update
    brew upgrade
    INSTALL_CMD="brew install"
    CHECK_CMD="brew list"
  else
    eprint "Unsupported OS: $OS"
    exit 1
  fi
}

install_packages() {
  for PACKAGE in "$@"; do
    if ! $CHECK_CMD $PACKAGE &> /dev/null; then
      cprint "Installing $PACKAGE"
      $INSTALL_CMD $PACKAGE
    fi
  done
}

cprint "Authenticating"
sudo test

detect_os
get_package_tools

PACKAGES=$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/main/misc/reqs.txt)
install_packages $PACKAGES

cprint "Setting default shell"
chsh -s $(which zsh)

if [[ ! -d ~/dots ]]; then
  cprint "Cloning dotfiles repo"
  git clone --recurse-submodules https://github.com/tsedan/dots.git ~/dots
fi

cprint "Updating dotfiles"
cd ~/dots
stow -D .
git pull
git submodule update --init --recursive
stow .
