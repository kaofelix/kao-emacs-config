(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-face-check-include-overlay t)
 '(ahs-idle-interval 0.5)
 '(ahs-inhibit-face-list
   (quote
    (font-lock-comment-delimiter-face font-lock-comment-face font-lock-doc-face font-lock-doc-string-face font-lock-string-face font-lock-keyword-face)))
 '(auto-revert-check-vc-info t)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-highlight-inserted-item (quote pulse))
 '(coffee-tab-width 2)
 '(company-idle-delay 0)
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(dired-dwim-target t)
 '(flycheck-indication-mode nil)
 '(global-auto-revert-mode t)
 '(global-git-gutter-mode t)
 '(global-undo-tree-mode t)
 '(helm-ack-grep-executable "ack")
 '(helm-buffer-max-length 45)
 '(helm-buffers-fuzzy-matching t)
 '(helm-ff-file-name-history-use-recentf t)
 '(helm-ff-search-library-in-sexp t)
 '(helm-grep-default-command "ack -Hn --no-group --no-color %e %p %f")
 '(helm-grep-default-recurse-command "ack -H --no-group --no-color %e %p %f")
 '(helm-quick-update t)
 '(helm-split-window-default-side (quote other))
 '(helm-truncate-lines t)
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(multi-term-program-switches "--login")
 '(paradox-github-token t)
 '(projectile-completion-system (quote helm))
 '(projectile-mode-line (quote (:eval (format " P[%s]" (projectile-project-name)))))
 '(projectile-rails-keymap-prefix "")
 '(projectile-switch-project-action (quote helm-projectile-find-file))
 '(register-preview-delay 0)
 '(rspec-use-rvm t)
 '(rspec-use-spring-when-possible nil)
 '(rspec-use-zeus-when-possible nil)
 '(smartparens-global-mode t)
 '(sml-electric-pipe-mode nil)
 '(term-bind-key-alist
   (quote
    (("C-c C-c" . term-interrupt-subjob)
     ("C-c C-e" . term-send-esc)
     ("C-s" . isearch-forward)
     ("C-r" . isearch-backward)
     ("C-m" . term-send-return)
     ("C-y" . term-paste)
     ("M-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-d" . term-send-forward-kill-word)
     ("M-DEL" . term-send-backward-kill-word)
     ("M-r" . term-send-reverse-search-history)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete))))
 '(term-unbind-key-list
   (quote
    ("C-z" "C-x" "C-c" "C-y" "<ESC>" "C-a" "C-e" "C-f" "C-b" "C-n" "C-p" "C-g")))
 '(whitespace-action (quote (auto-cleanup)))
 '(whitespace-global-modes nil)
 '(whitespace-style (quote (face trailing tabs)))
 '(whitespace-trailing (quote whitespace-space-before-tab) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-source-header ((t (:inherit variable-pitch :underline nil :weight semi-bold :height 1.3))))
 '(highlight-numbers-number ((t (:foreground "#d33682"))))
 '(highlight-quoted-symbol ((t (:inherit font-lock-constant-face :weight normal))))
 '(org-level-1 ((t (:inherit default :height 1.2))))
 '(org-level-2 ((t (:inherit default :height 1.1))))
 '(org-level-3 ((t (:inherit default :height 1.0))))
 '(org-level-4 ((t (:inherit default :height 1.0))))
 '(org-level-5 ((t (:inherit default))))
 '(org-level-6 ((t (:inherit default))))
 '(org-level-7 ((t (:inherit default))))
 '(org-level-8 ((t (:inherit default))))
 '(variable-pitch ((t (:family "Source Sans Pro")))))
