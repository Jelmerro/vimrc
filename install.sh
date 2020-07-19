# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# Suitable for Python, JavaScript, Vue, Bash, Docker and related filetypes
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released into the public domain, see UNLICENSE file for details

# packages that are required system-wide for development and for use in vim
system_packages=(node npm pip3 python3 vim)
# highly recommended system packages are: rg fzf

# pip linting packages installed into ~/.local
pip_packages=(autopep8 flake8 pylint)

# npm linting packages installed into ~/.local
npm_packages=(
    bash-language-server@latest
    eslint@latest
    eslint-plugin-vue@latest
    instant-markdown-d@latest
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
    coc-json@latest
    coc-markdownlint@latest
    coc-python@latest
    coc-snippets@latest
    coc-syntax@latest
    coc-tailwindcss@latest
    coc-tsserver@latest
    coc-vetur@latest
    coc-vimlsp@latest
    coc-word@latest
    coc-yaml@latest
)
coc_settings='{
    "coc.source.syntax.priority": 1,
    "diagnostic.enableHighlightLineNumber": false,
    "diagnostic.errorSign": ">>",
    "diagnostic.hintSign": ">>",
    "diagnostic.infoSign": ">>",
    "diagnostic.warningSign": ">>",
    "git.addedSign.text": "+",
    "git.changedSign.text": "~",
    "git.changeRemovedSign.text": "±",
    "git.removedSign.text": ".",
    "git.topRemovedSign.text": "^",
    "languageserver": {
        "bash": {
            "args": ["start"],
            "command": "bash-language-server",
            "filetypes": ["bash", "sh"],
            "ignoredRootPaths": []
        }
    },
    "python.jediEnabled": false,
    "python.linting.flake8Enabled": true,
    "python.linting.pylintEnabled": true,
    "python.linting.pylintArgs": [
        "--disable=C0103",
        "--disable=C0112",
        "--disable=C0114",
        "--disable=C0115",
        "--disable=C0116",
        "--disable=C0301",
        "--disable=R0902",
        "--disable=R0903",
        "--disable=R0904",
        "--disable=W0621"
    ],
    "python.linting.pylintCategorySeverity.convention": "Hint",
    "python.linting.pylintUseMinimalCheckers": false,
    "tailwindCSS.headwind.runOnSave": false
}'

# vim plugins installed in ~/.vim/pack/plugins/start
vim_plugins=(
    editorconfig/editorconfig-vim
    digitaltoad/vim-pug
    honza/vim-snippets
    joshdick/onedark.vim
    junegunn/fzf
    junegunn/fzf.vim
    lambdalisue/suda.vim
    "neoclide/coc.nvim release"
    pangloss/vim-javascript
    posva/vim-vue
    RRethy/vim-illuminate
    suan/vim-instant-markdown
    tomtom/tcomment_vim
    tpope/vim-fugitive
    vim-airline/vim-airline
    vim-ide/scss-syntax.vim
)

# show colorful titles for installation steps
title() { echo -e "\n\x1b[31m === \x1b[32m$1\x1b[0m\n"; }
subtitle() { echo -e "\n\x1b[31m - \x1b[33m$1\x1b[0m\n"; }

# clone and update a plugin in the vim/pack directory
plugin() {
    subtitle "$1"
    mkdir -p ~/.vim/pack/plugins/start
    cd ~/.vim/pack/plugins/start
    if [ ! -d $(basename $1) ];then
        git clone https://github.com/$1
    fi
    cd $(basename $1)
    git checkout $2
    git pull --all
}

# store the current script location directory to copy the config files from
scriptdir=$(dirname $(realpath $0))

setup() {
    title "Jelmerro's Vim installation script"
    echo "See https://github.com/Jelmerro/vimrc for info and updates"
    # check if all the required software is present
    subtitle "Check required system software"
    for software in ${system_packages[@]};do
        which $software
        if [ $? == 1 ];then
            echo $software should be installed on your system
            exit
        fi
    done
    # install linters for the current user globally into ~/.local folder
    title "Install/update linters and parsers"
    subtitle "Pip packages"
    pip3 install --user -U ${pip_packages[@]}
    subtitle "Npm packages"
    npm config set prefix "~/.local"
    npm i -g ${npm_packages[@]}
    # clean current configuration if requested
    if [[ $1 = clean ]];then
        rm -rf ~/.vim ~/.config/coc
    fi
    # install plugins
    title "Install/update Vim plugins"
    for plug in "${vim_plugins[@]}";do
        plugin $plug
    done
    # conquer of completion installation steps
    title "Install/update COC extensions"
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc/extensions
    echo '{"dependencies":{}}' > package.json
    npm i ${coc_packages[@]} --ignore-scripts --no-package-lock --only=prod
    echo $coc_settings > ~/.vim/coc-settings.json
    # copy setting files
    title "Copy config files"
    cd $scriptdir
    cp .eslintrc.json ~
    cp vimrc ~/.vim/vimrc
    title "Done"
}

# start the setup if called as script
$(return >/dev/null 2>&1)
if [ $? != 0 ];then
    setup $1
fi
