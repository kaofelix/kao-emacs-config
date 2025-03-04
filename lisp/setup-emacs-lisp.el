;;; emacs-lisp.el --- Config for Emacs Lisp editing

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local, lisp

;;; Commentary:

;;

;;; Code:
(use-package elisp-slime-nav
  :delight
  :hook (emacs-lisp-mode . elisp-slime-nav-mode))

(use-package highlight-quoted
  :hook ((emacs-lisp-mode lisp-interaction-mode) . highlight-quoted-mode))

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)

;; auto-modes
(add-to-list 'auto-mode-alist '("Cask$" . emacs-lisp-mode))

(defface emacs-lisp-keyword-symbol-face
  '((t :inherit font-lock-variable-name-face))
  "Face to highlight Lisp keyword symbols (e.g. :foobar)."
  :group 'keyword-symbol)

(font-lock-add-keywords 'emacs-lisp-mode
                        '((":\\(\\sw\\|\\s_\\|\\\\.\\)+" . 'emacs-lisp-keyword-symbol-face)))


(use-package el-patch
  :config
  ;; Fix the indentation of keyword lists in Emacs Lisp. See [1] and [2].
  ;;
  ;; Before:
  ;;  (:foo bar
  ;;        :baz quux)
  ;;
  ;; After:
  ;;  (:foo bar
  ;;   :bar quux)
  ;;
  ;; [1]: https://github.com/Fuco1/.emacs.d/blob/af82072196564fa57726bdbabf97f1d35c43b7f7/site-lisp/redef.el#L12-L94
  ;; [2]: http://emacs.stackexchange.com/q/10230/12534
  (el-patch-defun lisp-indent-function (indent-point state)
                  "This function is the normal value of the variable `lisp-indent-function'.
The function `calculate-lisp-indent' calls this to determine
if the arguments of a Lisp function call should be indented specially.
INDENT-POINT is the position at which the line being indented begins.
Point is located at the point to indent under (for default indentation);
STATE is the `parse-partial-sexp' state for that position.
If the current line is in a call to a Lisp function that has a non-nil
property `lisp-indent-function' (or the deprecated `lisp-indent-hook'),
it specifies how to indent.  The property value can be:
* `defun', meaning indent `defun'-style
  (this is also the case if there is no property and the function
  has a name that begins with \"def\", and three or more arguments);
* an integer N, meaning indent the first N arguments specially
  (like ordinary function arguments), and then indent any further
  arguments like a body;
* a function to call that returns the indentation (or nil).
  `lisp-indent-function' calls this function with the same two arguments
  that it itself received.
This function returns either the indentation to use, or nil if the
Lisp function does not specify a special indentation."
                  (el-patch-let (($cond (and (elt state 2)
                                             (el-patch-wrap 1 1
                                                            (or (not (looking-at "\\sw\\|\\s_"))
                                                                (looking-at ":")))))
                                 ($then (progn
                                          (if (not (> (save-excursion (forward-line 1) (point))
                                                      calculate-lisp-indent-last-sexp))
                                              (progn (goto-char calculate-lisp-indent-last-sexp)
                                                     (beginning-of-line)
                                                     (parse-partial-sexp (point)
                                                                         calculate-lisp-indent-last-sexp 0 t)))
                                          ;; Indent under the list or under the first sexp on the same
                                          ;; line as calculate-lisp-indent-last-sexp.  Note that first
                                          ;; thing on that line has to be complete sexp since we are
                                          ;; inside the innermost containing sexp.
                                          (backward-prefix-chars)
                                          (current-column)))
                                 ($else (let ((function (buffer-substring (point)
                                                                          (progn (forward-sexp 1) (point))))
                                              method)
                                          (setq method (or (function-get (intern-soft function)
                                                                         'lisp-indent-function)
                                                           (get (intern-soft function) 'lisp-indent-hook)))
                                          (cond ((or (eq method 'defun)
                                                     (and (null method)
                                                          (> (length function) 3)
                                                          (string-match "\\`def" function)))
                                                 (lisp-indent-defform state indent-point))
                                                ((integerp method)
                                                 (lisp-indent-specform method state
                                                                       indent-point normal-indent))
                                                (method
                                                 (funcall method indent-point state))))))
                                (let ((normal-indent (current-column))
                                      (el-patch-add
                                       (orig-point (point))))
                                  (goto-char (1+ (elt state 1)))
                                  (parse-partial-sexp (point) calculate-lisp-indent-last-sexp 0 t)
                                  (el-patch-swap
                                   (if $cond
                                       ;; car of form doesn't seem to be a symbol
                                       $then
                                     $else)
                                   (cond
                                    ;; car of form doesn't seem to be a symbol, or is a keyword
                                    ($cond $then)
                                    ((and (save-excursion
                                            (goto-char indent-point)
                                            (skip-syntax-forward " ")
                                            (not (looking-at ":")))
                                          (save-excursion
                                            (goto-char orig-point)
                                            (looking-at ":")))
                                     (save-excursion
                                       (goto-char (+ 2 (elt state 1)))
                                       (current-column)))
                                    (t $else)))))))

(provide 'setup-emacs-lisp)
;;; setup-emacs-lisp.el ends here
