#####################################################
# enable prompt colors
autoload -U colors && colors

# disable auto-correct, I have perfect typing!
unsetopt correct_all

unsetopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

# support emacs keybindings
bindkey -e
#####################################################
# aliases

alias workspace='cd ~/workspace'

#####################################################

if [ -z "$VIRTUALENVWRAPPER_PYTHON" ]; then
    source /usr/local/bin/virtualenvwrapper_lazy.sh
fi

#####################################################
export WORKON_HOME=$HOME/.virtualenvs

# Customize to your needs...
export PATH=$HOME/bin:/usr/local/go/bin:$HOME/.rvm/bin:/usr/local/bin/:/usr/local/share/python/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin

export EDITOR=`which vim`
#export GOROOT=/usr/local/Cellar/go/1.1.1
#export GOBIN=$GOROOT/bin
export GOPATH=$HOME/workspace/gopath

### Include bin dir by default
export PATH=$PATH:$GOPATH/bin

export PYTHONPATH=.:$PYTHONPATH

source /Users/jeff/.rvm/scripts/rvm
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

PATH=$PATH:/usr/local/share/npm/bin/ # for npm/node

PATH=$PATH:/usr/local/sbin/ # for rabbitmq
#####################################################

workon_virtualenv() {
    local curr_dir="${PWD##*/}"
    if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$curr_dir" ]; then
        if [ -d "$WORKON_HOME/$curr_dir" ]; then
            echo "$1%{$fg[red]%}workon $curr_dir%{$reset_color%}$2"
        fi
    fi
}

#####################################################

is_git_repo() {
    git remote 2>/dev/null
    return $?
}

git_status(){
    local output="`git status -s --porcelain 2>/dev/null`"
    local git_stat=""
    for i in \? A D R U C M
    do
        echo $output | grep -q "^ *$i" > /dev/null
        if [ $? -eq 0 ]; then
            git_stat+="$1$i"
        fi
    done
    if [ -n "$git_stat" ]; then
        echo "$2$git_stat$3"
    fi
}

git_branch(){
    local branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ $? ]; then
        echo "$1$branch$2"
    else
        echo ""
    fi
}

repo_status() {
    echo "$1`git_branch``git_status '' ':'`$2"
}

#####################################################

setopt PROMPT_SUBST

# [parent-dir/current-dir] username(repo_status) $
#export PROMPT=$'%(?..%{$fg[red]%}%?%{$reset_color%} )[%{$fg[green]%}%2c%{$reset_color%}] %{$fg[blue]%}%n%{$reset_color%}$(repo_status "(" ")") $ '
# [parent-dir/current-dir] (repo_status) $
export PROMPT=$'%(?..%{$fg[red]%}%?%{$reset_color%} )[%{$fg[green]%}%2c%{$reset_color%}] $(repo_status) $ '

# tell us to use virtualenv if available
export RPROMPT=$'$(workon_virtualenv)'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
