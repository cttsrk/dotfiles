# Tool for conditionalizing platform-specific aliases.
# Usage: 'if_ostype gnu && ...'
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

# Prepare to vi.
alias v='nvim'
alias vim='echo Use v'                      # NULL ROUTE THIS HABIT

# Shortcuts for environment configuration.
alias novimconfig='vim -u NONE ~/.vimrc'
alias aliases='v ~/.dotfiles/bash_aliases'
alias profconf='v ~/.dotfiles/profile'
alias bashconf='v ~/.dotfiles/bashrc'
alias kittyconf='v ~/.dotfiles/kitty.conf'
alias tmuxconf='v ~/.dotfiles/tmux.conf'
alias vconf='v ~/.dotfiles/vimrc'
alias colorconf='v ~/.dotfiles/color_terminal'
alias rebash='. ~/.dotfiles/profile'

# misc webripperino
alias blobget='blobget(){ wget ${*/blob/raw}; }; blobget'
alias bestaudio="use ytmp4audio or ytwebmaudio"     # NULL ROUTE THIS HABIT
alias ytinfo="youtube-dl -F"
alias ytmp4audio="youtube-dl -f bestaudio[ext=m4a] -x -o '%(title)s - %(id)s.%(ext)sTMP'"
alias ytwebmaudio="youtube-dl -f bestaudio[ext=webm] -x -o '%(title)s - %(id)s.%(ext)sTMP'"
alias ytmp4video="youtube-dl -f bestvideo[ext=mp4]+bestaudio[ext=m4a] -x -o '%(title)s - %(id)s.%(ext)sTMP'"
alias ytwebmvideo="youtube-dl -f bestvideo[ext=webm]+bestaudio[ext=webm] -x -o '%(title)s - %(id)s.%(ext)sTMP'"
alias dumpaudio='dumpaudio(){ mplayer -ao pcm:file="$1.wav" -vo null "$1"; }; dumpaudio'

# misc quality of life
alias ls='echo Use no'                      # NULL ROUTE THIS HABIT
if_ostype gnu && alias no='/bin/ls --color=auto'    # Colored ls has different
if_ostype bsd && alias no='/bin/ls -G'      # syntax on gnu and bsd.
alias df='echo Use eu'                      # NULL ROUTE THIS HABIT
if_ostype gnu && alias eu='/bin/df -kTh'    # T and t are switched
if_ostype bsd && alias eu='/bin/df -kth'    # on gnu and bsd.
alias sudo='sudo '                          # Enable sudo for aliases.
alias pager='less'
alias ll='echo Use nn'                      # NULL ROUTE THIS HABIT
alias nn='no -hl'
alias na='nn -a'
alias la='echo Use na'                      # NULL ROUTE THIS HABIT
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias j='jobs -l'
alias grep='grep --color=auto'
alias du='du -ckhx'
alias dudir='du -s *'
alias free='free -h'
alias path='echo -e ${PATH//:/\\n}'         # Prettyprint $PATH.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias treepager='treepager(){ tree -C $* | less -r; }; treepager'
alias mkcd='mkcd(){ mkdir -p $1; cd $1; }; mkcd'

# Microsoft WSL-specific aliases.
if_os win && homedrv="$(cmd.exe /c 'echo %HOMEDRIVE%' | cut -c 1 | tr [A-Z] [a-z])"
if_os win && homepath=$(cmd.exe /c "echo %HOMEPATH%" | tr '\\' '\/' | tr -d '\r')
if_os win && export winhome="/mnt/$homedrv$homepath"
if_os win && alias winhome='cd $winhome'
if_os win && winclip='_(){ cat $1 | clip.exe; }; _'  # Cat to windows clipboard.

# Cleanup.
unset -f if_ostype if_os; unset s
