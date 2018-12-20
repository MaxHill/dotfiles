#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Vim
ln -s ${BASEDIR}/vimrc ~/.vimrc
ln -s ${BASEDIR}/gvimrc ~/.gvimrc
ln -s ${BASEDIR}/vim/ ~/.vim
mkdir ~/.vim/swapfiles

# Ssh
ln -s ${BASEDIR}/ssh.config ~/.ssh/config

# Zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc
ln -s ${BASEDIR}/aliases.sh ~/.aliases.sh

# Git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

# Tmux
ln -s ${BASEDIR}/tmux.conf ~/.tmux.conf
# ln -s ${BASEDIR}/teamocil/ ~/.teamocil

# VsCode
ln -s ${BASEDIR}/vsCode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
ln -s ${BASEDIR}/vsCode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
ln -s ${BASEDIR}/vsCode/snippets/ ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets

# Ack
ln -s ${BASEDIR}/ackrc ~/.ackrc
