;;; setup-ruby.el --- configs for ruby

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package ruby-ts-mode
  :hook (ruby-ts-mode . eglot-ensure)
  :mode ("\\.rb\\'" "\\.rake\\'" "\\.gemspec\\'" "\\.ru\\'")
  :config
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((ruby-ts-mode) . ("ruby-lsp")))))

(use-package rspec-mode
  :after ruby-ts-mode
  :hook (ruby-ts-mode . rspec-mode)
  :custom
  (rspec-use-rake-when-possible nil)
  (rspec-use-bundler-when-possible nil))

(provide 'setup-ruby)
;;; setup-ruby.el ends here
