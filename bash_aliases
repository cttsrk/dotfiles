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
alias bashconfig='v ~/.dotfiles/bashrc'
alias dotconfig='v ~/.dotfiles/install.conf.yaml'
alias kittyconfig='v ~/.dotfiles/kitty.conf'
alias tmuxconfig='v ~/.dotfiles/tmux.conf'
alias vconfig='v ~/.dotfiles/vimrc'
alias colorconfig='v ~/.dotfiles/color_terminal'
alias rebash='. ~/.dotfiles/bashrc'

# Fallback for when you mess up vimrc.
alias novim='vim -u NONE' 
alias novimconfig='vim -u NONE ~/.vimrc'

# Fast directory change.
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory tree inspection.
alias treepager='_(){ tree -C $* | less -r; }; _'
alias ftreepager='_(){ tree -shfC $* | prettyprint.awk | less -r; }; _'

# Create dir and change to it.
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'

# Download files from github.
alias blobget='_(){ wget ${*/blob/raw}; }; _'

# Download music from youtube.
alias bestaudio="youtube-dl -f bestaudio -x -o '%(track)s - %(artist)s - %(release_year)s - %(id)s.%(ext)stoconvert'"
#alias bestaudio="youtube-dl -f bestaudio -x -o '%(artist)s - %(release_year)s - %(track)s - %(id)s.%(ext)s'"

# Misc media stuff.
alias music='mplayer -novideo'
alias dumpaudio='_(){ mplayer -ao pcm:file="$1.wav" -vo null "$1"; }; _'

# Dvorak typing helpers.
alias th='ls' # ls is wicked hard to type on dvorak
alias eu='cd' # and cd is on the wrong side of the keyboard
alias pager='less' # four left pinky strikes in 'less'+<Enter>...

# Set the $LSCOLORS environment variable for bsd 'ls'. This approximates the
# dircolors defaults from above, sans 'bold' settings (MacOS renders fonts
# plenty fat without).
if_ostype bsd && export LSCOLORS='dxgxfxdacxdadahbadacec'

# Colored ls has different syntax on different platforms.
if_ostype gnu && alias ls='ls --color=auto'
if_ostype bsd && alias ls='ls -G'

alias ll='ls -hl'
alias la='ll -a'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias h='history'
alias j='jobs -l'
alias grep='grep --color=auto'

# REALLY fancy ls. TODO: Maybe decrease coupling by inlining the awk script as
# a function?
alias pp='CLICOLOR_FORCE=true ls | prettyprint.awk'
alias pl='CLICOLOR_FORCE=true ll | prettyprint.awk'
alias pa='CLICOLOR_FORCE=true la | prettyprint.awk'

# Prettyprint the path environment variable.
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# Filesystem inspection.
alias du='du -ckhx'
alias dudir='du -s *'
alias free='free -h'

# Gotcha: -T and -t are switched for gnu 'df' and bsd 'df'...
if_ostype gnu && alias df='df -kTh'
if_ostype bsd && alias df='df -kth'

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
