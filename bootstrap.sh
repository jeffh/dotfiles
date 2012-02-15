#!/usr/bin/env bash
set -e

function main {
    git submodule init
    command_t
    symlink_to_home
}

function command_t {
    # build command-t
    echo "Building Command-T"
    cd vim/.vim/bundle/command-t
    rake make
    cd ../../../..
}

function symlink_to_home {
    ln -s $PWD/vim/.vim $HOME/.vim
    ln -s $PWD/vim/.vimrc $HOME/.vimrc
}

main
