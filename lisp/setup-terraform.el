;;; setup-terraform.el --- configs for terraform

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package terraform-mode
  :hook (terraform-mode . outline-minor-mode)
  :custom
  (terraform-format-on-save t))

(provide 'setup-terraform)
;;; setup-terraform.el ends here
