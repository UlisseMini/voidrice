# Setup fzf
# ---------
if [[ ! "$PATH" == */home/peep/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/peep/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/peep/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/peep/.fzf/shell/key-bindings.bash"
