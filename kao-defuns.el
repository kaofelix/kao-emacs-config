;;; kao-defuns.el --- Defuns

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local

;;; Commentary:

;; Custom elisp functions and macros

;;; Code:

;; Interactive commands

(defun kao/duplicate-line (times)
  "Duplicate the current line TIMES times."
  (interactive "p")
  (kao/type-last-key-to-repeat
    (save-excursion
      (dotimes (ignored times)
        (end-of-line)
        (insert "\n" (replace-regexp-in-string "\n" "" (thing-at-point 'line)))))))


;; Utility functions and macros

(defmacro kao/type-last-key-to-repeat (&rest body)
  "Repeat BODY when typing the last key on the key sequence typed."
  (declare (indent defun))
  `(progn
     (progn ,@body)
     (let* ((repeat-key last-input-event)
            (repeat-key-str (format-kbd-macro (vector repeat-key) nil)))
       (while repeat-key
         (message "(Type %s to repeat.)" repeat-key-str)
         (if (equal repeat-key (read-event))
             (progn
               (clear-this-command-keys t)
               (progn ,@body)
               (setq last-input-event nil))
           (setq repeat-key nil)))
       (when last-input-event
         (clear-this-command-keys t)
         (setq unread-command-events (list last-input-event))))))


(provide 'kao-defuns)
;;; kao-defuns.el ends here
