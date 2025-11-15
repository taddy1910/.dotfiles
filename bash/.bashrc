# EPOCHREALTIME は bash 5 以降 (秒.マイクロ秒)
export PS4='+$EPOCHREALTIME\t${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '

# トレース出力先をファイルに
exec 9> "${HOME}/bash_startup.log"
BASH_XTRACEFD=9

# xtrace (set -x) を有効化
set -x
#
#
# load .env
load_dotenv() {
  local f="$PWD/.env"
  if [[ -f "$f" ]]; then
    # export everything defined in the file
    set -a          # auto-export any assignment that follows
    . "$f"          # dot-source the file
    set +a
  fi
}
PROMPT_COMMAND="load_dotenv;$PROMPT_COMMAND"

# load fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# load bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

## prompt
PS1='\[\033[34m\][\h]\[\033[00m\] \w$(parse_git_branch)\n$(if [ $? -eq 0 ]; then echo "\[\033[32m\]"; else echo "\[\033[31m\]"; fi)\$ \[\033[00m\]'

# JINA_CLI_BEGIN

## autocomplete
_jina() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(jina commands)" -- "$word") )
  else
    local words=("${COMP_WORDS[@]}")
    unset words[0]
    unset words[$COMP_CWORD]
    local completions=$(jina completions "${words[@]}")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _jina jina

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# default workspace for Executors

# JINA_CLI_END

export PATH="/opt/podman/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# anyenv
if [ -x "$(command -v anyenv)" ]; then
  eval "$(anyenv init -)"
fi
export PATH=~/.npm-global/bin:$PATH

export HISTSIZE=100000
export HISTFILESIZE=100000
