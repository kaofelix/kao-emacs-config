;;; setup-helm.el --- Setup helm

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(require 'helm-config)

;; Projectile integration
(require 'helm-projectile)
(helm-projectile-on)
(helm-mode 1)

(global-set-key [remap execute-extended-command] 'helm-M-x)
(global-set-key [remap find-file] 'helm-find-files)
(global-set-key [remap switch-to-buffer] 'helm-mini)
(global-set-key [remap yank-pop] 'helm-show-kill-ring)
(global-set-key [remap list-buffers] 'helm-buffer-list)

(define-key helm-command-map (kbd "o") 'helm-occur)
(define-key helm-command-map (kbd "SPC") 'helm-all-mark-rings)

;; git grep
(define-key helm-command-map (kbd "g") 'helm-git-grep)
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)

(provide 'setup-helm)
;;; setup-helm.el ends here
