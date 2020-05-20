# Tool for conditionalizing platform-specific aliases.
# Usage: 'if_ostype gnu && command', 'if_ostype bsd'... etc.
function if_ostype {
    case $OSTYPE in
        *linux*|*hurd*|*msys*|*cygwin*|*sua*|*interix*)     s="gnu";;
        *bsd*|*darwin*)                                     s="bsd";;
        *sunos*|*solaris*|*indiana*|*illumos*|*smartos*)    s="sun";;
    esac
    [[ "${s}" == "$1" ]]
}
function if_os {
    if [[ "$OSTYPE" == *"darwin"*  ]]; then s="osx"; fi
    if [[ $(uname -r) =~ Microsoft$ ]]; then s="win"; fi
    [[ "${s}" == "$1" ]]
}

# Enable sudo for aliases.
alias sudo='sudo '

# Set the default editor.
alias v='nvim'
alias vim='echo Use v instead, you creature of habit!'

# Qickly edit some key files.
alias aliases='v ~/.dotfiles/bash_aliases'
alias bashconf='v ~/.dotfiles/bashrc'
alias dotconf='v ~/.dotfiles/install.conf.yaml'
alias kittyconf='v ~/.dotfiles/kitty.conf'
alias tmuxconf='v ~/.dotfiles/tmux.conf'
alias vconf='v ~/.dotfiles/vimrc'
alias colorconf='v ~/.dotfiles/color_terminal'
alias rebash='. ~/.dotfiles/bashrc'

# Fallback in case of a broken vim config.
alias novim='vim -u NONE' 
alias novimconfig='vim -u NONE ~/.vimrc'

# Fast directory change.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Misc
alias treepager='_(){ tree -C $* | less -r; }; _'
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'
alias blobget='_(){ wget ${*/blob/raw}; }; _'
alias bestaudio="youtube-dl -f bestaudio -x -o '%(artist)s - %(release_year)s - %(track)s - %(id)s.%(ext)sTMP'"
alias dumpaudio='_(){ mplayer -ao pcm:file="$1.wav" -vo null "$1"; }; _'

# Dvorak typing helpers.
alias th='ls' # ls is wicked hard to type on dvorak
alias eu='cd' # and cd is on the wrong side of the keyboard
alias pager='less' # four left pinky strikes in 'less'+<Enter>...

# Colored ls has different syntax on different platforms.
if_ostype gnu && alias ls='ls --color=auto'
if_ostype bsd && alias ls='ls -G'

alias ll='ls -hl'
alias la='ll -a'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias j='jobs -l'
alias grep='grep --color=auto'

# Prettyprint the path environment variable.
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# Filesystem inspection.
alias du='du -ckhx'
alias dudir='du -s *'
alias free='free -h'

# NOTE: -T and -t are switched for gnu 'df' and bsd 'df'...
if_ostype gnu && alias df='df -kTh'
if_ostype bsd && alias df='df -kth'

if_os osx && echo '--start-as=fullscreen' > ~/.config/kitty/macos-launch-services-cmdline

# Microsoft WSL-specific aliases.
if [[ $(uname -r) =~ Microsoft$ ]]; then
    homedrv="$(cmd.exe /c 'echo %HOMEDRIVE%' | cut -c 1 | tr [A-Z] [a-z])"
    homepath=$(cmd.exe /c "echo %HOMEPATH%" | tr '\\' '\/' | tr -d '\r')
	export winhome="/mnt/$homedrv$homepath"

	alias winhome='cd $winhome'

    # Copy file to windows clipboard with 'winclip [filename]'
    winclip='_(){ cat $1 | clip.exe; }; _'
fi

# Cleanup.
unset -f if_ostype if_os
unset s
