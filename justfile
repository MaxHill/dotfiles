#!/usr/bin/env just --justfile
# SETTINGS
set dotenv-load := true
# set dotenv-filename := "app/.env"

# DB
brew:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "brew" 
dependencies:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "dependencies"
symlinks:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "symlinks"


