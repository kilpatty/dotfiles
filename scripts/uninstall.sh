cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
CONFIGS=".config"

set -e 

unlink_file () {
  local src=$1
  local action=
  local confirmed=

  if [ "$unlink_all" == "false" ]
  then


	  echo "Are you sure you want to unlink $src? [y/n]"
	  read -n 1 action

	  case "$action" in
		  u )
			  confirmed=true;;
		  U )
			  unlink_all=true;;
		  * )
			  ;;
	 esac

  fi

  confirmed=${confirmed:-$unlink_all}

  if [ "$confirmed" == "true" ]
	  then
		  unlink $src
	  fi

}

uninstall_symlinks() {
  echo 'Scanning for Symlinks'

  local unlink_all=false

  for src in $(find $HOME -maxdepth 1 -lname "$DOTFILES_ROOT"'*')
  do
     unlink_file "$src"
  done
}

uninstall_configs() {
  info 'Scanning for Configs'

  local unlink_all=false

  for src in $(find $HOME/$CONFIGS/ -maxdepth 1 -lname "$DOTFILES_ROOT"'*')
  do
    unlink_file "$src"
  done

}

uninstall_symlinks
uninstall_configs


