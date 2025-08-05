# Prompt
precmd() {
    print -rP "%B%F{green}╭─%f%b[%B%F{cyan}%n%f%b%B%F{white}@%f%b%B%F{magenta}%m%f%b %B%F{blue}%~%f%b]"
}
PROMPT='%B%F{green}╰─%f%b%B%F{red}❯%f%b '

# History opts
HISTSIZE=1000000
HISTFILE=~/.zsh_history
SAVEHIST=1000000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ma=48;5;244;1"

# Aliases
alias ls="ls --color"
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
    echo -n "Current directory: $(pwd). Is this the External Hard Drive (EDH)? [y/N] "
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

# vi mode
bindkey -v
export KEYTIMEOUT=1

bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
zle-keymap-select () {
    if [[ $KEYMAP == vicmd ]]; then
        # the command mode for vi
        echo -ne "\e[2 q"
    else
        # the insert mode for vi
        echo -ne "\e[6 q"
    fi
}
precmd_functions+=(zle-keymap-select)
zle -N zle-keymap-select

# Make zsh autocomplete with up arrow
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Syntax highlighting
# requires zsh-syntax-highlighting package
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
# requires zsh-autosuggestions package
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
