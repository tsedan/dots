# aliases
alias la="ls -a"
alias vi="nvim"
alias py="python3"

# custom prompt
PROMPT="%F{10}%n %F{8}@ %F{7}%1~ %F{8}%# %f"

# zsh plugins
source ${ZPATH:-/usr}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${ZPATH:-/usr}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
