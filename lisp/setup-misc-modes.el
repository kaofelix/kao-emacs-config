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

;; dtrt-indent
(dtrt-indent-mode 1)

;; Paren face
(global-paren-face-mode)

;; Smart parens
(require 'smartparens-config)

(defun kao/wrap-with-round-brackets (&optional arg)
  "Wrap next ARG expressions with round brackets."
  (interactive "P")
  (sp-wrap-with-pair "("))

(defvar kao/sp-bindings
  '(("C-M-f" . sp-forward-sexp)
    ("C-M-b" . sp-backward-sexp)

    ("C-M-n" . sp-next-sexp)
    ("C-M-p" . sp-previous-sexp)

    ("C-M-d" . sp-down-sexp)
    ("C-M-a" . sp-backward-down-sexp)
    ("C-S-d" . sp-beginning-of-sexp)
    ("C-S-a" . sp-end-of-sexp)
    ("C-M-e" . sp-up-sexp)
    ("C-M-u" . sp-backward-up-sexp)
    ("C-M-k" . sp-kill-sexp)
    ("C-M-w" . sp-copy-sexp)

    ("M-s" . sp-splice-sexp) ;; depth-changing commands
    ("M-S" . sp-split-sexp) ;; depth-changing commands

    ("M-(" . kao/wrap-with-round-brackets)
    ("C-)" . sp-forward-slurp-sexp) ;; barf/slurp
    ("C-}" . sp-forward-barf-sexp)
    ("C-(" . sp-backward-slurp-sexp)
    ("C-{" . sp-backward-barf-sexp)

    ("C-M-]" . sp-select-next-thing)
    ("M-F" . sp-forward-symbol)
    ("M-B" . sp-backward-symbol)))

(--each kao/sp-bindings
  (define-key sp-keymap (read-kbd-macro (car it)) (cdr it)))

;; Show paren
(show-paren-mode t)

;;; Projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

;; Golden Ratio
(defun golden-ratio-ace-window (&optional arg)
    "Advice function to make `golden-ratio' work with `ace-window'.  Ignore ARG."
    (if golden-ratio-mode
        (advice-add 'ace-window :after #'golden-ratio)
      (advice-remove 'ace-window #'golden-ratio)))

(with-eval-after-load 'golden-ratio
  (advice-add 'golden-ratio-mode :after #'golden-ratio-ace-window))

;; Man mode
(add-hook 'Man-mode-hook 'visual-line-mode)

;; Clean modeline
(with-eval-after-load 'rainbow-mode
  (diminish 'rainbow-mode))
(with-eval-after-load 'company
  (diminish 'company-mode))
(with-eval-after-load 'yasnippet
  (diminish 'yas-minor-mode))
(with-eval-after-load 'drag-stuff
  (diminish 'drag-stuff-mode))

(diminish 'undo-tree-mode)
(diminish 'smartparens-mode)
(diminish 'git-gutter-mode)

;; Tramp with vc
(setq vc-ignore-dir-regexp
                (format "\\(%s\\)\\|\\(%s\\)"
                        vc-ignore-dir-regexp
                        tramp-file-name-regexp))

;; vagrant tramp
(eval-after-load 'tramp '(vagrant-tramp-enable))

;; Prodigy
(defvar prodigy-file "~/.prodigy-services.el")

(defun reload-prodigy ()
  "Reload prodigy file."
  (interactive)
  (when (f-exists? prodigy-file)
    (load prodigy-file)))

(reload-prodigy)

(provide 'setup-misc-modes)
;;; setup-misc-modes.el ends here
