set PATH $HOME/.local/bin $HOME/bin /usr/local/bin $PATH

setenv EDITOR /usr/local/bin/vim
setenv GOPATH $HOME/workspace/gopath
setenv ALTERNATIVE_EDITOR ""
setenv RUST_SRC_PATH $HOME/workspace/rust-1.7.0/src

# needed for gpg-agent
setenv GPG_TTY (tty)
gpg-agent --daemon >/dev/null 2>&1
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

. $HOME/.config/fish/plugins/virtualfish/virtual.fish
. $HOME/.config/fish/plugins/virtualfish/auto_activation.fish
. $HOME/.config/fish/plugins/virtualfish/global_requirements.fish

# golang 
set PATH $GOPATH/bin $PATH
set PATH /usr/local/opt/go/libexec/bin $PATH
# rust
set PATH /Users/jeff/.cargo/bin $PATH
# capstan
set CAPSTAN_QEMU_PATH /usr/local/bin/qemu-system-x86_64

# ruby
set PATH $HOME/.rbenv/bin $PATH
set PATH ~/.rbenv/shims $PATH
setenv RBENV_SHELL fish
set -gx RBENV_ROOT /usr/local/var/rbenv
. (rbenv init -|psub)

# Set prompt
. ~/.config/fish/fish_prompt.fish
. ~/.config/fish/fish_right_prompt.fish

set SWIFTENV_ROOT "$HOME/.swiftenv"
set PATH "$SWIFTENV_ROOT/bin" $PATH
status --is-interactive; and . (swiftenv init -|psub)

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
