set PATH $HOME/bin /usr/local/bin $PATH

setenv EDITOR $HOME/bin/vim
setenv GOPATH $HOME/workspace/gopath
setenv ALTERNATIVE_EDITOR ""
setenv RUST_SRC_PATH $HOME/workspace/rust-1.7.0/src

. $HOME/.config/fish/plugins/virtualfish/virtual.fish
. $HOME/.config/fish/plugins/virtualfish/auto_activation.fish
. $HOME/.config/fish/plugins/virtualfish/global_requirements.fish

alias trim_tree="ack --print0 -l '[ \t]+\$' --known-types | xargs -0 -n1 perl -pi -e 's/[ \t]+\$//'"

set PATH $HOME/.rbenv/bin $PATH
set PATH $GOPATH/bin $PATH
set PATH ~/.rbenv/shims $PATH
set PATH /Users/jeff/.cargo/bin $PATH
set CAPSTAN_QEMU_PATH /usr/local/bin/qemu-system-x86_64
setenv RBENV_SHELL fish

set -gx RBENV_ROOT /usr/local/var/rbenv
. (rbenv init -|psub)

fzf_key_bindings

# Set prompt
. ~/.config/fish/fish_prompt.fish
. ~/.config/fish/fish_right_prompt.fish

setenv SWIFTENV_ROOT "$HOME/.swiftenv"
setenv PATH "$SWIFTENV_ROOT/bin" $PATH
status --is-interactive; and . (swiftenv init -|psub)
