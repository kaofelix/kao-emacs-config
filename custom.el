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
 '(anzu-replace-to-string-separator " => ")
 '(auto-revert-check-vc-info t)
 '(avy-background t)
 '(browse-kill-ring-display-duplicates nil)
 '(browse-kill-ring-highlight-current-entry t)
 '(browse-kill-ring-highlight-inserted-item (quote pulse))
 '(coffee-tab-width 2)
 '(custom-safe-themes
   (quote
    ("595617a3c537447aa7e76ce05c8d43146a995296ea083211225e7efc069c598f" "a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" default)))
 '(custom-search-field nil)
 '(dired-dwim-target t)
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults)))
 '(eshell-aliases-file "/Users/kaofelix/.emacs.d/eshell-aliases")
 '(exec-path-from-shell-arguments (quote ("-l")))
 '(flycheck-indication-mode nil)
 '(git-commit-post-finish-hook (quote (git-gutter:update-all-windows)))
 '(global-auto-revert-mode t)
 '(global-git-gutter-mode t)
 '(global-rbenv-mode nil)
 '(global-undo-tree-mode t)
 '(helm-M-x-always-save-history t)
 '(helm-M-x-fuzzy-match t)
 '(helm-ack-grep-executable "ack")
 '(helm-buffer-max-length 45)
 '(helm-buffers-fuzzy-matching t)
 '(helm-ff-file-name-history-use-recentf t)
 '(helm-ff-search-library-in-sexp t)
 '(helm-find-files-actions
   (quote
    (("Find File" . helm-find-file-or-marked)
     ("Find file in Dired" . helm-point-file-in-dired)
     ("View file" . view-file)
     ("Query replace fnames on marked `M-@'" . helm-ff-query-replace-fnames-on-marked)
     ("Marked files in dired `C-x C-q, C-u wdired'" . helm-marked-files-in-dired)
     ("Query replace contents on marked `M-%'" . helm-ff-query-replace)
     ("Query replace regexp contents on marked `C-M-%'" . helm-ff-query-replace-regexp)
     ("Attach file(s) to mail buffer `C-c C-a'" . helm-ff-mail-attach-files)
     ("Serial rename files" . helm-ff-serial-rename)
     ("Serial rename by symlinking files" . helm-ff-serial-rename-by-symlink)
     ("Serial rename by copying files" . helm-ff-serial-rename-by-copying)
     ("Open file with default tool" . helm-open-file-with-default-tool)
     ("Find file in hex dump" . hexl-find-file)
     ("Browse project `C-x C-d'" . helm-ff-browse-project)
     ("Complete at point `C-c i'" . helm-insert-file-name-completion-at-point)
     ("Insert as org link `C-c @'" . helm-files-insert-as-org-link)
     ("Find shell command `C-c /'" . helm-ff-find-sh-command)
     ("Add marked files to file-cache" . helm-ff-cache-add-file)
     ("Open file externally `C-c C-x, C-u to choose'" . helm-open-file-externally)
     ("Grep current directory with AG `C-s, C-u select type'" . helm-find-files-ag)
     ("Grep File(s) `C-u Recurse'" . helm-find-files-grep)
     ("Git grep `M-g g, C-u from root'" . helm-ff-git-grep)
     ("Zgrep File(s) `M-g z, C-u Recurse'" . helm-ff-zgrep)
     ("Gid `M-g i'" . helm-ff-gid)
     ("Switch to Eshell `M-e'" . helm-ff-switch-to-eshell)
     ("Etags `M-., C-u reload tag file'" . helm-ff-etags-select)
     ("Eshell command on file(s) `M-!, C-u take all marked as arguments.'" . helm-find-files-eshell-command-on-file)
     ("Find file as root `C-c r'" . helm-find-file-as-root)
     ("Find alternate file `C-x C-v'" . find-alternate-file)
     ("Ediff File `C-c ='" . helm-find-files-ediff-files)
     ("Ediff Merge File `M-='" . helm-find-files-ediff-merge-files)
     ("Delete File(s) `M-D' (C-u reverse trash)" . helm-ff-delete-files)
     ("Touch File(s) `M-T'" . helm-ff-touch-files)
     ("Copy file(s) `M-C, C-u to follow'" . helm-find-files-copy)
     ("Rename file(s) `M-R, C-u to follow'" . helm-find-files-rename)
     ("Backup files" . helm-find-files-backup)
     ("Symlink files(s) `M-S, C-u to follow'" . helm-find-files-symlink)
     ("Relsymlink file(s) `M-Y, C-u to follow'" . helm-find-files-relsymlink)
     ("Hardlink file(s) `M-H, C-u to follow'" . helm-find-files-hardlink)
     ("Find file other window `C-c o'" . helm-find-files-other-window)
     ("Find file other frame `C-c C-o'" . find-file-other-frame)
     ("Print File `C-c p, C-u to refresh'" . helm-ff-print)
     ("Locate `C-x C-f, C-u to specify locate db'" . helm-ff-locate))))
 '(helm-grep-ag-command
   "rg --color=always --smart-case --no-heading --line-number %s %s %s")
 '(helm-grep-ag-pipe-cmd-switches
   (quote
    ("--colors 'match:fg:black'" "--colors 'match:bg:yellow'")))
 '(helm-locate-command "mdfind %s %s")
 '(helm-quick-update t)
 '(helm-split-window-default-side (quote right))
 '(helm-truncate-lines t)
 '(helm-window-prefer-horizontal-split t)
 '(helm-yas-display-key-on-candidate t)
 '(helm-yas-display-msg-after-complete nil)
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(locate-command "mdfind")
 '(magit-diff-use-overlays nil)
 '(magit-save-repository-buffers (quote dontask))
 '(magit-status-headers-hook
   (quote
    (magit-insert-error-header magit-insert-diff-filter-header magit-insert-repo-header magit-insert-remote-header magit-insert-head-branch-header magit-insert-upstream-branch-header magit-insert-push-branch-header magit-insert-tags-header)))
 '(magit-use-overlays nil)
 '(magit-wip-mode t)
 '(mmm-parse-when-idle t)
 '(multi-term-program-switches "--login")
 '(neo-default-system-application "open")
 '(neo-hide-cursor t)
 '(neo-window-fixed-size nil)
 '(neo-window-width 35)
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
    (ace-window anzu wgrep-helm nginx-mode rjsx-mode flycheck-rust drag-stuff multi-term git-timemachine highlight-symbol delight comment-dwim-2 yasnippet-snippets yaml-mode which-key use-package undo-tree toml-mode smartparens smart-mode-line shackle rainbow-mode racer paren-face paradox pallet org-tree-slide org-bullets neotree multiple-cursors highlight-quoted highlight-numbers helm-projectile helm-descbinds helm-c-yasnippet hydra gruvbox-theme gitignore-mode git-gutter expand-region exec-path-from-shell elpy elisp-slime-nav el-patch dtrt-indent docker direnv company-terraform cargo avy)))
 '(paradox-column-width-package 25)
 '(paradox-column-width-version 13)
 '(paradox-execute-asynchronously t)
 '(paradox-github-token t)
 '(paradox-hide-wiki-packages t)
 '(paradox-lines-per-entry 1)
 '(pdf-view-midnight-colors (quote ("#fdf4c1" . "#32302f")))
 '(projectile-completion-system (quote helm))
 '(projectile-mode-line (quote (:eval (format " P[%s]" (projectile-project-name)))))
 '(projectile-mode-line-prefix " ")
 '(projectile-project-root-files
   (quote
    ("rebar.config" "project.clj" "build.boot" "deps.edn" "SConstruct" "pom.xml" "build.sbt" "gradlew" "build.gradle" ".ensime" "Gemfile" "requirements.txt" "setup.py" "pyproject.toml" "tox.ini" "composer.json" "Cargo.toml" "mix.exs" "stack.yaml" "info.rkt" "DESCRIPTION" "TAGS" "GTAGS" "configure.in" "configure.ac" "cscope.out")))
 '(projectile-rails-keymap-prefix "" t)
 '(projectile-switch-project-action (quote helm-projectile-find-file))
 '(py-underscore-word-syntax-p nil)
 '(register-preview-delay 0)
 '(safe-local-variable-values
   (quote
    ((checkdoc-minor-mode . 1)
     (eval when
           (fboundp
            (quote rainbow-mode))
           (rainbow-mode 1))
     (elpy-test-runner quote elpy-test-pytest-runner)
     (pyvenv-activate . "/Users/kaofelix/Library/Caches/pypoetry/virtualenvs/op1-py3.")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect" "angular")
     (js2-global-externs "describe" "beforeEach" "module" "inject" "it" "expect"))))
 '(smartparens-global-mode t)
 '(sp-navigate-interactive-always-progress-point t)
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
 '(wgrep-auto-save-buffer t)
 '(wgrep-enable-key "e")
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
 '(avy-lead-face ((t (:inherit font-lock-keyword-face))))
 '(avy-lead-face-0 ((t (:inherit font-lock-keyword-face))))
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
 '(sp-show-pair-match-face ((t (:inherit show-paren-match))))
 '(sp-show-pair-mismatch-face ((t (:inherit show-paren-mismatch))))
 '(variable-pitch ((t (:family "Source Sans Pro")))))
