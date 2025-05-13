;;; setup-ruby.el --- configs for ruby

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package ruby-ts-mode
  :hook (ruby-ts-mode . eglot-ensure)
  :config
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((ruby-ts-mode) . ("ruby-lsp")))))

(provide 'setup-ruby)
;;; setup-ruby.el ends here
