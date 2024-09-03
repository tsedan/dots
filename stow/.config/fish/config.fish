if status is-interactive
  abbr -a up sh ~/dots/misc/install.sh

  abbr -a v nvim
  abbr -a py python3
  abbr -a tm tmux new -A

  abbr -a lt tree --dirsfirst -a -I '.git' -C --noreport --gitignore
end

if type -q direnv
  direnv hook fish | source
end
