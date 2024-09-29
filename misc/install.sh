#!/bin/sh

cprint() {
  printf "\033[1;34minfo:\033[0m %s\n" "$1"
}

pprint() {
  printf "\033[1;33mwarning:\033[0m %s" "$1"
}

eprint() {
  printf "\033[1;31merror:\033[0m %s\n" "$1"
}

update_packages() {
  OS=$(uname -s)
  case "$OS" in
  "Linux")
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS=$NAME
    elif [ -f /etc/lsb-release ]; then
      . /etc/lsb-release
      OS=$DISTRIB_ID
    fi
    ;;
  esac

  case "$OS" in
  "Ubuntu" | "Debian GNU/Linux")
    cprint "updating packages"
    sudo apt update -qq && sudo apt upgrade -qq -y
    INSTALL_CMD="sudo apt install -qqq -y"
    ;;
  "Fedora Linux")
    cprint "updating packages"
    sudo dnf update -q
    INSTALL_CMD="sudo dnf install -q -y"
    ;;
  "Darwin")
    if [ ! -d /opt/homebrew/bin ]; then
      cprint "installing homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    PATH=/opt/homebrew/bin:$PATH
    cprint "updating packages"
    brew update -q && brew upgrade -q
    INSTALL_CMD="brew install -q"
    ;;
  *)
    eprint "unsupported OS: $OS"
    exit 1
    ;;
  esac
}

cprint "authenticating"
if ! sudo -v >/dev/null 2>&1; then
  pprint "proceed without sudo (Y/n)? "
  read response
  case "$response" in
  [yY] | "") NOSUDO=1 ;;
  *) exit 0 ;;
  esac
fi

if [ -z "$NOSUDO" ]; then
  update_packages
fi

if [ ! -d ~/dots ]; then
  if [ -z "$NOSUDO" ]; then
    cprint "installing dependencies"
    PACKAGES=$(curl -fsSL https://raw.githubusercontent.com/tsedan/dots/HEAD/misc/reqs.txt | tr '\n' ' ')
    eval $INSTALL_CMD $PACKAGES

    cprint "setting default shell"
    if ! grep -qxF "$(command -v zsh)" /etc/shells; then
      sudo sh -c "echo $(command -v zsh) >> /etc/shells"
    fi
    chsh -s "$(command -v zsh)"
  fi

  cprint "cloning dotfiles repo"
  git clone --recurse-submodules https://github.com/tsedan/dots.git ~/dots
else
  cprint "updating dotfiles"
  cd ~/dots
  stow -d stow -t .. -D .
  git pull
  git submodule update --init --recursive

  if [ -z "$NOSUDO" ]; then
    cprint "checking dependencies"
    PACKAGES=$(cat ~/dots/misc/reqs.txt | tr '\n' ' ')
    eval $INSTALL_CMD $PACKAGES
  fi
fi

cd ~/dots
stow -d stow -t .. .
