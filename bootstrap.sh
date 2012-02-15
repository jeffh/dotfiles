#!/usr/bin/env bash
set -e

function main {
    download_plugins
    build_command_t
    symlink_to_home
}

function download_plugins {
    git submodule init
}

function build_command_t {
    # build command-t
    echo "Building Command-T"
    cd vim/.vim/bundle/command-t
    rake make
    # restore cwd
    cd ../../../..
}

function symlink_to_home {
    echo "Symlinking to home."
    ln -s $PWD/vim/.vim $HOME/.vim
    ln -s $PWD/vim/.vimrc $HOME/.vimrc
}

main
