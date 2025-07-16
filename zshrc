# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/parsa/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# `newc` creates a test.c file with some initial code in . directory.
alias newc="echo \"#include <stdio.h>\n\nint main(void)\n{\n\x20\x20\x20\x20return 0;\n}\" >> test.c && nvim test.c"
# `newcpp` creates a test.cpp file with some initial code in . directory.
alias newcpp="echo \"#include <iostream>\n\nusing namespace std;\n\nint main()\n{\n}\" >> test.cpp && nvim test.cpp"
# `newjava` creates a test.java file with some initial code in . directory.
alias newjava="echo \"public class Test\n{\n\tpublic static void main(String[] args)\n\t{\n\t}\n}\" >> Test.java && nvim Test.java"
alias subtitle-workshop="cd $HOME/GitHub/subtitle-workshop && node app.js"
alias sioyek="QT_QPA_PLATFORM=xcb sioyek"
# this function downloads the specific letter of Moral Letters to Lucilius
download-moral-letter() { youtube-dl -x --audio-format m4a https://www.youtube.com/playlist\?list\=PLzKrfPkpj5om1kEBj7c80cwjJ1JS78FL7 --playlist-items "$1" -o '%(title)s.%(ext)s' }
proton-connect() {
    finished=false
    counter=0
    while ! $finished; do
        if [ $counter -eq 0 ]; then
            protonvpn-cli c -f && finished=true
            let "counter++"
        else
            protonvpn-cli c -r && finished=true
        fi
    done
}
# function to sync subtitles with video titles
subtitle-sync() {
    2=`printf %02d $2`
    directory=$(echo */)
    subtitle=$(ls $directory | grep -e ""$1".*"$2"")
    mv "$directory$subtitle" .
    1=`printf %02d $1`
    mv "$subtitle" "${$(ls | grep -e "s"$1".*e"$2".*\.mkv$" -e "S"$1".*E"$2".*\.mkv$")%.mkv}.srt"
}
# update Calibre
update-calibre() {sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin }
# syncing hard drive
hdd-sync() {
    echo -n "Current directory is $(pwd). Continue? [y/N] "
    read response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        rsync -arv --exclude .git/ --delete $HOME/Academia/ Academia
        rsync -arv --delete $HOME/Calibre\ Library/ Calibre\ Library
        rsync -arv --delete $HOME/Downloads/ Downloads
        rsync -arv --delete $HOME/Documents/ Documents
        rsync -arv --delete $HOME/Music/ Music
        rsync -arv --exclude .git/ --delete $HOME/dotfiles/ dotfiles
        rsync -arv --exclude .git/ --delete $HOME/GitHub/ GitHub
        rsync -arv --delete $HOME/Videos/ Videos
        rsync -arv --delete $HOME/Pictures/ Pictures
        rsync -arv --delete $HOME/Zotero/ Zotero
    fi
}
# download best-quality mp4 video from YouTube
# use --proxy "socks://localhost:<port>" if needed
yt-highdl() { yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 $1 --cookies-from-browser firefox }

export PATH=$PATH:~/.local/bin
export PATH=/opt/jdk-21.0.2+13/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/parsa/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/parsa/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/parsa/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/parsa/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

