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
(add-to-list 'load-path user-emacs-directory t)
(setq custom-theme-directory (expand-file-name "custom-themes" user-emacs-directory))
(load-theme 'zenburn t)

(setq user-mail-address "kcfelix@gmail.com")

;; Defaults
(require 'defaults)

;; Initialize Cask and Pallet
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)

(when (eq window-system 'ns)
  (menu-bar-mode t)
  (add-hook 'after-init-hook 'toggle-frame-fullscreen))

;; Setup custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Shell Path
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


;; Load personal packages
(require 'defuns)
(require 'key-bindings)
(require 'setup-minor-modes)
(require 'setup-hippie)
(require 'setup-yasnippet)
(require 'setup-prog-mode)
(require 'setup-emacs-lisp)
(require 'setup-ruby)
(require 'setup-javascript)

;;; init.el ends here
