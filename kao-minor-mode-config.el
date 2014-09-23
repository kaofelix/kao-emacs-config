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

;;; Projectile
(projectile-global-mode t)
(define-key projectile-mode-map (kbd "C-c a") 'ag-project)

(provide 'kao-minor-mode-config)
;;; kao-minor-mode-config.el ends here
