;;; setup-theme.el --- Theme configs

;;; Commentary:
;; Sets up gruvbox with a toggle function

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:

(defun general-theme-config ()
  ;; Git gutter should be a solid color
  (with-eval-after-load 'git-gutter
    (dolist (face '(git-gutter:added
                    git-gutter:modified
                    git-gutter:deleted))
      (set-face-background face (face-foreground face))))

  ;; Make target names in Makefiles different from variables
  (with-eval-after-load 'make-mode
    (set-face-foreground 'makefile-targets nil)
    (set-face-attribute 'makefile-targets nil :inherit font-lock-function-name-face)))

(use-package doom-themes
  :config
  (load-theme 'doom-nord-aurora t)
  (doom-themes-org-config)
  (general-theme-config)
  ;; Set ansi-color-bright-black to doom base3
  (set-face-foreground 'ansi-color-bright-black (doom-color 'base4))
  (set-face-background 'ansi-color-bright-black (doom-color 'base4))

  (with-eval-after-load 'corfu
    (set-face-background 'corfu-current (doom-color 'base4))))

(use-package spacious-padding
  :config
  (spacious-padding-mode 1)
  :custom
  (spacious-padding-widths
   '(:internal-border-width 10
     :header-line-width 4
     :mode-line-width 4
     :tab-width 4
     :right-divider-width 0
     :scroll-bar-width 0
     :fringe-width 12)))

(provide 'setup-theme)
;;; setup-theme.el ends here
