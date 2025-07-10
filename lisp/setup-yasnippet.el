;;; setup-yasnippet.el --- yasnippet setup

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local, convenience

;;; Commentary:

;;

;;; Code:

(use-package yasnippet
  :delight  yas-minor-mode
  :config
  ;; Inter-field navigation
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

  (setq yas-prompt-functions '(yas/completing-prompt))
  (setq yas-verbosity 1)
  (setq yas-wrap-around-region t)
  :hook (prog-mode . yas-minor-mode)
  :bind
  (:map yas-keymap
   ("<return>" . #'yas-exit-all-snippets)
   ("C-e" . #'yas/goto-end-of-active-field)
   ("C-a" . #'yas/goto-start-of-active-field)))

(use-package yasnippet-snippets
  :after yasnippet)

(provide 'setup-yasnippet)
;;; setup-yasnippet.el ends here
