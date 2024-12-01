#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# Suitable for Python, JavaScript, React, Vue, Bash, Docker and related files
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released as free software via MIT, see LICENSE file for details

# load package lists and functions from install script
source ./install.sh

uninstall() {
    title "Uninstall Vim configuration"
    read -rp "This will delete all Vim configuration, continue? [y/N] " confirm
    case $confirm in [Yy]|[Yy][Ee][Ss])
        title "Deleting vimrc, vim plugins and coc packages..."
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc/
    esac
}

# start the setup if called as script
if [ "$0" = "${BASH_SOURCE[0]}" ];then
    uninstall "$@"
fi
