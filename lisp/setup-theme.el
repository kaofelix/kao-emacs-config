;;; setup-theme.el --- Theme configs

;;; Commentary:
;; Sets up gruvbox with a toggle function

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:

(use-package gruvbox-theme
  :config
  (defvar kao/current-theme-file (expand-file-name "current-theme" cache-and-saves-dir))
  (defvar kao/current-theme 'gruvbox-dark-soft)

  (defvar kao/light-theme 'gruvbox-light-hard)
  (defvar kao/dark-theme 'gruvbox-dark-soft)

  (defun kao/theme-light-switch ()
    "Toggle between light and dark theme."
    (interactive)
    (if (memq kao/light-theme custom-enabled-themes)
        (kao/set-theme-and-save kao/dark-theme)
      (kao/set-theme-and-save kao/light-theme)))

  (defun kao/set-theme-and-save (new-theme)
    "Set the current theme to `NEW-THEME' and save it to a theme file."
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme new-theme t)
    (setq kao/current-theme new-theme)
    (with-temp-file kao/current-theme-file
      (emacs-lisp-mode)
      (kao/dump-theme-variable 'kao/current-theme)
      (beginning-of-line)
      (delete-char -1)))

  (defun kao/dump-theme-variable (theme-variable)
    "Insert \"(setq THEME-VARIABLE theme)\" in the current buffer."
    (let ((value (symbol-value theme-variable)))
      (insert (format "\n(setq %S '%S)\n" theme-variable value))))

  (load kao/current-theme-file 'noerror 'nomessage)
  (kao/set-theme-and-save kao/current-theme)

  :bind
  ("C-x C-t" . #'kao/theme-light-switch))

(provide 'setup-theme)
;;; setup-theme.el ends here
