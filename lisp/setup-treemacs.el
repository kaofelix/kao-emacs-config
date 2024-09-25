;;; setup-treemacs.el --- Treemacs setup -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:
(require 'use-package)

(use-package all-the-icons)

(use-package treemacs
  :custom
  (treemacs-is-never-other-window           t)
  (treemacs-read-string-input               'from-minibuffer)

  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'only-when-focused)

  (with-eval-after-load 'doom-themes
    (setq doom-themes-treemacs-theme "doom-atom")
    (doom-themes-treemacs-config)

    ;; prevent doom-themes from messing with treemacs
    (defun doom-themes-hide-fringes-maybe (&rest _))
    (defun doom-themes-hide-modeline ()))

  (when treemacs-python-executable
    (treemacs-git-commit-diff-mode t))

  (pcase (cons (not (null (executable-find "git")))
               (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))

  (treemacs-hide-gitignored-files-mode nil)
  (defun kao/treemacs-close ()
    (interactive)
    (when (eq (treemacs-current-visibility) 'visible)
      (delete-window (treemacs-get-local-window))))

  :bind
  (:map global-map
   ("s-1" . #'treemacs-add-and-display-current-project-exclusively)
   ("s-]" . #'treemacs-add-and-display-current-project-exclusively)
   ("s-[" . #'kao/treemacs-close)))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))

(provide 'setup-treemacs)
;;; setup-treemacs.el ends here
