;;; setup-project.el --- configs for js

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package project
  :after (multi-vterm magit)
  :bind
  (("s-;" . #'multi-vterm-project)
   :map project-prefix-map
   ("t" . #'multi-vterm-project)
   ("m" . #'magit-project-status))
  :custom
  (project-switch-commands '((project-find-file "Find file")
                             (consult-ripgrep "Find regexp")
                             (project-dired "Dired")
                             (magit-project-status "Magit")
                             (project-vterm "VTerm" ?t))))

(provide 'setup-project)
;;; setup-project.el ends here
