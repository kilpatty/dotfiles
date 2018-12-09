# Kilpatty's Dotfiles
This is the collection of configuration and setup files that I use for all of my personal computers. This collection has been amassed over the course of a few years, and borrows from many different sources.

## How to use/install

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


## The Specs

These dotfiles are for the following software and programs:

* [MacOS](http://www.apple.com/macos/sierra/)
* [Bash](https://www.gnu.org/software/bash/)
* [Atom](https://atom.io/)
* [Hyper](https://github.com/zeit/hyper)
* [Homebrew](http://brew.sh/)
* [GPG Tools](https://gpgtools.org/)
* [SSH](http://man.openbsd.org/OpenBSD-current/man1/ssh.1)

## Contributing

I'm always open to contributions or suggestions! If you think something should be changed, added, or removed - make a pull request!

## Inspiration

These dotfiles have arisen due to a large amount of inspiration and borrowing from many sources. Here are some of the sources of Inspiration used most:

* [Mathias Bynes](https://github.com/mathiasbynens/dotfiles)
* [Zach Holman](https://github.com/holman/dotfiles)
* [Nick Plekhanov](https://github.com/nicksp/dotfiles)
* [Github Does Dotfiles](https://dotfiles.github.io/)


## License

This repository is covered by the [MIT License](/LICENSE)
