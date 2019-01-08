Kao's Emacs Config Files
========================

This README file is to serve as a reminder to myself on how to setup Emacs on a
new machine and also hopefully to help people interested in trying out my
config.

Setup
-----

Currently I'm using macOS with the latest stable emacs from
[brew](http://brew.sh).

This repository lives locally on my machine in the `~/.emacs.d/` directory.
Package manager dependencies are managed by [cask](https://github.com/cask/cask)
and [pallet](https://github.com/rdallasgray/pallet).

Current installation steps from shell are as follows:

    $ brew install emacs --with-cocoa --with-imagemagick@6 --with-librsvg
    $ brew install cask

    $ git clone https://github.com/kaofelix/kao-emacs-config ~/.emacs.d/
    $ cd ~/.emacs.d
    $ cask install

