#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Vim
[ -e ~/.vimrc ] && rm  ~/.vimrc
[ -e ~/.gvimrc ] && rm ~/.gvimrc
[ -e ~/.vim ] && rm -rf ~/.vim

# Zsh
[ -e ~/.zshrc ] && rm ~/.zshrc
[ -e ~/.aliases.sh ] && rm ~/.aliases.sh

# Git
[ -e ~/.gitconfig ] && rm ~/.gitconfig

# Tmux
[ -e ~/.tmux.conf ] && rm ~/.tmux.conf
# [ -e ~/.teamocil ] && rm -rf ~/.teamocil

# VsCode
[ -e ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json ] && rm ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
[ -e ~/Library/Application\ Support/Code/User/keybindings.json ] && rm ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
[ -e ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets ] && rm -rf ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets


# Ack
[ -e ~/.ackrc ] && rm ~/.ackrc
