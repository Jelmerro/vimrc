#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released as free software via MIT, see LICENSE file for details

# vim plugins installed in ~/.vim/pack/plugins/start
vim_plugins=(
    ap/vim-css-color
    chaimleib/vim-renpy
    honza/vim-snippets
    junegunn/fzf
    junegunn/fzf.vim
    laggardkernel/vim-one
    mbbill/undotree
    pangloss/vim-javascript
    RRethy/vim-illuminate
    instant-markdown/vim-instant-markdown
    tomtom/tcomment_vim
    tpope/vim-fugitive
    vim-airline/vim-airline
    wellle/context.vim
)

# coc plugin with extensions installed by npm into ~/.config/coc/extensions
coc_packages=(
    coc-clangd@latest
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
title() { echo -e "\x1b[31m === \x1b[32m$1\x1b[0m"; }
subtitle() { echo -e "\x1b[31m - \x1b[33m$1\x1b[0m"; }

# clone and update a plugin in the vim/pack directory
plugin() {
    subtitle "$1"
    mkdir -p ~/.vim/pack/plugins/start
    cd ~/.vim/pack/plugins/start || exit
    folder=$(basename "$1")
    if which git 1>/dev/null 2>/dev/null;then
        if [ -d "$folder" ] && [ ! -d "$folder/.git" ];then
            rm -rf "$folder"
        fi
        if [ ! -d "$folder" ];then
            if [ -n "$2" ];then
                git clone -b "$2" --depth 1 "https://github.com/$1"
            else
                git clone --depth 1 "https://github.com/$1"
            fi
        fi
        cd "$folder" || exit
        if [ -n "$2" ];then
            git checkout "$2"
        fi
        git pull --all
        return 0
    fi
    if which tar 1>/dev/null 2>/dev/null;then
        if which curl 1>/dev/null 2>/dev/null;then
            rm -rf "$folder"
            if [ -n "$2" ];then
                curl -sSL "https://github.com/$1/archive/$2.tar.gz" | tar xzf - --one-top-level="$folder" --strip-components 1
            else
                curl -sSL "https://api.github.com/repos/$1/tarball" | tar xzf - --one-top-level="$folder" --strip-components 1
            fi
            return 0
        fi
    fi
    subtitle "Can't download vim plugin because either git or curl+tar are required"
    return 1
}

setup() {
    title "Jelmerro's Vim installation script"
    subtitle "See https://github.com/Jelmerro/vimrc for info and updates"
    if [[ $1 = 'clean' ]];then
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc/
    fi

    subtitle "Copy config files"
    mkdir -p ~/.vim/spell/
    cd "$(dirname "$(realpath "$0")")" || exit
    cp vimrc ~/.vim/vimrc
    cp nl.utf-8.spl ~/.vim/spell/nl.utf-8.spl
    if which npm 1>/dev/null 2>/dev/null;then
        cp coc-settings.json ~/.vim/coc-settings.json
    fi
    if [[ $1 = 'config-only' ]];then
        title "Done"
        exit
    fi

    title "Install/update Vim plugins"
    for plug in "${vim_plugins[@]}";do
        plugin "$plug"
    done

    if [[ $1 = 'no-lsp' ]];then
        title "Done"
        exit
    fi

    title "Install/update CoC extensions"
    if which npm 1>/dev/null 2>/dev/null;then
        plugin "neoclide/coc.nvim" "release"
        mkdir -p ~/.config/coc/extensions
        cd ~/.config/coc || exit
        echo '{"coc-eslint|global": {"eslintAlwaysAllowExecution": true}}' > memos.json
        cd ~/.config/coc/extensions || exit
        echo '{"dependencies":{}}' > package.json
        npm --ignore-scripts --install-strategy nested --loglevel=error --force --only=prod --no-audit --no-fund i "${coc_packages[@]}"
    else
        subtitle "Skipping CoC installation because npm is missing"
    fi
    title "Done"
}

# start the setup if called as script
if [ "$0" = "${BASH_SOURCE[0]}" ];then
    setup "$@"
fi
