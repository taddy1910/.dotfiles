#!/bin/bash

for f in .??*
do
   if [ "$f" = ".git" ];then
       echo ".git ignored"
       continue
   fi

   if [ "$f" = ".DS_STORE" ];then
       echo ".DS_STORE ignored"
       continue
   fi
   ln -s $HOME/.dotfiles/$f $HOME/$f

done

# neovim setup
mkdir -p $HOME/.config/nvim
ln -s $HOME/.dotfiles/.vimrc $HOME/.config/nvim/init.vim

# fish setup
mkdir -p $HOME/.config/fish
ln -s $HOME/.dotfiles/fish/config.fish $HOME/.config/fish/config.fish

# bash setup
ln -s $HOME/.dotfiles/bash/.bash_profile $HOME/.bash_profile
ln -s $HOME/.dotfiles/bash/.bashrc $HOME/.bashrc
ln -s $HOME/.dotfiles/bash/.fzf.bash $HOME/.fzf.bash
