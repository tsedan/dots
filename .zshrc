# exports

export TERM="xterm-256color"

# functions

include() {
  [[ -f "$1" ]] && source "$1"
}

up() {
  sh ~/dots/misc/install.sh
}

lt() {
  tree --dirsfirst -a -I '.git' -C --noreport -L "${1:-2}"
}

tm() {
  tmux new -A -s "${1:-ssh}"
}

make_venv() {
  python3 -m venv .env
  echo "source .env/bin/activate" >> .envrc
  direnv allow .
}

# aliases

alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"

alias vi="nvim"
alias py="python3"

# zsh plugins

PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
if [[ "$PLATFORM" == 'darwin' ]]; then
  BPREFIX=$(brew --prefix)
fi
include "${BPREFIX:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# git info

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks track-git
zstyle ':vcs_info:*' formats "%m%c%u[%b]%f "
zstyle ':vcs_info:*' stagedstr "%F{blue}"
zstyle ':vcs_info:*' unstagedstr "%F{yellow}"
setopt prompt_subst
precmd() {
  vcs_info
}

+vi-track-git() {
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    hook_com[unstaged]="%F{green}"
  elif [[ -n "$(git cherry)" ]]; then
    hook_com[misc]="%F{magenta}"
  fi

  if [[ -n "$(git status -sb | grep 'behind')" ]]; then
    hook_com[unstaged]="%F{red}"
  fi
}

# prompt

if [[ -n "$SSH_CLIENT" ]]; then
  PROMPT='%F{magenta}'
else
  PROMPT='%F{green}'
fi
PROMPT=$PROMPT'%n %F{8}@ %F{7}%1~ %F{8}%# %f'
RPROMPT='%F{8}${VIRTUAL_ENV_PROMPT}${vcs_info_msg_0_}%(?.%F{8}.%F{red})%*%f'
