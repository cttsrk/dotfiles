# ~/.profile: executed by the command interpreter for login shells.
umask 022

if [ -n "$BASH_VERSION" ]; then         # If running BASH.
    # include .bashrc if it exists
    if [ -f "$HOME/.dotfiles/bashrc" ]; then
	. "$HOME/.dotfiles/bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then            # Add ~/bin to PATH if we have it.
    PATH="$HOME/bin:$PATH"
fi

if [ -z "$TMPDIR" ]; then               # Make sure we have a TMPDIR.
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
