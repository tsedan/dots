# exports
export TERM="xterm-256color"

# functions
autoload -Uz vcs_info
precmd() { vcs_info }
include() { [[ -f "$1" ]] && source "$1" }
lt() { tree -a -I '.git' -C --noreport -L "${1:-3}" }
tm() { tmux new -A -s "${1:-ssh}" }

# aliases
alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"

alias vi="nvim"
alias py="python3"

# zsh plugins
include ${ZPATH:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# custom prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%F{8}%c%u[%b]%f "
zstyle ':vcs_info:*' stagedstr "%F{blue}"
zstyle ':vcs_info:*' unstagedstr "%F{yellow}"
setopt prompt_subst

if [[ -n "$SSH_CLIENT" ]]; then
  PROMPT='%F{magenta}'
else
  PROMPT='%F{green}'
fi
PROMPT=$PROMPT'%n %F{8}@ %F{7}%1~ %F{8}%# %f'
RPROMPT='${vcs_info_msg_0_}%F{8}%(?..%F{red})%*%f'

