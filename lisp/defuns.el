;;; defuns.el --- Defuns

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;; Custom elisp functions and macros

;;; Code:

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

(defun kao/duplicate-line (times)
  "Duplicate the current line TIMES times."
  (interactive "p")
  (kao/type-last-key-to-repeat
    (save-excursion
      (dotimes (ignored times)
        (end-of-line)
        (insert "\n" (replace-regexp-in-string "\n" "" (thing-at-point 'line)))))))

(defun kao/move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(defun rename-current-buffer-file ()
  "Rename current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun delete-current-buffer-file ()
  "Remove file connected to current buffer and kill buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun kao/open-line (arg)
  "Open `ARG' lines under current point position.
If point is on beggining of line, open lines above the current
one. Otherwise, open a line under the next one. When before
closing delimiter, will open a new line between both delimiters."
  (interactive "p")
  (let ((bol-or-empy-before-point (or (looking-back "^\\s *" 0))))
    (if bol-or-empy-before-point
        (progn
          (open-line arg)
          (save-excursion
            (forward-line 1)
            (indent-according-to-mode)))
      (if (looking-at-p "\\s)")
          (progn
            (open-line 1)
            (save-excursion
              (forward-line 1)
              (indent-according-to-mode)))
        (end-of-line))
      (open-line arg)
      (forward-line 1)
      (indent-according-to-mode))))

(provide 'defuns)
;;; defuns.el ends here
