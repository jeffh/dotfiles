set -x PATH /usr/local/bin /usr/local/sbin $PATH
test -d $HOME/.local/bin; and set -x PATH $HOME/.local/bin $PATH
test -d $HOME/bin; and set -x PATH $HOME/bin $PATH

setenv EDITOR (which vim)
setenv ALTERNATIVE_EDITOR ""

# needed for gpg-agent
setenv GPG_TTY (tty)
gpg-agent --daemon >/dev/null 2>&1
set -e SSH_AUTH_SOCK
set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

#ssh-add -K 2> /dev/null

eval (python3 -m virtualfish)

# golang 
set -x GOPATH $HOME/workspace/gopath
test -d $GOPATH/bin; and set -x PATH $GOPATH/bin $PATH
test -d /usr/local/opt/go/libexec/bin; and set -x PATH /usr/local/opt/go/libexec/bin $PATH

# rust
test -d $HOME/.cargo/bin; and set -x PATH $HOME/.cargo/bin $PATH

# capstan
test -d /usr/local/bin/qeum-system-x86_64; and set CAPSTAN_QEMU_PATH /usr/local/bin/qemu-system-x86_64

# ruby
if test -d $HOME/.rbenv/bin
    set -x PATH $HOME/.rbenv/bin $PATH
    set -x PATH ~/.rbenv/shims $PATH
    set -x RBENV_SHELL fish
#set -gx RBENV_ROOT /usr/local/var/rbenv
    . (rbenv init -|psub)
end

# swift
set -x SWIFTENV_ROOT "$HOME/.swiftenv"
if test -d "$SWIFTENV_ROOT/bin"
    set -x PATH "$SWIFTENV_ROOT/bin" $PATH
    status --is-interactive; and . (swiftenv init -|psub)
end

# Set prompt
. ~/.config/fish/fish_prompt.fish
. ~/.config/fish/fish_right_prompt.fish

# iterm2
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
