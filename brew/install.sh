#!/usr/bin/env bash
if ! which brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi;

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Run Homebrew through the Brewfile
echo "› brew bundle"
brew bundle
