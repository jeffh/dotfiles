# Display the following bits on the left:
# * Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# * Current directory name
# * Git branch and dirty state (if inside a git repo)

function _git_branch_name
    echo (git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (git status -s --ignore-submodules=dirty 2>/dev/null)
end

function _jj_commit_hash
    echo (jj log -n 1 -T 'change_id.shortest()' 2>/dev/null | awk '{printf $2}')
end

function _is_jj_dirty
    echo (jj st 2>/dev/null | head -n 1 | grep 'copy changes' 2> /dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l duration $CMD_DURATION

  set -l info (set_color -o brblack)
  set -l infoval (set_color -o blue)
  set -l dirpathcolor (set_color AAA)
  set -l dircolor (set_color -o cyan)
  set -l exitcodecolor (set_color -o red)
  set -l normal (set_color normal)
  set -l durationcolor (set_color -o yellow)

  set -l repocleancolor (set_color -o green)
  set -l repodirtycolor (set_color -o red)

  set -l cwd $dircolor(basename (prompt_pwd))

  # output the prompt, left to right

  # display exit code
  if set -q last_status && test "$last_status" -ne 0
    echo $info'=> '$exitcodecolor$last_status $normal
  end

  # Display abbrev CWD
  echo -n -s $dirpathcolor (prompt_pwd) ' '

  # Display [shell] if in pyenv
  if set -q PYENV_SHELL && type -q pyenv
      set -l pyshell (pyenv local 2>/dev/null || pyenv global)
      if test "$pyshell" != "system"
        echo -n -s $info'pyenv:'$infoval $pyshell $normal ' '
      end
  end

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s $info'virtualenv:'$infoval (basename "$VIRTUAL_ENV") $normal ' '
  end

  # display duration
  if test -n "$duration"
    set -l secs (math --scale=1 $duration/1000 % 60)
    set -l mins (math --scale=0 $duration/60000 % 60)
    set -l hours (math --scale=0 $duration/3600000)

    set -l cmd_dur ""
    test $hours -gt 0 && set --local --append cmd_dur $hours"h"
    test $mins -gt 0 && set --local --append cmd_dur $mins"m"
    test $secs -gt 0 && set --local --append cmd_dur $secs"s"

    if test "$cmd_dur" != ""
      echo -n -s $info'duration:' $durationcolor $cmd_dur $info ' now:' $infoval (date '+%I:%M:%S%p') $normal
    end
  end
 
  # Add a newline
  echo -e ""

  # Display [nix] if in a nix shell
  if test -n "$IN_NIX_SHELL"
     echo -n -s $info'nix:'$infoval $normal
  end

  # Display the current directory name
  echo -n -s $cwd $normal

  # Show git branch and dirty state
  if type -q git
    set -l git_branch (_git_branch_name)
    if test -n "$git_branch"
        set -l git_branch '(git:' $git_branch ')'

        if [ (_is_git_dirty) ]
            set git_info $repodirtycolor $git_branch " ★ "
        else
            set git_info $repocleancolor $git_branch
        end
        echo -n -s ' · ' $git_info $normal
    end
  end

  if type -q jj
    set -l jj_hash (_jj_commit_hash)
    if test -n "$jj_hash"
        set -l jj_hash '(jj:' $jj_hash ')'
        if [ (_is_jj_dirty) ]
            set jj_info $repodirtycolor $jj_hash " ★ "
        else
            set jj_info $repocleancolor $jj_hash
        end
        echo -n -s ' · ' $jj_info $normal
    end
  end

  # Terminate with a nice prompt char
  echo -n -s ' ⟩ ' $normal

end
