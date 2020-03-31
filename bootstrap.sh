#!/usr/bin/env bash
set -e

function run {
    echo " >> $@"
    $@
}

function main {
    download_plugins
    symlink_to_home
    setup_vim
    print_post_install_message
}

function print_post_install_message {
    echo
    echo "Done! The following steps need to be done manually:"
    echo " - open emacs to install packages out of the box"
    echo
    echo
}

function download_plugins {
    echo
    echo "Downloading plugins"
    run git submodule update --init --recursive
}

function link {
    if [ -L "$2" ]; then
        rm "$2"
    fi
    if [ -d "$2" ]; then
        rm -r "$2"
    fi
    ln -fs "$1" "$2"
}

function symlink_to_home {
    echo
    echo "Symlinking configuration to $HOME"
    echo " - vim (.vim, .vimrc)"
    link $PWD/vim/vim $HOME/.vim
    link $PWD/vim/vimrc $HOME/.vimrc

    echo " - zsh (.zshrc, .zsh)"
    link $PWD/zsh/zshrc $HOME/.zshrc
    rm $HOME/.zsh 2> /dev/null || true
    link $PWD/zsh/zsh $HOME/.zsh

    echo " - tmux (.tmux.conf)"
    link $PWD/tmux/.tmux.conf $HOME/.tmux.conf

    echo " - fish (.config/fish)"
    mkdir $HOME/.config > /dev/null 2> /dev/null || true
    rm $HOME/.config/fish 2> /dev/null || true
    link $PWD/fish $HOME/.config/fish

    echo " - emacs (.emacs.d)"
    rm $HOME/.emacs.d 2> /dev/null || true
    link $PWD/emacs $HOME/.emacs.d

    echo " - emacs mayvenn layer"
    rm $HOME/.emacs.d/private/mayvenn 2> /dev/null || true
    link $PWD/external/mayvenn-layer $HOME/.emacs.d/private/mayvenn

    echo "*** Don't forget to configure your .spacemacs layers.  The simplest option is to use the 'mayvenn' layer."

    echo " - scripts (bin)"
    rm $HOME/bin 2> /dev/null || true
    link $PWD/bin $HOME/bin

    if [ ! -d ~/.swiftenv ]; then
        echo " - Installing swiftenv"
        git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
    fi

    echo " - gpg (.gnupg)"
    mkdir -p $HOME/.gnupg; true
    link $PWD/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

    echo " - making dirs"
    mkdir -p ~/.rbenv/bin; true
    mkdir -p ~/.rbenv/shims; true
    mkdir -p ~/workspace/gopath/bin; true
    mkdir -p ~/.cargo/bin; true
    mkdir -p ~/.swiftenv/shims; true
}

function setup_vim {
    vim +PlugInstall +qall
    vim +GoInstallBinaries +qall
}

function update {
    update_submodules
    # install gocode files
    echo "Re-downloading gocode vim files ..."
    run curl -L "https://raw.github.com/nsf/gocode/master/vim/autoload/gocomplete.vim" > $PWD/vim/vim/autoload/gocomplete.vim
    run curl -L "https://raw.github.com/nsf/gocode/master/vim/ftplugin/go.vim" > $PWD/vim/vim/ftplugin/go.vim

    print_post_install_message
}

function update_submodules {
    echo "Updating submodules ..."
    CWD=$PWD
    for i in `git submodule status | cut -f3 -d ' '`
    do
        echo "Updating $i ..."
        cd $CWD/$i
        run git reset --hard
        run git checkout master
        run git pull
        run git checkout master
    done
    cd $CWD
}

