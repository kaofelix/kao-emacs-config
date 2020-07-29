;;; setup-ivy.el --- Setup helm

;; Copyright (C) 2020  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package wgrep)
(use-package amx)
(use-package flx)

(use-package counsel
  :after ivy
  :delight
  :config
  (setq ivy-initial-inputs-alist nil)
  (counsel-mode))

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
        '((swiper . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  (ivy-mode))

(use-package swiper
  :after ivy
  :bind (("M-i" . swiper)))

(provide 'setup-ivy)
;;; setup-ivy.el ends here
