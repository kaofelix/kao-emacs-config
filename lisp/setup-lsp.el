;;; setup-lsp.el --- configure LSP
;;; Commentary:
;;; Code:
(use-package lsp-mode
  :hook ((rust-mode . lsp)
         (typescript-mode . lsp)
         (web-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-keymap-prefix "s-l"))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(provide 'setup-lsp)
;;; setup-lsp ends here
