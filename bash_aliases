# Tool for conditionalizing platform-specific aliases: 'if_ostype gnu && ...'
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

alias v='nvim'
alias vim='echo Use v instead, you creature of habit!'
alias novim='vim -u NONE' 
alias novimconfig='vim -u NONE ~/.vimrc'
alias aliases='v ~/.dotfiles/bash_aliases'
alias bashconf='v ~/.dotfiles/bashrc'
alias kittyconf='v ~/.dotfiles/kitty.conf'
alias tmuxconf='v ~/.dotfiles/tmux.conf'
alias vconf='v ~/.dotfiles/vimrc'
alias colorconf='v ~/.dotfiles/color_terminal'
alias rebash='. ~/.dotfiles/bashrc'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias sudo='sudo '                          # Enable sudo for aliases.
alias treepager='treepager(){ tree -C $* | less -r; }; treepager'
alias mkcd='mkcd(){ mkdir -p $1; cd $1; }; mkcd'
alias blobget='blobget(){ wget ${*/blob/raw}; }; blobget'
alias bestaudio="youtube-dl -f bestaudio -x -o '%(artist)s - %(release_year)s - %(track)s - %(id)s.%(ext)sTMP'"
alias dumpaudio='dumpaudio(){ mplayer -ao pcm:file="$1.wav" -vo null "$1"; }; dumpaudio'

if_ostype gnu && alias ls='ls --color=auto' # Colored ls has different ...
if_ostype bsd && alias ls='ls -G'           # ... syntax on gnu and bsd.
if_ostype gnu && alias df='df -kTh'         # T and t are switched ...
if_ostype bsd && alias df='df -kth'         # ... on gnu and bsd.
alias pager='less'
alias ll='ls -hl'
alias la='ll -a'
alias rm='rm -v'
alias cp='cp -v'
alias th='cd'                               # Dvorak.
alias eu='ls'                               # Dvorak.
alias mv='mv -v'
alias j='jobs -l'
alias grep='grep --color=auto'
alias du='du -ckhx'
alias dudir='du -s *'
alias free='free -h'
alias path='echo -e ${PATH//:/\\n}'         # Prettyprint $PATH.
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

# Microsoft WSL-specific aliases.
if [[ $(uname -r) =~ Microsoft$ ]]; then
    homedrv="$(cmd.exe /c 'echo %HOMEDRIVE%' | cut -c 1 | tr [A-Z] [a-z])"
    homepath=$(cmd.exe /c "echo %HOMEPATH%" | tr '\\' '\/' | tr -d '\r')
	export winhome="/mnt/$homedrv$homepath"
	alias winhome='cd $winhome'
    winclip='_(){ cat $1 | clip.exe; }; _'  # Cat to windows clipboard.
fi

unset -f if_ostype if_os; unset s           # Cleanup.
