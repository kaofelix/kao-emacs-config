;;; setup-org.el --- Setup helm

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)

(add-hook 'org-mode-hook 'auto-fill-mode)

(provide 'setup-org)
;;; setup-org.el ends here
