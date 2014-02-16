set PATH $HOME/bin $PATH

set -x EDITOR $HOME/bin/vim
set -x GOPATH $HOME/workspace/gopath

. $HOME/.config/fish/plugins/virtualfish/virtual.fish
. $HOME/.config/fish/plugins/virtualfish/auto_activation.fish
. $HOME/.config/fish/plugins/virtualfish/global_requirements.fish

alias trim_tree="ack --print0 -l '[ \t]+\$' | xargs -0 -n1 perl -pi -e 's/[ \t]+\$//'"

