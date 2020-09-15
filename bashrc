case $- in *i*) ;; *) return;; esac     # Return if not in an interactive shell.
shopt -s checkwinsize                   # Keep LINES and COLUMNS up to date.
shopt -s histappend
export HISTCONTROL=ignoreboth           # Don't save doubles in history.
export HISTSIZE=1000
export HISTFILESIZE=2000
bind Space:magic-space                  # History expansion expansion on space.

# Use a separate file for aliases.
if [ -f ~/.dotfiles/bash_aliases ]; then . ~/.dotfiles/bash_aliases; fi

# Set a fancy shell prompt and keep the window title up to date.
if (( EUID != 0 )); then
    # luser
    PS1="\[\e]0;\w/\a\]\[\e[32m\]\u@\h \[\e[34m\]\w/\[\e[00m\] "
else
    # root
    PS1="\[\e]0;\w/\a\]\[\e[31m\]\u@\h \[\e[34m\]\w/\[\e[00m\] "
fi
