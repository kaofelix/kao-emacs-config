;;; setup-misc-modes.el --- Config for misc modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

;; Dependencies requires
(require 'use-package)

(use-package f)

;; Compile packages asynchronously
(use-package async
  :config
  (async-bytecomp-package-mode 1))

(add-hook 'Man-mode-hook 'visual-line-mode)

(use-package emacs
  :delight subword-mode
  :config
  (global-subword-mode 1)
  :bind
  ([remap open-line] . #'kao/open-line))

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package hydra)

(use-package paren-face
  :config
  (global-paren-face-mode))

(use-package try
  :commands #'try)

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (defun my-doom-modeline--font-height ()
    "Calculate the actual char height of the mode-line."
    (+ (frame-char-height) 2))
  (advice-add #'doom-modeline--font-height :override #'my-doom-modeline--font-height))

(use-package which-key
  :delight
  :init
  (which-key-mode t))

;; Smart parens
(use-package smartparens
  :delight smartparens-mode
  :init
  (defun kao/wrap-with-round-brackets (&optional arg)
    "Wrap next ARG expressions with round brackets."
    (interactive "P")
    (sp-wrap-with-pair "("))
  :config
  (require 'smartparens-config)
  (show-smartparens-global-mode t)
  (smartparens-global-mode t)
  :hook ((emacs-lisp-mode . smartparens-strict-mode)
         (eval-expression-minibuffer-setup . smartparens-mode))
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
   ("M-B" . #'sp-backward-symbol)
   ("s-'" . #'sp-rewrap-sexp)))

(use-package anzu
  :delight
  :init
  (global-anzu-mode 1)
  :bind
  (([remap query-replace] . #'anzu-query-replace)
   ([remap query-replace-regexp] . #'anzu-query-replace-regexp)
   ("S-<f6>" . #'anzu-replace-at-cursor-thing)
   ("C-S-<f6>" . #'anzu-query-replace-at-cursor)
   :map isearch-mode-map
   ([remap isearch-query-replace] .  #'anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . #'anzu-isearch-query-replace-regexp)))

(use-package rainbow-mode
  :delight
  :hook (prog-mode css-mode))

(use-package undo-tree
  :delight undo-tree-mode
  :config
  (global-undo-tree-mode 1)
  :bind
  (:map undo-tree-map
   ("C-?" . nil)
   ("C-/" . nil)))

(use-package git-gutter
  :after (hydra)
  :delight git-gutter-mode
  :config
  (defhydra hydra-zoom (global-map "C-x v")
    "next/previous hunk"
    ("n" #'git-gutter:next-hunk "next")
    ("p" #'git-gutter:previous-hunk "previous"))
  (global-git-gutter-mode t)
  :bind
  ("C-x C-g" . #'git-gutter)
  ("C-x v =" . #'git-gutter:popup-hunk)
  ("C-x v C-=" . #'vc-diff)
  ("C-x v s" . #'git-gutter:stage-hunk)
  ("C-x v r" . #'git-gutter:revert-hunk)
  ("C-x v R" . #'vc-revert)
  ("C-x v SPC" . #'git-gutter:mark-hunk))

(use-package neotree
  :config
  (defun neotree-project ()
    "Open NeoTree in project root."
    (interactive)
    (let ((project-dir (project-root (project-current t)))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if (neo-global--window-exists-p)
          (progn
            (neotree-dir project-dir)
            (neotree-find file-name)))))

  (setq neo-theme 'icons
        neo-smart-open t
        neo-show-hidden-files t
        neo-autorefresh nil
        neo-show-updir-line nil
        neo-mode-line-type 'none
        neo-default-system-application "open"
        neo-hide-cursor t
        neo-window-fixed-size nil
        neo-window-width 35)

  :bind
  (("s-1" . #'neotree-project)
   :map neotree-mode-map
   ("C" . #'neotree-copy-node)
   ("D" . #'neotree-delete-node)
   ("R" . #'neotree-rename-node)
   ("+" . #'neotree-create-node)))

(use-package avy
  :config
  (avy-setup-default)
  ;; Any lower-case letter a-z.
  (setq avy-keys (number-sequence ?a ?z))
  :bind
  (("C-;" . #'avy-goto-word-or-subword-1)))

(use-package ace-window
  :bind
  (("C-x o" . #'ace-window)))

(use-package direnv
  :config
  (direnv-mode)
  (add-to-list 'direnv-non-file-modes 'magit-status-mode))

(use-package dockerfile-mode)

(use-package docker
  :bind
  ("H-d" . 'docker))

(use-package gitignore-mode)

(use-package git-timemachine
  :bind (:map kao/toggle-map
         ("g" . #'git-timemachine-toggle)))

(use-package docker-compose-mode
  :config
  (add-hook 'docker-compose-mode-hook 'company-mode)
  (add-to-list 'auto-mode-alist
               '("docker-compose[^/]*\\.ya?ml\\'" . docker-compose-mode)))

(use-package origami
  :hook (yaml-mode . origami-mode)
  :bind (:map origami-mode-map
         ("C-c [ [" . #'origami-toggle-node)))

(use-package goto-line-preview
  :bind (([remap goto-line] . #'goto-line-preview)))

(use-package toml-mode)
(use-package yaml-mode)
(use-package nginx-mode)

(use-package restclient
  :mode ("\\.http\\'" . restclient-mode))

(use-package company-restclient
  :after (company)
  :hook (restclient-mode . company-mode))

(use-package sudo-edit)

(use-package vterm
  :custom
  (vterm-shell "/bin/zsh -l"))

(use-package pico8-mode
  :after (project)
  :straight (:host github :repo "Kaali/pico8-mode"))

(use-package dumb-jump
  :after (project)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package emojify
  :hook (after-init . global-emojify-mode)
  :custom
  (emojify-emoji-styles '(github unicode))
  (emojify-display-style 'unicode))

(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
