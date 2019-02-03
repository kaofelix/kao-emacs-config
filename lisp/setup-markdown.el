;;; setup-markdown.el --- Setup markdown

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, wp

;;; Commentary:

;;

;;; Code:
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :init  (setq markdown-command "multimarkdown")
  :config
  (add-hook 'markdown-mode-hook #'auto-fill-mode)
  (add-hook 'markdown-mode-hook #'orgtbl-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :bind
  (:map markdown-mode-map
   ("M-<up>" . #'markdown-move-up)
   ("M-<down>" . #'markdown-move-down)
   ("M-<left>" . #'markdown-promote)
   ("M-<right>" . #'markdown-demote)
   ("M-S-<up>" . #'markdown-table-delete-row)
   ("M-S-<down>" . #'markdown-table-insert-row)
   ("M-S-<left>" . #'markdown-table-delete-column)
   ("M-S-<right>" . #'markdown-table-insert-column)))

(provide 'setup-markdown)
;;; setup-markdown.el ends here
