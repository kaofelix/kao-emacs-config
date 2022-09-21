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
   ("C-M-o" . #'embark-act-noquit))

  :config
  (add-to-list 'embark-keymap-alist '(project-file . embark-file-map) t)
  (add-to-list 'embark-transformer-alist'(project-file . kao/embark-project-file-absolute-path) t)

  (defun embark-act-noquit ()
    "Run action but don't quit the minibuffer afterwards."
    (interactive)
    (let ((embark-quit-after-action nil))
      (embark-act)))

  (defun kao/embark-project-file-absolute-path(target)
    (if-let* ((project (project-current))
                (root (project-root project)))
        (cons 'project-file (expand-file-name target root))
      target))

  (defun embark-which-key-indicator ()
    "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
    (lambda (&optional keymap targets prefix)
      (if (null keymap)
          (which-key--hide-popup-ignore-command)
        (which-key--show-keymap
         (if (eq (caar targets) 'embark-become)
             "Become"
           (format "Act on %s '%s'%s"
                   (plist-get (car targets) :type)
                   (embark--truncate-target (plist-get (car targets) :target))
                   (if (cdr targets) "…" "")))
         (if prefix
             (pcase (lookup-key keymap prefix 'accept-default)
               ((and (pred keymapp) km) km)
               (_ (key-binding prefix 'accept-default)))
           keymap)
         nil nil t))))

  (setq embark-indicators
        '(embark-which-key-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

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
