;;; setup-org.el --- Setup org-mode

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package org
  :ensure org-bullets
  :config
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'org-bullets-mode)
  :bind
  ("C-c c" . #'org-capture)
  ("C-c l" . #'org-store-link))

(use-package org-mobile
  :config
  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg/"))

(use-package org-tree-slide
  :bind
  (:map org-mode-map
        ("<f8>" . #'org-tree-slide-mode)
        :map org-tree-slide-mode-map
        ("<f7>" . #'org-tree-slide-move-previous-tree)
        ("<f9>" . #'org-tree-slide-move-next-tree)))

(provide 'setup-org)
;;; setup-org.el ends here
