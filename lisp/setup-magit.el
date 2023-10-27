;;; setup-magit.el --- set up for Magit

;;; Commentary:
;;

;;; Code:
(require 'use-package)

(use-package magit
  :bind
  ("C-c g" . #'magit-project-status)
  (:map magit-mode-map
   ("C-M-u" . #'magit-section-up)))

(use-package browse-at-remote)

(provide 'setup-magit)

;;; setup-magit.el ends here
