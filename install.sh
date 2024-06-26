#!/bin/bash
# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# Suitable for Python, JavaScript, React, Vue, Bash, Docker and related files
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released into the public domain, see UNLICENSE file for details

# packages that are required system-wide for development and for use in vim
system_packages=(git node npm pip3 python3 vim)
# highly recommended system packages are: rg fzf bat

# pip linting packages installed into ~/.local
pip_packages=(autopep8 flake8 pylint)

# global npm packages installed into ~/.local
npm_packages=(
    bash-language-server@latest
    instant-markdown-d@latest
)

# vim plugins installed in ~/.vim/pack/plugins/start
vim_plugins=(
    ap/vim-css-color
    chaimleib/vim-renpy
    editorconfig/editorconfig-vim
    digitaltoad/vim-pug
    honza/vim-snippets
    junegunn/fzf
    junegunn/fzf.vim
    laggardkernel/vim-one
    lambdalisue/suda.vim
    MaxMEllon/vim-jsx-pretty
    mbbill/undotree
    "neoclide/coc.nvim release"
    pangloss/vim-javascript
    posva/vim-vue
    RRethy/vim-illuminate
    suan/vim-instant-markdown
    tomtom/tcomment_vim
    tpope/vim-fugitive
    vim-airline/vim-airline
    vim-ide/scss-syntax.vim
    wellle/context.vim
)

# coc plugin with extensions installed by npm into ~/.config/coc/extensions
coc_packages=(
    coc-css@latest
    coc-dictionary@latest
    coc-docker@latest
    coc-emoji@latest
    coc-eslint@latest
    coc-git@latest
    coc-highlight@latest
    coc-html@latest
    coc-jedi@latest
    coc-json@latest
    coc-markdownlint@latest
    coc-pyright@latest
    coc-react-refactor@latest
    coc-snippets@latest
    coc-syntax@latest
    coc-tailwindcss@latest
    coc-tsserver@latest
    coc-vetur@latest
    coc-vimlsp@latest
    coc-word@latest
    coc-yaml@latest
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
        rm -rf ~/.vim/spell/ ~/.vim/pack/ ~/.vim/vimrc ~/.vim/coc-settings.json ~/.config/coc
    fi
    subtitle "Copy config files"
    mkdir -p ~/.vim/spell/
    cd "$(dirname "$(realpath "$0")")" || exit
    cp eslint.config.js ~
    cp vimrc ~/.vim/vimrc
    cp nl.utf-8.spl ~/.vim/spell/nl.utf-8.spl
    cp coc-settings.json ~/.vim/coc-settings.json
    if [[ $1 = 'config-only' ]];then
        title "Done"
        exit
    fi

    title "Install/update linters and parsers"
    subtitle "Pip packages"
    pip3 install --user -U "${pip_packages[@]}"
    subtitle "Npm packages"
    npm config set prefix "$HOME/.local"
    npm --loglevel=error i --force --no-audit --no-fund -g "${npm_packages[@]}"
    cd ~ || exit
    npm --loglevel=error i --force --no-audit --no-fund -D https://github.com/Jelmerro/eslint-config
    npm dedup

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
