#!/bin/bash

fprint() {
  echo "\e[34m$1\e[0m"
}

platform=$(uname | tr '[:upper:]' '[:lower:]')
if [[ "$platform" == 'linux' ]]; then
  # linux

  # TODO: automate installation

elif [[ "$platform" == 'darwin' ]]; then
  # macOS
  fprint "MacOS detected"

  fprint "Checking if brew installed"
  if ! command -v brew &> /dev/null; then
      fprint "Installing brew first"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  fprint "Updating brew"
  brew update && brew upgrade

  fprint "Installing dependencies"
  xargs brew install < mac_reqs.txt

  fprint "Linking dotfiles"
  stow .

  # TODO: mac specific symlinks
fi
