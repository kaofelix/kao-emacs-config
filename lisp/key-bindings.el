;;; key-bindings.el --- Global keybindinggs

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, convenience

;;; Commentary:

;; My global keybindings.

;;; Code:
(require 'use-package)

;; Mac modifiers
(setq mac-function-modifier 'hyper)
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier nil)

(global-set-key (kbd "C-c d") 'kao/duplicate-line)
(global-set-key [remap move-beginning-of-line] 'kao/move-beginning-of-line)
(global-set-key [remap just-one-space] 'cycle-spacing)
(global-set-key (kbd "C-c r") 'replace-string)

;; C-h for backspace
(global-unset-key [?\C-h])
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map [?\M-\C-h] [?\M-\C-?])
(global-set-key (kbd "C-?") 'help-command)

;; Change quit keybing
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x r q") 'save-buffers-kill-emacs)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand-no-case-fold)

;; Windmove: Shift+direction
(windmove-default-keybindings)

;;; Expand region
(use-package expand-region
  :bind
  ("C-=" . #'er/expand-region))

(use-package change-inner
  :bind
  ("M-i" . #'change-inner))

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
(define-key kao/toggle-map "n" 'global-display-line-numbers-mode)

(provide 'key-bindings)
;;; key-bindings.el ends here
