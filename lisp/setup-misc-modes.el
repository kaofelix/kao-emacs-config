;;; -*- lexical-binding: t -*-
;;; setup-misc-modes.el --- Config for misc modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

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

(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches "-alh")
  (dired-dwim-target t))

(use-package persist-state
  :config
  (persist-state-mode))

(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

(use-package gptel
  :config
  (define-prefix-command 'gptel-prefix-map)
  (setq gptel-model 'deepseek-chat
        gptel-backend (gptel-make-deepseek "DeepSeek"
                        :stream t
                        :key #'gptel-api-key-from-auth-source))
  :bind
  ("C-c RET" . #'gptel-menu)
  ("C-c c" . 'gptel-prefix-map)
  (:map gptel-prefix-map
   ("r" . #'gptel-rewrite)
   ("a" . #'gptel-context-add)
   ("k" . #'gptel-context-remove)
   ("DEL" . #'gptel-context-remove-all)))

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize))
  :custom
  (exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-shell-name "/bin/zsh")
  (exec-path-from-shell-variables '("PATH" "MANPATH" "WORKON_HOME")))

(use-package prodigy)

(use-package hydra)

(use-package paren-face
  :config
  (global-paren-face-mode))

(use-package try
  :commands #'try)

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25 "Make modeline taller"))

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
   ([remap isearch-query-replace-regexp] . #'anzu-isearch-query-replace-regexp))
  :custom
  (anzu-replace-to-string-separator " => ")
  (auto-revert-check-vc-info t))

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

(use-package avy
  :config
  (avy-setup-default)
  ;; Any lower-case letter a-z.
  (setq avy-keys (number-sequence ?a ?z))
  :bind
  (("C-;" . #'avy-goto-word-or-subword-1))
  :custom
  (avy-background t))

(use-package ace-window
  :bind
  (("C-x o" . #'ace-window))
  :config
  (setq aw-ignore-current t
        aw-ignored-buffers '(" *NeoTree*")))

(use-package direnv
  :config
  (direnv-mode)
  (add-to-list 'direnv-non-file-modes 'magit-status-mode))

(use-package git-modes)

(use-package git-timemachine
  :bind (:map kao/toggle-map
         ("g" . #'git-timemachine-toggle)))

(use-package origami
  :hook (yaml-mode . origami-mode)
  :bind (:map origami-mode-map
         ("C-c [ [" . #'origami-toggle-node)))

(use-package goto-line-preview
  :bind (([remap goto-line] . #'goto-line-preview)))

(use-package toml-mode)
(use-package nginx-mode
  :after (dtrt-indent)
  :config
  (add-to-list 'dtrt-indent-hook-mapping-list '(nginx-mode default nginx-indent-level)))

(use-package jq-mode)

(use-package restclient
  :after (jq-mode)
  :commands (restclient-jq-interactive-result)
  :mode  ("\\.http\\'" . restclient-mode))

(use-package sudo-edit)

(use-package vterm
  :custom
  (vterm-shell "/bin/zsh -l"))

(use-package eat)

(use-package string-inflection
  :config
  (defun repeatable-string-inflection-cycle ()
    (interactive)
    (kao/type-last-key-to-repeat
      (string-inflection-cycle)))
  :bind
  ("C-c i" . 'repeatable-string-inflection-cycle))

(use-package highlight-indent-guides
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'top))

(use-package csv-mode
  :bind
  (:map csv-mode-map
   ("C-c C-c" . #'csv-align-mode)))

(use-package rainbow-csv
  :vc (:url "https://github.com/emacs-vs/rainbow-csv" :rev :newest)
  :hook (csv-mode . rainbow-csv-mode))

(use-package yank-indent
  :vc (:url "https://github.com/jimeh/yank-indent" :rev :newest)
  :config (global-yank-indent-mode t))

(use-package dotenv-mode
  :mode (("\\.env\\..*\\'" . dotenv-mode)
         ("\\.env\\'" . dotenv-mode)))

(use-package fix-word
  :bind
  ("M-u" . #'fix-word-upcase)
  ("M-l" . #'fix-word-downcase))



(use-package graphviz-dot-mode)
(use-package mermaid-mode)
(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
