;;; setup-ivy.el --- Setup helm

;; Copyright (C) 2020  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package wgrep)

(use-package counsel
  :after ivy
  :delight
  :config
  (setq ivy-initial-inputs-alist nil)
  (counsel-mode)
  :custom
  (counsel-yank-pop-preselect-last t)
  (counsel-yank-pop-separator "\n---\n"))

(use-package counsel-projectile
  :after counsel
  :bind (:map projectile-command-map
         ("s" . #'counsel-projectile-rg))
  :config (counsel-projectile-mode))

(use-package ivy
  :defer 0.1
  :delight
  :bind (("C-c C-r" . ivy-resume))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  (ivy-height 20)
  :config
  (setq ivy-re-builders-alist
        '((counsel-rg . ivy--regex-plus)))
  (ivy-mode))

(use-package ivy-prescient
  :after (ivy counsel)
  :config
  (ivy-prescient-mode)
  (prescient-persist-mode))

(provide 'setup-ivy)
;;; setup-ivy.el ends here
