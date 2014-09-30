;;; emacs-lisp.el --- Config for Emacs Lisp editing

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local, lisp

;;; Commentary:

;;

;;; Code:

(add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)

(add-hook 'lisp-interaction-mode-hook 'elisp-slime-nav-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

(provide 'setup-emacs-lisp)
;;; setup-emacs-lisp.el ends here
