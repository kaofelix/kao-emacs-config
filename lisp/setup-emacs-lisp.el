;;; emacs-lisp.el --- Config for Emacs Lisp editing

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, lisp

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package elisp-slime-nav
  :delight
  :hook (emacs-lisp-mode . elisp-slime-nav-mode))

(use-package highlight-quoted
  :hook ((emacs-lisp-mode lisp-interaction-mode) . highlight-quoted-mode))

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

(defface emacs-lisp-keyword-symbol-face
  '((t :inherit font-lock-variable-name-face))
  "Face to highlight Lisp keyword symbols (e.g. :foobar)."
  :group 'keyword-symbol)

(font-lock-add-keywords 'emacs-lisp-mode
                        '((":\\(\\sw\\|\\s_\\|\\\\.\\)+" . 'emacs-lisp-keyword-symbol-face)))

(provide 'setup-emacs-lisp)
;;; setup-emacs-lisp.el ends here
