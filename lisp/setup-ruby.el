;;; setup-ruby.el --- configs for ruby

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) . ("mise" "x" "--" "ruby-lsp"))))

(provide 'setup-ruby)
;;; setup-ruby.el ends here
