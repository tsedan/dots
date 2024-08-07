#!/usr/bin/env bash

cprint() {
  printf "\033[1;34minfo:\033[0m $1\n"
}

pprint() {
  printf "\033[1;33mwarning:\033[0m $1"
}

eprint() {
  printf "\033[1;31merror:\033[0m $1\n"
}

update_packages() {
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
    cprint "updating packages"
    sudo apt update -qq && sudo apt upgrade -qq
    INSTALL_CMD="sudo apt install -qqq -y"
  elif [[ "$OS" == "Fedora Linux" ]]; then
    cprint "updating packages"
    sudo dnf update -q
    INSTALL_CMD="sudo dnf install -q -y"
  elif [[ "$OS" == "MacOS" ]]; then
    if ! type brew &>/dev/null; then
      cprint "installing homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    cprint "updating packages"
    brew update -q && brew upgrade -q
    INSTALL_CMD="brew install -q"
  else
    eprint "unsupported OS: $OS"
    exit 1
  fi
}

cprint "authenticating"
if ! sudo -v &>/dev/null; then
  pprint "proceed without sudo (Y/n)? "
  read response
  if [[ "${response:-y}" == "y" || "$response" == "Y" ]]; then
    NOSUDO=1
  else
    exit 0;
  fi
fi

if [ -z $NOSUDO ]; then
  update_packages
fi

if [[ ! -d ~/dots ]]; then
  if [ -z $NOSUDO ]; then
    cprint "installing dependencies"
    PACKAGES=$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/main/misc/reqs.txt)
    $INSTALL_CMD $PACKAGES

    cprint "setting default shell"
    if ! grep -qxF "$(which zsh)" /etc/shells; then
      sudo sh -c "echo $(which zsh) >> /etc/shells"
    fi
    chsh -s $(which zsh)
  fi

  cprint "cloning dotfiles repo"
  git clone --recurse-submodules https://github.com/tsedan/dots.git ~/dots
else
  cprint "updating dotfiles"
  cd ~/dots
  stow -D .
  git pull
  git submodule update --init --recursive

  if [ -z $NOSUDO ]; then
    cprint "validating dependencies"
    PACKAGES=$(cat ~/dots/misc/reqs.txt)
    $INSTALL_CMD $PACKAGES
  fi
fi

cd ~/dots
stow .
