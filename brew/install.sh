#!/usr/bin/env bash
echo "Checking for Homebrew install"
if ! command -v brew; then
    echo "Homebrew not found, installing now"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
else
    echo "Homebrew already installed!"
fi;

# Check for Homebrew Update
brew update

# Run Homebrew through the Brewfile
brew bundle --file="${BASH_SOURCE%/*}"/Brewfile

# Run Homebrew updating script
sh "${BASH_SOURCE%/*}"/update.sh

echo "Homebrew install complete"

