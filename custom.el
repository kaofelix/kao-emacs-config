
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-face-check-include-overlay t)
 '(ahs-idle-interval 0.5)
 '(ahs-inhibit-face-list
   '(font-lock-comment-delimiter-face font-lock-comment-face font-lock-doc-face font-lock-doc-string-face font-lock-string-face font-lock-keyword-face))
 '(ansi-color-names-vector
   ["#3c3836" "#fb4933" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c" "#ebdbb2"])
 '(anzu-replace-to-string-separator " => ")
 '(auto-revert-check-vc-info t)
 '(avy-background t)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-highlight-inserted-item 'pulse)
 '(coffee-tab-width 2)
 '(counsel-projectile-switch-project-action
   '(1
     ("o" counsel-projectile-switch-project-action "jump to a project buffer or file")
     ("f" counsel-projectile-switch-project-action-find-file "jump to a project file")
     ("d" counsel-projectile-switch-project-action-find-dir "jump to a project directory")
     ("D" counsel-projectile-switch-project-action-dired "open project in dired")
     ("b" counsel-projectile-switch-project-action-switch-to-buffer "jump to a project buffer")
     ("m" counsel-projectile-switch-project-action-find-file-manually "find file manually from project root")
     ("S" counsel-projectile-switch-project-action-save-all-buffers "save all project buffers")
     ("k" counsel-projectile-switch-project-action-kill-buffers "kill all project buffers")
     ("K" counsel-projectile-switch-project-action-remove-known-project "remove project from known projects")
     ("c" counsel-projectile-switch-project-action-compile "run project compilation command")
     ("C" counsel-projectile-switch-project-action-configure "run project configure command")
     ("E" counsel-projectile-switch-project-action-edit-dir-locals "edit project dir-locals")
     ("v" counsel-projectile-switch-project-action-vc "open project in vc-dir / magit / monky")
     ("s" counsel-projectile-switch-project-action-rg "search project with rg")
     ("x" counsel-projectile-switch-project-action-run-vterm "invoke vterm from project root")))
 '(custom-safe-themes
   '("595617a3c537447aa7e76ce05c8d43146a995296ea083211225e7efc069c598f" "a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" default))
 '(custom-search-field nil)
 '(dired-dwim-target t)
 '(dtrt-indent-max-merge-deviation 15.0)
 '(elpy-modules
   '(elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults))
 '(elpy-test-runner 'elpy-test-pytest-runner)
 '(exec-path-from-shell-arguments '("-l"))
 '(flycheck-indication-mode nil)
 '(flycheck-pycheckers-checkers '(flake8 mypy3))
 '(git-commit-post-finish-hook '(git-gutter:update-all-windows))
 '(git-gutter:update-interval 2)
 '(global-rbenv-mode nil)
 '(global-undo-tree-mode t)
 '(gofmt-command "goimports")
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(ivy-format-functions-alist
   '((counsel-compile-env . counsel-compile-env--format-hint)
     (counsel-kmacro . counsel--kmacro-format-function)
     (counsel-colors-web . counsel--colors-web-format-function)
     (counsel-colors-emacs . counsel--colors-emacs-format-function)
     (counsel-evil-registers . counsel--yank-pop-format-function)
     (counsel-yank-pop . counsel--yank-pop-format-function)
     (counsel-git-log . counsel--git-log-format-function)
     (counsel-faces . counsel--faces-format-function)
     (swiper-isearch . swiper-isearch-format-function)
     (swiper-all . swiper--all-format-function)
     (swiper-multi . swiper--all-format-function)
     (t . ivy-format-function-line)))
 '(locate-command "mdfind")
 '(magit-diff-use-overlays nil)
 '(magit-save-repository-buffers 'dontask)
 '(magit-status-headers-hook
   '(magit-insert-error-header magit-insert-diff-filter-header magit-insert-repo-header magit-insert-remote-header magit-insert-head-branch-header magit-insert-upstream-branch-header magit-insert-push-branch-header magit-insert-tags-header))
 '(magit-use-overlays nil)
 '(magit-wip-mode t)
 '(mmm-parse-when-idle t)
 '(multi-term-program-switches "--login")
 '(neo-default-system-application "open")
 '(neo-hide-cursor t)
 '(neo-window-fixed-size nil)
 '(neo-window-width 35)
 '(orderless-matching-styles '(orderless-regexp orderless-initialism orderless-flex))
 '(org-agenda-files '("~/org/notes.org"))
 '(org-capture-templates
   '(("t" "Todo" entry
      (file+headline "~/org/notes.org" "Inbox")
      "* TODO %?" :prepend t)
     ("e" "Emacs Idea" entry
      (file+headline "~/org/notes.org" "Emacs Config")
      "* TODO %?" :prepend t)))
 '(org-catch-invisible-edits 'error)
 '(org-hide-leading-stars t)
 '(org-mobile-directory "~/Dropbox/MobileOrg/" t)
 '(org-replace-disputed-keys t)
 '(org-return-follows-link t)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-src-fontify-natively t)
 '(pdf-view-midnight-colors '("#fdf4c1" . "#32302f"))
 '(pico8-documentation-file "~/.emacs.d/etc/pico8/pico8_manual.txt")
 '(projectile-completion-system 'ivy)
 '(projectile-mode-line '(:eval (format " P[%s]" (projectile-project-name))))
 '(projectile-mode-line-prefix " ")
 '(projectile-rails-keymap-prefix "" t)
 '(py-underscore-word-syntax-p nil)
 '(register-preview-delay 0)
 '(safe-local-variable-values
   '((checkdoc-minor-mode . 1)
     (eval when
           (fboundp 'rainbow-mode)
           (rainbow-mode 1))
     (elpy-test-runner quote elpy-test-pytest-runner)
     (pyvenv-activate . "/Users/kaofelix/Library/Caches/pypoetry/virtualenvs/op1-py3.")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect" "angular")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect")))
 '(sp-navigate-interactive-always-progress-point t)
 '(term-bind-key-alist
   '(("C-c C-c" . term-interrupt-subjob)
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
     ("M-." . comint-dynamic-complete)))
 '(term-unbind-key-list '("C-x" "C-c" "C-h" "C-y" "C-d" "<ESC>"))
 '(wgrep-auto-save-buffer t)
 '(wgrep-enable-key "e")
 '(which-key-idle-delay 0.2)
 '(which-key-idle-secondary-delay 0.0)
 '(whitespace-action '(auto-cleanup))
 '(whitespace-global-modes nil)
 '(whitespace-style '(face trailing tabs))
 '(whitespace-trailing 'whitespace-space-before-tab t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-current-match ((t (:inherit highlight :underline nil :weight normal))))
 '(ivy-highlight-face ((t (:inherit lazy-highlight))))
 '(markdown-table-face ((t (:inherit org-table)))))
