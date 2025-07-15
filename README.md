# Dotfiles

My personal dotfiles for Arch Linux, managed with Git for easy setup and synchronization across systems.

## ✨ Features

- **Simple setup:** One script to create all symlinks
- **Backup system:** Preserves existing dotfiles before overwriting
- **Inspired by:** [Michael Samelly's dotfiles management guide](https://blog.smalleycreative.com/using-git-and-github-to-manage-your-dotfiles/)

## 🚀 Installation

### Quick Start

1. Clone this repository to your home directory:
```bash
$ git clone https://github.com/parasilius/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
```
2. Run the setup script:
```bash
$ chmod +x setup.sh
./setup.sh
```

### What This Script Does

The setup script manages your dotfiles by:

1. Creating Backups:
    - Creates a backup directory at `~/dotfiles/.dotfiles_old`
    - Safely moves existing dotfiles to this backup directory before making changes
    - Preserves previous backups of privileged files by appending `.old` if conflicts occur

2. Managing User Dotfiles:
    - Creates symbolic links from your home directory to the dotfiles in this repo
    - Handles files in `~/.config` and other locations

3. Managing Privileged Files:
    - Copies (rather than symlinks) root-owned files to system locations

4. Smart Comparison:
    - Only makes changes when files differ (using `cmp -s`)
    - Preserves identical files without unnecessary operations
