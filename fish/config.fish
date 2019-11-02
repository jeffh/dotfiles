set -x PATH /usr/local/bin /usr/local/sbin $PATH
test -d $HOME/.local/bin; and set -x PATH $HOME/.local/bin $PATH
test -d $HOME/bin; and set -x PATH $HOME/bin $PATH

setenv EDITOR (which vim)
setenv ALTERNATIVE_EDITOR ""

begin # SSH Agent
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end
    if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
        source $SSH_ENV > /dev/null
    end
    if not test -z "$SSH_AGENT_PID"
        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent

        if test $status -ne 0
            ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
            chmod 600 "$SSH_ENV"
            source "$SSH_ENV" > /dev/null
        end
    end
end

# needed for gpg-agent
# setenv GPG_TTY (tty)
# gpg-agent --daemon >/dev/null 2>&1

#set -e SSH_AUTH_SOCK
#set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

#ssh-add -K 2> /dev/null

eval (python3 -m virtualfish 2>/dev/null)

# golang 
test -d /usr/local/go/bin; and set -x PATH /usr/local/go/bin $PATH
test -d /usr/local/opt/go/libexec/bin; and set -x PATH /usr/local/opt/go/libexec/bin $PATH

# rust
test -d $HOME/.cargo/bin; and set -x PATH $HOME/.cargo/bin $PATH

# capstan
test -d /usr/local/bin/qeum-system-x86_64; and set CAPSTAN_QEMU_PATH /usr/local/bin/qemu-system-x86_64

# ruby
if test -d $HOME/.rbenv/bin
    set -x PATH $HOME/.rbenv/bin $PATH
end
if test -d $HOME/.rbenv/shims
    set -x PATH ~/.rbenv/shims $PATH
    set -x RBENV_SHELL fish
#set -gx RBENV_ROOT /usr/local/var/rbenv
    which rbenv
    if test $status -eq 0
        source (rbenv init -|psub)
    end
end

# swift
set -x SWIFTENV_ROOT "$HOME/.swiftenv"
if test -d "$SWIFTENV_ROOT/bin"
    set -x PATH "$SWIFTENV_ROOT/bin" $PATH
    status --is-interactive; and . (swiftenv init -|psub)
end

# graalvm
if test -d "/usr/local/opt/graalvm/1.0.0-rc12/Contents/Home/"
    set -x GRAALVM_HOME "/usr/local/opt/graalvm/1.0.0-rc12/Contents/Home/"
end
if test -d "/opt/graalvm/1.0.0-rc12/Contents/Home/"
    set -x GRAALVM_HOME "/opt/graalvm/1.0.0-rc12/Contents/Home/"
end

# Set prompt
. ~/.config/fish/fish_prompt.fish
. ~/.config/fish/fish_right_prompt.fish

# iterm2
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

if test -d "/nix"
    eval (~/.config/fish/nix.sh)
    set -x NIX_SSL_CERT_FILE /etc/ssl/cert.pem
end
