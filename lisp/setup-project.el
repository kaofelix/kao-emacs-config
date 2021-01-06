;;; setup-project.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package project
  :after (vterm magit)
  :config
  (defun project-vterm ()
    (interactive)
    (let* ((project (project-current t))
           (buffer (format "*%s %s*" "vterm" (project-root project))))
      (unless (buffer-live-p (get-buffer buffer))
        (let ((default-directory (project-root project)))
          (vterm buffer)))
      (switch-to-buffer buffer)))

  (defun project-toggle-vterm ()
    (interactive)
    (if (derived-mode-p 'vterm-mode)
        (previous-buffer)
      (project-vterm)))

  :bind
  (("s-;" . #'project-toggle-vterm)
   :map project-prefix-map
   ("t" . #'project-vterm)
   ("m" . #'magit-project-status))
  :custom
  (project-switch-commands '((project-find-file "Find file")
                             (consult-ripgrep "Find regexp")
                             (project-dired "Dired")
                             (magit-project-status "Magit")
                             (project-vterm "VTerm"))))

(provide 'setup-project)
;;; setup-project.el ends here
