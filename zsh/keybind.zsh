# basic key bind like emacs
bindkey -e

# remove words like bash with ctrl u
bindkey \^U backward-kill-line

# select history
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# select complete-menu like vi
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Ctrl r history search from fzf list
if which fzf >/dev/null 2>&1 ; then
	function select-history-fzf(){
    BUFFER="$(history -n -r 1 | fzf --exact --no-sort +m --query "$LBUFFER" --prompt="History > ")"
		CURSOR=$#BUFFER
	}
	zle -N select-history-fzf
	bindkey '^r' select-history-fzf
else
	bindkey '^r' history-incremental-pattern-search-backward
fi

# Ctrl o open file from fzf list
function open-file() {
    local out key file
    out="$(find ./ -type f | fzf --exact --no-sort +m --query "$LBUFFER" --prompt="File > " --expect=ctrl-v,ctrl-o,ctrl-s)"
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
        [ "$key" = "ctrl-o" ]  && open "$file"
        [ "$key" = "ctrl-v" ]  && nvr -cc vsplit "$file"
        [ "$key" = "ctrl-s" ]  && nvr -cc split "$file"
        BUFFER="$file"
    fi
}

zle -N open-file
bindkey '^o' open-file

function ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf
