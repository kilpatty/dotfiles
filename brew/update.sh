# Make sure we’re using the latest Homebrew.
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae.
echo "Updating Homebrew Formulae..."
brew upgrade

# So it turns out that Homebrew disabled to the option to remove shitty git zsh completions.
# This will check for the file, and remove it here - hopefully updates only occur using this file.
# But, I don't want to check and delete file on every check, so this is the next best bet.

[[ -f /usr/local/share/zsh/site-functions/_git ]] && \
  echo "Removing git zsh completions"
  rm  -f /usr/local/share/zsh/site-functions/_git

