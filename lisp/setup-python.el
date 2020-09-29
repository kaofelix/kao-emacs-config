;;; setup-python.el --- configs for python

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package elpy
  :init
  (elpy-enable))


(use-package poetry
 :ensure t)

(use-package blacken
  :hook
  (python-mode . blacken-mode))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(provide 'setup-python)
;;; setup-python.el ends here
