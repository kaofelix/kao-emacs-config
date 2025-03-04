;;; setup-docker.el --- configs for docker and related

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package dockerfile-mode)

(use-package docker
  :bind
  ("H-d" . 'docker))

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

(provide 'setup-docker)
;;; setup-docker.el ends here


