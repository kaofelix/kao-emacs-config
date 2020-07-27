
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
 '(custom-safe-themes
   '("595617a3c537447aa7e76ce05c8d43146a995296ea083211225e7efc069c598f" "a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" default))
 '(custom-search-field nil)
 '(dired-dwim-target t)
 '(dtrt-indent-max-merge-deviation 15.0)
 '(elpy-modules
   '(elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults))
 '(eshell-aliases-file "/Users/kaofelix/.emacs.d/eshell-aliases")
 '(exec-path-from-shell-arguments '("-l"))
 '(flycheck-indication-mode nil)
 '(git-commit-post-finish-hook '(git-gutter:update-all-windows))
 '(git-gutter:update-interval 2)
 '(global-git-gutter-mode t)
 '(global-rbenv-mode nil)
 '(global-undo-tree-mode t)
 '(imenu-auto-rescan t)
 '(inhibit-startup-screen t)
 '(ivy-sort-matches-functions-alist
   '((t)
     (ivy-completion-in-region . ivy--shorter-matches-first)
     (ivy-switch-buffer . ivy-sort-function-buffer)))
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
 '(package-selected-packages
   '(flx counsel-projectile counsel lsp-metals sbt-mode nvm sudo-edit add-node-modules-path web-mode scala-mode lsp-treemacs lsp-ivy company-lsp lsp-ui lsp-mode blacken yasnippet-snippets elpy drag-stuff dtrt-indent highlight-numbers highlight-symbol org-bullets company-restclient restclient nginx-mode toml-mode goto-line-preview docker-compose-mode git-timemachine gitignore-mode magit docker dockerfile-mode direnv ace-window avy neotree git-gutter undo-tree rainbow-mode anzu multi-term smartparens which-key smart-mode-line paradox paren-face hydra delight exec-path-from-shell f markdown-mode prettier-js highlight-quoted elisp-slime-nav origami try auto-package-update org racer cargo flycheck-rust company-terraform shackle org-tree-slide multiple-cursors comment-dwim-2 expand-region gruvbox-theme bind-key el-patch use-package))
 '(paradox-column-width-package 25)
 '(paradox-column-width-version 13)
 '(paradox-execute-asynchronously t)
 '(paradox-github-token t)
 '(paradox-hide-wiki-packages t)
 '(paradox-lines-per-entry 1)
 '(pdf-view-midnight-colors '("#fdf4c1" . "#32302f"))
 '(projectile-completion-system 'ivy)
 '(projectile-mode-line '(:eval (format " P[%s]" (projectile-project-name))))
 '(projectile-mode-line-prefix " ")
 '(projectile-project-root-files
   '("rebar.config" "project.clj" "build.boot" "deps.edn" "SConstruct" "pom.xml" "build.sbt" "gradlew" "build.gradle" ".ensime" "Gemfile" "requirements.txt" "setup.py" "pyproject.toml" "tox.ini" "composer.json" "Cargo.toml" "mix.exs" "stack.yaml" "info.rkt" "DESCRIPTION" "TAGS" "GTAGS" "configure.in" "configure.ac" "cscope.out"))
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
 '(smartparens-global-mode t)
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
 '(markdown-table-face ((t (:inherit org-table)))))
