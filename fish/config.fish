set PATH $HOME/bin /usr/local/bin $PATH

set -x EDITOR $HOME/bin/vim
set -x GOPATH $HOME/workspace/gopath
set -x ALTERNATIVE_EDITOR ""

. $HOME/.config/fish/plugins/virtualfish/virtual.fish
. $HOME/.config/fish/plugins/virtualfish/auto_activation.fish
. $HOME/.config/fish/plugins/virtualfish/global_requirements.fish
. /usr/local/etc/autojump.fish

alias trim_tree="ack --print0 -l '[ \t]+\$' --known-types | xargs -0 -n1 perl -pi -e 's/[ \t]+\$//'"

set PATH $HOME/.rbenv/bin $PATH
set PATH $GOPATH/bin $PATH
set PATH ~/.rbenv/shims/ $PATH
setenv RBENV_SHELL fish

set -gx RBENV_ROOT /usr/local/var/rbenv
. (rbenv init -|psub)

fzf_key_bindings


# Set prompt
. ~/.config/fish/fish_prompt.fish
. ~/.config/fish/fish_right_prompt.fish

