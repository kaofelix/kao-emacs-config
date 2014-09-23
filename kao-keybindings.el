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

(provide 'kao-keybindings)
;;; kao-keybindings.el ends here
