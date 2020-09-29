;;; setup-rust.el --- configs for rust

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package cargo
  :delight cargo-minor-mode)

(use-package rust-mode
  :config
  (setq rust-format-on-save t)
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook #'cargo-minor-mode))

(provide 'setup-rust)
;;; setup-rust.el ends here
