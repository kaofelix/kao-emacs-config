;;; setup-project.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(defun kao/vterm-project-dwim()
  "Opens a vterm with or without a project."
  (interactive)
  (let ((project-name (cond ((project-current) (project-root (project-current)))
                            (t "no-project"))))
    (if-let* ((buffer-name (format "*vterm - %s*"  project-name))
              (buffer-live-p (get-buffer buffer-name)))
        (if (string-equal (buffer-name (current-buffer)) buffer-name)
            (delete-window (selected-window))
          (switch-to-buffer-other-window buffer-name))
      (with-temp-buffer
        (setq default-directory
              (project-root
               (or (project-current) `(transient . ,default-directory))))
        (let* ((vterm-buffer (generate-new-buffer buffer-name)))
          (set-buffer vterm-buffer)
          (vterm-mode)
          (switch-to-buffer-other-window vterm-buffer))))))

(defun kao/project-start-branch()
  (interactive)
  (magit-project-status)
  (ignore-error
      (magit-stash-both "changes before new branch"))
  (magit-branch-checkout (magit-main-branch))
  (call-interactively 'magit-pull-from-pushremote)
  (call-interactively 'magit-branch-spinoff))

(use-package projectile
  :init
  (projectile-mode +1)
  :custom
  (projectile-current-project-on-switch 'keep)
  (projectile-switch-project-action #'projectile-commander)
  :bind (("s-;" . #'kao/vterm-project-dwim)
         :map projectile-mode-map
         ("s-p" . projectile-command-map)
         ("C-x p" . projectile-command-map)
         :map projectile-command-map
         ("s s" . consult-ripgrep)
         ("s r" . nil)
         ("s g" . nil)))

(provide 'setup-project)
;;; setup-project.el ends here
