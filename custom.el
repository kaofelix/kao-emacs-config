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
 '(ansi-color-names-vector
   ["#3c3836" "#fb4933" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"])
 '(auto-revert-check-vc-info t)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-highlight-inserted-item (quote pulse))
 '(coffee-tab-width 2)
 '(company-idle-delay 0)
 '(custom-safe-themes
   (quote
    ("595617a3c537447aa7e76ce05c8d43146a995296ea083211225e7efc069c598f" "a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" default)))
 '(custom-search-field nil)
 '(dired-dwim-target t)
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults)))
 '(eshell-aliases-file "/Users/kaofelix/.emacs.d/eshell-aliases")
 '(exec-path-from-shell-arguments (quote ("-l")))
 '(flycheck-indication-mode nil)
 '(git-commit-post-finish-hook (quote (git-gutter:update-all-windows)))
 '(global-auto-revert-mode t)
 '(global-git-gutter-mode t)
 '(global-rbenv-mode nil)
 '(global-undo-tree-mode t)
 '(helm-M-x-always-save-history t)
 '(helm-ack-grep-executable "ack")
 '(helm-buffer-max-length 45)
 '(helm-buffers-fuzzy-matching t)
 '(helm-ff-file-name-history-use-recentf t)
 '(helm-ff-search-library-in-sexp t)
 '(helm-locate-command "mdfind %s %s")
 '(helm-quick-update t)
 '(helm-swoop-speed-or-color t)
 '(helm-swoop-split-direction (quote split-window-horizontally))
 '(helm-truncate-lines t t)
 '(helm-window-prefer-horizontal-split t)
 '(helm-yas-display-key-on-candidate t)
 '(helm-yas-display-msg-after-complete nil)
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(locate-command "mdfind")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(mmm-parse-when-idle t)
 '(multi-term-program-switches "--login")
 '(org-agenda-files (quote ("~/org/notes.org")))
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file+headline "~/org/notes.org" "Inbox")
      "* TODO %?" :prepend t)
     ("e" "Emacs Idea" entry
      (file+headline "~/org/notes.org" "Emacs Config")
      "* TODO %?" :prepend t))))
 '(org-catch-invisible-edits (quote error))
 '(org-hide-leading-stars t)
 '(org-mobile-directory "~/Dropbox/MobileOrg/")
 '(org-replace-disputed-keys t)
 '(org-return-follows-link t)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-src-fontify-natively t)
 '(package-selected-packages
   (quote
    (nginx-mode company-nginx helm-c-yasnippet cider company ivy projectile helm-dash dash-at-point transpose-frame which-key smart-mode-line gruvbox-theme shackle gitignore-templates helm-ag elpy gitignore-mode yasnippet-snippets toml-mode pyvenv dtrt-indent yasnippet yaml-mode wgrep-ag web-mode visual-regexp visual-fill-column use-package undo-tree solarized-theme sml-mode smartparens slim-mode rbenv rainbow-mode rainbow-blocks pythonic projectile-rails popwin popup pcre2el pcmpl-homebrew pcache parent-mode paren-face paradox pallet nyan-mode multiple-cursors magit idle-highlight-mode htmlize flycheck-cask expand-region exec-path-from-shell)))
 '(paradox-execute-asynchronously nil)
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (quote ("#fdf4c1" . "#32302f")))
 '(projectile-completion-system (quote helm))
 '(projectile-mode-line (quote (:eval (format " P[%s]" (projectile-project-name)))))
 '(projectile-rails-keymap-prefix "" t)
 '(projectile-switch-project-action (quote helm-projectile-find-file))
 '(py-underscore-word-syntax-p nil)
 '(rbenv-installation-dir "/usr/local")
 '(register-preview-delay 0)
 '(rspec-use-rake-when-possible nil)
 '(rspec-use-spring-when-possible nil)
 '(rspec-use-vagrant-when-possible t)
 '(rspec-vagrant-cwd "/vagrant/transervicos/")
 '(safe-local-variable-values
   (quote
    ((elpy-test-runner quote elpy-test-pytest-runner)
     (pyvenv-activate . "/Users/kaofelix/Library/Caches/pypoetry/virtualenvs/op1-py3.")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect" "angular")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect"))))
 '(smartparens-global-mode t)
 '(term-bind-key-alist
   (quote
    (("C-c C-c" . term-interrupt-subjob)
     ("C-c C-d" . term-send-eof)
     ("C-c C-e" . term-send-esc)
     ("C-c C-j" . term-line-mode)
     ("C-c C-k" . term-char-mode)
     ("C-c C-q" . term-pager-toggle)
     ("C-m" . term-send-return)
     ("C-y" . term-paste)
     ("M-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-f" . term-send-forward-word)
     ("M-b" . term-send-backward-word)
     ("M-d" . term-send-forward-kill-word)
     ("M-DEL" . term-send-backward-kill-word)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete))))
 '(term-unbind-key-list (quote ("C-x" "C-c" "C-h" "C-y" "C-d" "<ESC>")))
 '(which-key-idle-secondary-delay 0.0)
 '(whitespace-action (quote (auto-cleanup)))
 '(whitespace-global-modes nil)
 '(whitespace-style (quote (face trailing tabs)))
 '(whitespace-trailing (quote whitespace-space-before-tab) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-ff-dotted-directory ((t (:inherit helm-ff-directory :weight bold))))
 '(helm-source-header ((t (:inherit variable-pitch :underline nil :weight semi-bold :height 1.3))))
 '(org-level-1 ((t (:inherit default :height 1.1))))
 '(org-level-2 ((t (:inherit default :height 1.0))))
 '(org-level-3 ((t (:inherit default :height 1.0))))
 '(org-level-4 ((t (:inherit default :height 1.0))))
 '(org-level-5 ((t (:inherit default))))
 '(org-level-6 ((t (:inherit default))))
 '(org-level-7 ((t (:inherit default))))
 '(org-level-8 ((t (:inherit default))))
 '(variable-pitch ((t (:family "Source Sans Pro")))))
