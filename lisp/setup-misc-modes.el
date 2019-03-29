;;; setup-misc-modes.el --- Config for misc modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

;; Dependencies requires
(require 'f)

;; Compile packages asynchronously
(require 'async-bytecomp)

(desktop-save-mode 1)
(global-paren-face-mode)
(add-hook 'Man-mode-hook 'visual-line-mode)

(use-package delight)

(use-package hydra)

(use-package paradox
  :config
  (paradox-enable))

(use-package smart-mode-line
  :init
  (smart-mode-line-enable))

(use-package which-key
  :delight
  :init
  (which-key-mode t))

;; Smart parens
(use-package smartparens
  :delight smartparens-mode
  :init
  (defun kao/wrap-with-round-brackets (&optional arg)
    "Wrap next ARG expressions with round brackets."
    (interactive "P")
    (sp-wrap-with-pair "("))
  :config
  (require 'smartparens-config)
  (show-smartparens-global-mode t)
  :hook ((emacs-lisp-mode . smartparens-strict-mode)
         (eval-expression-minibuffer-setup . smartparens-mode))
  :bind
  (:map smartparens-mode-map
   ("C-M-f" . #'sp-forward-sexp)
   ("C-M-b" . #'sp-backward-sexp)
   ("C-M-n" . #'sp-next-sexp)
   ("C-M-p" . #'sp-previous-sexp)
   ("C-M-u" . #'sp-backward-up-sexp)
   ("C-M-d" . #'sp-down-sexp)
   ("C-M-a" . #'sp-beginning-of-sexp)
   ("C-M-e" . #'sp-end-of-sexp)
   ("C-M-k" . #'sp-kill-sexp)
   ("C-M-w" . #'sp-copy-sexp)
   ("M-s" . #'sp-splice-sexp) ;; depth-changing commands
   ("M-S" . #'sp-split-sexp)  ;; depth-changing commands
   ("M-(" . #'kao/wrap-with-round-brackets)
   ("C-)" . #'sp-forward-slurp-sexp) ;; barf/slurp
   ("C-}" . #'sp-forward-barf-sexp)
   ("C-(" . #'sp-backward-slurp-sexp)
   ("C-{" . #'sp-backward-barf-sexp)
   ("C-M-]" . #'sp-select-next-thing)
   ("M-F" . #'sp-forward-symbol)
   ("M-B" . #'sp-backward-symbol)))

;;; Projectile
(use-package projectile
  :init
  (projectile-mode)
  :config
  (defun projectile-run-multi-term (program)
    "Invoke `multi-term' in the project's root.

Switch to the project specific term buffer if it already exists."
    (interactive (list nil))
    (let* ((project (projectile-ensure-project (projectile-project-root)))
           (multi-term-buffer-name (concat "terminal " (projectile-project-name project)))
           (buffer (concat "*" multi-term-buffer-name "<1>*")))
      (unless (get-buffer buffer)
        (require 'multi-term)
        (projectile-with-default-dir project
          (setq term-buffer (multi-term-get-buffer current-prefix-arg))
          (setq multi-term-buffer-list (nconc multi-term-buffer-list (list term-buffer)))
          (set-buffer term-buffer)
          ;; Internal handle for `multi-term' buffer.
          (multi-term-internal)))
      (switch-to-buffer-other-window buffer)))
  :bind
  (:map projectile-mode-map
   ("C-c p" . #'projectile-command-map)
   :map projectile-command-map
   ("x t" . #'projectile-run-multi-term)))

(use-package anzu
  :delight
  :init
  (global-anzu-mode 1)
  :bind
  (([remap query-replace] . #'anzu-query-replace)
   ([remap query-replace-regexp] . #'anzu-query-replace-regexp)
   ("S-<f6>" . #'anzu-replace-at-cursor-thing)
   :map isearch-mode-map
   ([remap isearch-query-replace] .  #'anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . #'anzu-isearch-query-replace-regexp)))

(use-package rainbow-mode
  :delight
  :hook prog-mode)

(use-package yasnippet
  :delight yas-minor-mode)

(use-package undo-tree
  :delight undo-tree-mode
  :bind
  (:map undo-tree-map
   ("C-?" . nil)
   ("C-/" . nil)))

(use-package git-gutter
  :after (hydra)
  :delight git-gutter-mode
  :config
  (defhydra hydra-zoom (global-map "C-x v")
    "next/previous hunk"
    ("n" #'git-gutter:previous-hunk "next")
    ("p" #'git-gutter:next-hunk "previous"))

  :bind
  ("C-x C-g" . #'git-gutter)
  ("C-x v =" . #'git-gutter:popup-hunk)
  ("C-x v C-=" . #'vc-diff)
  ("C-x v s" . #'git-gutter:stage-hunk)
  ("C-x v r" . #'git-gutter:revert-hunk)
  ("C-x v R" . #'vc-revert)
  ("C-x v SPC" . #'git-gutter:mark-hunk))

(use-package neotree
  :config
  (setq neo-theme 'nerd)
  (setq neo-smart-open t)
  (setq neo-show-hidden-files t)
  :bind
  (("s-1" . #'neotree-toggle)
   :map kao/toggle-map
   ("t" . #'neotree-toggle)
   :map neotree-mode-map
   ("C" . #'neotree-copy-node)
   ("D" . #'neotree-delete-node)
   ("R" . #'neotree-rename-node)
   ("+" . #'neotree-create-node)))

(use-package avy
  :config
  (avy-setup-default)
  :bind
  (("C-;" . #'avy-goto-word-or-subword-1)))

(use-package ace-window
  :bind
  (("C-x o" . #'ace-window)))

(use-package direnv
  :config
  (direnv-mode)
  (add-to-list 'direnv-non-file-modes 'magit-status-mode))

(use-package dockerfile-mode)

(use-package docker
  :bind
  ("H-d" . 'docker))

(use-package magit
  :after (git-gutter)
  :config
  (defun magit-status-project-dwim (always-prompt)
    "Run magit-status for current project or prompts for project.
When ALWAYS-PROMPT is passed, prompts for project even if it's
already inside a project."
    (interactive "P")
    (let ((project-root (projectile-project-p)))
      (if (and project-root (not always-prompt))
          (magit-status-internal project-root)
        (let ((relevant-projects (projectile-relevant-known-projects)))
          (if relevant-projects
              (let ((target-project (projectile-completing-read "Magit status for project: " relevant-projects)))
                (magit-status-internal target-project))
            (error "There are no known projects"))))))

  (add-hook 'magit-post-refresh-hook #'git-gutter:update-all-windows)

  :bind
  ("C-c g" . 'magit-status-project-dwim))

(use-package git-timemachine
  :bind (:map kao/toggle-map
         ("g" . #'git-timemachine-toggle)))

(use-package docker-compose-mode
  :config
  (add-hook 'docker-compose-mode-hook 'company-mode)
  (add-to-list 'auto-mode-alist
               '("docker-compose[^/]*\\.ya?ml\\'" . docker-compose-mode)))

(use-package toml-mode)
(use-package nginx-mode)

(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
