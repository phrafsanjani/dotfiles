# Dotfiles

My personal dotfiles for Arch Linux, managed with Git for easy setup and synchronization across systems.

## ✨ Features

- **Simple setup:** One script to create all symlinks
- **Backup system:** Preserves existing dotfiles before overwriting
- **Inspired by:** [Michael Samelly's dotfiles management guide](https://blog.smalleycreative.com/using-git-and-github-to-manage-your-dotfiles/)

## 🚀 Installation

1. Clone this repository to your home directory:
```bash
$ git clone https://github.com/parasilius/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
```

2. Run the setup script:
```bash
$ chmod +x makesymlinks.sh
$ ./makesymlinks.sh
```

This will:
- Create symbolic links in the user's filesystem that point to the corresponding configuration files in `~/dotfiles`
- Backup existing dotfiles to `~/dotfiles_old`
