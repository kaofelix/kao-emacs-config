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

;; ^⌘F: Fullscreen on Mac
(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

;; Magit
(global-set-key (kbd "C-c g") 'magit-status-project-dwim)

;; Browse kill ring
(browse-kill-ring-default-keybindings)

;;; Duplicate line
(global-set-key (kbd "C-c d") 'kao/duplicate-line)

;; Ace Jump
(global-set-key (kbd "C-;") 'ace-jump-mode)

;; Ace Window
(global-set-key (kbd "C-x o") 'ace-window)

;; Comment DWIM 2
(global-set-key [remap comment-dwim] 'comment-dwim-2)

;; C-h for backspace
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map [?\M-\C-h] [?\M-\C-?])
(global-set-key (kbd "<backspace>") '(lambda () (interactive) (message "No!")))
(global-set-key (kbd "M-<backspace>") '(lambda () (interactive) (message "No!")))

;; Ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

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
(discover-add-context-menu
 :context-menu '(toggle-map
                 (actions
                  ("Toggle"
                   ("e" "Debug On Error" toggle-debug-on-error)
                   ("r" "Rainbow Blocks Mode" rainbow-blocks-mode)
                   ("f" "Flycheck Mode" flycheck-mode))))
 :bind "C-x t")

(provide 'key-bindings)
;;; key-bindings.el ends here
