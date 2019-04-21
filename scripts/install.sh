#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# find the installers and run them iteratively
find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

# Switch to using brew-installed bash as default shell
# Switch to ZSH TODO
#if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
#  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
#  chsh -s /usr/local/bin/bash;
#fi;
