Kao's Emacs Config Files
========================

This README file is to serve as a reminder to myself on how to setup Emacs on a new machine and also hopefully to help people interested in trying out my config.

Setup
-----

Currently I'm using Mac OS X Yosemite with latest stable emacs from [homebrew](http://brew.sh).

This repository lives locally on my machine in the `~/.emacs.d/` directory. Package manager dependencies are managed by [cask](https://github.com/cask/cask) and [pallet](https://github.com/rdallasgray/pallet). 

Current installation steps from shell are as follows:

    $ brew install emacs --srgb --cocoa --with-gnutls --with-imagemagick --with-librsvg --with-glib --with-mailutils --with-d-bus
    $ brew install cask

    $ git clone https://github.com/kaofelix/kao-emacs-config ~/.emacs.d/
    $ cd ~/.emacs.d
    $ cask install

After this, Emacs should open with all packages available.
