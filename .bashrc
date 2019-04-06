source /home/peep/.shortcuts.sh
source ~/.bashrc_git

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ssh only configuration
if [ "$SSH_CLIENT" != "" ]; then
    echo "You connected through ssh"
    espeak "$SSH_CLIENT Connected"
fi
