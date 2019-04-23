#!/usr/bin/env bash

if ! command -v nvm; then
    echo "Intalling NVM from Github"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash;
    nvm install node
else
    echo "NVM already installed"
fi;


