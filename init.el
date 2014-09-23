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

;; Initialize Cask and Pallet
(require 'cask "/usr/local/Cellar/cask/0.7.1/cask.el")
(cask-initialize)
(require 'pallet)

;; GUI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

(when (eq window-system 'ns)
  (menu-bar-mode t))
(set-frame-font "Source Code Pro-14" t t)

;;; Setup custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(add-to-list 'load-path user-emacs-directory t)

(require 'kao-keybindings)

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

;;; init.el ends here
