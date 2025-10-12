#!/bin/bash
# Status line command for Claude Code - based on fish prompt configuration

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd * 100 | round / 100')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed')

# Color definitions (using printf for ANSI codes)
info=$(printf '\033[90m')           # bright black (dim)
infoval=$(printf '\033[94m')        # bright blue
dirpathcolor=$(printf '\033[96m')   # bright cyan
repotypecolor=$(printf '\033[96m')  # bright cyan
repocleancolor=$(printf '\033[92m') # bright green
repodirtycolor=$(printf '\033[91m') # bright red
normal=$(printf '\033[0m')

output=""

# Display [nix] if in a nix shell
if [ -n "$IN_NIX_SHELL" ]; then
    output+="${info}nix:${infoval}${normal} "
fi

# Git branch and dirty state
if command -v git >/dev/null 2>&1 && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        git_dirty=$(git -C "$cwd" --no-optional-locks status -s --ignore-submodules=dirty 2>/dev/null)
        if [ -n "$git_dirty" ]; then
            output+="${repotypecolor}git${normal}:${repodirtycolor}${git_branch} ★${normal} "
        else
            output+="${repotypecolor}git${normal}:${repocleancolor}${git_branch}${normal} "
        fi
    fi
fi

# JJ commit hash and dirty state
if command -v jj >/dev/null 2>&1 && jj -R "$cwd" log -r @ -T 'change_id.shortest()' >/dev/null 2>&1; then
    jj_hash=$(jj -R "$cwd" log -r @ -T 'change_id.shortest()' 2>/dev/null | awk '{print $2}')
    if [ -n "$jj_hash" ]; then
        jj_dirty=$(jj -R "$cwd" st 2>/dev/null | head -n 1 | grep 'copy changes' 2>/dev/null)
        if [ -n "$jj_dirty" ]; then
            output+="${repotypecolor}jj${normal}:${repodirtycolor}${jj_hash} ★${normal} "
        else
            output+="${repotypecolor}jj${normal}:${repocleancolor}${jj_hash}${normal} "
        fi
    fi
fi

# Pyenv indicator
if [ -n "$PYENV_SHELL" ] && command -v pyenv >/dev/null 2>&1; then
    pyshell=$(pyenv local 2>/dev/null || pyenv global 2>/dev/null)
    if [ -n "$pyshell" ] && [ "$pyshell" != "system" ]; then
        output+="${info}pyenv:${infoval}${pyshell}${normal} "
    fi
fi

# Virtualenv indicator
if [ -n "$VIRTUAL_ENV" ]; then
    venv_name=$(basename "$VIRTUAL_ENV")
    output+="${info}virtualenv:${infoval}${venv_name}${normal} "
fi

# Current time
output+="${info}now:${infoval}$(date '+%I:%M:%S%p')${normal} "

# Current directory path (abbreviated like prompt_pwd)
# Simplify to just show last 2 path components for brevity
short_dir=$(echo "$cwd" | awk -F/ '{
    if (NF <= 2) print $0;
    else if ($1 == "") printf "/%s/%s", $(NF-1), $NF;
    else printf "%s/%s", $(NF-1), $NF
}')
output+="${dirpathcolor}${short_dir}${normal}"

if [ "${cost}" -ne 0 ]; then
    output+=" \$${cost}"
fi
if [ "${lines_added}" -ne 0 ]; then
    output+=" +${lines_added}"
fi
if [ "${lines_removed}" -ne 0 ]; then
    output+=" -${lines_removed}"
fi

echo "$output"
