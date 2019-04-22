#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# find the installers and run them iteratively
find . -name install.sh -maxdepth 2 | sort -n | while read installer ; do sh -c "${installer}" ; done

# Switch to ZSH installed by Brew
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
fi;
