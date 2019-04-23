#!/bin/sh
if command -v brew >/dev/null 2>&1; then
	brew install getantibody/tap/antibody || brew upgrade antibody
else
	curl -sL https://git.io/antibody | sh -s
fi

#Run update script
sh "${BASH_SOURCE%/*}"/update.sh

echo "ZSH installation complete"
