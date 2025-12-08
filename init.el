;;; init.el --- Kao's init file

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix;; Custom theme <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars.  It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;;; Code:
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory) t)
(setq user-mail-address "me@kaofelix.dev")


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(require 'defaults)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Load personal packages
(require 'setup-theme)
(require 'defuns)
(require 'key-bindings)
(require 'setup-hippie)
(require 'setup-completion)
(require 'setup-misc-modes)
(require 'setup-yasnippet)
(require 'setup-project)
(require 'setup-magit)
(require 'setup-treemacs)
(require 'setup-prog-mode)
(require 'setup-emacs-lisp)
(require 'setup-js)
(require 'setup-python)
(require 'setup-ruby)
(require 'setup-markdown)
(require 'setup-terraform)
(require 'setup-docker)
(require 'setup-ai)

;;(require 'setup-rust)
;;(require 'setup-go)
;;(require 'setup-swift)

;;(let ((local-elisp (expand-file-name  "local.el" user-emacs-directory)))
;;  (when (file-exists-p local-elisp)
;;    (message "Local file '%s' found" local-elisp)
;;    (load-file local-elisp)))

(server-start)
;;; init.el ends here
