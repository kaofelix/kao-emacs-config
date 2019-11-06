;;; setup-js.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package tide
  :after (rjsx-mode company flycheck)
  :hook ((rjsx-mode . tide-setup)))

(use-package prettier-js
  :hook (rjsx-mode . prettier-js-mode))

(use-package rjsx-mode
  :mode "\\.js\\'")

(provide 'setup-js)
;;; setup-js.el ends here
