;;; kao-prog-mode.el --- prog-mode config

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(defun turn-on-hl-line ()
  (hl-line-mode 1))

(defun turn-on-whitespace ()
  (whitespace-mode 1))

(defun turn-on-which-function-mode ()
  (which-function-mode))

(defun turn-on-rainbow-mode ()
  (rainbow-mode 1))

(defun prog-mode-key-bindings ()
  "Set keys for `prog-mode'."
  (local-set-key (kbd "C-,") 'highlight-symbol-next)
  (local-set-key (kbd "C-.") 'highlight-symbol-next))

(add-hook 'prog-mode-hook 'turn-on-hl-line)
(add-hook 'prog-mode-hook 'turn-on-which-function-mode)
(add-hook 'prog-mode-hook 'turn-on-whitespace)
(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'prog-mode-hook 'turn-on-rainbow-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'prog-mode-hook 'auto-highlight-symbol-mode)
(add-hook 'prog-mode-hook 'prog-mode-key-bindings)

(provide 'kao-prog-mode)
;;; kao-prog-mode.el ends here
