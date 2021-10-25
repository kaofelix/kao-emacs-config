;;; setup-magit.el --- set up for Magit

;;; Commentary:
;;

;;; Code:
(require 'use-package)

(use-package magit
  :after (git-gutter)
  :delight magit-wip-mode
  :config
  (add-hook 'magit-post-refresh-hook #'git-gutter:update-all-windows)
  :custom
  (magit-status-margin '(nil age-abbreviated magit-log-margin-width t 18))

  :bind
  ("C-c g" . #'magit-project-status)
  (:map magit-mode-map
   ("C-M-u" . #'magit-section-up)))

(use-package forge
  :after magit
  :custom
  (forge-owned-accounts '(("kaofelix"))))

(use-package browse-at-remote)

(provide 'setup-magit)

;;; setup-magit.el ends here
