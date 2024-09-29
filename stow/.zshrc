# functions

include() {
  [ -f "$1" ] && source "$1"
}

make_venv() {
  python3 -m venv .env && \
    echo "source .env/bin/activate" >> .envrc && \
    direnv allow .
}

autoload -Uz vcs_info
precmd() {
  vcs_info
}

+vi-track-git() {
  if [ -n "$(git status -sb | grep 'behind')" ]; then
    hook_com[unstaged]="%F{red}"
  elif [ -n "$(git ls-files --others --exclude-standard)" ]; then
    hook_com[unstaged]="%F{green}"
  elif [ -n "$(git cherry)" ]; then
    hook_com[misc]="%F{magenta}"
  fi
}

# aliases

alias up="sh ~/dots/misc/install.sh"

alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"
alias lt="tree --dirsfirst -a -I '.git' -C --noreport --gitignore"

alias v="nvim"
alias py="python3"
alias tm="tmux new -A"

# zsh plugins

include "${HOMEBREW_PREFIX:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# git info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%m%c%u[%b]%f "
zstyle ':vcs_info:*' stagedstr "%F{blue}"
zstyle ':vcs_info:*' unstagedstr "%F{yellow}"
zstyle ':vcs_info:git*+set-message:*' hooks track-git

# prompt

if [ -n "$SSH_CLIENT" ]; then
  SSH_PROMPT='%F{magenta}'
fi

setopt prompt_subst
PROMPT='%F{green}${SSH_PROMPT}%n %F{8}@ %F{7}%1~ %F{8}%# %f'
RPROMPT='%F{8}${VIRTUAL_ENV_PROMPT}${vcs_info_msg_0_}%(?.%F{8}.%F{red})%*%f'
ZLE_RPROMPT_INDENT=0
