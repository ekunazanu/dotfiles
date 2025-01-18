HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=50000

setopt nomatch notify correct extendedhistory incappendhistorytime histreduceblanks histignorespace histfindnodups menucomplete promptsubst
unsetopt autocd extendedglob correct_all

autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash
autoload -Uz vcs_info

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word
bindkey "^[[1;5D"  backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[Z" reverse-menu-complete
bindkey "^[[1;5A" up-line
bindkey "^[[1;5B" down-line
bindkey "^[[5~" up-line
bindkey "^[[6~" down-line
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

zstyle ':compinstall' filename '$HOME/.zshrc'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*:commands' list-colors '=*=1;32'
zstyle ':completion:*:arguments' list-colors '=*=1;33'
zstyle ':completion:*:parameters' list-colors '=*=1;33'
zstyle ':completion:*:options' list-colors '=*=1;34'
zstyle ':completion:*:zsh-options' list-colors "=*=1;34"

eval "$(dircolors)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats ' %b%c%u'
zstyle ':vcs_info:git:*' actionformats ' %a|%b%c%u%a'
PROMPT='%# %F{4}%(4~|../%3~|%d)%f%F{3}${vcs_info_msg_0_}%f %(?.%F{2}>.%F{1}%? >)%f '
RPROMPT='%F{1}${vcs_info_msg_1_} ${vcs_info_msg_2_}%f %F{5}%h%f [%F{6}%D %*%f]'

alias cp="cp -v -r -i"
alias mv="mv -v -i"
alias rm="rm -v -r -i"
alias mkdir="mkdir -p -v"
alias chown="chown -v"
alias chmod="chmod -v"
alias tree="tree -C --dirsfirst"
alias diff="diff -y -N --suppress-common-lines --no-ignore-file-name-case --color=always"
alias ls="ls -l -h --group-directories-first --color=auto"
alias grep="rg -i"
alias mount="mount | column -t"
alias du="du -h"
alias df="df -h"
alias cat="bat"

preexec() { print -Pn "\e]0;${(q)1}\e\\" }
precmd() { vcs_info }
