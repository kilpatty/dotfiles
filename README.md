#Sean Kilgarriff's Dotfiles
This is the collection of configuration and setup files that I use for all of my personal computers. This collection has been amassed over the course of a few years, and borrows from many different sources.

##How to use/install

*I highly recommend forking this repository before installing it. These files are configured for my personal machine, and therefore I will have an ssh config and aliases' that will not make sense if you are not me.*

To install these files, simply clone the repository into your home directory under the folder dotfiles.

```
git clone (your fork) ~/dotfiles
```

These dotfiles work by connecting anyting with .symlink to a file in your home directory. To get these symlinks to install run the boostrap script.

```
./boostrap.sh
```

To install Brew along with all casks and formulas, run the brew.sh file.

```
./brew.sh
```

These dotfiles also use a slightly modified version of [Mathias Bynens' macOS defaults script](https://github.com/mathiasbynens/dotfiles/blob/master/.macos). To install the defaults from this sript, simply run the macOS shell file.

```
./macOS
```


##

##how to contribute

#inspiration

## License

This repository is covered by the [MIT License](/LICENSE)

Copyright (c) 2016 Sean Kilgarriff.
