;;; setup-theme.el --- Theme configs

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Code:
(setq solarized-distinct-fringe-background t)
(setq solarized-use-less-bold t)
(load-theme 'solarized-light t)

;; Warning: currently, disabling and enabling themes many times crashes latest
;; Mac OSX Homebrew Emacs version:
;; "GNU Emacs 24.4.1 (x86_64-apple-darwin14.0.0, NS apple-appkit-1343.14) of 2014-10-24"
(defun solarized-light-switch ()
  "Toggle between solarized light and dark."
  (interactive)
  (lexical-let* ((current-solarized (cl-find-if
                                     (lambda (sym) (string-prefix-p "solarized-" (symbol-name sym)))
                                     custom-enabled-themes))
                 (other-solarized (if (string-suffix-p "-dark" (symbol-name current-solarized))
                                      'solarized-light
                                    'solarized-dark)))
    (disable-theme current-solarized)
    (load-theme other-solarized)))

(global-set-key (kbd "C-x C-t") 'solarized-light-switch)

(provide 'setup-theme)
;;; setup-theme.el ends here
