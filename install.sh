#!/bin/bash

if [ -f ~/.profile ]; then mv ~/.profile ~/profile.old; fi
ln -s ~/.dotfiles/profile ~/.profile

if [ -f ~/.tmux.conf ]; then mv ~/.tmux.conf ~/.tmux.conf.old; fi
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

if [ -f ~/.config/kitty/kitty.conf ]; then
    mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.old
fi
ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf

if [ -f ~/.config/nvim/init.vim ]; then
    mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.old
fi
ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim

rm ~/bin    # fails if bin is a directory
ln -s ~/.dotfiles/bin ~/bin
