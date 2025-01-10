#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released as free software via MIT, see LICENSE file for details

title() { echo -e "\x1b[31m === \x1b[32m$1\x1b[0m"; }

uninstall() {
    title "Uninstall Vim configuration"
    read -rp "This will delete all Vim configuration, continue? [y/N] " confirm
    case $confirm in [Yy]|[Yy][Ee][Ss])
        title "Deleting vimrc, vim plugins and coc packages..."
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc/
    esac
}

# uninstall only if called as a script
if [ "$0" = "${BASH_SOURCE[0]}" ];then
    uninstall "$@"
fi
