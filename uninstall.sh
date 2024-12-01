#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# Suitable for Python, JavaScript, React, Vue, Bash, Docker and related files
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released as free software via MIT, see LICENSE file for details

# load package lists and functions from install script
source ./install.sh

# ask for removal of an npm package
ask_removal() {
    subtitle "$2"
    read -rp "Do you want to uninstall $2 using npm? [y/N] " confirm
    case $confirm in [Yy]|[Yy][Ee][Ss])
        cd ~ || exit
        npm uninstall "$(echo "$2" | cut -d "@" -f 1)"
        npm uninstall -g "$(echo "$2" | cut -d "@" -f 1)"
    esac
}

uninstall() {
    title "Uninstall Vim configuration"
    read -rp "This will delete all Vim configuration, continue? [y/N] " confirm
    case $confirm in [Yy]|[Yy][Ee][Ss])
        title "Deleting vimrc, vim plugins, eslint config and coc packages..."
        rm -rf ~/.vim/ ~/.config/coc/ ~/eslint.config.js
        title "Ask for individual package removal"
        npm config set prefix "$HOME/.local"
        for package in "${npm_packages[@]}";do
            ask_removal "$package"
        done
        ask_removal "eslint-config"
    esac
}

# start the setup if called as script
if [ "$0" = "${BASH_SOURCE[0]}" ];then
    uninstall "$@"
fi
