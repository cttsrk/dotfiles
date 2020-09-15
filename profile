# ~/.profile: executed by the command interpreter for login shells.
umask 022
# stty -ixon

# Source bashrc if we're in bash.
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.dotfiles/bashrc" ]; then
	    . "$HOME/.dotfiles/bashrc"
    fi
fi

# If we have a ~/bin, add it to PATH.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Make sure we have a temp directory.
if [ -z "$TMPDIR" ]; then
    TMPDIR="/tmp/"
fi

# If we're not in a tmux pane, attach to the first available tmux session,
# cor launch one if none exists. Also, only set terminal colors before we
# enter tmux.
if [ -z "$TMUX" ] && (( EUID != 0 )); then
    if [ -f ~/.dotfiles/color_terminal ]; then . ~/.dotfiles/color_terminal; fi

    tmux attach || tmux
fi

# FUCK YOU APPLE FOR SERIAL
export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH="$HOME/.cargo/bin:$PATH"
