include () {
  [[ -f "$1" ]] && source "$1"
}

# exports
export TERM="xterm-256color"

# aliases
alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"

alias vi="nvim"
alias py="python3"

# custom prompt
PROMPT="%F{10}%n %F{8}@ %F{7}%1~ %F{8}%# %f"

# zsh plugins
include ${ZPATH:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
