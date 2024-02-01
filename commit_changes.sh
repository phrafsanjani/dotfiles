#!/bin/zsh

cd `dirname "$0$"`

cp $HOME/.zshrc .

git add --all
git commit -m "sync zsh config"
git push origin
