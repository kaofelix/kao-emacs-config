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
;;
(require 'minimal-gui)
(require 'emoji)

;; straight.el + use-package setup
(setq package-install-upgrade-built-in t)
(set-default 'straight-use-package-by-default t)
(set-default 'straight-vc-git-default-protocol 'ssh)
(set-default 'straight-disable-native-compile nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(eval-when-compile
  (require 'use-package))
(use-package delight)
;; end straight.el + use-package setup

(require 'defaults)

(use-package el-patch)
(require 'setup-theme)

(when (eq window-system 'ns)
  (menu-bar-mode t))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Load personal packages
(require 'defuns)
(require 'key-bindings)
(require 'setup-treemacs)
(require 'setup-docker)
(require 'setup-emacs-lisp)
(require 'setup-completion)
;; (require 'setup-gdscript)
(require 'setup-hippie)
;; (require 'setup-groovy)
(require 'setup-js)
(require 'setup-markdown)
(require 'setup-misc-modes)
(require 'setup-magit)
(require 'setup-prog-mode)
(require 'setup-project)
(require 'setup-python)
(require 'setup-rust)
(require 'setup-terraform)
(require 'setup-yasnippet)
(require 'setup-go)
(require 'setup-swift)

(let ((local-elisp (expand-file-name  "local.el" user-emacs-directory)))
  (when (file-exists-p local-elisp)
    (message "Local file '%s' found" local-elisp)
    (load-file local-elisp)))

(server-start)
;;; init.el ends here
