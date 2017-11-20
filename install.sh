#!/usr/bin/env bash

#Installs things that can't be installed by other means.




# Make sure we’re using the latest Homebrew.
echo "brew updating"
brew update

# Upgrade any already-installed formulae.
echo "brew upgrading"
brew upgrade

# Run Homebrew through the Brewfile
echo "› brew bundle"
brew bundle


# Switch to using brew-installed zsh as default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
fi;

chsh -s /usr/local/bin/zsh;
