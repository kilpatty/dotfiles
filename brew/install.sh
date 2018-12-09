#!/usr/bin/env bash
if ! command -v brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
else
    echo "Homebrew already installed!"
fi;

# Run Homebrew updating script
sh ./update.sh

# Run Homebrew through the Brewfile
brew bundle
