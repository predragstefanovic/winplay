# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/$HOME/.fzf/bin"
fi

# fzf options
export FZF_DEFAULT_OPTS='--exact --no-sort --reverse --cycle --height 40%'
# list directories and preview contents
export FZF_ALT_C_COMMAND='fdfind -H -L -E .git -t d'
export FZF_ALT_C_OPTS='--ansi --preview-window "right:60%" --preview "ls --group-directories-first -a -l {}"'
# list files and preview contents
export FZF_CTRL_T_OPTS='--ansi --preview-window "right:60%" --preview "batcat --color=always --style=header,grid --line-range :300 {} {}"'
export FZF_CTRL_T_COMMAND='fdfind -H -L -E .git -t f'

source <(fzf --zsh)
