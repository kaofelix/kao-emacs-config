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
  (setq file-name-shadow-properties
        '(invisible t))
  (file-name-shadow-mode +1)
  :custom
  (selectrum-num-candidates-displayed 20)
  (selectrum-max-window-height 20)
  (selectrum-extend-current-candidate-highlight t))

(use-package selectrum-prescient
  :config
  (selectrum-prescient-mode +1)
  (prescient-persist-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("M-o" . #'embark-act)
   :map embark-general-map
   ("L" . nil)
   :map minibuffer-local-map
   ("C-M-o" . #'embark-act-noexit))

  :config
  (add-to-list 'embark-keymap-alist '(project-file . embark-file-map) t)
  (add-to-list 'embark-transformer-alist'(project-file . kao/embark-project-file-absolute-path) t)

  (defun kao/embark-project-file-absolute-path(target)
    (let* ((project (project-current))
           (root (project-root project)))
      (cons 'project-file (expand-file-name target root))))


  (setq embark-action-indicator
        (lambda (map)
          (which-key--show-keymap "Embark" map nil nil 'no-paging)
          #'which-key--hide-popup-ignore-command)
        embark-become-indicator embark-action-indicator)

  ;; For Selectrum users:
  (defun refresh-selectrum ()
    (setq selectrum--previous-input-string nil))

  (add-hook 'embark-pre-action-hook #'refresh-selectrum))

(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . embark-consult-preview-minor-mode))

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
    (when-let (pr (project-current))
      (project-root pr)))

  (setq consult-config '((consult-buffer :preview-key nil)))
  (setq consult-project-root-function #'consult-project-root))

(use-package consult-flycheck
  :after (flycheck)
  :bind (:map flycheck-command-map
         ("!" . consult-flycheck)))

;; (use-package mini-frame
;;   :config
;;   (mini-frame-mode +1)
;;   :custom
;;   (mini-frame-show-parameters '((top . 0.54)
;;                                 (left . 0.5)
;;                                 (width . 0.9)))
;;   (mini-frame))

(provide 'setup-completion)
;;; setup-completion.el ends here
