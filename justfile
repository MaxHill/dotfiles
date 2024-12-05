#!/usr/bin/env just --justfile
# SETTINGS
set dotenv-load := true
# set dotenv-filename := "app/.env"

# List available commands
default:
    @just --list

# DB
keyboard:
    sudo kanata --cfg ~/.config/kanata/kanata.kbd --debug

brew:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "brew" 

dependencies:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "dependencies"

symlinks:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "symlinks"


