set PATH $HOME/bin /usr/local/bin $PATH

set -x EDITOR $HOME/bin/vim
set -x GOPATH $HOME/workspace/gopath
set -x ALTERNATIVE_EDITOR ""
set -x RUST_SRC_PATH $HOME/workspace/rust-1.7.0/src

. $HOME/.config/fish/plugins/virtualfish/virtual.fish
. $HOME/.config/fish/plugins/virtualfish/auto_activation.fish
. $HOME/.config/fish/plugins/virtualfish/global_requirements.fish
. /usr/local/etc/autojump.fish

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

setenv PATH '/Users/jeff/.swiftenv/shims' $PATH
. '/usr/local/Cellar/swiftenv/0.5.0/bin/../libexec/../completions/swiftenv.fish'
