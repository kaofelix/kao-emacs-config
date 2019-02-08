;;; setup-rust.el --- configs for rust

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package flycheck-rust)
(use-package cargo)
(use-package racer)
(use-package rust-mode
  :delight 'cargo-minor-mode
  :config
  (setq rust-format-on-save t)
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook #'cargo-minor-mode)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

(provide 'setup-rust)
;;; setup-rust.el ends here
