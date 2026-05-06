;;; llm-review.el --- Collect code review comments for LLMs -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: tools, convenience
;; Package-Requires: ((emacs "29.1") (transient "0.4.0"))
;; Version: 0.1.0
;; URL: https://github.com/kaofelix/kao-emacs-config

;;; Commentary:

;; llm-review collects project-scoped code review comments for later use
;; with LLMs.  Comments are grouped by file, can be reviewed in a
;; dedicated buffer, and can be exported as plain text.
;;
;; See the accompanying README for installation and usage details.

;;; Code:

(require 'cl-lib)
(require 'project)
(require 'seq)
(require 'subr-x)
(require 'transient)

(defgroup llm-review nil
  "Collect code review comments for LLM workflows."
  :group 'tools
  :prefix "llm-review-")

(defcustom llm-review-storage-directory
  (locate-user-emacs-file "var/llm-review/")
  "Directory where persisted LLM review projects are stored."
  :type 'directory)

(defcustom llm-review-clear-on-copy t
  "Whether `llm-review-copy' should clear active comments after copying."
  :type 'boolean)

(defcustom llm-review-history-length 20
  "Maximum number of archived exports to keep per project."
  :type 'integer)

(defface llm-review-file-heading-face
  '((t :inherit bold :height 1.1))
  "Face for file headings in `llm-review-list-mode'.")

(defface llm-review-section-label-face
  '((t :inherit font-lock-keyword-face :weight bold))
  "Face for section labels in `llm-review-list-mode'.")

(defface llm-review-code-face
  '((t :inherit fixed-pitch))
  "Face for code snippets in `llm-review-list-mode'.")

(defface llm-review-comment-face
  '((t :inherit default))
  "Face for comment text in `llm-review-list-mode'.")

(defface llm-review-current-comment-face
  '((t :inherit hl-line :extend t))
  "Face for the current comment block in `llm-review-list-mode'.")

(cl-defstruct llm-review-project
  version
  project-root
  files
  created-at
  updated-at)

(cl-defstruct llm-review-file-review
  relative-file
  comments
  created-at
  updated-at)

(cl-defstruct llm-review-comment
  id
  line-start
  line-end
  snippet
  comment
  created-at
  updated-at)

(cl-defstruct llm-review-history-entry
  exported-at
  export-text
  project-snapshot)

(defvar llm-review--projects-by-root (make-hash-table :test #'equal)
  "Hash table of `llm-review-project' objects keyed by project root.")

(defvar llm-review--comment-locators (make-hash-table :test #'eql)
  "Hash table of ephemeral comment locators keyed by comment id.")

(defvar llm-review--history-by-root (make-hash-table :test #'equal)
  "Hash table of archived export history keyed by project root.")

(defvar llm-review--next-comment-id 0
  "Next numeric identifier for `llm-review-comment' objects.")

(defvar-local llm-review--project-root nil
  "Project root associated with the current LLM review list buffer.")

(defvar-local llm-review--current-comment-overlay nil
  "Overlay used to highlight the current comment block.")

(defvar llm-review-after-change-hook nil
  "Hook run after LLM review data changes.

Hook functions receive four arguments: ACTION, PROJECT-ROOT, PROJECT, and
COMMENT-ID. ACTION is one of the symbols `capture', `edit', `delete', or
`clear'. PROJECT is the current in-memory project object, or nil for `clear'.
COMMENT-ID is the affected comment id when applicable.")

(defun llm-review--setup-list-mode-map (map)
  "Populate MAP with `llm-review-list-mode' bindings."
  (set-keymap-parent map special-mode-map)
  (define-key map (kbd "RET") #'llm-review-visit)
  (define-key map (kbd "g") #'llm-review-list)
  (define-key map (kbd "w") #'llm-review-copy)
  (define-key map (kbd "e") #'llm-review-edit-comment)
  (define-key map (kbd "d") #'llm-review-delete-comment)
  (define-key map (kbd "n") #'llm-review-next-comment)
  (define-key map (kbd "p") #'llm-review-previous-comment)
  map)

(defvar llm-review-history-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map (kbd "g") #'llm-review-history)
    (define-key map (kbd "w") #'llm-review-history-copy-entry)
    map)
  "Keymap for `llm-review-history-mode'.")

(defvar llm-review-list-mode-map
  (llm-review--setup-list-mode-map (make-sparse-keymap))
  "Keymap for `llm-review-list-mode'.")

(llm-review--setup-list-mode-map llm-review-list-mode-map)

(define-derived-mode llm-review-list-mode special-mode "LLM-Review"
  "Major mode for reviewing collected LLM review comments."
  (setq-local llm-review--current-comment-overlay (make-overlay (point-min) (point-min)))
  (overlay-put llm-review--current-comment-overlay 'face 'llm-review-current-comment-face)
  (add-hook 'post-command-hook #'llm-review--update-current-comment-highlight nil t))

(define-derived-mode llm-review-history-mode special-mode "LLM-Review-History"
  "Major mode for browsing archived LLM review exports.")

;;;###autoload (autoload 'llm-review-menu "llm-review" nil t)
(transient-define-prefix llm-review-menu ()
  "Open the LLM review command menu."
  [["Capture"
    ("c" "Capture" llm-review-capture)]
   ["Review"
    ("l" "List" llm-review-list)
    ("w" "Copy" llm-review-copy)]
   ["Item"
    ("e" "Edit at point" llm-review-edit-comment)
    ("d" "Delete at point" llm-review-delete-comment)]
   ["History"
    ("h" "History" llm-review-history)]
   ["Project"
    ("x" "Clear project" llm-review-clear-project)]]
  (interactive)
  (let ((cleanup (llm-review--show-list-during-transient)))
    (condition-case err
        (transient-setup 'llm-review-menu)
      (error
       (when cleanup
         (funcall cleanup))
       (signal (car err) (cdr err))))))

(defun llm-review-refresh-open-list-buffer (_action project-root project comment-id)
  "Refresh the open list buffer for PROJECT-ROOT, if any."
  (when-let* ((buffer (get-buffer (llm-review--buffer-name project-root))))
    (llm-review--refresh-list-buffer
     buffer
     (or project (llm-review-store-empty-project project-root))
     comment-id)))

(defun llm-review-refresh-open-history-buffer (_action project-root _project _comment-id)
  "Refresh the open history buffer for PROJECT-ROOT, if any."
  (when-let* ((buffer (get-buffer (llm-review--history-buffer-name project-root))))
    (llm-review-render-history-into-buffer project-root buffer)))

(add-hook 'llm-review-after-change-hook #'llm-review-refresh-open-list-buffer)
(add-hook 'llm-review-after-change-hook #'llm-review-refresh-open-history-buffer)

(defun llm-review-store-empty-project (project-root)
  "Create an empty review project for PROJECT-ROOT."
  (let ((now (current-time)))
    (make-llm-review-project
     :version 1
     :project-root (file-name-as-directory project-root)
     :files nil
     :created-at now
     :updated-at now)))

(defun llm-review-store-max-comment-id (project)
  "Return the largest comment id in PROJECT, or 0 when empty."
  (let ((ids (llm-review-store-project-comment-ids project)))
    (if ids
        (apply #'max ids)
      0)))

(defun llm-review--sync-next-comment-id (project)
  "Ensure global comment id counter is at least PROJECT's max id."
  (setq llm-review--next-comment-id
        (max llm-review--next-comment-id
             (llm-review-store-max-comment-id project))))

(defun llm-review-persist-project-file (project-root)
  "Return persistence file path for PROJECT-ROOT."
  (expand-file-name
   (format "%s.el" (secure-hash 'sha1 (file-name-as-directory project-root)))
   llm-review-storage-directory))

(defun llm-review-persist-history-file (project-root)
  "Return history persistence file path for PROJECT-ROOT."
  (expand-file-name
   (format "%s-history.el" (secure-hash 'sha1 (file-name-as-directory project-root)))
   llm-review-storage-directory))

(defun llm-review-persist-serialize-comment (comment)
  "Serialize COMMENT into a plist."
  (list :id (llm-review-comment-id comment)
        :line-start (llm-review-comment-line-start comment)
        :line-end (llm-review-comment-line-end comment)
        :snippet (llm-review-comment-snippet comment)
        :comment (llm-review-comment-comment comment)
        :created-at (llm-review-comment-created-at comment)
        :updated-at (llm-review-comment-updated-at comment)))

(defun llm-review-persist-deserialize-comment (data)
  "Deserialize comment DATA plist into a struct."
  (make-llm-review-comment
   :id (plist-get data :id)
   :line-start (plist-get data :line-start)
   :line-end (plist-get data :line-end)
   :snippet (plist-get data :snippet)
   :comment (plist-get data :comment)
   :created-at (plist-get data :created-at)
   :updated-at (plist-get data :updated-at)))

(defun llm-review-persist-serialize-file-review (file-review)
  "Serialize FILE-REVIEW into a plist."
  (list :relative-file (llm-review-file-review-relative-file file-review)
        :comments (mapcar #'llm-review-persist-serialize-comment
                          (llm-review-file-review-comments file-review))
        :created-at (llm-review-file-review-created-at file-review)
        :updated-at (llm-review-file-review-updated-at file-review)))

(defun llm-review-persist-deserialize-file-review (data)
  "Deserialize file review DATA plist into a struct."
  (make-llm-review-file-review
   :relative-file (plist-get data :relative-file)
   :comments (mapcar #'llm-review-persist-deserialize-comment
                     (plist-get data :comments))
   :created-at (plist-get data :created-at)
   :updated-at (plist-get data :updated-at)))

(defun llm-review-persist-serialize-project (project)
  "Serialize PROJECT into a plist suitable for persistence."
  (list :version (llm-review-project-version project)
        :project-root (llm-review-project-project-root project)
        :files (mapcar #'llm-review-persist-serialize-file-review
                       (llm-review-project-files project))
        :created-at (llm-review-project-created-at project)
        :updated-at (llm-review-project-updated-at project)))

(defun llm-review-persist-deserialize-project (data)
  "Deserialize project DATA plist into a struct."
  (make-llm-review-project
   :version (plist-get data :version)
   :project-root (file-name-as-directory (plist-get data :project-root))
   :files (mapcar #'llm-review-persist-deserialize-file-review
                  (plist-get data :files))
   :created-at (plist-get data :created-at)
   :updated-at (plist-get data :updated-at)))

(defun llm-review-persist-save-project (project)
  "Persist PROJECT to disk and store it in memory."
  (let ((file (llm-review-persist-project-file (llm-review-project-project-root project))))
    (make-directory (file-name-directory file) t)
    (with-temp-file file
      (let ((print-length nil)
            (print-level nil))
        (prin1 (llm-review-persist-serialize-project project) (current-buffer))))
    (puthash (llm-review-project-project-root project) project llm-review--projects-by-root)
    project))

(defun llm-review-persist-load-project (project-root)
  "Load PROJECT-ROOT from disk into memory and return it.
Return nil if no persisted data exists."
  (let* ((project-root (file-name-as-directory project-root))
         (file (llm-review-persist-project-file project-root)))
    (when (file-exists-p file)
      (let ((project (with-temp-buffer
                       (insert-file-contents file)
                       (goto-char (point-min))
                       (llm-review-persist-deserialize-project (read (current-buffer))))))
        (puthash project-root project llm-review--projects-by-root)
        (llm-review--sync-next-comment-id project)
        project))))

(defun llm-review-persist-delete-project (project-root)
  "Delete persisted data for PROJECT-ROOT."
  (let ((file (llm-review-persist-project-file project-root)))
    (when (file-exists-p file)
      (delete-file file))))

(defun llm-review-history-serialize-entry (entry)
  "Serialize history ENTRY into a plist."
  (list :exported-at (llm-review-history-entry-exported-at entry)
        :export-text (llm-review-history-entry-export-text entry)
        :project-snapshot (llm-review-history-entry-project-snapshot entry)))

(defun llm-review-history-deserialize-entry (data)
  "Deserialize history entry DATA plist into a struct."
  (make-llm-review-history-entry
   :exported-at (plist-get data :exported-at)
   :export-text (plist-get data :export-text)
   :project-snapshot (plist-get data :project-snapshot)))

(defun llm-review-history-save-entries (project-root entries)
  "Persist history ENTRIES for PROJECT-ROOT and cache them in memory."
  (let* ((project-root (file-name-as-directory project-root))
         (file (llm-review-persist-history-file project-root)))
    (make-directory (file-name-directory file) t)
    (with-temp-file file
      (let ((print-length nil)
            (print-level nil))
        (prin1 (mapcar #'llm-review-history-serialize-entry entries) (current-buffer))))
    (puthash project-root entries llm-review--history-by-root)
    entries))

(defun llm-review-history-get-entries (project-root)
  "Return archived export entries for PROJECT-ROOT."
  (let* ((project-root (file-name-as-directory project-root))
         (cached (gethash project-root llm-review--history-by-root)))
    (or cached
        (let ((file (llm-review-persist-history-file project-root)))
          (when (file-exists-p file)
            (let ((entries (with-temp-buffer
                             (insert-file-contents file)
                             (goto-char (point-min))
                             (mapcar #'llm-review-history-deserialize-entry
                                     (read (current-buffer))))))
              (puthash project-root entries llm-review--history-by-root)
              entries))))))

(defun llm-review-history-add-entry (project-root entry)
  "Archive ENTRY for PROJECT-ROOT and persist history."
  (let* ((project-root (file-name-as-directory project-root))
         (entries (cons entry (llm-review-history-get-entries project-root))))
    (llm-review-history-save-entries
     project-root
     (seq-take entries llm-review-history-length))))

(defun llm-review-store-get-project (project-root &optional create)
  "Return review project for PROJECT-ROOT.
If CREATE is non-nil, create and store an empty project when absent."
  (let ((project-root (file-name-as-directory project-root)))
    (or (gethash project-root llm-review--projects-by-root)
        (llm-review-persist-load-project project-root)
        (when create
          (let ((project (llm-review-store-empty-project project-root)))
            (puthash project-root project llm-review--projects-by-root)
            project)))))

(defun llm-review-store-find-file-review (project relative-file)
  "Find file review for RELATIVE-FILE in PROJECT."
  (seq-find (lambda (file-review)
              (equal (llm-review-file-review-relative-file file-review)
                     relative-file))
            (llm-review-project-files project)))

(defun llm-review-store-ensure-file-review (project relative-file &optional timestamp)
  "Return file review for RELATIVE-FILE in PROJECT, creating it if needed."
  (or (llm-review-store-find-file-review project relative-file)
      (let* ((now (or timestamp (current-time)))
             (file-review (make-llm-review-file-review
                           :relative-file relative-file
                           :comments nil
                           :created-at now
                           :updated-at now)))
        (setf (llm-review-project-files project)
              (append (llm-review-project-files project) (list file-review)))
        file-review)))

(defun llm-review-store-add-comment (project relative-file comment)
  "Add COMMENT under RELATIVE-FILE in PROJECT."
  (let* ((timestamp (or (llm-review-comment-updated-at comment)
                        (llm-review-comment-created-at comment)
                        (current-time)))
         (file-review (llm-review-store-ensure-file-review project relative-file timestamp)))
    (setf (llm-review-file-review-comments file-review)
          (append (llm-review-file-review-comments file-review) (list comment))
          (llm-review-file-review-updated-at file-review) timestamp
          (llm-review-project-updated-at project) timestamp)
    comment))

(defun llm-review-store-find-comment (project comment-id)
  "Find COMMENT-ID in PROJECT.
Return a plist with keys :file-review and :comment, or nil."
  (cl-loop for file-review in (llm-review-project-files project)
           for comment = (seq-find (lambda (entry)
                                     (= (llm-review-comment-id entry) comment-id))
                                   (llm-review-file-review-comments file-review))
           when comment
           return (list :file-review file-review :comment comment)))

(defun llm-review-store-update-comment (project comment-id new-text)
  "Update COMMENT-ID in PROJECT with NEW-TEXT.
Return updated comment, or nil if not found."
  (when-let* ((result (llm-review-store-find-comment project comment-id))
              (file-review (plist-get result :file-review))
              (comment (plist-get result :comment)))
    (let ((now (current-time)))
      (setf (llm-review-comment-comment comment) new-text
            (llm-review-comment-updated-at comment) now
            (llm-review-file-review-updated-at file-review) now
            (llm-review-project-updated-at project) now)
      comment)))

(defun llm-review-store-delete-comment (project comment-id)
  "Delete COMMENT-ID from PROJECT.
Return non-nil if a comment was removed."
  (let ((deleted nil)
        (now (current-time))
        (remaining-files nil))
    (dolist (file-review (llm-review-project-files project))
      (let* ((comments (llm-review-file-review-comments file-review))
             (kept (cl-remove-if (lambda (comment)
                                   (= (llm-review-comment-id comment) comment-id))
                                 comments)))
        (when (< (length kept) (length comments))
          (setq deleted t))
        (when kept
          (when deleted
            (setf (llm-review-file-review-comments file-review) kept
                  (llm-review-file-review-updated-at file-review) now))
          (push file-review remaining-files))))
    (when deleted
      (setf (llm-review-project-files project) (nreverse remaining-files)
            (llm-review-project-updated-at project) now)
      (remhash comment-id llm-review--comment-locators))
    deleted))

(defun llm-review-store-project-comment-ids (project)
  "Return all comment ids stored in PROJECT."
  (cl-loop for file-review in (llm-review-project-files project)
           append (mapcar #'llm-review-comment-id
                          (llm-review-file-review-comments file-review))))

(defun llm-review-store-sorted-file-reviews (project)
  "Return PROJECT file reviews in display order."
  (sort (copy-sequence (llm-review-project-files project))
        (lambda (left right)
          (string-lessp (llm-review-file-review-relative-file left)
                        (llm-review-file-review-relative-file right)))))

(defun llm-review-store-sorted-comments (file-review)
  "Return FILE-REVIEW comments in display order."
  (sort (copy-sequence (llm-review-file-review-comments file-review))
        (lambda (left right)
          (or (< (llm-review-comment-line-start left)
                 (llm-review-comment-line-start right))
              (and (= (llm-review-comment-line-start left)
                      (llm-review-comment-line-start right))
                   (< (llm-review-comment-id left)
                      (llm-review-comment-id right)))))))

(defun llm-review-render-export-comment (relative-file comment)
  "Render COMMENT from RELATIVE-FILE as compact plain text."
  (format "%s:%d-%d\n```\n%s\n```\n\n%s"
          relative-file
          (llm-review-comment-line-start comment)
          (llm-review-comment-line-end comment)
          (llm-review-comment-snippet comment)
          (llm-review-comment-comment comment)))

(defun llm-review-render-file-review-plain (file-review)
  "Render FILE-REVIEW as compact plain text."
  (string-join
   (mapcar (lambda (comment)
             (llm-review-render-export-comment
              (llm-review-file-review-relative-file file-review)
              comment))
           (llm-review-store-sorted-comments file-review))
   "\n\n---\n\n"))

(defun llm-review-render-project-plain (project)
  "Render PROJECT as plain text for export."
  (let ((rendered (string-join
                   (mapcar #'llm-review-render-file-review-plain
                           (llm-review-store-sorted-file-reviews project))
                   "\n\n---\n\n")))
    (if (string-empty-p rendered)
        rendered
      (concat rendered "\n"))))

(defun llm-review--propertize-code (text)
  "Return TEXT with faces suitable for displaying source code."
  (propertize text 'face '(llm-review-code-face fixed-pitch)))

(defun llm-review-render-comment-into-buffer (comment)
  "Insert COMMENT into current buffer and add navigation properties."
  (let ((start (point)))
    (insert (propertize (format "Lines: %d-%d"
                                (llm-review-comment-line-start comment)
                                (llm-review-comment-line-end comment))
                        'face 'llm-review-section-label-face)
            "\n"
            (propertize "Code:" 'face 'llm-review-section-label-face)
            "\n"
            (llm-review--propertize-code (llm-review-comment-snippet comment))
            "\n\n"
            (propertize "Comment:" 'face 'llm-review-section-label-face)
            "\n"
            (propertize (llm-review-comment-comment comment)
                        'face 'llm-review-comment-face)
            "\n")
    (add-text-properties start (point)
                         `(llm-review-comment-id ,(llm-review-comment-id comment)))))

(defun llm-review-render-file-review-into-buffer (file-review)
  "Insert FILE-REVIEW into current buffer."
  (insert (propertize (format "File: %s"
                              (llm-review-file-review-relative-file file-review))
                      'face 'llm-review-file-heading-face)
          "\n\n")
  (let ((comments (llm-review-store-sorted-comments file-review)))
    (while comments
      (llm-review-render-comment-into-buffer (car comments))
      (setq comments (cdr comments))
      (when comments
        (insert "\n")))))

(defun llm-review--comment-bounds-for-id (comment-id)
  "Return bounds of COMMENT-ID in the current buffer, or nil."
  (when-let* ((start (text-property-any (point-min) (point-max)
                                       'llm-review-comment-id
                                       comment-id)))
    (cons start
          (or (next-single-property-change start 'llm-review-comment-id nil (point-max))
              (point-max)))))

(defun llm-review--comment-bounds-at-point ()
  "Return bounds of the comment block at point, or nil."
  (when-let* ((comment-id (llm-review--comment-id-at-point)))
    (llm-review--comment-bounds-for-id comment-id)))

(defun llm-review--first-comment-bounds ()
  "Return bounds of the first comment block in the current buffer, or nil."
  (when-let* ((start (text-property-any (point-min) (point-max)
                                       'llm-review-comment-id
                                       (get-text-property (point-min) 'llm-review-comment-id))))
    (let ((comment-id (get-text-property start 'llm-review-comment-id)))
      (llm-review--comment-bounds-for-id comment-id))))

(defun llm-review--next-comment-bounds-from (position)
  "Return bounds for the next comment block after POSITION, or nil."
  (let ((pos position)
        next-id)
    (while (and (< pos (point-max)) (not next-id))
      (setq next-id (get-text-property pos 'llm-review-comment-id))
      (unless next-id
        (setq pos (or (next-single-property-change pos 'llm-review-comment-id nil (point-max))
                      (point-max)))))
    (when next-id
      (llm-review--comment-bounds-for-id next-id))))

(defun llm-review--update-current-comment-highlight ()
  "Update the overlay highlighting the current comment block."
  (when (and (derived-mode-p 'llm-review-list-mode)
             (overlayp llm-review--current-comment-overlay))
    (if-let* ((bounds (or (llm-review--comment-bounds-at-point)
                         (llm-review--next-comment-bounds-from (point-min)))))
        (move-overlay llm-review--current-comment-overlay
                      (car bounds)
                      (cdr bounds)
                      (current-buffer))
      (delete-overlay llm-review--current-comment-overlay))))

(defun llm-review-next-comment ()
  "Move point to the next review comment."
  (interactive)
  (unless (derived-mode-p 'llm-review-list-mode)
    (user-error "Not in an LLM review list buffer"))
  (let* ((current-start (and (overlayp llm-review--current-comment-overlay)
                             (overlay-start llm-review--current-comment-overlay)))
         (current-end (and (overlayp llm-review--current-comment-overlay)
                           (overlay-end llm-review--current-comment-overlay)))
         (bounds (or (and current-end
                          (llm-review--next-comment-bounds-from current-end))
                     (llm-review--next-comment-bounds-from (point-min)))))
    (if (and bounds (not (equal (car bounds) current-start)))
        (progn
          (goto-char (car bounds))
          (llm-review--update-current-comment-highlight))
      (user-error "No next review comment"))))

(defun llm-review--all-comment-starts ()
  "Return a list of all comment block start positions in the current buffer."
  (let ((pos (point-min))
        starts)
    (while (< pos (point-max))
      (when-let* ((bounds (llm-review--next-comment-bounds-from pos)))
        (push (car bounds) starts)
        (setq pos (cdr bounds)))
      (unless (llm-review--next-comment-bounds-from pos)
        (setq pos (point-max))))
    (nreverse starts)))

(defun llm-review-previous-comment ()
  "Move point to the previous review comment."
  (interactive)
  (unless (derived-mode-p 'llm-review-list-mode)
    (user-error "Not in an LLM review list buffer"))
  (let* ((current-start (and (overlayp llm-review--current-comment-overlay)
                             (overlay-start llm-review--current-comment-overlay)))
         (starts (llm-review--all-comment-starts))
         (previous-start nil))
    (dolist (start starts)
      (when (and current-start (< start current-start))
        (setq previous-start start)))
    (if previous-start
        (progn
          (goto-char previous-start)
          (llm-review--update-current-comment-highlight))
      (user-error "No previous review comment"))))

(defun llm-review-render-project-into-buffer (project buffer)
  "Render PROJECT into BUFFER."
  (with-current-buffer buffer
    (let ((inhibit-read-only t)
          (file-reviews (llm-review-store-sorted-file-reviews project)))
      (llm-review-list-mode)
      (setq-local llm-review--project-root (llm-review-project-project-root project))
      (erase-buffer)
      (if file-reviews
          (while file-reviews
            (llm-review-render-file-review-into-buffer (car file-reviews))
            (setq file-reviews (cdr file-reviews))
            (when file-reviews
              (insert "\n\n")))
        (insert "No review comments collected for this project.\n"))
      (goto-char (point-min))
      (llm-review--update-current-comment-highlight)))
  buffer)

(defun llm-review-nav-register-comment (comment-id marker-start marker-end)
  "Register runtime locator for COMMENT-ID using MARKER-START and MARKER-END."
  (puthash comment-id
           (list :marker-start (copy-marker marker-start)
                 :marker-end (copy-marker marker-end))
           llm-review--comment-locators))

(defun llm-review-nav-find-comment-locator (comment-id)
  "Return runtime locator for COMMENT-ID, if any."
  (gethash comment-id llm-review--comment-locators))

(defun llm-review-nav-clear-project-locators (project)
  "Remove runtime locators associated with PROJECT."
  (dolist (comment-id (llm-review-store-project-comment-ids project))
    (remhash comment-id llm-review--comment-locators)))

(defun llm-review-nav-goto-comment (project-root relative-file comment)
  "Jump to COMMENT in RELATIVE-FILE under PROJECT-ROOT."
  (let* ((comment-id (llm-review-comment-id comment))
         (locator (llm-review-nav-find-comment-locator comment-id))
         (marker (plist-get locator :marker-start)))
    (if (and marker (marker-buffer marker))
        (progn
          (pop-to-buffer (marker-buffer marker))
          (goto-char marker))
      (let ((file (expand-file-name relative-file project-root)))
        (pop-to-buffer (find-file-noselect file))
        (goto-char (point-min))
        (forward-line (1- (llm-review-comment-line-start comment)))))))

(defun llm-review--project-root ()
  "Return project root for the current context, or signal a user error."
  (cond
   (llm-review--project-root
    llm-review--project-root)
   ((if-let* ((current-project (project-current nil)))
        (file-name-as-directory (project-root current-project))
      nil))
   (t
    (user-error "Current buffer is not in a project"))))

(defun llm-review--ensure-file-buffer ()
  "Ensure the current buffer is visiting a file."
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file")))

(defun llm-review--capture-bounds ()
  "Return the active region bounds, or the current line bounds."
  (if (use-region-p)
      (cons (region-beginning) (region-end))
    (cons (line-beginning-position) (line-end-position))))

(defun llm-review--buffer-name (project-root)
  "Return list buffer name for PROJECT-ROOT."
  (format "*LLM Review: %s*"
          (file-name-nondirectory (directory-file-name project-root))))

(defun llm-review--history-buffer-name (project-root)
  "Return history buffer name for PROJECT-ROOT."
  (format "*LLM Review History: %s*"
          (file-name-nondirectory (directory-file-name project-root))))

(defun llm-review--next-comment-id ()
  "Return the next comment id."
  (cl-incf llm-review--next-comment-id))

(defun llm-review--make-comment-from-context (comment-text)
  "Build a `llm-review-comment' from current buffer context and COMMENT-TEXT."
  (let* ((bounds (llm-review--capture-bounds))
         (start (car bounds))
         (end (cdr bounds))
         (now (current-time)))
    (list
     :comment (make-llm-review-comment
               :id (llm-review--next-comment-id)
               :line-start (line-number-at-pos start)
               :line-end (line-number-at-pos end)
               :snippet (buffer-substring-no-properties start end)
               :comment comment-text
               :created-at now
               :updated-at now)
     :start start
     :end end)))

(defun llm-review--comment-id-at-point ()
  "Return comment id at point in a review list buffer."
  (or (get-text-property (point) 'llm-review-comment-id)
      (and (> (point) (point-min))
           (get-text-property (1- (point)) 'llm-review-comment-id))))

(defun llm-review--display-preview-buffer (project-root)
  "Render and display the review buffer for PROJECT-ROOT."
  (let* ((project (or (llm-review-store-get-project project-root)
                      (llm-review-store-empty-project project-root)))
         (buffer (get-buffer-create (llm-review--buffer-name project-root))))
    (llm-review-render-project-into-buffer project buffer)
    (display-buffer buffer '(display-buffer-pop-up-window))
    buffer))

(defun llm-review--show-list-during-transient ()
  "Display the project review buffer until the current transient exits.

Return a cleanup function when a preview was displayed, or nil when the
current context has no project."
  (when-let* ((project-root (ignore-errors (llm-review--project-root))))
    (let ((window-configuration (current-window-configuration))
          cleanup)
      (llm-review--display-preview-buffer project-root)
      (setq cleanup
            (lambda ()
              (remove-hook 'transient-exit-hook cleanup)
              (set-window-configuration window-configuration)))
      (add-hook 'transient-exit-hook cleanup)
      cleanup)))

(defun llm-review--read-comment-with-preview (project-root)
  "Prompt for a review comment while showing the project review buffer."
  (save-window-excursion
    (llm-review--display-preview-buffer project-root)
    (read-string "Review comment: ")))

(defun llm-review--save-project (project)
  "Persist PROJECT, or delete persisted storage when it is empty."
  (if (llm-review-project-files project)
      (llm-review-persist-save-project project)
    (progn
      (remhash (llm-review-project-project-root project) llm-review--projects-by-root)
      (llm-review-persist-delete-project (llm-review-project-project-root project))
      nil)))

(defun llm-review--archive-project-export (project export-text)
  "Archive PROJECT with EXPORT-TEXT in history."
  (llm-review-history-add-entry
   (llm-review-project-project-root project)
   (make-llm-review-history-entry
    :exported-at (current-time)
    :export-text export-text
    :project-snapshot (llm-review-persist-serialize-project project))))

(defun llm-review--clear-active-project (project-root)
  "Clear active comments for PROJECT-ROOT without touching history."
  (let ((project (llm-review-store-get-project project-root)))
    (when project
      (llm-review-nav-clear-project-locators project))
    (remhash project-root llm-review--projects-by-root)
    (llm-review-persist-delete-project project-root)
    (llm-review--notify-change 'clear project-root nil nil)))

(defun llm-review--notify-change (action project-root &optional project comment-id)
  "Notify listeners of ACTION for PROJECT-ROOT."
  (run-hook-with-args 'llm-review-after-change-hook
                      action
                      project-root
                      project
                      comment-id))

(defun llm-review--refresh-list-buffer (buffer project &optional comment-id)
  "Re-render BUFFER for PROJECT and try to keep point on COMMENT-ID."
  (with-current-buffer buffer
    (llm-review-render-project-into-buffer project buffer)
    (when comment-id
      (when-let* ((pos (text-property-any (point-min) (point-max)
                                         'llm-review-comment-id
                                         comment-id)))
        (goto-char pos)))))

(defun llm-review-render-history-entry-into-buffer (entry)
  "Insert archived history ENTRY into the current buffer."
  (let* ((start (point))
         (project (llm-review-persist-deserialize-project
                   (llm-review-history-entry-project-snapshot entry))))
    (insert (propertize (format-time-string "%Y-%m-%d %H:%M:%S"
                                            (llm-review-history-entry-exported-at entry))
                        'face 'llm-review-file-heading-face)
            "\n\n")
    (let ((file-reviews (llm-review-store-sorted-file-reviews project)))
      (while file-reviews
        (llm-review-render-file-review-into-buffer (car file-reviews))
        (setq file-reviews (cdr file-reviews))
        (when file-reviews
          (insert "\n\n"))))
    (insert "\n")
    (add-text-properties start (point)
                         `(llm-review-history-entry ,entry))))

(defun llm-review-render-history-into-buffer (project-root buffer)
  "Render archived history for PROJECT-ROOT into BUFFER."
  (let ((entries (llm-review-history-get-entries project-root)))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (llm-review-history-mode)
        (setq-local llm-review--project-root project-root)
        (erase-buffer)
        (if entries
            (let ((remaining entries))
              (while remaining
                (llm-review-render-history-entry-into-buffer (car remaining))
                (setq remaining (cdr remaining))
                (when remaining
                  (insert "\n\n"))))
          (insert "No archived exports for this project.\n"))
        (goto-char (point-min)))))
  buffer)

(defun llm-review-history-copy-entry ()
  "Copy the archived export at point to the kill ring."
  (interactive)
  (unless (derived-mode-p 'llm-review-history-mode)
    (user-error "Not in an LLM review history buffer"))
  (if-let* ((entry (get-text-property (point) 'llm-review-history-entry)))
      (progn
        (kill-new (llm-review-history-entry-export-text entry))
        (message "Copied archived review export"))
    (user-error "No archived export at point")))

;;;###autoload
(defun llm-review-capture ()
  "Capture the active region or current line as an LLM review note."
  (interactive)
  (llm-review--ensure-file-buffer)
  (let* ((project-root (llm-review--project-root))
         (relative-file (file-relative-name buffer-file-name project-root))
         (comment-text (llm-review--read-comment-with-preview project-root))
         (payload (llm-review--make-comment-from-context comment-text))
         (comment (plist-get payload :comment))
         (project (llm-review-store-get-project project-root t)))
    (llm-review-store-add-comment project relative-file comment)
    (llm-review-nav-register-comment (llm-review-comment-id comment)
                                     (plist-get payload :start)
                                     (plist-get payload :end))
    (llm-review--save-project project)
    (llm-review--notify-change 'capture project-root project
                               (llm-review-comment-id comment))
    (message "Captured review comment for %s:%d"
             relative-file
             (llm-review-comment-line-start comment))
    comment))

;;;###autoload
(defun llm-review-copy ()
  "Copy all collected comments for the current project to the kill ring."
  (interactive)
  (let* ((project-root (llm-review--project-root))
         (project (llm-review-store-get-project project-root)))
    (unless (and project (llm-review-project-files project))
      (user-error "No review comments collected for this project"))
    (let* ((export-text (llm-review-render-project-plain project))
           (count (length (llm-review-store-project-comment-ids project))))
      (llm-review--archive-project-export project export-text)
      (kill-new export-text)
      (when llm-review-clear-on-copy
        (llm-review--clear-active-project project-root))
      (message "Copied %d review comment%s"
               count
               (if (= count 1) "" "s")))))

;;;###autoload
(defun llm-review-list ()
  "Display collected review comments for the current project."
  (interactive)
  (let* ((project-root (llm-review--project-root))
         (project (or (llm-review-store-get-project project-root)
                      (llm-review-store-empty-project project-root)))
         (buffer (get-buffer-create (llm-review--buffer-name project-root))))
    (llm-review-render-project-into-buffer project buffer)
    (pop-to-buffer buffer)
    buffer))

;;;###autoload
(defun llm-review-visit ()
  "Visit the review comment at point."
  (interactive)
  (unless (derived-mode-p 'llm-review-list-mode)
    (user-error "Not in an LLM review list buffer"))
  (let* ((project-root (llm-review--project-root))
         (project (llm-review-store-get-project project-root))
         (comment-id (llm-review--comment-id-at-point))
         (result (and project comment-id
                      (llm-review-store-find-comment project comment-id))))
    (unless result
      (user-error "No review entry at point"))
    (llm-review-nav-goto-comment
     project-root
     (llm-review-file-review-relative-file (plist-get result :file-review))
     (plist-get result :comment))))

;;;###autoload
(defun llm-review-edit-comment ()
  "Edit the review comment at point."
  (interactive)
  (unless (derived-mode-p 'llm-review-list-mode)
    (user-error "Not in an LLM review list buffer"))
  (let* ((project-root (llm-review--project-root))
         (project (llm-review-store-get-project project-root))
         (comment-id (llm-review--comment-id-at-point))
         (result (and project comment-id
                      (llm-review-store-find-comment project comment-id))))
    (unless result
      (user-error "No review entry at point"))
    (let* ((comment (plist-get result :comment))
           (new-text (read-string "Edit review comment: "
                                  (llm-review-comment-comment comment))))
      (llm-review-store-update-comment project comment-id new-text)
      (llm-review--save-project project)
      (llm-review--notify-change 'edit project-root project comment-id)
      (message "Updated review comment"))))

;;;###autoload
(defun llm-review-delete-comment ()
  "Delete the review comment at point."
  (interactive)
  (unless (derived-mode-p 'llm-review-list-mode)
    (user-error "Not in an LLM review list buffer"))
  (let* ((project-root (llm-review--project-root))
         (project (llm-review-store-get-project project-root))
         (comment-id (llm-review--comment-id-at-point)))
    (unless (and project comment-id)
      (user-error "No review entry at point"))
    (when (yes-or-no-p "Delete review comment? ")
      (unless (llm-review-store-delete-comment project comment-id)
        (user-error "No review entry at point"))
      (llm-review--save-project project)
      (llm-review--notify-change 'delete project-root project nil)
      (message "Deleted review comment"))))

;;;###autoload
(defun llm-review-history ()
  "Display archived exports for the current project."
  (interactive)
  (let* ((project-root (llm-review--project-root))
         (buffer (get-buffer-create (llm-review--history-buffer-name project-root))))
    (llm-review-render-history-into-buffer project-root buffer)
    (pop-to-buffer buffer)
    buffer))

(defun llm-review-clear-project ()
  "Clear collected review comments for the current project."
  (interactive)
  (let ((project-root (llm-review--project-root)))
    (llm-review--clear-active-project project-root)
    (message "Cleared review comments for %s"
             (file-name-nondirectory (directory-file-name project-root)))))

(provide 'llm-review)
;;; llm-review.el ends here
