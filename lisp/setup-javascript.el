;;; setup-javascript.el --- setup javascript modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.jshintrc$" . javascript-mode))
(add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

(setq js2-global-externs  '("describe"
                            "beforeEach"
                            "module"
                            "inject"
                            "it"
                            "expect"
                            "angular"))

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-r")

(require 'js2-imenu-extras)
(js2-imenu-extras-setup)

(provide 'setup-javascript)
;;; setup-javascript.el ends here
