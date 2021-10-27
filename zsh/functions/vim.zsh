#!/bin/sh

# Make vim the main editor
export EDITOR="nvim"

vim() {
	#See Python File
	__pyenv_init
	#See Ruby File
	__rbenv_init
	#See Node File we don't have one for npm yet.
	#rewrite this, remove the plugin


	command nvim "$@"
}
