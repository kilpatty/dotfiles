# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

## Kubectl Completion
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
