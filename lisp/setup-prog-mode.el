;;; setup-prog-mode.el --- prog-mode config

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package apheleia
  :straight (:host github :repo "raxod502/apheleia")
  :delight
  :config
  (apheleia-global-mode +1))

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

  :hook (prog-mode . turn-on-dtrt-indent-mode-maybe))

(use-package drag-stuff
  :delight
  :config
  (drag-stuff-define-keys)
  :hook  (prog-mode . drag-stuff-mode))

(use-package whitespace
  :delight
  :hook (prog-mode . whitespace-mode))

(use-package company
  :delight
  :hook (prog-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t)
  :bind
  (("C-c C-M-i" . #'completion-at-point)
   :map company-mode-map
   ("C-M-i" . #'company-complete-common)
   :map company-active-map
   ("C-n" . #'company-select-next-or-abort)
   ("C-p" . #'company-select-previous-or-abort)))

;; With use-package:
(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package dash-at-point)

(use-package yaml-mode)

(use-package json-mode
  :after (dtrt-indent)
  :config
  (add-to-list 'dtrt-indent-hook-mapping-list '(json-mode default js-indent-level)))

(add-hook 'prog-mode-hook 'hl-line-mode)

(use-package copilot
  :hook (prog-mode . copilot-mode)
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :config
  (with-eval-after-load 'company
    ;; disable inline previews
    (delq 'company-preview-if-just-one-frontend company-frontends))

  (define-key copilot-mode-map (kbd "s-i") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "C-s-i") 'copilot-accept-completion-by-word))

(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
