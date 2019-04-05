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

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(eval-when-compile
  (add-to-list 'load-path (expand-file-name "use-package" user-emacs-directory) t)
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(require 'defaults)
(require 'setup-theme)

(when (eq window-system 'ns)
  (menu-bar-mode t)
  (add-hook 'after-init-hook 'toggle-frame-fullscreen))

;; Setup custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Load personal packages
(require 'defuns)
(require 'key-bindings)
(require 'setup-misc-modes)
(require 'setup-hippie)
(require 'setup-yasnippet)
(require 'setup-prog-mode)
(require 'setup-emacs-lisp)
(require 'setup-markdown)
(require 'setup-python)
(require 'setup-org)
(require 'setup-helm)
(require 'setup-terraform)
(require 'setup-rust)

(server-start)
;;; init.el ends here
