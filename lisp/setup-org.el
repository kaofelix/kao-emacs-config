;;; setup-org.el --- Setup org-mode

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package org
  :pin org
  :config
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg/")
  :bind
  ("C-c c" . #'org-capture)
  ("C-c l" . #'org-store-link))

(use-package org-bullets
  :after (org)
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package org-tree-slide
  :after (org)
  :bind
  (:map org-mode-map
        ("<f8>" . #'org-tree-slide-mode)
        :map org-tree-slide-mode-map
        ("<f7>" . #'org-tree-slide-move-previous-tree)
        ("<f9>" . #'org-tree-slide-move-next-tree)))

(provide 'setup-org)
;;; setup-org.el ends here
