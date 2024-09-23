;;; setup-theme.el --- Theme configs

;;; Commentary:
;; Sets up gruvbox with a toggle function

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:

(use-package doom-themes
  :after (git-gutter)
  :config
  (load-theme 'doom-gruvbox t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)

  ;; Git gutter should be a solid color
  (dolist (face '(git-gutter:added
                  git-gutter:modified
                  git-gutter:deleted))
    (set-face-background face (face-foreground face)))


  ;; Set ansi-color-bright-black to doom base3
  (set-face-foreground 'ansi-color-bright-black (doom-color 'base4))
  (set-face-background 'ansi-color-bright-black (doom-color 'base4))


  ;; Make target names in Makefiles different from variables
  (eval-after-load 'make-mode
    '(progn
       (set-face-foreground 'makefile-targets nil)
       (set-face-attribute 'makefile-targets nil :inherit font-lock-function-name-face)))

  (eval-after-load 'corfu
    '(progn
       (set-face-background 'corfu-current (doom-color 'base4)))))

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
