# aliases
alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"

alias vi="nvim"
alias py="python3"

alias s="kitty +kitten ssh"
alias c="git commit -a -m"

# custom prompt
PROMPT="%F{10}%n %F{8}@ %F{7}%1~ %F{8}%# %f"

# zsh plugins
source ${ZPATH:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
