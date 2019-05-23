# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export MY_COMPUTER="`hostname`"

################################################################################
# Bash specifics
################################################################################
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000
shopt -s checkwinsize
shopt -s histappend

################################################################################
# Alias
################################################################################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
