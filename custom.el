
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
 '(bidi-paragraph-direction 'left-to-right)
 '(bookmark-fringe-mark nil)
 '(bookmark-save-flag 1)
 '(bookmark-set-fringe-mark nil)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-highlight-inserted-item 'pulse)
 '(coffee-tab-width 2)
 '(consult-ripgrep-args
   "rg --hidden -g \"!.git/*\" --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip")
 '(copilot-indent-offset-warning-disable t)
 '(custom-search-field nil)
 '(dap-auto-configure-features '(controls tooltip))
 '(dap-internal-terminal 'dap-internal-terminal-vterm)
 '(dired-dwim-target t)
 '(dtrt-indent-max-merge-deviation 15.0)
 '(dumb-jump-force-searcher 'rg)
 '(eglot-confirm-server-edits nil)
 '(eglot-confirm-server-initiated-edits nil)
 '(enable-recursive-minibuffers t)
 '(exec-path-from-shell-arguments '("-l"))
 '(exec-path-from-shell-shell-name "/bin/zsh")
 '(exec-path-from-shell-variables '("PATH" "MANPATH" "WORKON_HOME"))
 '(git-commit-post-finish-hook '(git-gutter:update-all-windows))
 '(global-rbenv-mode nil)
 '(gofmt-command "goimports")
 '(gptel-model "gpt-4")
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(locate-command "mdfind")
 '(magit-save-repository-buffers 'dontask)
 '(markdown-asymmetric-header t)
 '(minibuffer-depth-indicate-mode t)
 '(mmm-parse-when-idle t)
 '(native-comp-async-report-warnings-errors 'silent)
 '(orderless-matching-styles '(orderless-regexp orderless-initialism orderless-flex))
 '(org-catch-invisible-edits 'error)
 '(org-fold-catch-invisible-edits 'error)
 '(org-hide-leading-stars t)
 '(org-replace-disputed-keys t)
 '(org-return-follows-link t)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-src-fontify-natively t)
 '(pdf-view-midnight-colors '("#fdf4c1" . "#32302f"))
 '(pico8-create-images nil)
 '(pico8-documentation-file "~/.emacs.d/etc/pico8/pico8_manual.txt")
 '(pos-tip-border-width 3)
 '(pos-tip-internal-border-width 8)
 '(py-underscore-word-syntax-p nil)
 '(python-check-command "ruff check")
 '(python-flymake-command '("ruff check"))
 '(register-preview-delay 0)
 '(safe-local-variable-values
   '((eval let
           ((root
             (locate-dominating-file default-directory ".dir-locals.el")))
           (setq-local pyvenv-activate
                       (expand-file-name ".venv" root)))
     (eval let
           ((root
             (locate-dominating-file default-directory ".dir-locals.el")))
           (setq-local pyvenv-activate
                       (expand-file-name "path/to/venv" root)))
     (eglot-server-programs
      (typescript-ts-mode "bunx" "typescript-language-server" "--stdio"))
     (typescript-ts-mode "bunx" "typescript-language-server" "--stdio")
     (eglot-server-programs
      (tsx-ts-mode "bunx" "typescript-language-server" "--stdio"))
     (project-current-directory-override concat
                                         (project-root
                                          (project-current))
                                         "/dags")))
 '(sp-navigate-interactive-always-progress-point t)
 '(split-height-threshold 100)
 '(vc-follow-symlinks t)
 '(vterm-always-compile-module t)
 '(wgrep-auto-save-buffer t)
 '(whitespace-action '(auto-cleanup))
 '(whitespace-global-modes nil)
 '(whitespace-style '(face trailing tabs))
 '(whitespace-trailing 'whitespace-space-before-tab t))
