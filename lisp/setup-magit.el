;;; setup-magit.el --- set up for Magit

;;; Commentary:
;;

;;; Code:

(use-package magit
  :bind
  ("C-c g" . #'magit-project-status)
  (:map magit-mode-map
   ("C-M-u" . #'magit-section-up))
  :config
  (add-hook 'after-save-hook 'magit-after-save-refresh-status t)

  :custom
  (magit-save-repository-buffers 'dontask))

(use-package browse-at-remote
  :bind
  ("C-c b" . #'browse-at-remote))

(provide 'setup-magit)

;;; setup-magit.el ends here
