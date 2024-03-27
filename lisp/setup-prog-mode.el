;;; setup-prog-mode.el --- prog-mode config

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package emacs
  :bind
  (:map prog-mode-map
   ("M-h" . mark-defun)))

(use-package eglot
  :after yasnippet
  :bind
  (:map eglot-mode-map
   ("C-c C-r" . eglot-rename)
   ("C-c C-f" . eglot-format)
   ("C-c C-c" . eglot-code-actions)
   ("C-c C-e" . eglot-reconnect)))

(use-package apheleia
  :delight
  :config
  (apheleia-global-mode +1)
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff)))

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



(use-package dash-at-point
  :bind
  (("s-." . dash-at-point)))

(use-package yaml-mode)
(use-package dumb-jump
  :after (project)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))


(use-package json-mode
  :after (dtrt-indent)
  :config
  (add-to-list 'dtrt-indent-hook-mapping-list '(json-mode default js-indent-level)))

(add-hook 'prog-mode-hook 'hl-line-mode)

(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (global-treesit-auto-mode))

(use-package combobulate
  :straight (combobulate
             :type git
             :host github
             :repo "mickeynp/combobulate"
             :files ("*.el"))
  :hook ((js-ts-mode . combobulate-mode)
         (css-ts-mode . combobulate-mode)
         (yaml-ts-mode . combobulate-mode)
         (typescript-ts-mode . combobulate-mode)
         (tsx-ts-mode . combobulate-mode)))
(use-package testrun
  :straight (:host github :repo "martini97/testrun.el" :files ("testrun.el" "testrun-*.el"))
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

  :bind
  (:map prog-mode-map
   ("C-c t" . my/tests-key-map)
   :map testrun-keymap
   ("t" . testrun-nearest)
   ("c" . testrun-namespace)
   ("f" . testrun-file)
   ("a" . testrun-all)
   ("l" . testrun-last)))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :config
  (define-key copilot-mode-map (kbd "s-i") 'copilot-accept-completion)
  (define-key copilot-mode-map (kbd "C-s-i") 'copilot-accept-completion-by-word))

(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
