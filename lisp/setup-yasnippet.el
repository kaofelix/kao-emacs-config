;;; setup-yasnippet.el --- yasnippet setup

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, convenience

;;; Commentary:

;;

;;; Code:

(use-package yasnippet
  ;; Inter-field navigation
  :config
  (defun yas/goto-end-of-active-field ()
    (interactive)
    (let* ((snippet (car (yas-active-snippets)))
           (position (yas--field-end (yas--snippet-active-field snippet))))
      (if (= (point) position)
          (move-end-of-line 1)
        (goto-char position))))

  (defun yas/goto-start-of-active-field ()
    (interactive)
    (let* ((snippet (car (yas-active-snippets)))
           (position (yas--field-start (yas--snippet-active-field snippet))))
      (if (= (point) position)
          (move-beginning-of-line 1)
        (goto-char position))))

  (setq yas-prompt-functions '(yas/ido-prompt yas/completing-prompt))
  (setq yas-verbosity 1)
  (setq yas-wrap-around-region t)
  :hook (prog-mode . yas-minor-mode)
  :bind
  (:map yas-keymap
   ("<return>" . #'yas-exit-all-snippets)
   ("C-e" . #'yas/goto-end-of-active-field)
   ("C-a" . #'yas/goto-start-of-active-field)))

(provide 'setup-yasnippet)
;;; setup-yasnippet.el ends here
