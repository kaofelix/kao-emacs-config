;;; setup-python.el --- configs for python

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package python
  :hook
  (python-mode . eglot-ensure)
  (python-ts-mode . eglot-ensure))

(use-package poetry
  :hook
  (python-mode . poetry-tracking-mode)
  (python-ts-mode . poetry-tracking-mode))

(use-package pyvenv
  :config
  (pyvenv-mode 1))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(provide 'setup-python)
;;; setup-python.el ends here

