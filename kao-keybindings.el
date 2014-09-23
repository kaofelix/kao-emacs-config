;;; kao-keybindings.el --- Global keybings

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
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
(global-set-key (kbd "C-c g") 'magit-status)

;; Browse kill ring
(browse-kill-ring-default-keybindings)

;;; Duplicate line
(global-set-key (kbd "C-c d") 'kao/duplicate-line)

;; Ace Jump
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

(provide 'kao-keybindings)
;;; kao-keybindings.el ends here
