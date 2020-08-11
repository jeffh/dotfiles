# Jeff's Dotfiles

Just VIM config here. If you just want to use these, clone it and then run:

    ./bootstrap.sh osx      # for macOS specific dependencies
    ./bootstrap.sh osx_nix  # for nix install in macOS, requires multiple system reboots
    ./bootstrap.sh install

Which will set up the vim environment and symlink the vim stuff to your home
directory. Warning: it will blow out your .zshrc and existing vim config.