function install_nix {
    if ! grep nix /etc/synthetic.conf > /dev/null 2>&1; then
        echo "nix missing from /etc/synthetic.conf. Adding it (will request sudo)"
        echo "nix" | sudo tee -a /etc/synthetic.conf > /dev/null
        echo "Rebooting system in 10 seconds... Please return bootstrap script to continue nix install"
        sleep 10
        run sudo reboot
        exit 0
    fi

    if [ ! -d "/nix" ]; then
        echo "/nix directory not created yet. Please reboot to get the proper changes."
        exit 0
    else
        echo "/nix exists!"
    fi

    if ! diskutil info Nix > /dev/null 2>&1; then
        echo "nix volume missing."
        PASSPHRASE=$(openssl rand -base64 32)
        echo "Creating encrypted APFS volume with passphrase: $PASSPHRASE"
        run sudo diskutil apfs addVolume disk1 APFSX Nix -mountpoint /nix -passphrase "$PASSPHRASE"

        UUID=$(diskutil info -plist /nix | plutil -extract VolumeUUID xml1 - -o - | plutil -p - | sed -e 's/"//g')
        echo "writing nix passphrase to your keychain"
        security add-generic-password -l Nix -a "$UUID" -s "$UUID" -D '"Encrypted Volume Password"' -w "$PASSPHRASE" \
            -T "/System/Library/CoreServices/APFSUserAgent" -T "/System/Library/CoreServices/CSUserAgent"

        echo "nix volume created. Rebooting in 10 seconds to get the changes and run this script again."
        sleep 10
        run sudo reboot
    else
        echo "nix volume already created"
    fi

    if ! grep nix /etc/fstab > /dev/null; then
          echo "enabling automount of nix volume"
          # we explicitly want unescaped in this printf, so ignore shellcheck
          # shellcheck disable=SC2016
          printf '$a\nLABEL=Nix /nix apfs rw\n.\nwq\n' | EDITOR='ed' sudo vifs >/dev/null
    else
          echo "automount of nix volume already enabled"
    fi

    if [ ! -d /nix/store ]; then
        echo "Installing NIX"
        curl https://nixos.org/nix/install | sh
    fi
}

function osx {
    if [ -z "`which brew`" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # for emoji in git diff
    run brew install less

    if [ ! -f /usr/local/bin/gpg2 ]; then
        run brew install gpg2
    fi

    if [ ! -f /usr/local/bin/pinentry-mac ]; then
        run brew install pinentry-mac
    fi

    if [ ! -f /usr/local/bin/go ]; then
        run brew install go
    fi

    if [ ! -f /usr/local/bin/python ]; then
        run brew install python
    fi

    if [ ! -f /usr/local/bin/rbenv ]; then
        run brew install rbenv --HEAD
    fi

    if [ ! -f /usr/local/bin/mvim ]; then
        run brew install macvim
    fi

    brew tap d12frosted/emacs-plus
    brew install emacs-plus
    if [ ! -f /usr/local/bin/ag ]; then
        brew install ag
    fi

    if [ ! -f /usr/local/bin/hg ]; then
        run brew install hg
    fi
    if [ ! -f /usr/local/bin/fish ]; then
        run brew install fish
    fi

    if [ ! -f /usr/local/bin/python3 ]; then
        run brew install python3
    fi

    if [ ! -f /usr/local/bin/go ]; then
        run brew install go
    fi

    if [ ! -f /usr/local/bin/fish ]; then
        run brew install fish
    fi

    if [ ! -f /usr/local/bin/ag ]; then
        run brew install the_silver_searcher
    fi

    if [ ! -f /usr/bin/javac ]; then
        run brew cask install java
    fi

    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 1
    echo 'key repeat settings will only apply on restart'

   # if [ ! -d /nix ]; then
   #      install_nix
#        echo " >> curl https://nixos.org/nix/install | sh"
#        curl https://nixos.org/nix/install | sh
#        export NIX_SSL_CERT_FILE=/etc/ssl/cert.pem
#
#        run nix-channel --add https://nixos.org/channels/nixpkgs-19.03-darwin
#        run nix-channel --update
#
#        run nix-env -i mercurial-full
#        run nix-env -i python3
#        run nix-env -i go
#        run nix-env -i ruby-2.6.3
#        run nix-env -i macvim
#        run nix-env -i emacs-mac
#        run nix-env -i silver-searcher
#        run nix-env -i fish
#        run nix-env -i graal-1.0.0-rc15
#        run nix-env -i rustup
#
#        pushd nix
#            run nix-env -f custom-packages -iA openjdk12
#            run nix-env -f custom-packages -iA clojure
#        popd
   # fi
}

function fish_as_default {
    echo "Switch default to fish shell. Requires sudo. Abort to skip"
    if [ "$(cat /etc/shells | grep -q $(which fish))" = "0" ]; then
        echo "Fish shell already in /etc/shells"
    else
        which fish | sudo tee -a /etc/shells > /dev/null
    fi
}

function help {
    echo "Usage: $0 COMMAND"
    echo
    echo "Commands:"
    echo "  install   Symlinks files to home directory (overwrites existing)."
    echo "  osx       Installs various dependencies for OS X"
    echo "  osx_nix   Installs NIX on OS X (requires several reboots)"
    echo "  update    Updates all submodules & gocode. Changes the repository."
    echo "  help      This help"
}

case "$1" in
    "install") main;;
    "osx_nix") install_nix;;
    "osx") osx;;
    "upgrade"|"update") update;;
    "help") help;;
    *) echo "Invalid command. Use '$0 help' for help";;
esac
