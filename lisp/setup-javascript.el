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

(with-eval-after-load 'dtrt-indent
  (add-to-list 'dtrt-indent-hook-mapping-list '(js2-mode c/c++/java  js2-basic-offset)))

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-r")

(require 'js2-imenu-extras)
(js2-imenu-extras-setup)

(provide 'setup-javascript)
;;; setup-javascript.el ends here
