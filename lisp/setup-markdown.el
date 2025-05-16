;;; setup-markdown.el --- Setup markdown

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, wp

;;; Commentary:

;;

;;; Code:
(use-package adaptive-wrap
  :hook (text-mode . adaptive-wrap-prefix-mode))

(use-package visual-fill-column
  :hook (markdown-mode . visual-line-fill-column-mode)
  :custom
  (visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-center-text nil)
  (visual-fill-column-width 100))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :init
  (setq markdown-command "multimarkdown")
  (setq markdown-open-command (expand-file-name "bin/mark" user-emacs-directory))
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.mdx\\'" . markdown-mode))

  :custom
  (markdown-header-scaling t)

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
