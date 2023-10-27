;;; setup-terraform.el --- configs for terraform

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package terraform-mode
  :config
  (add-hook 'terraform-mode-hook 'terraform-format-on-save-mode))

(provide 'setup-terraform)
;;; setup-terraform.el ends here
