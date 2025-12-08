;;; setup-ai.el --- configs for LLM integration packages

;; Copyright (C) 2025  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package chatgpt-shell
  :custom
  ((chatgpt-shell-deepseek-key
    (lambda ()
      (auth-source-pick-first-password :host "api.deepseek.com")))
   (chatgpt-shell-model-version "deepseek-chat")))

(use-package monet
  :vc (:url "https://github.com/stevemolitor/monet" :rev :newest))

(defun aidermacs-add-file-at-point (&optional read-only)
  "Add the file at point with optional READ-ONLY flag.
Uses `ffap-file-at-point' to detect the file. With prefix argument `C-u',
adds the file as read-only."
  (interactive "P")
  (let ((file (expand-file-name (or (ffap-file-at-point)
                                    (user-error "No file at point")))))
    (unless (file-exists-p file)
      (user-error "File does not exist: %s" file))
    (aidermacs--add-files-helper
     (list file)
     read-only
     (format "Added %s as %s"
             (file-name-nondirectory file)
             (if read-only "read-only" "editable")))))

(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  (setenv "DEEPSEEK_API_KEY" (auth-source-pick-first-password :host "api.deepseek.com"))

  (transient-insert-suffix 'aidermacs-transient-menu
    'aidermacs-add-current-file  ; Insert after this command
    '("b" "Add File at Point" aidermacs-add-file-at-point))

  :custom
  (aidermacs-default-model "deepseek/deepseek-chat")
  (aidermacs-architect-model "deepseek/deepseek-reasoner")
  (aidermacs-backend 'vterm)
  (aidermacs-watch-files t))

(provide 'setup-ai)
;;; setup-aidermacs.el ends here



