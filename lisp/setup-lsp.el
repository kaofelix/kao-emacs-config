;;; setup-lsp.el --- configure LSP
;;; Commentary:
;;; Code:
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
  (setq lsp-modeline-diagnostics-enable t)
  (lsp-modeline-code-actions-mode))

(use-package company-lsp :commands company-lsp)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package lsp-ivy
  :after (ivy)
  :bind (("s-o" . lsp-ivy-workspace-symbol)))

(provide 'setup-lsp)
;;; setup-lsp ends here
