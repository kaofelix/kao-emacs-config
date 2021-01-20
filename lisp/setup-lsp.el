;;; setup-lsp.el --- configure LSP
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package lsp-mode
  :hook ((rust-mode . lsp)
         (go-mode . lsp)
         (typescript-mode . lsp)
         (web-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  :config
  (setq lsp-keymap-prefix "s-l")
  (lsp-modeline-code-actions-mode)
  :custom
  (lsp-headerline-breadcrumb-enable nil))

(use-package company-lsp :commands company-lsp)

(provide 'setup-lsp)
;;; setup-lsp ends here
