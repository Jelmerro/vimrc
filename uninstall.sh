# Jelmerro's Vim configuration
# Configure Vim with autocompletion, keybindings, editorconfig and linting
# Suitable for Python, JavaScript, Vue, Docker and related files
# For updates and info go to https://github.com/Jelmerro/vimrc
# This file is released into the public domain, see UNLICENSE file for details

# load package lists and functions from install script
source ./install.sh

# ask for removal of a pip or npm package
ask_removal() {
    subtitle $2
    read -p "Do you want to uninstall $2 using $1? [y/N] " uninstall
    case $uninstall in [Yy]|[Yy][Ee][Ss])
        if [ $1 == "pip3" ];then
            $1 uninstall -y $2
        fi
        if [ $1 == "npm" ];then
            $1 uninstall -g `echo $2 | cut -d "@" -f 1`
        fi
    esac
}

title "Uninstall Vim configuration"
read -p "This will delete all Vim configuration, continue? [y/N] " uninstall
case $uninstall in [Yy]|[Yy][Ee][Ss])
    title "Deleting vim plugins, eslint config and coc packages completely..."
    rm -rf ~/.vim/
    rm -rf ~/.config/coc/
    rm ~/.eslintrc.json

    title "Ask for individual package removal"
    for package in ${pip_packages[@]};do
        ask_removal pip3 $package
    done
    npm config set prefix "~/.local"
    for package in ${npm_packages[@]};do
        ask_removal npm $package
    done
esac
