#!/usr/bin/env zsh

## Kubectl Completion
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
