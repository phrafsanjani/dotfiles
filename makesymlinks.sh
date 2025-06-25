#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$HOME/dotfiles"                    # dotfiles directory
olddir="$HOME/dotfiles_old"             # old dotfiles backup directory
files="zshrc"                           # list of files/folders to symlink in homedir
configs="nvim go"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/$file
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file $HOME/.$file
done

for config in $configs; do
    echo "Moving any existing dotfiles from ~/.config to $olddir"
    mkdir -p ~/dotfiles_old/$config
    mv ~/.config/$config/* ~/dotfiles_old/$config
    echo "Creating symlink to $config in ~/.config."
    ln -s $dir/$config/* $HOME/.config/$config
done

echo "Moving any existing dotfiles from /etc/pacman.d/hooks to $olddir"
mkdir -p ~/dotfiles_old/hooks
sudo mv /etc/pacman.d/hooks/* ~/dotfiles_old/hooks
echo "Creating symlink to hooks in /etc/pacman.d/hooks."
sudo mkdir -p /etc/pacman.d/hooks
sudo ln -s $dir/hooks/* /etc/pacman.d/hooks

echo "Moving any existing pkglist.txt to $olddir"
sudo mv /etc/pkglist.txt ~/dotfiles_old
echo "Creating symlink to /etc/pkglist.txt."
sudo ln -s $dir/pkglist.txt /etc/pkglist.txt
