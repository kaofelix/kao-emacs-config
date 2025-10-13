;;; setup-prog-mode.el --- prog-mode config

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
               '(astro-ts-mode . ("astro-ls" "--stdio"
                                  :initializationOptions
                                  (:typescript (:tsdk "./node_modules/typescript/lib")))))
  :bind
  (:map eglot-mode-map
   ("C-c C-r" . eglot-rename)
   ("C-c C-f" . eglot-format)
   ("C-c C-c" . eglot-code-actions)
   ("C-c C-e" . eglot-reconnect))
  :custom
  (eglot-confirm-server-edits nil)
  (eglot-confirm-server-initiated-edits nil))

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
  (apheleia-global-mode +1))

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
  (add-to-list 'dtrt-indent-hook-mapping-list '(typescript-ts-mode default typescript-ts-mode-indent-offset))
  :hook (prog-mode . turn-on-dtrt-indent-mode-maybe))

(use-package drag-stuff
  :delight
  :config
  (drag-stuff-define-keys)
  :hook  (prog-mode . drag-stuff-mode))

(use-package whitespace
  :delight
  :hook (prog-mode . whitespace-mode))

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

  (add-to-list 'testrun-runners '(yarn "yarn" "test"))
  (let ((jsts-modes
         '(js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)))
    (dolist (key jsts-modes)
      (setf (alist-get key testrun-mode-alist) 'yarn)))
  (add-to-list 'testrun-runner-function-alist '(yarn . testrun-jest-get-test))

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

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el" :rev :newest)
  :hook (prog-mode . copilot-mode)
  :config
  (defun copilot-complete-or-accept ()
    (interactive)
    (if (copilot--overlay-visible)
        (copilot-accept-completion)
      (copilot-complete)))
  :bind (:map copilot-mode-map
         ("s-i" . 'copilot-complete-or-accept)
         ("C-s-i" . 'copilot-accept-completion-by-word)
         ("C-s-j" . 'copilot-accept-completion-by-line)
         :map copilot-completion-map
         ("C-g" . 'copilot-clear-overlay)
         ("M-p" . 'copilot-previous-completion)
         ("M-n" . 'copilot-next-completion)
         ("M-f" . 'copilot-accept-completion-by-word)
         ("M-j" . 'copilot-accept-completion-by-line))
  :custom
  (copilot-idle-delay nil) ; disable copilot auto complete
  (copilot-indent-offset-warning-disable t)
  (copilot-max-char 800000))

(use-package treesit
  :ensure nil
  :mode (("\\.tsx\\'" . tsx-ts-mode))
  :preface
  (defun mp-setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             ;; Note the version numbers. These are the versions that
             ;; are known to work with Combobulate *and* Emacs.
             '((astro "https://github.com/virchau13/tree-sitter-astro")
               (css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (go . ("https://github.com/tree-sitter/tree-sitter-go" "v0.20.0"))
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.1" "src"))
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
               (markdown "https://github.com/ikatyang/tree-sitter-markdown")
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
               (rust "https://github.com/tree-sitter/tree-sitter-rust")
               (toml . ("https://github.com/tree-sitter/tree-sitter-toml" "v0.5.1"))
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
               (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby" "master"))))
      (add-to-list 'treesit-language-source-alist grammar)
      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional. Combobulate works in both xxxx-ts-modes and
  ;; non-ts-modes.

  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  (dolist (mapping
           '((python-mode . python-ts-mode)
             (css-mode . css-ts-mode)
             (typescript-mode . typescript-ts-mode)
             (js2-mode . js-ts-mode)
             (js-mode . js-ts-mode)
             (bash-mode . bash-ts-mode)
             (conf-toml-mode . toml-ts-mode)
             (go-mode . go-ts-mode)
             (css-mode . css-ts-mode)
             (json-mode . json-ts-mode)
             (js-json-mode . json-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))
  :config
  (mp-setup-install-grammars))

(defun turn-on-treesit-fold ()
  (treesit-fold-mode 1)
  (treesit-fold-indicators-mode 1)
  (setq left-fringe-width 24))

(use-package treesit-fold
  :hook (prog-mode . turn-on-treesit-fold)
  :after (treesit)
  :vc (:url "https://github.com/emacs-tree-sitter/treesit-fold" :rev :newest))

(use-package combobulate
  :vc (:url "https://github.com/mickeynp/combobulate.git" :rev :newest)
  :custom
  (combobulate-key-prefix "C-c o")
  :hook ((prog-mode . combobulate-mode)))


(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
