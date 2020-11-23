;;; setup-python.el --- configs for python

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package elpy
  :after poetry
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook 'poetry-tracking-mode)
  (setq elpy-rpc-virtualenv-path 'current))

(use-package poetry)

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(use-package flycheck-pycheckers
  :after flycheck
  :hook
  (flycheck-mode . flycheck-pycheckers-setup))

(provide 'setup-python)
;;; setup-python.el ends here

