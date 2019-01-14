# This is the local bashrc file, the one under source control is called .bashrc_git
source /home/$USER/.bashrc_git

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/peep/google-cloud-sdk/path.bash.inc' ]; then . '/home/peep/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/peep/google-cloud-sdk/completion.bash.inc' ]; then . '/home/peep/google-cloud-sdk/completion.bash.inc'; fi

# added by travis gem
[ -f /home/peep/.travis/travis.sh ] && source /home/peep/.travis/travis.sh
source /home/peep/.shortcuts.sh
