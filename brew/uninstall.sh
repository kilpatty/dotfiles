if command -v brew; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
else
	echo "No Homebrew installation found"
fi;

