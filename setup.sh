#!/bin/bash

set -euo pipefail

dir="$HOME/dotfiles"
if [ ! -d "$dir" ]; then
    echo "FATAL: dotfiles directory '$dir' does not exist." >&2
    exit 1
fi

olddir="$dir/.dotfiles_old"      # old dotfiles backup directory
if [ -d "$olddir" ]; then
    echo "Directory '$olddir' already exists - continuing..."
else
    echo -n "Creating $olddir"
    mkdir -p $olddir
fi

backup_config() {
    user_config_path=$1
    backup_config_path=$2
    if [ -f "$user_config_path" ]; then
        if cmp -s "$user_config_path" "$backup_config_path"; then
            if [ ! -L "$user_config_path" ]; then
                echo "Removing $user_config_path"
                rm $user_config_path
            fi
            echo "$user_config_path and $backup_config_path are identical - continuing..."
        else
            if [ -f "$backup_config_path" ]; then
                echo "Moving previous $backup_config_path to $backup_config_path.old"
                mv "$backup_config_path" "$backup_config_path.old"
            fi
            echo "Writing $user_config_path contents to $backup_config_path"
            mkdir -p "$(dirname "$backup_config_path")" && cat $user_config_path > $backup_config_path
            echo "Removing $user_config_path"
            rm $user_config_path
        fi
    fi
}

home_files="zshrc"
for file in $home_files; do
    backup_config "$HOME/.$file" "$olddir/$file"
    echo "Creating symlink to $dir/$file in home directory."
    ln -s $dir/$file $HOME/.$file
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
    backup_config "$user_config_path" "$backup_config_path"
    echo "Creating symlink to $dotfiles_config_path"
    ln -s "$dotfiles_config_path" "$user_config_path"
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
        backup_config "$user_config_path" "$backup_config_path"
    done
    echo "Creating symlink to $dotfiles_configs_dir"
    ln -s "$dotfiles_configs_dir/*" "$user_configs_dir"
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

# Apply DarkMaterialShell Power Settings
apply_dms_power() {
    # --- Config ---
    local dms_settings="$HOME/.config/DankMaterialShell/settings.json"
    local power_json='{
        "acSuspendTimeout": 300,
        "batterySuspendTimeout": 300,
        "batteryChargeLimit": 85,
        "batteryNotifyLow": true,
        "lockBeforeSuspend": true
    }'

    # --- 1. Check DMS is the current shell ---
    if ! pgrep -x dms >/dev/null 2>&1; then
        echo "DMS does not appear to be running. Aborting." >&2
        return 1
    fi

    if [ ! -d "$HOME/.config/DankMaterialShell" ]; then
        echo "DMS config directory not found at $HOME/.config/DankMaterialShell" >&2
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "jq is required but not installed. Install it and re-run." >&2
        return 1
    fi

    # --- 2. Create settings.json if missing ---
    if [ ! -f "$dms_settings" ]; then
        echo "{}" > "$dms_settings"
    fi

    # --- 3. Early exit if all power values already match ---
    if jq -e --argjson power "$power_json" '
        . as $s
        | ($power | to_entries | all(. as $e | $s[$e.key] == $e.value))
    ' "$dms_settings" >/dev/null 2>&1; then
        echo "All power settings already match. Nothing to do."
        return 0
    fi

    # --- 4. Merge power keys, preserving everything else ---
    local tmp
    tmp=$(mktemp)
    # shellcheck disable=SC2064
    trap "rm -f '$tmp'" RETURN

    if ! jq --argjson power "$power_json" '. * $power' "$dms_settings" > "$tmp"; then
        echo "jq failed to process $dms_settings." >&2
        return 1
    fi

    if ! jq empty "$tmp" >/dev/null 2>&1; then
        echo "jq produced invalid JSON; leaving original file untouched." >&2
        return 1
    fi

    mv "$tmp" "$dms_settings"
    echo "Merged power settings into $dms_settings"

    # --- 5. Restart DMS to apply ---
    if ! dms restart; then
        echo "Warning: failed to restart DMS. Settings written but not applied." >&2
        return 1
    fi
    echo "DMS restarted."
    return 0
}

setup_config "$HOME/.config/go/env" "go" "env"
setup_config "$HOME/.config/nvim/init.lua" "nvim" "init.lua"
setup_root_configs "/etc/pacman.d/hooks" "hooks"
setup_root_config "/etc/pkglist.txt" "." "pkglist.txt"
setup_config "$HOME/.config/niri/config.kdl" "." "niri-config.kdl"
setup_config "$HOME/.config/ghostty/config.ghostty" "." "config.ghostty"
setup_config "$HOME/.config/mimeapps.list" "." "mimeapps.list"
setup_config "$HOME/.config/Code/User/settings.json" "." "code-settings.json"
setup_config "$HOME/.config/fontconfig/fonts.conf" "." "fonts.conf"
setup_root_configs "/etc/ssh/sshd_config.d" "sshd_config"
setup_root_config "/etc/tsocks.conf" "." "tsocks.conf"
apply_dms_power
