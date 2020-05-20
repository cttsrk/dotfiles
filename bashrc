# If not running interactively, don't do anything
case $- in *i*) ;; *) return;; esac

# Check the window size after each command and update LINES and COLUMNS.
shopt -s checkwinsize

# Use a separate file for aliases.
if [ -f ~/.dotfiles/bash_aliases ]; then . ~/.dotfiles/bash_aliases; fi

# Save a lot of bash history but no doubles.
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

# History expansion preview when you hit space.
bind Space:magic-space

# Use a color theme for the terminal.
if [ -f ~/.dotfiles/color_terminal ]; then
    . ~/.dotfiles/color_terminal
fi

# Colors for BSD ls.
export LSCOLORS='dxgxfxdacxdadahbadacdc'

# Colors for GNU ls and all versions of tree.
export LS_COLORS='rs=0:di=33:ln=36:mh=00:pi=40;33:so=35:do=35:bd=40;33:cd=40;33:or=40;31:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=32:*.tar=31:*.tgz=31:*.zip=31:*.gz=31:*.bz2=31:*.bz=31:*.tbz=31:*.tbz2=31:*.deb=31:*.rpm=31:*.rar=31:*.cpio=31:*.7z=31:*.cab=31:*.jpg=35:*.jpeg=35:*.gif=35:*.tga=35:*.tif=35:*.tiff=35:*.png=35:*.svg=35:*.svgz=35:*.mov=35:*.mpg=35:*.mpeg=35:*.m2v=35:*.mkv=35:*.webm=35:*.mp4=35:*.m4v=35:*.vob=35:*.wmv=35:*.avi=35:*.flac=00;36:*.m4a=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.wav=00;36:*.opus=00;36:';

# Force a color prompt if possible.
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Set the color prompt using ANSI escape sequences.
if [ "$color_prompt" = yes ]; then
    PS1="\[\e[32m\]\u@\h \[\e[33m\]\w/\[\e[00m\] "
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If we are in Tmux, prepend the prompt with an ANSI escape sequence that
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
