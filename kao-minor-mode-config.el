;;; kao-minor-mode-config.el --- Config for minor modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local

;;; Commentary:

;; Configuration for minor modes.

;;; Code:

;; Smart parens
(require 'smartparens-config)
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
    ("M-<delete>" . sp-unwrap-sexp)

    ("M-s" . sp-splice-sexp) ;; depth-changing commands
    ("M-<up>" . sp-splice-sexp-killing-backward)
    ("M-<down>" . sp-splice-sexp-killing-forward)

    ("C-)" . sp-forward-slurp-sexp) ;; barf/slurp
    ("C-<right>" . sp-forward-slurp-sexp)
    ("C-}" . sp-forward-barf-sexp)
    ("C-<left>" . sp-forward-barf-sexp)
    ("C-(" . sp-backward-slurp-sexp)
    ("C-M-<left>" . sp-backward-slurp-sexp)
    ("C-{" . sp-backward-barf-sexp)
    ("C-M-<right>" . sp-backward-barf-sexp)

    ("M-D" . sp-splice-sexp)
    ("C-]" . sp-select-next-thing-exchange)
    ("C-M-]" . sp-select-next-thing)
    ("M-F" . sp-forward-symbol)
    ("M-B" . sp-backward-symbol)))

(--each kao/sp-bindings
    (define-key sp-keymap (read-kbd-macro (car it)) (cdr it)))
(show-smartparens-global-mode t)

;;; Projectile
(projectile-global-mode t)
(define-key projectile-mode-map (kbd "C-c a") 'ag-project)

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
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'my-ido-setup-hook)

;; Clean modeline
(diminish 'undo-tree-mode)

(eval-after-load 'magit
  '(diminish 'magit-auto-revert-mode))
(diminish 'smartparens-mode)
(diminish 'git-gutter-mode)

(provide 'kao-minor-mode-config)
;;; kao-minor-mode-config.el ends here
