;;; setup-rust.el --- configs for rust

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package rust-mode
  :delight 'cargo-minor-mode
  :hook  (rust-mode . lsp)
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(provide 'setup-rust)
;;; setup-rust.el ends here
