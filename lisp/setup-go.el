;;; setup-go.el --- configs for go

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package go-mode
  :hook
  (go-mode . (lambda ()
               (setq tab-width 4))))

(provide 'setup-go)
;;; setup-go.el ends here
