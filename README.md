Kao's Emacs Config Files
========================

My config is currently using `use-package` with
`use-package-always-ensure` set to `t` so all configured packages get
automatically installed.

Have a recent version of Emacs installed and clone this repo to
.emacs.d:

``` shell
$ git clone https://github.com/kaofelix/kao-emacs-config ~/.emacs.d/
```

Start Emacs and let
`[use-package](https://github.com/jwiegley/use-package)` work its
magic.

org-mode
--------

Org has a built-in version and `package.el` (which also means
`use-package` ensure) won't install the latest from the org repo over
it. Need to manually select it and install it from the package list
first.
