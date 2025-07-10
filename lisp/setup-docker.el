;;; setup-docker.el --- configs for docker and related

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package dockerfile-mode)

(use-package docker)

(use-package docker-compose-mode
  :config
  (add-to-list 'auto-mode-alist
               '("docker-compose[^/]*\\.ya?ml\\'" . docker-compose-mode)))

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

(provide 'setup-docker)
;;; setup-docker.el ends here


