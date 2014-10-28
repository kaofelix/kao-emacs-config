;;; init.el --- Kao's init file

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix;; Custom theme <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars.  It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;;; Code:
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory) t)
(setq user-mail-address "kcfelix@gmail.com")

;; Defaults
(require 'defaults)

;; Initialize Cask and Pallet
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)

(require 'setup-theme)

(when (eq window-system 'ns)
  (menu-bar-mode t)
  (add-hook 'after-init-hook 'toggle-frame-fullscreen))

;; Setup custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Shell Path and Args
(defvar explicit-zsh-args '("--login" "-i"))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Load personal packages
(require 'defuns)
(require 'key-bindings)
(require 'setup-misc-modes)
(require 'setup-hippie)
(require 'setup-yasnippet)
(require 'setup-prog-mode)
(require 'setup-emacs-lisp)
(require 'setup-ruby)
(require 'setup-sml)
(require 'setup-javascript)
(require 'setup-helm)

;;; init.el ends here
