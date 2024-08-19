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

if [ ! -d ~/dots ]; then
  eprint "nothing to uninstall"
  exit 1
fi

pprint "this script will not uninstall packages"
echo

cd ~/dots
stow -d stow -t .. -D .
cprint "unstowed files"

pprint "permanently remove the dots directory (y/N)? "
read response
case "$response" in
[yY]);;
*) exit 0 ;;
esac

rm -r ~/dots
