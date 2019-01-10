;;; setup-theme.el --- Theme configs

;;; Commentary:
;; Sets up gruvbox with a toggle function

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:

(defvar kao/current-theme-file (expand-file-name "current-theme" cache-and-saves-dir))
(defvar kao/current-theme 'gruvbox-dark-soft)

(defun kao/theme-light-switch ()
  "Toggle between light and dark theme (currently gruvbox)."
  (interactive)
  (if (memq 'gruvbox-dark-soft custom-enabled-themes)
      (kao/set-theme-and-save 'gruvbox-light-soft)
    (kao/set-theme-and-save 'gruvbox-dark-soft)))

(defun kao/set-theme-and-save (new-theme)
  "Set the current theme to `NEW-THEME' and save it to a theme file."
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme new-theme t)
  (setq kao/current-theme new-theme)
  (with-temp-file kao/current-theme-file
    (emacs-lisp-mode)
    (recentf-dump-variable 'kao/current-theme)
    (beginning-of-line)
    (delete-char -1)))

(load kao/current-theme-file 'noerror 'nomessage)
(kao/set-theme-and-save kao/current-theme)

(global-set-key (kbd "C-x C-t") 'kao/theme-light-switch)

(provide 'setup-theme)
;;; setup-theme.el ends here
