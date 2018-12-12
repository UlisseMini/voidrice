#!/bin/bash

# general
alias reload="source ~/.bashrc"
alias wifi="sudo wifi"

# colors!
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
# Color cat - print file with syntax highlighting.
alias ccat="highlight --out-format=ansi"

## DOTFILES ##
function vrc() {
	cd ~/dotfiles 2>/dev/null &&
		$EDITOR . &&
		cd - >/dev/null
}

## DOCKER ##
function dockerstopall() {
	docker stop $(docker ps -q)
}

function dockerclean() {
	# sometimes containers will not be running
	# if thats the case we don't want to see the
	# error message
	dockerstopall 2>/dev/null

	# delete all the containers (will prompt user)
	docker container prune
}
