#!/usr/bin/env bash
set -e

function main {
    set -x
    download_plugins
    symlink_to_home
    set +x
}

function download_plugins {
    git submodule update --init --recursive
}

function symlink_to_home {
    echo "Symlinking to home."
    ln -fs $PWD/vim/vim $HOME/.vim
    ln -fs $PWD/vim/vimrc $HOME/.vimrc
    ln -fs $PWD/zsh/zshrc $HOME/.zshrc
    ln -fs $PWD/zsh/zsh $HOME/.zsh
    mkdir $HOME/.config; true
    ln -fs $PWD/fish $HOME/.config/fish
}

function update {
    set -x
    update_submodules
    # install gocode files
    echo "Re-downloading gocode vim files ..."
    curl -L "https://raw.github.com/nsf/gocode/master/vim/autoload/gocomplete.vim" > $PWD/vim/vim/autoload/gocomplete.vim
    curl -L "https://raw.github.com/nsf/gocode/master/vim/ftplugin/go.vim" > $PWD/vim/vim/ftplugin/go.vim

    set +x
    echo "Run :BundleInstall in vim to install all packages."
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
    echo "  install   Symlinks files to home directory (overwrites existing)."
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
