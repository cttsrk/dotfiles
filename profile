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

# FUCK YOU APPLE FOR SERIAL
export BASH_SILENCE_DEPRECATION_WARNING=1
