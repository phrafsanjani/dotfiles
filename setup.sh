#!/bin/bash

dir="$HOME/dotfiles"
olddir="$dir/.dotfiles_old"      # old dotfiles backup directory

if [ -d "$olddir" ]; then
    echo "Directory '$olddir' already exists - continuing..."
else
    echo -n "Creating $olddir"
    mkdir -p $olddir
fi

home_files="zshrc"
for file in $home_files; do
    if cmp -s "~/.$file" "$olddir/$file"; then
        echo "~/.$file and $olddir/$file are identical - continuing..."
    else
        echo "Moving ".$file" from ~ to $olddir"
        mv ~/.$file $olddir/$file
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file $HOME/.$file
    fi
done

setup_config() {
    local user_config_path="$1"
    local dotfiles_config_dir="$2"
    local dotfiles_config_file="$3"

    # Validate all arguments are provided
    if [[ $# -ne 3 ]]; then
        echo "Error: Missing arguments"
        echo "Usage: setup_config user_config_path dotfiles_config_dir dotfiles_config_file"
        return 1
    fi

    local backup_config_path="$olddir/$dotfiles_config_dir/$dotfiles_config_file"
    local dotfiles_config_path="$dir/$dotfiles_config_dir/$dotfiles_config_file"
    if cmp -s "$user_config_path" "$backup_config_path"; then
        echo "$user_config_path and $backup_config_path are identical - continuing..."
    else
        if [ -f "$user_config_path" ]; then
            echo "Backing up existing $user_config_path to $olddir"
            mkdir -p "$olddir/$dotfiles_config_dir"
            mv "$user_config_path" "$backup_config_path"
        fi
        echo "Creating symlink to $dotfiles_config_path"
        ln -s "$dotfiles_config_path" "$user_config_path"
    fi
}

setup_configs() {
    local user_configs_dir="$1"
    local configs_dir="$2"

    # Validate all arguments are provided
    if [[ $# -ne 2 ]]; then
        echo "Error: Missing arguments"
        echo "Usage: setup_configs user_configs_dir configs_dir"
        return 1
    fi

    local backup_configs_dir="$olddir/$configs_dir"
    local dotfiles_configs_dir="$dir/$configs_dir"
    for config_path in "$dotfiles_configs_dir"/*; do
        local config=$(basename "$config_path")
        local user_config_path="$user_configs_dir/$config"
        local dotfiles_config_path="$dotfiles_configs_dir/$config"
        local backup_config_path="$backup_configs_dir/$config"
        if cmp -s "$user_config_path" "$backup_config_path"; then
            echo "$user_config_path and $backup_config_path are identical - continuing..."
        else
            if [ -f "$user_config_path" ]; then
                echo "Backing up existing $user_config_path to $olddir"
                mkdir -p "$olddir/$dotfiles_configs_dir"
                mv "$user_config_path" "$backup_config_path"
            fi
            echo "Creating symlink to $dotfiles_config_path"
            ln -s "$dotfiles_configs_dir/*" "$user_configs_dir"
        fi
    done
}

setup_root_config() {
    local user_config_path="$1"
    local dotfiles_config_dir="$2"
    local dotfiles_config_file="$3"

    # Validate all arguments are provided
    if [[ $# -ne 3 ]]; then
        echo "Error: Missing arguments"
        echo "Usage: setup_root_config user_config_path dotfiles_config_dir dotfiles_config_file"
        return 1
    fi

    local backup_config_path="$olddir/$dotfiles_config_dir/$dotfiles_config_file"
    local dotfiles_config_path="$dir/$dotfiles_config_dir/$dotfiles_config_file"
    if [ -f "$user_config_path" ]; then
        if cmp -s "$user_config_path" "$backup_config_path"; then
            echo "$user_config_path and $backup_config_path are identical - continuing..."
        else
            echo "Backing up existing $user_config_path to $olddir"
            mkdir -p "$olddir/$dotfiles_configs_dir"
            if [ -f "$user_config_path" ]; then
                if [ -f "$backup_config_path" ]; then
                    echo "Moving previous $backup_config_path to $backup_config_path.old"
                    sudo mv "$backup_config_path" "$backup_config_path.old"
                fi
                sudo mv "$user_config_path" "$backup_config_path"
            fi
        fi
    fi
    echo "Copying $dotfiles_config_path to $user_config_path"
    sudo cp "$dotfiles_config_path" "$user_config_path"
}

setup_root_configs() {
    local user_configs_dir="$1"
    local configs_dir="$2"

    # Validate all arguments are provided
    if [[ $# -ne 2 ]]; then
        echo "Error: Missing arguments"
        echo "Usage: setup_root_configs user_configs_dir configs_dir"
        return 1
    fi

    local backup_configs_dir="$olddir/$configs_dir"
    local dotfiles_configs_dir="$dir/$configs_dir"
    for config_path in "$dotfiles_configs_dir"/*; do
        local config=$(basename "$config_path")
        local user_config_path="$user_configs_dir/$config"
        local dotfiles_config_path="$dotfiles_configs_dir/$config"
        local backup_config_path="$backup_configs_dir/$config"
        if [ -f "$user_config_path" ]; then
            if cmp -s "$user_config_path" "$backup_config_path"; then
                echo "$user_config_path and $backup_config_path are identical - continuing..."
            else
                echo "Backing up existing $user_config_path to $olddir"
                mkdir -p "$backup_configs_dir"
                if [ -f "$user_config_path" ]; then
                    if [ -f "$backup_config_path" ]; then
                        echo "Moving previous $backup_config_path to $backup_config_path.old"
                        sudo mv "$backup_config_path" "$backup_config_path.old"
                    fi
                    sudo mv "$user_config_path" "$backup_config_path"
                fi
            fi
        fi
        echo "Copying $dotfiles_config_path to $user_configs_dir"
        sudo cp "$dotfiles_config_path" "$user_configs_dir"
    done
}

setup_config "$HOME/.config/go/env" "go" "env"
setup_config "$HOME/.config/nvim/init.vim" "nvim" "init.vim"
setup_root_configs "/etc/pacman.d/hooks" "hooks"
setup_root_config "/etc/pkglist.txt" "." "pkglist.txt"
setup_config "$HOME/.config/Code/User/settings.json" "." "code-settings.json"
setup_config "$HOME/.config/fontconfig/fonts.conf" "." "fonts.conf"
setup_root_configs "/etc/ssh/sshd_config.d" "sshd_config"
