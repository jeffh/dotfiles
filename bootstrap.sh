#!/usr/bin/env bash
set -e

function main {
    download_plugins
    symlink_to_home
}

function download_plugins {
    git submodule update --init --recursive
    echo "Run :BundleInstall in vim to install all packages."
}

function symlink_to_home {
    echo "Symlinking to home."
    ln -s $PWD/vim/vim $HOME/.vim
    ln -s $PWD/vim/vimrc $HOME/.vimrc
    ln -s $PWD/zshrc $HOME/.zshrc
}

function update {
    update_submodules
    # install gocode files
    echo "Re-downloading gocode vim files ..."
    curl -L "https://raw.github.com/nsf/gocode/master/vim/autoload/gocomplete.vim" > $PWD/vim/.vim/autoload/gocomplete.vim
    curl -L "https://raw.github.com/nsf/gocode/master/vim/ftplugin/go.vim" > $PWD/vim/.vim/ftplugin/go.vim
}

function update_submodules {
    echo "Updating submodules ..."
    CWD=$PWD
    for i in `git submodule status | cut -f3 -d ' '`
    do
        echo "Updating $i ..."
        cd $CWD/$i
        git reset --hard
        git checkout master
        git pull
        git checkout master
    done
    cd $CWD
}


function help {
    echo "Usage: $0 COMMAND"
    echo
    echo "Commands:"
    echo "  install   Sets up vim config. Symlinks files to home directory."
    echo "  update    Updates all submodules & gocode. Changes the repository."
    echo "  help      This help"
    echo
}

case "$1" in
    "install") main;;
    "upgrade"|"update") update;;
    "help") help;;
    *) echo "Invalid command. Use '$0 help' for help";;
esac
