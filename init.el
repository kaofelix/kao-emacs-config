;;; init.el --- Kao's init file

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix;; Custom theme <kaofelix@Steelix.local>
;; Keywords: local

;;; Commentary:

;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars.  It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;;; Code:
(setq custom-theme-directory (expand-file-name "custom-themes" user-emacs-directory))
(load-theme 'zenburn t)

;; Setup caches, autosave, and backups
(defvar cache-and-saves-dir (expand-file-name "caches-and-saves" user-emacs-directory))
(setq bookmark-default-file (expand-file-name "bookmarks" cache-and-saves-dir))
(setq ido-save-directory-list-file (expand-file-name "ido-last" cache-and-saves-dir))
(setq save-place-file (expand-file-name "places" cache-and-saves-dir))
(setq tramp-persistency-file-name (expand-file-name "tramp" cache-and-saves-dir))
(setq smex-save-file (expand-file-name "smex-items" cache-and-saves-dir))
(setq semanticdb-default-save-directory (expand-file-name "semanticdb" cache-and-saves-dir))
(setq backup-directory-alist
      `((".*" . ,(expand-file-name "backups" cache-and-saves-dir))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list" cache-and-saves-dir) t)))

(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(setq create-lockfiles nil)

;; Initialize Cask and Pallet
(require 'cask "/usr/local/Cellar/cask/0.7.1/cask.el")
(cask-initialize)
(require 'pallet)

;; GUI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)
(setq-default indicate-empty-lines t)

(when (eq window-system 'ns)
  (menu-bar-mode t))

(defalias 'yes-or-no-p 'y-or-n-p)

(set-frame-font "Source Code Pro-14" t t)

;; Misc
(delete-selection-mode 1)
(setq shift-select-mode nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 8)
(setq gc-cons-threshold 20000000)

;; Setup custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Shell Path
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

;; Load personal packages
(add-to-list 'load-path user-emacs-directory t)
(require 'kao-defuns)
(require 'kao-minor-mode-config)
(require 'kao-keybindings)

;;; init.el ends here
