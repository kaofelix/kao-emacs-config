;;; setup-js.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package add-node-modules-path
  :after (typescript-ts-mode tsx-ts-mode)
  :hook
  (typescript-ts-mode . add-node-modules-path)
  (tsx-ts-mode . add-node-modules-path))

(provide 'setup-js)
;;; setup-js.el ends here
