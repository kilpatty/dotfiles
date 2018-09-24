#!/usr/bin/env bash
if ! which brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi;

# Run Homebrew updating script
sh ./update.sh

# Run Homebrew through the Brewfile
brew bundle
