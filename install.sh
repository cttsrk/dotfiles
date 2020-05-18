#!/bin/bash

rm ~/.profile
ln -s ~/.dotfiles/profile ~/.profile

rm ~/.config/kitty/kitty.conf
ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf

rm ~/.tmux.conf
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

rm ~/.config/nvim/init.vim
ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim
