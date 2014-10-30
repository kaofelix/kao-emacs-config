;;; setup-prog-mode.el --- prog-mode config

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
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

;; Temp fix for emacs bug where lisp-mode-shared-map doesn't inherit from
;; prog-mode-map.
(unless (keymap-parent lisp-mode-shared-map)
  (set-keymap-parent lisp-mode-shared-map prog-mode-map))

(define-key prog-mode-map (kbd "C-,") 'highlight-symbol-prev)
(define-key prog-mode-map (kbd "C-.") 'highlight-symbol-next)

(require hideshow)
(define-key hs-minor-mode-map (kbd "C-c [ [") 'hs-toggle-hiding)
(define-key hs-minor-mode-map (kbd "C-c [ s") 'hs-show-all)
(define-key hs-minor-mode-map (kbd "C-c [ h") 'hs-hide-all)

(add-hook 'prog-mode-hook 'turn-on-hl-line)
(add-hook 'prog-mode-hook 'turn-on-which-function-mode)
(add-hook 'prog-mode-hook 'turn-on-whitespace)
(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'prog-mode-hook 'turn-on-rainbow-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'prog-mode-hook 'yas-minor-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'drag-stuff-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode)

(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
