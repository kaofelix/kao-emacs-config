;;; custom.el --- Custom settings -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3c3836" "#fb4933" "#b8bb26" "#fabd2f" "#83a598" "#d3869b" "#8ec07c"
    "#ebdbb2"])
 '(bidi-paragraph-direction 'left-to-right)
 '(bookmark-fringe-mark nil)
 '(bookmark-save-flag 1)
 '(bookmark-set-fringe-mark nil)
 '(dtrt-indent-max-merge-deviation 15.0)
 '(enable-recursive-minibuffers t)
 '(git-commit-post-finish-hook '(git-gutter:update-all-windows))
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(locate-command "mdfind")
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
 '(package-selected-packages
   '(adaptive-wrap all-the-icons anzu apheleia astro-ts-mode async
                   browse-at-remote cape change-inner chatgpt-shell
                   combobulate comment-dwim-2 corfu dape dash-at-point
                   dimmer direnv docker docker-compose-mode
                   dockerfile-mode doom-modeline doom-themes
                   dotenv-mode drag-stuff dtrt-indent dumb-jump eat
                   el-patch eldoc-box elisp-slime-nav embark-consult
                   expreg fix-word fnm git-gutter git-modes
                   git-timemachine go-mode goto-line-preview
                   graphql-ts-mode graphviz-dot-mode
                   highlight-indent-guides highlight-numbers
                   highlight-quoted highlight-symbol jq-mode json-mode
                   jtsx k8s-mode kind-icon macher magit-delta
                   marginalia markdown-mode mermaid-mode minuet
                   multiple-cursors nginx-mode nix-mode no-littering
                   nord-theme origami paren-face persist-state
                   phscroll pi-coding-agent pip-requirements popup
                   prodigy pyvenv qml-ts-mode rainbow-csv rainbow-mode
                   request restclient rspec-mode smartparens
                   spacious-padding string-inflection sudo-edit
                   terraform-mode testrun toml-mode
                   treemacs-icons-dired treemacs-magit treesit-auto
                   try undo-tree vertico-prescient visual-fill-column
                   vterm wgrep yank-indent yasnippet-snippets))
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
 '(whitespace-trailing 'whitespace-space-before-tab t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
