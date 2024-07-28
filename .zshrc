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

# zsh plugins
include ${ZPATH:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# custom prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "%F{8}[%b]%f "
precmd() { vcs_info }
setopt prompt_subst

if [[ -n "$SSH_CLIENT" ]]; then
  PROMPT='%F{magenta}'
else
  PROMPT='%F{green}'
fi
PROMPT=$PROMPT'%n %F{8}@ %F{7}%1~ %F{8}%# %f'
RPROMPT='${vcs_info_msg_0_}%F{8}%(?..%F{red})%*%f'

# launch tmux when ssh'ed
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CLIENT" ]]; then
  tmux new -A -s ssh
fi
