;;; setup-js.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package nvm
  :after (web-mode)
  :hook (web-mode . nvm-use-for-buffer))

(use-package add-node-modules-path
  :after (web-mode)
  :hook (web-mode . add-node-modules-path))

(use-package web-mode
  :mode
  ("\\.ejs\\'" "\\.hbs\\'" "\\.html\\'" "\\.php\\'" "\\.[jt]sx?\\'")
  :config
  (setq web-mode-content-types-alist '(("jsx" . "\\.[jt]sx?\\'")))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-comment-annotation t)
  (setq web-mode-enable-comment-interpolation t)

  (defun setup-web-mode-ff-other-file()
    (setq ff-search-directories '(".")
          ff-other-file-alist '(("\\.spec\\.ts$" (".ts"))
                                ("\\.ts$" (".spec.ts"))
                                ("\\.test\\.ts$" (".ts"))
                                ("\\.ts$" (".test.ts"))
                                ("\\.spec\\.js$" (".js"))
                                ("\\.js$" (".spec.js"))
                                ("\\.test\\.js$" (".js"))
                                ("\\.js$" (".test.js")))))
  :hook
  (web-mode . setup-web-mode-ff-other-file))

(provide 'setup-js)
;;; setup-js.el ends here
