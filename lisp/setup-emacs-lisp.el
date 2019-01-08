;;; emacs-lisp.el --- Config for Emacs Lisp editing

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, lisp

;;; Commentary:

;;

;;; Code:
(add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)
(add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode)

(add-hook 'lisp-interaction-mode-hook 'elisp-slime-nav-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)

(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'smartparens-mode)

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

(defface emacs-lisp-keyword-symbol-face
  '((t :inherit font-lock-variable-name-face))
  "Face to highlight Lisp keyword symbols (starting with :)."
  :group 'keyword-symbol)

(font-lock-add-keywords
 'emacs-lisp-mode
 '((":\\(\\sw\\|\\s_\\|\\\\.\\)+" . 'emacs-lisp-keyword-symbol-face)))

(provide 'setup-emacs-lisp)
;;; setup-emacs-lisp.el ends here
