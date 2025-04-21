;;; setup-prog-mode.el --- prog-mode config

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
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
  :vc (:url "https://github.com/martini97/testrun.el")
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
  (copilot-indent-offset-warning-disable t))


(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package combobulate
  :vc (:url "https://github.com/mickeynp/combobulate.git" :rev "59b64d6")
  :hook ((prog-mode . combobulate-mode)))


(provide 'setup-prog-mode)
;;; setup-prog-mode.el ends here
