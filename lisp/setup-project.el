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

(use-package project
  :after (magit)
  :bind
  (("s-;" . #'kao/vterm-project-dwim)
   :map project-prefix-map
   ("t" . #'kao/vterm-project-dwim)
   ("m" . #'magit-project-status)
   ("b" . #'kao/project-start-branch)
   ("o" . #'ff-find-other-file))
  :custom
  (project-switch-commands '((project-find-file "Find file")
                             (consult-ripgrep "Find regexp")
                             (project-dired "Dired")
                             (magit-project-status "Magit")
                             (kao/project-start-branch "Create new branch" ?b)
                             (kao/vterm-project-dwim "VTerm" ?t))))

(provide 'setup-project)
;;; setup-project.el ends here
