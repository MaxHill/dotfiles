#!/usr/bin/env just --justfile
# SETTINGS
set dotenv-load := true
# set dotenv-filename := "app/.env"

# List available commands
default:
    @just --list

# DB
keyboard:
    mprocs \
    "sudo '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'" \
    "sudo kanata --cfg ~/.config/kanata/kanata.kbd --debug"

brew:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "brew" 

dependencies:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "dependencies"

symlinks:
    ansible-playbook bootstrap.yml --ask-become-pass --tags "symlinks"


