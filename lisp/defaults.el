;;; defaults.el --- nice defaults

;; Copyright (C) 2014  Kao Felix

;;; Commentary:

;;

;;; Code:

;; GUI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)
(setq-default indicate-empty-lines t)
(set-frame-font "Source Code Pro-13" t t)
(require 'pixel-scroll)
(pixel-scroll-mode 1)

(require 'saveplace)

(defvar cache-and-saves-dir (expand-file-name "caches-and-saves" user-emacs-directory))
(setq bookmark-default-file (expand-file-name "bookmarks" cache-and-saves-dir))
(setq ido-save-directory-list-file (expand-file-name "ido-last" cache-and-saves-dir))
(setq-default save-place t)
(setq save-place-file (expand-file-name "places" cache-and-saves-dir))
(setq tramp-persistency-file-name (expand-file-name "tramp" cache-and-saves-dir))
(setq semanticdb-default-save-directory (expand-file-name "semanticdb" cache-and-saves-dir))
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" cache-and-saves-dir))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list/" cache-and-saves-dir) t)))

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
(set-default 'indicate-empty-lines t)

(recentf-mode 1)
(setq recentf-max-saved-items 100) ;; just 20 is too recent

(savehist-mode 1)
(setq savehist-file (expand-file-name "history" cache-and-saves-dir))
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
