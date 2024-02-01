#!/bin/zsh

cd `dirname "$0"`

if [[ $(diff $HOME/.zshrc .zshrc) ]]; then
    cp $HOME/.zshrc .

    git add .zshrc
    git commit -m "Sync zsh config"
    git push origin
fi
