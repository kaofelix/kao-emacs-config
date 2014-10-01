;;; setup-minor-modes.el --- Config for minor modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

;; Dependencies requires
(require 'f)

;; Company
(add-hook 'after-init-hook 'global-company-mode)

;; discover
(global-discover-mode)

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
    ("C-M-p" . sp-backward-sexp)

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

    ("C-]" . sp-select-next-thing-exchange)
    ("C-M-]" . sp-select-next-thing)
    ("M-F" . sp-forward-symbol)
    ("M-B" . sp-backward-symbol)))

(--each kao/sp-bindings
  (define-key sp-keymap (read-kbd-macro (car it)) (cdr it)))

;; Show paren
(show-paren-mode t)

;;; Projectile
(projectile-global-mode t)

;; Smex and Ido
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(setq ido-enable-prefix nil
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-use-virtual-buffers t)

(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces t)

(defun my-ido-setup-hook ()
  "Setup navigation in ido."
  (define-key ido-completion-map (kbd "M-DEL") 'ido-delete-backward-word-updir)
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'my-ido-setup-hook)

;; Guide Key
(setq guide-key/guide-key-sequence '("C-x 4" "C-c p"))
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 1.0)
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1)  ; Enable guide-key-mode

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

;; Clean modeline
(eval-after-load 'magit
  '(diminish 'magit-auto-revert-mode))
(eval-after-load 'rainbow-mode
  '(diminish 'rainbow-mode))
(eval-after-load 'auto-highlight-symbol
  '(diminish 'auto-highlight-symbol-mode))
(eval-after-load 'company
  '(diminish 'company-mode))
(eval-after-load 'yasnippet
  '(diminish 'yas-minor-mode))

(diminish 'undo-tree-mode)
(diminish 'smartparens-mode)
(diminish 'git-gutter-mode)
(diminish 'guide-key-mode)

;; Tramp with vc
(setq vc-ignore-dir-regexp
                (format "\\(%s\\)\\|\\(%s\\)"
                        vc-ignore-dir-regexp
                        tramp-file-name-regexp))

;; Prodigy
(defvar prodigy-file "~/.prodigy-services.el")

(defun reload-prodigy ()
  "Reload prodigy file."
  (interactive)
  (when (f-exists? prodigy-file)
    (load prodigy-file)))

(reload-prodigy)

(provide 'setup-minor-modes)
;;; setup-minor-modes.el ends here