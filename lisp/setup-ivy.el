;;; setup-ivy.el --- Setup helm

;; Copyright (C) 2020  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)
(require 'cl-lib)

(use-package wgrep)

(use-package counsel
  :after ivy
  :delight
  :config
  (setq ivy-initial-inputs-alist nil)
  :bind
  (("C-c i" . counsel-imenu))
  :custom
  (counsel-yank-pop-preselect-last t)
  (counsel-yank-pop-separator "\n---\n"))

(use-package counsel-projectile
  :after counsel
  :bind
  (:map projectile-command-map
   ("s" . #'counsel-projectile-rg))
  :config
  (setq counsel-projectile-key-bindings
      (cl-remove-if (lambda (kb)
		      (and (stringp (car kb))
			   (string-prefix-p "s" (car kb))))
		    counsel-projectile-key-bindings))
  (add-to-list 'counsel-projectile-key-bindings '("s" . counsel-projectile-rg) t))

(use-package ivy
  :defer 0.1
  :delight
  :bind (("C-c C-r" . ivy-resume))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  (ivy-height 20)
  (ivy-wrap t)
  (ivy-use-selectable-prompt t)
  :config
  (setq ivy-re-builders-alist
        '((counsel-rg . ivy--regex-plus)
          (t . ivy--regex-plus)))
  (ivy-mode))

(use-package ivy-prescient
  :after (ivy counsel counsel-projectile)
  :config
  (counsel-mode)
  (counsel-projectile-mode)
  (ivy-prescient-mode)
  (prescient-persist-mode))

(use-package swiper
  :after ivy
  :bind (("M-i" . swiper)))

(provide 'setup-ivy)
;;; setup-ivy.el ends here
