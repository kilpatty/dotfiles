#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# find the installers and run them iteratively
find . -name install.sh -maxdepth 2 | sort -n | while read installer ;
do 
	#TODO probably a more elegant way to skip this file.
	if [ "${installer}" == "./scripts/install.sh" ]; then
		continue
	fi;

	#TODO would be nice to print the directory name rather than the full path
	#e.g. running install for Brew vs ./brew/install.sh
	echo "Running install for ${installer}"
	sh "${installer}" ;
done

# Switch to ZSH installed by Brew
echo "Checking shells for ZSH...."
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo "Adding ZSH to acceptable shells"
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  echo "Switching shell to ZSH"
  chsh -s /usr/local/bin/zsh;
fi;
