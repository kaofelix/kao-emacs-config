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

(defun magit-status-project-dwim (always-prompt)
  "Run magit-status for current project or prompts for project.
When ALWAYS-PROMPT is passed, prompts for project even if it's
already inside a project."
  (interactive "P")
  (let ((project-root (projectile-project-p)))
    (if (and project-root (not always-prompt))
        (magit-status project-root)
      (let ((relevant-projects (projectile-relevant-known-projects)))
        (if relevant-projects
            (let ((target-project (projectile-completing-read "Magit status for project: " relevant-projects)))
              (magit-status target-project))
          (error "There are no known projects"))))))

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
