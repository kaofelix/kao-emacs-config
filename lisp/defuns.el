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

(defvar default-font-size (face-attribute 'default :height)
  "Default font size.")

(defvar large-font-size 200
  "Default font size.")


(defun kao/toggle-big-font (arg)
  "Toggle between big and normal font size.
If ARG is not nil or 1, set font size to ARG."
  (interactive "P")
  (let ((font-size (if arg
                       arg
                     (if (equal (face-attribute 'default :height) default-font-size)
                         large-font-size
                       default-font-size))))
    (set-face-attribute 'default nil :height font-size)))


(defun kao/make-executable ()
  "Make current file executable."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (set-file-modes filename (logior (file-modes filename) #o100))
      (message "Made '%s' executable." filename))))


(defun kao/inhibit-message-advice (orig-fun &rest args)
  "Set inhibit-message to t while executing BODY."
  (let ((inhibit-message t))
    (apply orig-fun args)))

(advice-add 'undo-tree-save-history :around 'kao/inhibit-message-advice)


(defun kao/ad-memoize (orig-func &rest args)
  "Memoize ORIG-FUNC with ARGS."
  (let (
        (function-name) (symbol-name orig-func)
        (cache-file (no-littering-expand-var-file-name ".memo-cache.el"))
        (cache-var (intern (concat "kao/ad-memoize")))
        )
    (unless (file-exists-p cache-file)
      (error "Cache file '%s' does not exist." cache-file))
    (load-file cache-file)
    (unless (boundp cache-var)
      (error "Cache variable '%s' does not exist." cache-var))
    (let ((cache (symbol-value cache-var))
          (function-cache (cdr (assoc function-name cache))))

       (let ((result (apply orig-func args)))
          (with-temp-file cache-file
            (insert (format "%s" cache)))
          result))))


(defun kao/rename-symbol-at-point ()
  "Rename symbol at point."
  (interactive)
  ;; If eglot is available, use it
  (if (fboundp 'eglot-rename)
      (call-interactively 'eglot-rename)
    ;; Otherwise, use dumb-jump
    (call-interactively 'dumb-jump-rename)))


(defun move-current-buffer-file (new-directory)
  "Move current buffer file to NEW-DIRECTORY."
  (interactive "FNew location: ")
  (let ((filename (buffer-file-name)))
    (when filename
      (let ((new-filename (expand-file-name (file-name-nondirectory filename) new-location)))
        (copy-file filename new-filename 1)
        (delete-file filename)
        (set-visited-file-name new-filename)
        (set-buffer-modified-p nil)
        (message "File '%s' successfully moved to '%s'" filename new-filename)))))

(provide 'defuns)
;;; defuns.el ends here
