#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released as free software via MIT, see LICENSE file for details

# packages that are required system-wide for development and for use in vim
system_packages=(git npm vim)
# highly recommended system packages are: rg fzf bat python3 shellcheck shfmt

# vim plugins installed in ~/.vim/pack/plugins/start
vim_plugins=(
    ap/vim-css-color
    chaimleib/vim-renpy
    honza/vim-snippets
    junegunn/fzf
    junegunn/fzf.vim
    laggardkernel/vim-one
    lambdalisue/suda.vim
    mbbill/undotree
    "neoclide/coc.nvim release"
    pangloss/vim-javascript
    RRethy/vim-illuminate
    suan/vim-instant-markdown
    tomtom/tcomment_vim
    tpope/vim-fugitive
    vim-airline/vim-airline
    wellle/context.vim
)

# coc plugin with extensions installed by npm into ~/.config/coc/extensions
coc_packages=(
    coc-css@latest
    coc-eslint@latest
    coc-git@latest
    coc-highlight@latest
    coc-html@latest
    coc-json@latest
    coc-pyright@latest
    coc-snippets@latest
    coc-tsserver@latest
    coc-vimlsp@latest
)

# show colorful titles for installation steps
title() { echo -e "\n\x1b[31m === \x1b[32m$1\x1b[0m\n"; }
subtitle() { echo -e "\n\x1b[31m - \x1b[33m$1\x1b[0m\n"; }

# clone and update a plugin in the vim/pack directory
plugin() {
    subtitle "$1"
    mkdir -p ~/.vim/pack/plugins/start
    cd ~/.vim/pack/plugins/start || exit
    if [ ! -d "$(basename "$1")" ];then
        git clone "https://github.com/$1"
    fi
    cd "$(basename "$1")" || exit
    if [ -n "$2" ];then
        git checkout "$2"
    fi
    git pull --all
}

setup() {
    title "Jelmerro's Vim installation script"
    echo "See https://github.com/Jelmerro/vimrc for info and updates"
    subtitle "Check required system software"
    for software in "${system_packages[@]}";do
        which "$software"
        if [ $? == 1 ];then
            echo "$software should be installed on your system"
            exit
        fi
    done
    if [[ $1 = 'clean' ]];then
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc/
    fi
    subtitle "Copy config files"
    mkdir -p ~/.vim/spell/
    cd "$(dirname "$(realpath "$0")")" || exit
    cp vimrc ~/.vim/vimrc
    cp nl.utf-8.spl ~/.vim/spell/nl.utf-8.spl
    cp coc-settings.json ~/.vim/coc-settings.json
    if [[ $1 = 'config-only' ]];then
        title "Done"
        exit
    fi

    title "Install/update Vim plugins"
    for plug in "${vim_plugins[@]}";do
        # shellcheck disable=SC2086
        plugin $plug
    done

    title "Install/update CoC extensions"
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc || exit
    echo '{"coc-eslint|global": {"eslintAlwaysAllowExecution": true}}' > memos.json
    cd ~/.config/coc/extensions || exit
    echo '{"dependencies":{}}' > package.json
    npm --loglevel=error i --force --ignore-scripts --no-package-lock --only=prod --no-audit --no-fund "${coc_packages[@]}"
    for package in "${coc_packages[@]}";do
        cd "$HOME/.config/coc/extensions/node_modules/${package%%@*}" || continue
        npm --loglevel=error i --force --ignore-scripts --only=prod --no-audit --no-fund
    done
    title "Done"
}

# start the setup if called as script
if [ "$0" = "${BASH_SOURCE[0]}" ];then
    setup "$@"
fi
