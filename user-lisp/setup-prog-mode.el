;;; setup-prog-mode.el --- prog-mode config -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package emacs
  :bind
  (:map prog-mode-map
   ("M-h" . mark-defun)))

(use-package eglot
  :after (yasnippet)
  :config
  (add-to-list 'eglot-server-programs
               '((json-ts-mode json-mode js-json-mode) . ("vscode-json-languageserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(astro-ts-mode . ("astro-ls" "--stdio"
                                  :initializationOptions
                                  (:typescript (:tsdk "./node_modules/typescript/lib")))))

  ;; Prevent servers from claiming JSON buffers via mode inheritance.
  ;; json-ts-mode inherits from json-mode -> javascript-mode -> js-mode,
  ;; which causes the TypeScript server to claim JSON buffers as "javascript".
  (define-advice eglot--languageId (:around (orig &rest args) json-fix)
    (let ((server (car args)))
      (if (and server
               (derived-mode-p 'json-ts-mode 'json-mode)
               (not (cl-find major-mode (eglot--languages server) :key #'car)))
          nil
        (apply orig args))))
  :bind
  (:map eglot-mode-map
   ("C-c C-r" . eglot-rename)
   ("C-c C-f" . eglot-format)
   ("C-c C-c" . eglot-code-actions)
   ("C-c C-e" . eglot-reconnect))
  :custom
  (eglot-confirm-server-edits nil)
  (eglot-confirm-server-initiated-edits nil))

(use-package dape)

(use-package repeat
  :config
  (repeat-mode))

(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :custom
  (dumb-jump-force-searcher 'rg))

(use-package eldoc-box
  :bind
  (:map prog-mode-map
   ("s-e" . #'eldoc-box-help-at-point))
  :custom
  (eldoc-box-clear-with-C-g t))

(use-package apheleia
  :delight
  :config
  (apheleia-global-mode +1)

  ;; Use npx directly for oxfmt instead of apheleia-npx, which fails
  ;; in monorepos where a .pnp.cjs at the root shadows npm packages
  ;; installed in subdirectories.
  (setf (alist-get 'oxfmt apheleia-formatters) '("npx" "oxfmt" inplace))

  (defun apheleia-detect-oxfmt ()
    "Set `apheleia-formatter' to oxfmt if the project uses it.
Detection checks for .oxfmtrc or .oxfmtrc.json config files
walking up from the buffer's directory."
    (when-let* ((root (and buffer-file-name
                           (or (locate-dominating-file buffer-file-name ".oxfmtrc")
                               (locate-dominating-file buffer-file-name ".oxfmtrc.json")))))
      (setq-local apheleia-formatter 'oxfmt)))

  (dolist (hook '(tsx-ts-mode-hook
                  typescript-ts-mode-hook
                  js-ts-mode-hook
                  js-mode-hook
                  json-ts-mode-hook
                  json-mode-hook))
    (add-hook hook #'apheleia-detect-oxfmt))

  :custom
  (apheleia-formatters-respect-indent-level nil))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package highlight-symbol
  :delight
  :bind
  (:map prog-mode-map
   ("C-," . #'highlight-symbol-prev)
   ("C-." . #'highlight-symbol-next)))

(use-package hideshow
  :delight hs-minor-mode
  :hook (prog-mode . hs-minor-mode)
  :bind
  (:map hs-minor-mode-map
   ("C-c [ [" . #'hs-toggle-hiding)
   ("C-c [ s" . #'hs-show-all)
   ("C-c [ h" . #'hs-hide-all)))

(use-package highlight-numbers
  :delight
  :hook (prog-mode . highlight-numbers-mode))

(use-package dtrt-indent
  :after (parent-mode)
  :delight
  :config
  (defun turn-on-dtrt-indent-mode-maybe ()
    "Turn on dtrt if not elisp mode."
    (unless (parent-mode-is-derived-p major-mode 'emacs-lisp-mode)
      (dtrt-indent-mode)))
  (add-to-list 'dtrt-indent-hook-mapping-list '(js-ts-mode default js-indent-level))
  (add-to-list 'dtrt-indent-hook-mapping-list '(typescript-ts-mode default typescript-ts-indent-offset))
  :hook (prog-mode . turn-on-dtrt-indent-mode-maybe))

(use-package drag-stuff
  :delight
  :config
  (drag-stuff-define-keys)
  :hook  (prog-mode . drag-stuff-mode))

(use-package whitespace
  :delight
  :hook (prog-mode . whitespace-mode)
  :custom
  (whitespace-style '(face trailing indentation)))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package dash-at-point
  :bind
  (("s-." . dash-at-point)))

(use-package yaml-mode)

(use-package k8s-mode
  :hook (k8s-mode . yas-minor-mode))

(use-package json-mode
  :after (dtrt-indent)
  :config
  (add-to-list 'dtrt-indent-hook-mapping-list '(json-mode default js-indent-level)))

(add-hook 'prog-mode-hook 'hl-line-mode)

(use-package testrun
  :vc (:url "https://github.com/martini97/testrun.el" :rev :newest)
  :config
  ;; this will allow you to override the runners on your .dir-locals.el
  (put 'testrun-runners 'safe-local-variable #'listp)
  (put 'testrun-mode-alist 'safe-local-variable #'listp)
  (define-keymap :prefix 'testrun-keymap)

  (defun testrun-code--root-allow-override (orig)
    "Allow to override the root directory."
    (message "testrun-code--root-allow-override")
    (let ((root (or (locate-dominating-file (buffer-file-name) ".testrun-root")
                    (funcall orig))))
      root))

  (advice-add 'testrun-core--root :around #'testrun-code--root-allow-override)

  (add-to-list 'testrun-runners '(npx-jest "npx" "jest" "test"))
  (add-to-list 'testrun-comint-runners 'npx-jest)
  (let ((jsts-modes
         '(js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)))
    (dolist (key jsts-modes)
      (setf (alist-get key testrun-mode-alist) 'npx-jest)))
  (add-to-list 'testrun-runner-function-alist '(npx-jest . testrun-jest-get-test))

  :bind
  (:map prog-mode-map
   ("C-c t" . testrun-keymap)
   ("s-," . testrun-last)
   :map testrun-keymap
   ("t" . testrun-nearest)
   ("c" . testrun-namespace)
   ("f" . testrun-file)
   ("a" . testrun-all)
   ("l" . testrun-last)))

;; Tree-sitter: enable all available TS modes and auto-install grammars.
;; Emacs 31.1 provides `treesit-enabled-modes' to replace manual
;; `major-mode-remap-alist' setup, and `treesit-auto-install-grammar'
;; to replace manual grammar installation.
(setq treesit-enabled-modes t
      treesit-auto-install-grammar t)

;; Grammar sources needed for auto-install.  Uses Emacs 31.1's keyword
;; syntax (:revision, :source-dir, :commit) for clarity.
(setq treesit-language-source-alist
      '((astro . ("https://github.com/virchau13/tree-sitter-astro"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css" :revision "v0.20.0"))
        (go . ("https://github.com/tree-sitter/tree-sitter-go" :revision "v0.20.0"))
        (graphql . ("https://github.com/bkegley/tree-sitter-graphql"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html" :revision "v0.20.1"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" :revision "v0.20.1" :source-dir "src"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json" :revision "v0.20.2"))
        (markdown . ("https://github.com/ikatyang/tree-sitter-markdown"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python" :revision "v0.20.4"))
        (qmljs . ("https://github.com/yuja/tree-sitter-qmljs.git"))
        (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby" :revision "master"))
        (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
        (toml . ("https://github.com/tree-sitter/tree-sitter-toml" :revision "v0.5.1"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" :revision "v0.20.3" :source-dir "tsx/src"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" :revision "v0.20.3" :source-dir "typescript/src"))
        (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" :revision "v0.5.0"))))

(use-package combobulate
  :vc (:url "https://github.com/mickeynp/combobulate.git" :rev :newest)
  :custom
  (combobulate-key-prefix "C-c o")
  :hook ((prog-mode . combobulate-mode)))


(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
