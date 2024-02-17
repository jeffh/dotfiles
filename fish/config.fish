# nix
if test -d "~/.config/fish/nix.sh"
    eval (~/.config/fish/nix.sh)
    set -x NIX_SSL_CERT_FILE /etc/ssl/cert.pem
end

# nix-darwin
if test -f "/etc/bashrc"
    bass source /etc/bashrc
    # # Only execute this file once per shell.
    # if test -n "$__ETC_BASHRC_SOURCED" -o -n "$NOSYSBASHRC"
    # else
    #     set __ETC_BASHRC_SOURCED 1

    #     # Don't execute this file when running in a pure nix-shell.
    #     if test -n "$IN_NIX_SHELL"
    #     else
    #         if test -z "$__NIX_DARWIN_SET_ENVIRONMENT_DONE"
    #             bass source /nix/store/6pp4ar427dglr6fc29b11mz3w4ks42xy-set-environment
    #         end
    #     end
    # end
end
# nix
if test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"
    bass source "$HOME/.nix-profile/etc/profile.d/nix.sh"
end
#if test -d "/run/current-system/sw/bin"
#    for p in /run/current-system/sw/bin ~/bin
#        if not contains $p $fish_user_paths
#            set -g fish_user_paths $p $fish_user_paths
#        end
#    end
#    set -x NIX_PATH "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix" $NIX_PATH
#    set -x NIX_USER_PROFILE_DIR "/nix/var/nix/profiles/per-user/$USER"
#    set -x NIX_PROFILES "/nix/var/nix/profiles/default /run/current-system/sw $HOME/.nix-profile"
#end

test -d "/Library/Java/JavaVirtualMachines/graalvm-ce-java17-22.2.0/Contents/Home/bin"; and set -x PATH "/Library/Java/JavaVirtualMachines/graalvm-ce-java17-22.2.0/Contents/Home/bin" $PATH

set -x PATH /usr/local/bin /usr/local/sbin $PATH
test -d $HOME/.local/bin; and set -x PATH $HOME/.local/bin $PATH
test -d $HOME/bin; and set -x PATH $HOME/bin $PATH

# for Zig: https://github.com/ziglang/zig/issues/8317
# setenv ZIG_SYSTEM_LINKER_HACK 1

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

# golang 
test -d ~/go/bin; and set -x PATH ~/go/bin $PATH
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
    if test -e which
        which rbenv > /dev/null
        if test $status -eq 0
            rbenv init - | source
        end
    end
end

# swift
if type -q swiftenv
    set -x SWIFTENV_ROOT "$HOME/.swiftenv"
    if test -d "$SWIFTENV_ROOT/bin"
        set -x PATH "$SWIFTENV_ROOT/bin" $PATH
        status --is-interactive; and swiftenv init - | source
    end
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

# homebrew
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else
    eval (/usr/local/bin/brew shellenv)
end

# Odin
if test -d "/opt/homebrew/Cellar/llvm@11/11.1.0_2/bin"
    set -x PATH /opt/homebrew/Cellar/llvm@11/11.1.0_2/bin $PATH
end

fish_add_path -m /usr/local/opt/llvm@11/bin
test -d /opt/pkg/bin; and fish_add_path -m /opt/pkg/bin/
test -d /opt/pkg/bin; and fish_add_path -m /opt/pkg/sbin/

test -f (which pyenv); and pyenv init - | source
test -e (which nvim); and setenv EDITOR (which nvim)
test -e (which vim); and setenv ALTERNATIVE_EDITOR (which vim)

