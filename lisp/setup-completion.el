;;; setup-completion.el --- selectrum+consult+embark

;; Copyright (C) 2020  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package wgrep
  :custom
  (wgrep-enable-key "e")
  :bind
  (:map grep-mode-map
   ("e" . #'wgrep-change-to-wgrep-mode)))

(use-package selectrum
  :config
  (selectrum-mode +1)
  :custom
  (selectrum-num-candidates-displayed 20)
  (selectrum-extend-current-candidate-highlight t))

(use-package selectrum-prescient
  :config
  (selectrum-prescient-mode +1)
  (prescient-persist-mode))

(use-package marginalia
  :config
  (marginalia-mode))

(use-package embark
  :bind
  (("M-o" . #'embark-act)
   :map minibuffer-local-map
   ("C-M-o" . #'embark-act-noexit))
  :config
  (setq embark-action-indicator
        (lambda (map)
          (which-key--show-keymap "Embark" map nil nil 'no-paging)
          #'which-key--hide-popup-ignore-command)
        embark-become-indicator embark-action-indicator)

  ;; For Selectrum users:
  (add-hook 'embark-target-finders
            (defun current-candidate+category ()
              (when selectrum-active-p
                (cons (selectrum--get-meta 'category)
                      (selectrum-get-current-candidate)))))

  (add-hook 'embark-candidate-collectors
            (defun current-candidates+category ()
              (when selectrum-active-p
                (cons (selectrum--get-meta 'category)
                      (selectrum-get-current-candidates
                       ;; Pass relative file names for dired.
                       minibuffer-completing-file-name)))))

  ;; No unnecessary computation delay after injection.
  (add-hook 'embark-setup-hook 'selectrum-set-selected-candidate))

(use-package consult
  :after (project)
  :bind
  (("C-x M-:" . consult-complex-command)
   ("C-c h" . consult-history)
   ("C-c m" . consult-mode-command)
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x r x" . consult-register)
   ("C-x r b" . consult-bookmark)
   ("M-g g" . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-g o" . consult-outline)
   ("M-g l" . consult-line)
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g r" . consult-ripgrep)
   ("M-g f" . consult-fd)
   ("M-g i" . consult-project-imenu)
   ("M-g e" . consult-error)
   ("M-s m" . consult-multi-occur)
   ("M-y" . consult-yank-pop)
   ("<help> a" . consult-apropos)
   :map project-prefix-map
   ("s" . #'consult-ripgrep))

  :init
  (defun consult-fd (&optional dir)
    "Find with fd"
    (interactive "P")
    (let ((consult-find-command '("fd" "--color=never" "--full-path")))
      (consult-find dir)))

  ;; Replace `multi-occur' with `consult-multi-occur', which is a drop-in replacement.
  (fset 'multi-occur #'consult-multi-occur)

  :config
  (defun consult-project-root ()
    (let ((pr (project-current)))
      (when pr (project-root pr))))

  (setq consult-project-root-function #'consult-project-root))

(use-package consult-selectrum
  :after selectrum)

;; Optionally add the `consult-flycheck' command.
(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))

(provide 'setup-completion)
;;; setup-completion.el ends here
