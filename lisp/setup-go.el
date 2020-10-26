;;; setup-go.el --- configs for go

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package go-mode
  :hook
  (go-mode . (lambda ()
               (setq tab-width 4)
               (add-hook 'before-save-hook #'gofmt-before-save nil t))))

(provide 'setup-go)
;;; setup-go.el ends here
