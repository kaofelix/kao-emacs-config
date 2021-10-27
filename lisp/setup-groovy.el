;;; setup-groovy.el --- configs for groovy

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package groovy-mode
  :after (dtrt-indent)
  :config
  (add-to-list 'dtrt-indent-hook-mapping-list '(groovy-mode default groovy-indent-offset)))
(use-package jenkinsfile-mode)

(provide 'setup-groovy)
;;; setup-groovy.el ends here
