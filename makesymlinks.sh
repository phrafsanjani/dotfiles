#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$HOME/dotfiles"                    # dotfiles directory
olddir="$HOME/dotfiles_old"             # old dotfiles backup directory
files="zshrc"                           # list of files/folders to symlink in homedir

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

echo "Moving any existing env from ~/.config/go to $olddir"
mkdir -p ~/dotfiles_old/go
mv ~/.config/go/env ~/dotfiles_old/go
echo "Creating symlink to go/env in ~/.config/go."
ln -s $dir/go/env $HOME/.config/go/env

echo "Moving any existing init.vim from ~/.config/nvim to $olddir"
mkdir -p ~/dotfiles_old/nvim
mv ~/.config/nvim/init.vim ~/dotfiles_old/nvim
echo "Creating symlink to nvim/init.vim in ~/.config/nvim."
ln -s $dir/nvim/init.vim $HOME/.config/nvim/init.vim

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

echo "Moving any existing VS Code settings.json to $olddir"
mv ~/.config/Code/User/settings.json ~/dotfiles_old/code-settings.json
echo "Creating symlink to code-settings.json."
ln -s $dir/code-settings.json $HOME/.config/Code/User/settings.json

fontsconfig_dir="$HOME/.config/fontconfig/fonts.conf"
echo "Moving any existing fonts.conf to $olddir"
mv $fontsconfig_dir ~/dotfiles_old
echo "Creating symlink to fonts.conf."
ln -s $dir/fonts.conf $fontsconfig_dir

force_publickey_auth_conf="/etc/ssh/sshd_config.d/20-force_publickey_auth.conf"
echo "Moving any existing 20-force_publickey_auth.conf to $olddir"
sudo mv $force_publickey_auth_conf ~/dotfiles_old
echo "Creating symlink to force_publickey_auth.conf."
sudo ln -s $dir/force_publickey_auth.conf $force_publickey_auth_conf
