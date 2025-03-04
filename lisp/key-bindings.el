;;; key-bindings.el --- Global keybindinggs

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, convenience

;;; Commentary:

;; My global keybindings.

;;; Code:

;; Mac modifiers
(setq mac-function-modifier 'hyper)
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier nil)

(global-set-key (kbd "C-c d") 'kao/duplicate-dwim)
(global-set-key (kbd "C-S-k") 'kao/kill-whole-line)
(global-set-key [remap move-beginning-of-line] 'kao/move-beginning-of-line)
(global-set-key [remap just-one-space] 'cycle-spacing)
(global-set-key (kbd "C-c r") 'replace-string)

;; Make C-h act like backspace and C-/ or C-? as help key
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map [?\M-\C-h] [?\M-\C-?])
(define-key key-translation-map (kbd "C-/") (kbd "C-h"))
(define-key key-translation-map (kbd "C-?") (kbd "C-h"))

;; Disable touchpad text-scale
(global-unset-key (kbd "C-<wheel-down>"))
(global-unset-key (kbd "C-<wheel-up>"))

;; Change quit keybing
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x r q") 'save-buffers-kill-emacs)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand-no-case-fold)

;; Windmove: Shift+direction
(windmove-default-keybindings)

;;; Expand region
(use-package expreg
  :bind
  ("C-=" . #'expreg-expand)
  ("C--" . #'expreg-contract))

(use-package change-inner
  :bind
  ("C-'" . #'change-inner))

(use-package comment-dwim-2
  :bind
  ([remap comment-dwim] . #'comment-dwim-2))

;;; Multiple Cursors
(use-package multiple-cursors
  :bind
  ("C-<" . 'mc/mark-previous-like-this)
  ("C->" . 'mc/mark-next-like-this)
  ("C-*" . 'mc/mark-all-dwim)
  ("H-SPC" . 'set-rectangular-region-anchor))

;; Use cua mark
(require 'cua-base)
(global-set-key (kbd "C-SPC") 'cua-set-mark)

;; Toggle Map
(defvar kao/toggle-map)
(define-prefix-command 'kao/toggle-map)
(define-key ctl-x-map "t" 'kao/toggle-map)

(define-key kao/toggle-map "e" 'toggle-debug-on-error)
(define-key kao/toggle-map "l" 'toggle-truncate-lines)
(define-key kao/toggle-map "w" 'whitespace-mode)
(define-key kao/toggle-map "n" 'display-line-numbers-mode)
(define-key kao/toggle-map "+" 'kao/toggle-big-font)
(define-key kao/toggle-map "_" 'subword-mode)

(provide 'key-bindings)
;;; key-bindings.el ends here
