"This will allow us to use our regular vim configuration in neovim. Credit: http://vimcasts.org/episodes/meet-neovim/
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
