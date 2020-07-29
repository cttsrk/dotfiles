#!/bin/bash
# Dirty hacky dotfile installer, nothing fancy.

if [ -f ~/.profile ]; then mv ~/.profile ~/profile.old; fi
ln -s ~/.dotfiles/profile ~/.profile


if [ -f ~/.tmux.conf ]; then mv ~/.tmux.conf ~/.tmux.conf.old; fi
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

if [ ! -d ~/.config/kitty ]; then mkdir -p ~/.config/kitty; fi 
if [ -f ~/.config/kitty/kitty.conf ]; then
    mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.old
fi

if [ -f ~/.config/kitty/macos-launch-services-cmdline  ]; then
    mv ~/.config/kitty/macos-launch-services-cmdline  ~/.config/kitty/macos-launch-services-cmdline.old
fi

ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/.dotfiles/kitty.macos ~/.config/kitty/macos-launch-services-cmdline

if [ ! -d ~/.config/nvim ]; then mkdirp -p ~/.config/nvim; fi
if [ -f ~/.config/nvim/init.vim ]; then
    mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.old
fi
ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim


rm ~/bin    # fails if bin is a directory
ln -s ~/.dotfiles/bin ~/bin
