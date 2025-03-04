
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3c3836" "#fb4933" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c"
    "#ebdbb2"])
 '(anzu-replace-to-string-separator " => ")
 '(auto-revert-check-vc-info t)
 '(avy-background t)
 '(bidi-paragraph-direction 'left-to-right)
 '(bookmark-fringe-mark nil)
 '(bookmark-save-flag 1)
 '(bookmark-set-fringe-mark nil)
 '(consult-ripgrep-args
   "rg --hidden -g \"!.git/*\" --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip")
 '(copilot-indent-offset-warning-disable t)
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
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(locate-command "mdfind")
 '(magit-save-repository-buffers 'dontask)
 '(minibuffer-depth-indicate-mode t)
 '(native-comp-async-report-warnings-errors 'silent)
 '(org-catch-invisible-edits 'error)
 '(org-fold-catch-invisible-edits 'error)
 '(org-hide-leading-stars t)
 '(org-replace-disputed-keys t)
 '(org-return-follows-link t)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-src-fontify-natively t)
 '(python-check-command "ruff check")
 '(python-flymake-command '("ruff check"))
 '(register-preview-delay 0)
 '(safe-local-variable-values
   '((eval let
           ((root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq-local pyvenv-activate (expand-file-name ".venv" root)))
     (eval let
           ((root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq-local pyvenv-activate
                       (expand-file-name "path/to/venv" root)))
     (eglot-server-programs
      (typescript-ts-mode "bunx" "typescript-language-server"
                          "--stdio"))
     (typescript-ts-mode "bunx" "typescript-language-server" "--stdio")
     (eglot-server-programs
      (tsx-ts-mode "bunx" "typescript-language-server" "--stdio"))
     (project-current-directory-override concat
                                         (project-root
                                          (project-current))
                                         "/dags")))
 '(sp-navigate-interactive-always-progress-point t)
 '(split-height-threshold 100)
 '(use-package-enable-imenu-support t)
 '(vc-follow-symlinks t)
 '(vterm-always-compile-module t)
 '(wgrep-auto-save-buffer t)
 '(whitespace-action '(auto-cleanup))
 '(whitespace-global-modes nil)
 '(whitespace-style '(face trailing tabs))
 '(whitespace-trailing 'whitespace-space-before-tab t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
