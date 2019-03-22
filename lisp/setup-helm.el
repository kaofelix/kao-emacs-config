;;; setup-helm.el --- Setup helm

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(use-package shackle
  :init
  (shackle-mode 1))

(use-package helm
  :after shackle
  :delight helm-mode

  :init
  (require 'helm-config)
  (helm-mode 1)

  :config
  ;; Display helm nicely
  (defun helm-hide-minibuffer-maybe ()
    "Hides minibuffer when `helm-echo-input-in-header-line' is true."
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))
  (setq helm-echo-input-in-header-line t)
  (setq helm-display-function 'pop-to-buffer)
  (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.6)))
  (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

  :bind (([remap execute-extended-command] . helm-M-x)
         ([remap find-file] . helm-find-files)
         ([remap switch-to-buffer] . helm-mini)
         ([remap yank-pop] . helm-show-kill-ring)
         ([remap list-buffers] . helm-buffers-list)
         ([remap tab-to-tab-stop] . helm-swoop)
         ("C-c h" . helm-command-prefix)
         :map helm-map
         ("C-c g" . helm-git-grep-from-helm)
         :map helm-command-map
         ("h o" . helm-info-org)
         ("h l" . helm-info-elisp)
         ("o" . helm-occur)
         ("SPC" . helm-all-mark-rings)
         ("g" . helm-git-grep)
         :map isearch-mode-map
         ("C-c g" . helm-git-grep-from-isearch)))

(use-package wgrep-helm
  :after (helm))

(use-package helm-swoop
  :after (helm))

(use-package helm-projectile
  :after (helm)
  :init
  (helm-projectile-on)
  :config
  (defun kao/helm-projectile-ag (arg &optional dir)
    "Runs standard helm-do-grep-ag over a project as an action"
    (interactive "P")
    (if (or dir (projectile-project-p))
        (let ((default-directory (or dir (projectile-project-root))))
          (helm-do-grep-ag arg))
      (error "You're not in a project")))

  (defun kao/helm-projectile-ag-action (&optional dir)
    "Runs standard helm-do-grep-ag over a project as an action"
    (interactive)
    (kao/helm-projectile-ag nil dir))

  (defun kao/back-to-helm-projectile-switch-project ()
    (interactive)
    (helm-run-after-exit #'helm-projectile-switch-project))

  (fset #'helm-projectile-grep #'kao/helm-projectile-ag-action)

  :bind
  (:map helm-projectile-find-file-map
   ("C-l" . #'kao/back-to-helm-projectile-switch-project))
  (:map projectile-command-map
   ("s" . #'kao/helm-projectile-ag)))

(use-package helm-descbinds
  :after (helm)
  :init
  (helm-descbinds-mode))

(use-package helm-c-yasnippet
  :bind ("C-c y" . helm-yas-complete))

(provide 'setup-helm)
;;; setup-helm.el ends here
