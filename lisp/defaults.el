;;; defaults.el --- nice defaults

;; Copyright (C) 2014  Kao Felix

;;; Commentary:

;;

;;; Code:
(setq ring-bell-function 'ignore)
(require 'pixel-scroll)
(pixel-scroll-mode 1)

(require 'saveplace)

(setq insert-directory-program "/usr/local/bin/gls")

(setq apropos-do-all t
      require-final-newline t
      visible-bell t)

(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      create-lockfiles nil)

(setq load-prefer-newer t)
(setq x-select-enable-clipboard t
      save-interprogram-paste-before-kill t)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(setq echo-keystrokes 0.1)
(setq delete-by-moving-to-trash t)
(setq shift-select-mode nil)
(auto-compression-mode t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; UTF-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setenv "LC_ALL" "en_US.UTF-8")

(delete-selection-mode 1)
(setq line-number-mode t)
(setq column-number-mode t)
(setq fill-column 80)
(set-default 'indent-tabs-mode nil)

(recentf-mode 1)
(setq recentf-max-saved-items 100) ;; just 20 is too recent

(savehist-mode 1)
(setq history-length 1000)

(winner-mode 1)

(setq-default truncate-lines t)
(setq gc-cons-threshold 100000000)
(set-default 'sentence-end-double-space nil)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(provide 'defaults)
;;; defaults.el ends here
