;;; setup.sml.el --- Configs for Standard ML

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(with-eval-after-load 'sml-mode
  (define-key sml-mode-map (kbd "M-SPC") nil)
  (define-key sml-mode-map (kbd "C-c C-f") 'sml-send-function))

(provide 'setup-sml)
;;; setup-sml.el ends here
