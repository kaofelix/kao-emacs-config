;;; setup-magit.el --- set up for Magit

;;; Commentary:
;;

;;; Code:
(require 'use-package)

(use-package magit
  :after (git-gutter)
  :delight magit-wip-mode
  :config
  (defun magit-status-project-dwim (always-prompt)
    "Run magit-status for current project or prompts for project.
When ALWAYS-PROMPT is passed, prompts for project even if it's
already inside a project."
    (interactive "P")
    (let ((project-root (projectile-project-p)))
      (if (and project-root (not always-prompt))
          (magit-status-setup-buffer project-root)
        (let ((relevant-projects (projectile-relevant-known-projects)))
          (if relevant-projects
              (let ((target-project (projectile-completing-read "Magit status for project: " relevant-projects)))
                (magit-status-setup-buffer target-project))
            (error "There are no known projects"))))))

  (add-hook 'magit-post-refresh-hook #'git-gutter:update-all-windows)
  :custom
  (magit-status-margin '(nil age-abbreviated magit-log-margin-width t 18))

  :bind
  ("C-c g" . 'magit-status-project-dwim))

(use-package forge
  :after magit
  :custom
  (forge-owned-accounts '(("kaofelix"))))

(provide 'setup-magit)

;;; setup-magit.el ends here
