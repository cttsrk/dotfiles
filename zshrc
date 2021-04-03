# STFU
unsetopt BEEP

#DISABLE_AUTO_TITLE="true"
precmd () {print -Pn "\e]0;zsh %~   %(1j,%j job,)\a"}
preexec () {printf "\033]0;%s\a" "$2"}

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

alias v=vim
alias vconf="v ~/.dotfiles/vimrc"
alias zshconf="v ~/.dotfiles/zshrc"
alias reshell=". ~/.dotfiles/zshrc"
alias profconf="v ~/.dotfiles/zprofile"
alias kittyconf="v ~/.dotfiles/kitty.conf"
alias tmuxconf="v ~/.dotfiles/tmux.conf"

alias ytmp4audio="youtube-dl -f bestaudio[ext=m4a] -x -o '%(title)s - %(id)s.%(ext)sTMP'" 
alias ytwebmaudio="youtube-dl -f bestaudio[ext=webm] -x -o '%(title)s - %(id)s.%(ext)sTMP'" 
alias ytmp4video="youtube-dl -f bestvideo[ext=mp4]+bestaudio[ext=m4a] -x -o '%(title)s - %(id)s.%(ext)sTMP'" 
alias ytwebmvideo="youtube-dl -f bestvideo[ext=webm]+bestaudio[ext=webm] -x -o '%(title)s - %(id)s.%(ext)sTMP'" 
alias dumpaudio='dumpaudio(){ mplayer -ao pcm:file="$1.wav" -vo null "$1"; }; dumpaudio'


# misc quality of life
if_ostype gnu && alias ls='/bin/ls --color=auto'    # Colored ls has different
if_ostype bsd && alias ls='/bin/ls -G'              # syntax on gnu and bsd.
if_ostype gnu && alias df='/bin/df -kTh'            # T and t are switched
if_ostype bsd && alias df='/bin/df -kth'            # on gnu and bsd.
alias sudo='sudo '                          # Enable sudo for aliases.
alias ll='ls -hl'
alias th='ll'
alias la='ll -a'
alias grep='grep --color=auto'
alias du='du -ckhx'
alias path='echo -e ${PATH//:/\\n}'         # Prettyprint $PATH.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkcd='mkcd(){ mkdir -p $1; cd $1; }; mkcd'

# Microsoft WSL-specific aliases.
if_os win && homedrv="$(cmd.exe /c 'echo %HOMEDRIVE%' | cut -c 1 | tr [A-Z] [a-z])"
if_os win && homepath=$(cmd.exe /c "echo %HOMEPATH%" | tr '\\' '\/' | tr -d '\r')
if_os win && export winhome="/mnt/$homedrv$homepath"
if_os win && alias winhome='cd $winhome'
if_os win && winclip='_(){ cat $1 | clip.exe; }; _'  # Cat to windows clipboard.

# Cleanup.
unset -f if_ostype if_os; unset s
