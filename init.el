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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package el-patch)

(require 'defaults)
(require 'setup-theme)

(when (eq window-system 'ns)
  (menu-bar-mode t)
  (add-hook 'after-init-hook 'toggle-frame-fullscreen))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Load personal packages
(require 'defuns)
(require 'key-bindings)
(require 'setup-emacs-lisp)
(require 'setup-helm)
(require 'setup-hippie)
(require 'setup-js)
(require 'setup-lsp)
(require 'setup-markdown)
(require 'setup-misc-modes)
(require 'setup-org)
(require 'setup-prog-mode)
(require 'setup-python)
(require 'setup-rust)
(require 'setup-terraform)
(require 'setup-yasnippet)

(let ((local-elisp (expand-file-name  "local.el" user-emacs-directory)))
  (when (file-exists-p local-elisp)
    (message "Local file '%s' found" local-elisp)
    (load-file local-elisp)))

(server-start)
;;; init.el ends here
