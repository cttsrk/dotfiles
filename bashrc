# If not running interactively, don't do anything
case $- in *i*) ;; *) return;; esac

# Check the window size after each command and update LINES and COLUMNS.
shopt -s checkwinsize

# Enable colored ls. This sets the $LS_COLORS environment variable for gnu 'ls'.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" ||
    eval "$(dircolors -b)"
fi

# Use a separate file for aliases.
if [ -f ~/.dotfiles/bash_aliases ]; then . ~/.dotfiles/bash_aliases; fi

# HISTORY
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Enable programmable completion features.
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Enable preview when doing history expansion by hitting space.
bind Space:magic-space


# COLORS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

# Do we have colors settings?
if [ -f ~/.dotfiles/color_terminal ]; then
    . ~/.dotfiles/color_terminal
fi

# Do we want to try to force a color prompt?
force_color_prompt=yes

# Test if we can force a color prompt.
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Set the color prompt using ASCII escape sequences for color.
if [ "$color_prompt" = yes ]; then
    PS1="\[\e[32m\]\u@\h \[\e[33m\]\w/\[\e[00m\] "
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If we are in Tmux, prepend the prompt with an ASCII escape sequence that
# changes the title of the current window.
if [ "${TMUX_PANE}" ]; then
    # PS1 updates the title with the current working directory (CWD) after each 
    # command is run.
    PS1="\[\e]0;\w/\a\]$PS1"

    # HACK: This debug trap updates the title with the command invoked -before-
    # each command is run. This really wants to go at the end of the file or
    # we'll get funky output from previous commands. Break out "$BASH_COMMAND"
    # from the string to prevent printf from interpreting any '%'-characters
    # in it.
    trap 'printf "\e]0;%s\a" "$BASH_COMMAND" | tr -d "\134"' DEBUG
fi
