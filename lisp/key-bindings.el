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

;; Magit
(global-set-key (kbd "C-c g") 'magit-status-project-dwim)

;;; Duplicate line
(global-set-key (kbd "C-c d") 'kao/duplicate-line)

;; smarter move-beginning-of-line
(global-set-key [remap move-beginning-of-line] 'kao/move-beginning-of-line)

;; Ace Jump
(global-set-key (kbd "C-;") 'ace-jump-mode)

;; go to char
(global-set-key (kbd "s-;") 'iy-go-up-to-char)

;; Ace Window
(global-set-key [remap other-window] 'ace-window)

;; Comment DWIM 2
(global-set-key [remap comment-dwim] 'comment-dwim-2)

;; cycle-spacing instead of just-one-space
(global-set-key [remap just-one-space] 'cycle-spacing)

;; C-h for backspace
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map [?\M-\C-h] [?\M-\C-?])

;;; Expand region
(global-set-key (kbd "C-=") 'er/expand-region)

;;; Multiple Cursors
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-dwim)
(global-set-key (kbd "H-SPC") 'set-rectangular-region-anchor)

;; Use cua mark
(require 'cua-base)
(global-set-key (kbd "C-SPC") 'cua-set-mark)

;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Jump to a definition in the current file. (Protip: this is awesome.)
(global-set-key (kbd "C-x C-i") 'imenu)

;; Change quit keybing
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x r q") 'save-buffers-kill-emacs)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand-no-case-fold)
(global-set-key (kbd "M-?") 'hippie-expand-lines)

;; Windmove: Shift+direction
(windmove-default-keybindings)

;; Toggle Map
(defvar kao/toggle-map)
(define-prefix-command 'kao/toggle-map)
(define-key ctl-x-map "t" 'kao/toggle-map)

(define-key kao/toggle-map "e" 'toggle-debug-on-error)
(define-key kao/toggle-map "f" 'flycheck-mode)
(define-key kao/toggle-map "l" 'toggle-truncate-lines)
(define-key kao/toggle-map "w" 'whitespace-mode)
(define-key kao/toggle-map "r" 'rainbow-blocks-mode)

(provide 'key-bindings)
;;; key-bindings.el ends here
