#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# Run Homebrew through the Brewfile
echo "› brew bundle"
brew bundle

# find the installers and run them iteratively
find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

#!/usr/bin/env bash

#this just installs Brew now, and then makes sure that the brew install bashed shell is defaulted.

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



# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;
