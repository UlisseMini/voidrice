#!/bin/bash

# general
alias reload="source ~/.bashrc"
alias wifi="sudo wifi"
alias g="git"
alias ka="killall"

# golang aliases
alias gob="go build"
alias sgo="cd /lib/go/src/"
alias gos="cd ~/src/"
alias gop="cd ~/src/github.com/UlisseMini/"
alias got="go test -race"
alias goi="go install"

# aliases for finding files
alias locate="find . | grep -i"
alias rlocate="sudo find / 2>/dev/null | grep"

# editing
alias v="$EDITOR"
alias vi="$EDITOR"
alias vim="$EDITOR"
alias nvim="$EDITOR"

# brightness not working on my macbook, this is my workaround.
function brightness() {
	sudo bash -c "echo '$1' > /sys/class/backlight/intel_backlight/brightness" &&
		cat "/sys/class/backlight/intel_backlight/brightness"
}


# youtube-dl
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer" # Youtube streaming from the commandline!

# colors!
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
# Color cat - print file with syntax highlighting.
alias ccat="highlight --out-format=ansi"

## DOTFILES ##
function vrc() {
	cd ~/.config/nvim/ 2>/dev/null &&
		$EDITOR -p init.vim &&
		cd - >/dev/null
}

# i'm usually making aliases. cd is there so i can :tabedit bashrc easily.
function brc() {
	cd ~/ &&
		vim .bash_aliases &&
		cd - >/dev/null
}

## Docker ##
function dockerstopall() {
	docker stop $(docker ps -q)
}

function dockerclean() {
	# sometimes containers will not be running
	# if thats the case we don't want to see the
	# "docker stop" requires at least 1 argument. error message.
	dockerstopall 2>/dev/null

	# delete all the containers (will prompt user)
	docker container prune
}
