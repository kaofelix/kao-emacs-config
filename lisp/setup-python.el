;;; setup-python.el --- configs for python

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package python
  :after (apheleia)
  :hook
  (python-mode . eglot-ensure)
  (python-ts-mode . eglot-ensure)

  :config
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))

  (defun python-fix-imports ()
    (interactive)
    (shell-command-on-region
     (point-min) (point-max)
     "ruff check --silent --select I,F401 --fix --fix-only -" t t nil)
    (save-buffer))
  :custom
  (python-check-command "ruff check")
  (python-flymake-command '("ruff check")))

(use-package pyvenv
  :config
  (pyvenv-mode 1)
  (with-eval-after-load 'projectile
    (defun kao/activate-project-venv ()
      (let* ((root (projectile-project-root))
             (venv-path (concat root ".venv")))
        (if (file-exists-p venv-path)
            (pyvenv-activate venv-path))))

    (add-hook 'projectile-after-switch-project-hook #'kao/activate-project-venv)))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(use-package pip-requirements
  :mode ("\\.in\\'" . pip-requirements-mode))

(provide 'setup-python)
;;; setup-python.el ends here

