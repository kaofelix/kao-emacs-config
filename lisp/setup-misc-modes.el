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

;; dtrt-indent
(dtrt-indent-mode 1)

;; Paren face
(global-paren-face-mode)

(use-package smart-mode-line
  :init
  (smart-mode-line-enable))

(use-package which-key
  :init
  (which-key-mode t))

;; Smart parens
(require 'smartparens-config)

(defun kao/wrap-with-round-brackets (&optional arg)
  "Wrap next ARG expressions with round brackets."
  (interactive "P")
  (sp-wrap-with-pair "("))

(defvar kao/sp-bindings
  '(("C-M-f" . sp-forward-sexp)
    ("C-M-b" . sp-backward-sexp)

    ("C-M-n" . sp-next-sexp)
    ("C-M-p" . sp-previous-sexp)

    ("C-M-d" . sp-down-sexp)
    ("C-M-a" . sp-backward-down-sexp)
    ("C-S-d" . sp-beginning-of-sexp)
    ("C-S-a" . sp-end-of-sexp)
    ("C-M-e" . sp-up-sexp)
    ("C-M-u" . sp-backward-up-sexp)
    ("C-M-k" . sp-kill-sexp)
    ("C-M-w" . sp-copy-sexp)

    ("M-s" . sp-splice-sexp) ;; depth-changing commands
    ("M-S" . sp-split-sexp) ;; depth-changing commands

    ("M-(" . kao/wrap-with-round-brackets)
    ("C-)" . sp-forward-slurp-sexp) ;; barf/slurp
    ("C-}" . sp-forward-barf-sexp)
    ("C-(" . sp-backward-slurp-sexp)
    ("C-{" . sp-backward-barf-sexp)

    ("C-M-]" . sp-select-next-thing)
    ("M-F" . sp-forward-symbol)
    ("M-B" . sp-backward-symbol)))

(--each kao/sp-bindings
  (define-key sp-keymap (read-kbd-macro (car it)) (cdr it)))

;; Show paren
(show-paren-mode t)

;;; Projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

;; Man mode
(add-hook 'Man-mode-hook 'visual-line-mode)

;; Clean modeline
(with-eval-after-load 'rainbow-mode
  (diminish 'rainbow-mode))
(with-eval-after-load 'company
  (diminish 'company-mode))
(with-eval-after-load 'yasnippet
  (diminish 'yas-minor-mode))

(diminish 'smartparens-mode)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (define-key undo-tree-map (kbd "C-?") nil)
  (define-key undo-tree-map (kbd "C-/") nil))

(use-package git-gutter
  :diminish git-gutter-mode
  :bind
  ("C-x C-g" . git-gutter)
  ("C-x v =" . git-gutter:popup-hunk)
  ("C-x p" . git-gutter:previous-hunk)
  ("C-x n" . git-gutter:next-hunk)
  ("C-x v s" . git-gutter:stage-hunk)
  ("C-x v r" . git-gutter:revert-hunk)
  ("C-x v SPC" . git-gutter:mark-hunk))

;; Tramp with vc
(setq vc-ignore-dir-regexp
                (format "\\(%s\\)\\|\\(%s\\)"
                        vc-ignore-dir-regexp
                        tramp-file-name-regexp))

(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
