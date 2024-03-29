;;; setup-js.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(defun kao/ts-eglot-organize-imports ()
  (interactive)
  (eglot-code-actions nil nil "source.organizeImports.ts" t)
  (eglot-code-actions nil nil "source.removeUnusedImports.ts" t))

(defun setup-typescript()
  (eglot-ensure)
  (eglot--code-action eglot-code-action-organize-imports "source.organizeImports.ts")
  (eglot--code-action eglot-code-action-remove-unused-import "source.removeUnusedImports.ts")
  (add-hook 'before-save-hook 'kao/ts-eglot-organize-imports nil t))

(use-package typescript-ts-mode
  :hook
  (typescript-ts-mode . setup-typescript)
  (tsx-ts-mode . setup-typescript)
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode)))

(provide 'setup-js)
;;; setup-js.el ends here
