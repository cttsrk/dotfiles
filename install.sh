#!/bin/bash

if [ -f ~/.profile ]; then mv ~/.profile ~/profile.old; fi
ln -s profile ~/.profile

if [ -f ~/.tmux.conf ]; then mv ~/.tmux.conf ~/.tmux.conf.old; fi
ln -s tmux.conf ~/.tmux.conf

if [ -f ~/.config/kitty/kitty.conf ]; then
    mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.old
fi
ln -s kitty.conf ~/.config/kitty/kitty.conf

if [ -f ~/.config/nvim/init.vim ]; then
    mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.old
fi
ln -s vimrc ~/.config/nvim/init.vim

rm ~/bin    # fails if bin is a directory
ln -s ~/.dotfiles/bin ~/bin
