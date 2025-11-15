## # Setup fzf
## # ---------
## if [[ ! "$PATH" == */Users/tadaseiji/.cache/plugged/fzf/bin* ]]; then
##   PATH="${PATH:+${PATH}:}/Users/tadaseiji/.cache/plugged/fzf/bin"
## fi
## 
## eval "$(fzf --bash)"
## 
## 
## # fzfによるコマンド履歴検索
## __fzf_history__() {
##   local tac
##   if type tac > /dev/null 2>&1; then
##     tac="tac"
##   else
##     tac="tail -r"
##   fi
##   shopt -u nocaseglob nocasematch
##   echo $(HISTTIMEFORMAT= history | command $tac | sed -e 's/^ *[0-9]\{1,\}\** *//' -e 's/ *$//' | awk '!a[$0]++' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" $(__fzfcmd))
## }
## bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

# Setup fzf binary path
if [[ ! "$PATH" == */Users/tadaseiji/.cache/plugged/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/tadaseiji/.cache/plugged/fzf/bin"
fi

# Load fzf bash setup
eval "$(fzf --bash)"

# fzf-based command history search (Ctrl-R)
__fzf_history__() {
  local tac
  if type tac > /dev/null 2>&1; then
    tac="tac"
  else
    tac="tail -r"
  fi
  HISTTIMEFORMAT= history | $tac | sed -E 's/^ *[0-9]+[* ]*//' | awk '!a[$0]++' | \
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS \
    --reverse --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" \
    fzf --ansi --no-sort --query "$READLINE_LINE" --bind "enter:accept"
}

# Bind Ctrl-R to fzf history
__fzf_history_bind__() {
  bind -x '"\C-r": READLINE_LINE=$( __fzf_history__ ); READLINE_POINT=${#READLINE_LINE}'
}
__fzf_history_bind__
