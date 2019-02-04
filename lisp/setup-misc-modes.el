;;; setup-misc-modes.el --- Config for misc modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

;; Dependencies requires
(require 'f)

;; Compile packages asynchronously
(require 'async-bytecomp)

(desktop-save-mode 1)
(global-paren-face-mode)
(add-hook 'Man-mode-hook 'visual-line-mode)

(use-package smart-mode-line
  :init
  (smart-mode-line-enable))

(use-package which-key
  :init
  (which-key-mode t))

;; Smart parens
(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :init
  (defun kao/wrap-with-round-brackets (&optional arg)
    "Wrap next ARG expressions with round brackets."
    (interactive "P")
    (sp-wrap-with-pair "("))
  :config
  (show-smartparens-global-mode t)
  :bind
  (:map smartparens-mode-map
   ("C-M-f" . #'sp-forward-sexp)
   ("C-M-b" . #'sp-backward-sexp)
   ("C-M-n" . #'sp-next-sexp)
   ("C-M-p" . #'sp-previous-sexp)
   ("C-M-u" . #'sp-backward-up-sexp)
   ("C-M-d" . #'sp-down-sexp)
   ("C-M-a" . #'sp-beginning-of-sexp)
   ("C-M-e" . #'sp-end-of-sexp)
   ("C-M-k" . #'sp-kill-sexp)
   ("C-M-w" . #'sp-copy-sexp)
   ("M-s" . #'sp-splice-sexp) ;; depth-changing commands
   ("M-S" . #'sp-split-sexp)  ;; depth-changing commands
   ("M-(" . #'kao/wrap-with-round-brackets)
   ("C-)" . #'sp-forward-slurp-sexp) ;; barf/slurp
   ("C-}" . #'sp-forward-barf-sexp)
   ("C-(" . #'sp-backward-slurp-sexp)
   ("C-{" . #'sp-backward-barf-sexp)
   ("C-M-]" . #'sp-select-next-thing)
   ("M-F" . #'sp-forward-symbol)
   ("M-B" . #'sp-backward-symbol)))

;;; Projectile
(use-package projectile
  :config
  (projectile-mode +1)
  :bind
  (:map projectile-mode-map
   ("C-c p" . #'projectile-command-map)
   :map projectile-command-map
   ("s" . helm-projectile-ag)))

;; Visual regexp
(use-package visual-regexp
  :bind
  ("C-c r" . #'vr/replace)
  ("C-c q" . #'vr/query-replace)
  ("C-c m" . #'vr/mc-mark))

(use-package rainbow-mode
  :diminish)

(use-package yasnippet
  :diminish yas-minor-mode)

(use-package company
  :diminish company-mode
  :bind
  (("C-c C-M-i" . #'completion-at-point)
   :map company-mode-map
   ("C-M-i" . #'company-complete-common)
   :map company-active-map
   ("C-n" . #'company-select-next-or-abort)
   ("C-p" . #'company-select-previous-or-abort)))

(use-package undo-tree
  :diminish undo-tree-mode
  :bind
  (:map undo-tree-map
   ("C-?" . nil)
   ("C-/" . nil)))

(use-package git-gutter
  :diminish git-gutter-mode
  :bind
  ("C-x C-g" . #'git-gutter)
  ("C-x v =" . #'git-gutter:popup-hunk)
  ("C-x p" . #'git-gutter:previous-hunk)
  ("C-x n" . #'git-gutter:next-hunk)
  ("C-x v s" . #'git-gutter:stage-hunk)
  ("C-x v r" . #'git-gutter:revert-hunk)
  ("C-x v R" . #'vc-revert)
  ("C-x v SPC" . #'git-gutter:mark-hunk))

(use-package neotree
  :config
  (setq neo-theme 'nerd)
  (setq neo-smart-open t)
  (setq neo-show-hidden-files t)
  :bind
  (:map kao/toggle-map
   ("t" . #'neotree-toggle)))

(use-package avy
  :config
  (avy-setup-default)
  :bind
  (("C-;" . #'avy-goto-word-or-subword-1)))

(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
