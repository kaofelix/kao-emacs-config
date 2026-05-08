;;; llm-review-tests.el --- Tests for llm-review -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)
(require 'project)
(require 'seq)
(require 'transient)

(ignore-errors (load "llm-review" nil t))

(defmacro llm-review-tests--with-project-files (files &rest body)
  "Create a temporary project with FILES and evaluate BODY.

FILES is an alist of (RELATIVE-PATH . CONTENT)."
  (declare (indent 1))
  `(let* ((project-root (make-temp-file "llm-review-test-project-" t))
          (llm-review-storage-directory (make-temp-file "llm-review-test-storage-" t))
          (llm-review--projects-by-root (make-hash-table :test #'equal))
          (llm-review--comment-locators (make-hash-table :test #'eql))
          (llm-review--source-overlays (make-hash-table :test #'eql))
          (llm-review--next-comment-id 0)
          (file-specs ,files))
     (dolist (file-spec file-specs)
       (let ((file (expand-file-name (car file-spec) project-root)))
         (make-directory (file-name-directory file) t)
         (with-temp-file file
           (insert (cdr file-spec)))))
     (unwind-protect
         (cl-letf (((symbol-function 'project-current)
                    (lambda (&optional _maybe-prompt _dir)
                      `(transient . ,project-root))))
           ,@body)
       (dolist (file-spec file-specs)
         (when-let* ((buffer (get-file-buffer (expand-file-name (car file-spec) project-root))))
           (kill-buffer buffer)))
       (delete-directory project-root t)
       (delete-directory llm-review-storage-directory t))))

(defun llm-review-tests--find-file (project-root relative-file)
  "Open RELATIVE-FILE from PROJECT-ROOT and return its buffer."
  (let ((buffer (find-file-noselect (expand-file-name relative-file project-root))))
    (with-current-buffer buffer
      (setq-local transient-mark-mode t))
    buffer))

(defun llm-review-tests--make-comment (id text &optional line snippet)
  "Create a comment with ID and TEXT for tests."
  (make-llm-review-comment
   :id id
   :line-start (or line 1)
   :line-end (or line 1)
   :snippet (or snippet "(message \"hello\")")
   :comment text
   :created-at '(0 0 0 0)
   :updated-at '(0 0 0 0)))

(defun llm-review-tests--project-comment-count (project)
  "Return number of comments in PROJECT."
  (length (llm-review-store-project-comment-ids project)))

(ert-deftest llm-review-capture-bounds-uses-region-when-active ()
  (with-temp-buffer
    (insert "alpha\nbeta\n")
    (goto-char (point-min))
    (set-mark (point))
    (forward-word 1)
    (activate-mark)
    (should (equal (llm-review--capture-bounds)
                   (cons (region-beginning) (region-end))))))

(ert-deftest llm-review-capture-bounds-uses-current-line-without-region ()
  (with-temp-buffer
    (insert "alpha\nbeta\n")
    (goto-char (point-min))
    (forward-line 1)
    (forward-char 2)
    (should (equal (llm-review--capture-bounds)
                   (cons (line-beginning-position)
                         (line-end-position))))))

(ert-deftest llm-review-store-add-comment-groups-by-file ()
  (let* ((project (llm-review-store-empty-project "/tmp/project/"))
         (comment-1 (llm-review-tests--make-comment 1 "First comment" 3 "alpha"))
         (comment-2 (llm-review-tests--make-comment 2 "Second comment" 8 "beta")))
    (llm-review-store-add-comment project "src/example.el" comment-1)
    (llm-review-store-add-comment project "src/example.el" comment-2)
    (should (= 1 (length (llm-review-project-files project))))
    (let ((file-review (car (llm-review-project-files project))))
      (should (equal "src/example.el" (llm-review-file-review-relative-file file-review)))
      (should (= 2 (length (llm-review-file-review-comments file-review)))))))

(ert-deftest llm-review-serialize-roundtrip-preserves-file-grouping ()
  (let* ((project (llm-review-store-empty-project "/tmp/project/"))
         (comment-1 (llm-review-tests--make-comment 1 "First comment" 3 "alpha"))
         (comment-2 (llm-review-tests--make-comment 2 "Second comment" 8 "beta"))
         serialized
         restored)
    (llm-review-store-add-comment project "src/example.el" comment-1)
    (llm-review-store-add-comment project "src/example.el" comment-2)
    (setq serialized (llm-review-persist-serialize-project project))
    (setq restored (llm-review-persist-deserialize-project serialized))
    (should (= 1 (length (llm-review-project-files restored))))
    (should (= 2 (length (llm-review-file-review-comments
                          (car (llm-review-project-files restored))))))
    (should (equal "Second comment"
                   (llm-review-comment-comment
                    (cadr (llm-review-file-review-comments
                           (car (llm-review-project-files restored)))))))))

(ert-deftest llm-review-persist-save-and-load-project ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let* ((project (llm-review-store-empty-project project-root))
           (comment (llm-review-tests--make-comment 7 "Persist me" 1 "first")))
      (llm-review-store-add-comment project "src/example.el" comment)
      (llm-review-persist-save-project project)
      (clrhash llm-review--projects-by-root)
      (setq llm-review--next-comment-id 0)
      (let ((loaded (llm-review-persist-load-project project-root)))
        (should loaded)
        (should (= 1 (llm-review-tests--project-comment-count loaded)))
        (should (= 7 llm-review--next-comment-id))
        (should (equal "Persist me"
                       (llm-review-comment-comment
                        (car (llm-review-file-review-comments
                              (car (llm-review-project-files loaded)))))))))))

(ert-deftest llm-review-render-project-plain-uses-compact-export-format ()
  (let* ((project (llm-review-store-empty-project "/tmp/project/"))
         (comment-1 (llm-review-tests--make-comment 1 "First comment" 3 "alpha"))
         (comment-2 (llm-review-tests--make-comment 2 "Second comment" 8 "beta"))
         (comment-3 (llm-review-tests--make-comment 3 "Third comment" 1 "gamma")))
    (llm-review-store-add-comment project "src/example.el" comment-1)
    (llm-review-store-add-comment project "src/example.el" comment-2)
    (llm-review-store-add-comment project "src/other.el" comment-3)
    (should
     (equal
      (llm-review-render-project-plain project)
      (concat
       "src/example.el:3-3\n"
       "```\n"
       "alpha\n"
       "```\n\n"
       "First comment\n\n"
       "---\n\n"
       "src/example.el:8-8\n"
       "```\n"
       "beta\n"
       "```\n\n"
       "Second comment\n\n"
       "---\n\n"
       "src/other.el:1-1\n"
       "```\n"
       "gamma\n"
       "```\n\n"
       "Third comment\n")))))

(ert-deftest llm-review-capture-groups-comments-under-file ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\nthird\n"))
    (cl-letf (((symbol-function 'read-string)
               (let ((comments '("Comment one" "Comment two")))
                 (lambda (&rest _args)
                   (prog1 (car comments)
                     (setq comments (cdr comments)))))))
      (let ((buffer (llm-review-tests--find-file project-root "src/example.el")))
        (unwind-protect
            (with-current-buffer buffer
              (goto-char (point-min))
              (llm-review-capture)
              (forward-line 1)
              (llm-review-capture)
              (let* ((project (llm-review-store-get-project (file-name-as-directory project-root)))
                     (file-review (car (llm-review-project-files project))))
                (should (= 1 (length (llm-review-project-files project))))
                (should (= 2 (length (llm-review-file-review-comments file-review))))))
          (kill-buffer buffer))))))

(ert-deftest llm-review-copy-archives-and-clears-project ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((kill-ring nil)
          (buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Persisted comment")))
              (with-current-buffer buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (clrhash llm-review--projects-by-root)
            (with-current-buffer buffer
              (llm-review-copy))
            (should (string-match-p "Persisted comment" (current-kill 0)))
            (should-not (llm-review-store-get-project project-root))
            (let ((history (llm-review-history-get-entries project-root)))
              (should (= 1 (length history)))
              (should (string-match-p "Persisted comment"
                                      (llm-review-history-entry-export-text (car history))))))
        (kill-buffer buffer)))))

(ert-deftest llm-review-history-renders-archived-exports ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Archived comment")))
              (with-current-buffer buffer
                (goto-char (point-min))
                (llm-review-capture)
                (llm-review-copy)))
            (let ((history-buffer (llm-review-history)))
              (unwind-protect
                  (with-current-buffer history-buffer
                    (goto-char (point-min))
                    (should (string-match-p "Archived comment" (buffer-string)))
                    (should (equal (get-text-property (point) 'face)
                                   'llm-review-file-heading-face))
                    (search-forward "File: src/example.el")
                    (should (equal (get-text-property (match-beginning 0) 'face)
                                   'llm-review-file-heading-face))
                    (search-forward "Code:")
                    (should (equal (get-text-property (match-beginning 0) 'face)
                                   'llm-review-section-label-face))
                    (search-forward "first")
                    (should (equal (get-text-property (match-beginning 0) 'face)
                                   '(llm-review-code-face fixed-pitch))))
                (when (buffer-live-p history-buffer)
                  (kill-buffer history-buffer)))))
        (kill-buffer buffer)))))

(ert-deftest llm-review-list-renders-grouped-file-sections ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n")
                                          ("src/other.el" . "other\n"))
    (cl-letf (((symbol-function 'read-string)
               (let ((comments '("Comment one" "Comment two" "Comment three")))
                 (lambda (&rest _args)
                   (prog1 (car comments)
                     (setq comments (cdr comments)))))))
      (let ((example-buffer (llm-review-tests--find-file project-root "src/example.el"))
            (other-buffer (llm-review-tests--find-file project-root "src/other.el")))
        (unwind-protect
            (progn
              (with-current-buffer example-buffer
                (goto-char (point-min))
                (llm-review-capture)
                (forward-line 1)
                (llm-review-capture))
              (with-current-buffer other-buffer
                (goto-char (point-min))
                (llm-review-capture))
              (let ((buffer (llm-review-list)))
                (unwind-protect
                    (with-current-buffer buffer
                      (should (string-match-p "File: src/example.el" (buffer-string)))
                      (should (string-match-p "File: src/other.el" (buffer-string)))
                      (should (= 2 (how-many "File: " (point-min) (point-max)))))
                  (when (buffer-live-p buffer)
                    (kill-buffer buffer)))))
          (kill-buffer example-buffer)
          (kill-buffer other-buffer))))))

(ert-deftest llm-review-history-copy-entry-copies-export-text ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((kill-ring nil)
          (buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "History copy comment")))
              (with-current-buffer buffer
                (goto-char (point-min))
                (llm-review-capture)
                (llm-review-copy)))
            (let ((history-buffer (llm-review-history)))
              (unwind-protect
                  (with-current-buffer history-buffer
                    (goto-char (point-min))
                    (llm-review-history-copy-entry)
                    (should (string-match-p "History copy comment" (current-kill 0))))
                (when (buffer-live-p history-buffer)
                  (kill-buffer history-buffer)))))
        (kill-buffer buffer)))))

(ert-deftest llm-review-list-applies-faces ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Comment one")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (with-current-buffer list-buffer
                    (goto-char (point-min))
                    (should (equal (get-text-property (point) 'face)
                                   'llm-review-file-heading-face))
                    (search-forward "Code:")
                    (should (equal (get-text-property (match-beginning 0) 'face)
                                   'llm-review-section-label-face))
                    (search-forward "first")
                    (should (equal (get-text-property (match-beginning 0) 'face)
                                   '(llm-review-code-face fixed-pitch))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer)))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-list-highlights-current-comment ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (let ((comments '("Comment one" "Comment two")))
                         (lambda (&rest _args)
                           (prog1 (car comments)
                             (setq comments (cdr comments)))))))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)
                (forward-line 1)
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (with-current-buffer list-buffer
                    (goto-char (point-min))
                    (let ((overlay llm-review--current-comment-overlay))
                      (should (overlayp overlay))
                      (should (> (overlay-start overlay) (point)))
                      (should (string-match-p "Comment one"
                                              (buffer-substring-no-properties
                                               (overlay-start overlay)
                                               (overlay-end overlay)))))
                    (search-forward "Comment:\nComment two")
                    (beginning-of-line 0)
                    (llm-review--update-current-comment-highlight)
                    (should (string-match-p "Comment two"
                                            (buffer-substring-no-properties
                                             (overlay-start llm-review--current-comment-overlay)
                                             (overlay-end llm-review--current-comment-overlay)))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer)))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-list-navigation-moves-between-comments ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\nthird\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (let ((comments '("Comment one" "Comment two" "Comment three")))
                         (lambda (&rest _args)
                           (prog1 (car comments)
                             (setq comments (cdr comments)))))))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)
                (forward-line 1)
                (llm-review-capture)
                (forward-line 1)
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (with-current-buffer list-buffer
                    (goto-char (point-min))
                    (llm-review-next-comment)
                    (should (string-match-p "Comment two"
                                            (buffer-substring-no-properties
                                             (overlay-start llm-review--current-comment-overlay)
                                             (overlay-end llm-review--current-comment-overlay))))
                    (llm-review-previous-comment)
                    (should (string-match-p "Comment one"
                                            (buffer-substring-no-properties
                                             (overlay-start llm-review--current-comment-overlay)
                                             (overlay-end llm-review--current-comment-overlay)))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer)))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-list-auto-refreshes-after-capture ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Comment one")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (progn
                    (with-current-buffer list-buffer
                      (should-not (string-match-p "Comment two" (buffer-string))))
                    (cl-letf (((symbol-function 'read-string)
                               (lambda (&rest _args) "Comment two")))
                      (with-current-buffer source-buffer
                        (forward-line 1)
                        (llm-review-capture)))
                    (with-current-buffer list-buffer
                      (should (string-match-p "Comment one" (buffer-string)))
                      (should (string-match-p "Comment two" (buffer-string)))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer)))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-capture-displays-review-buffer-during-prompt ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el"))
          preview-buffer
          preview-action)
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Comment one")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (cl-letf (((symbol-function 'display-buffer)
                       (lambda (buffer-or-name action &optional _frame)
                         (setq preview-buffer (get-buffer buffer-or-name)
                               preview-action action)
                         (selected-window)))
                      ((symbol-function 'read-string)
                       (lambda (&rest _args)
                         (should (buffer-live-p preview-buffer))
                         (with-current-buffer preview-buffer
                           (should (string-match-p "Comment one" (buffer-string))))
                         "Comment two")))
              (with-current-buffer source-buffer
                (forward-line 1)
                (llm-review-capture)))
            (should (eq (car preview-action) 'display-buffer-pop-up-window))
            (should (eq (alist-get 'inhibit-same-window (cdr preview-action)) t)))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-menu-defines-core-actions ()
  (should (commandp 'llm-review-menu))
  (should (transient-get-suffix 'llm-review-menu "c"))
  (should (transient-get-suffix 'llm-review-menu "l"))
  (should (transient-get-suffix 'llm-review-menu "w"))
  (should (transient-get-suffix 'llm-review-menu "e"))
  (should (transient-get-suffix 'llm-review-menu "d"))
  (should (transient-get-suffix 'llm-review-menu "h"))
  (should (transient-get-suffix 'llm-review-menu "x")))

(ert-deftest llm-review-menu-displays-review-buffer-until-transient-exits ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el"))
          preview-buffer
          preview-action
          restored-window-configuration)
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Menu preview comment")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (let ((transient-exit-hook nil))
              (cl-letf (((symbol-function 'display-buffer)
                         (lambda (buffer-or-name action &optional _frame)
                           (setq preview-buffer (get-buffer buffer-or-name)
                                 preview-action action)
                           (selected-window)))
                        ((symbol-function 'set-window-configuration)
                         (lambda (configuration)
                           (setq restored-window-configuration configuration)))
                        ((symbol-function 'transient-setup)
                         (lambda (&rest _args)
                           (should (buffer-live-p preview-buffer))
                           (with-current-buffer preview-buffer
                             (should (string-match-p "Menu preview comment" (buffer-string))))
                           (run-hooks 'transient-exit-hook))))
                (with-current-buffer source-buffer
                  (llm-review-menu)))
              (should (eq (car preview-action) 'display-buffer-pop-up-window))
              (should (eq (alist-get 'inhibit-same-window (cdr preview-action)) t))
              (should restored-window-configuration)))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-menu-list-command-keeps-review-buffer-open ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el"))
          restored-window-configuration)
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Keep list open comment")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (let ((transient-exit-hook nil))
              (cl-letf (((symbol-function 'display-buffer)
                         (lambda (_buffer-or-name _action &optional _frame)
                           (selected-window)))
                        ((symbol-function 'set-window-configuration)
                         (lambda (configuration)
                           (setq restored-window-configuration configuration)))
                        ((symbol-function 'transient-setup)
                         (lambda (&rest _args)
                           (llm-review-list)
                           (run-hooks 'transient-exit-hook))))
                (with-current-buffer source-buffer
                  (llm-review-menu)))
              (should-not restored-window-configuration)))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-list-mode-map-setup-adds-navigation-bindings ()
  (let ((llm-review-list-mode-map (make-sparse-keymap)))
    (llm-review--setup-list-mode-map llm-review-list-mode-map)
    (should (eq (lookup-key llm-review-list-mode-map (kbd "n")) #'llm-review-next-comment))
    (should (eq (lookup-key llm-review-list-mode-map (kbd "p")) #'llm-review-previous-comment))
    (should (eq (lookup-key llm-review-list-mode-map (kbd "e")) #'llm-review-edit-comment))
    (should (eq (lookup-key llm-review-list-mode-map (kbd "d")) #'llm-review-delete-comment))))

(ert-deftest llm-review-capture-adds-source-marker-overlay ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (let (comment)
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Marked comment")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (set-mark (point))
                (forward-line 2)
                (activate-mark)
                (setq comment (llm-review-capture))))
            (let ((overlays (gethash (llm-review-comment-id comment)
                                     llm-review--source-overlays)))
              (should (= 3 (length overlays)))
              (should (cl-every #'overlayp overlays))
              (should (cl-every (lambda (overlay)
                                  (eq (overlay-buffer overlay) source-buffer))
                                overlays))
              (should (= 1 (length (seq-filter (lambda (overlay)
                                                  (eq (overlay-get overlay 'face)
                                                      'llm-review-source-range-face))
                                                overlays))))
              (let ((top-marker (overlay-get (car overlays) 'before-string))
                    (bottom-marker (overlay-get (cadr overlays) 'before-string))
                    (range-overlay (caddr overlays)))
                (should (equal (get-text-property 0 'display top-marker)
                               '(left-fringe llm-review-fringe-top llm-review-source-marker-face)))
                (should (equal (get-text-property 0 'display bottom-marker)
                               '(left-fringe llm-review-fringe-bottom llm-review-source-marker-face)))
                (should (equal (get-text-property 0 'help-echo top-marker)
                               "LLM Review Comment\n\nMarked comment"))
                (should (equal (get-text-property 0 'help-echo bottom-marker)
                               "LLM Review Comment\n\nMarked comment"))
                (should-not (overlay-get range-overlay 'before-string))
                (should (eq (overlay-get range-overlay 'face)
                            'llm-review-source-range-face))
                (should (equal (overlay-get range-overlay 'help-echo)
                               "LLM Review Comment\n\nMarked comment"))
                (should (= (overlay-start range-overlay)
                           (with-current-buffer source-buffer (point-min))))
                (should (= (overlay-end range-overlay)
                           (with-current-buffer source-buffer (point-max))))))
        (kill-buffer source-buffer))))))

(ert-deftest llm-review-delete-comment-removes-source-marker-overlay ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (let (comment)
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Marked comment")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (setq comment (llm-review-capture))))
            (let ((overlays (gethash (llm-review-comment-id comment)
                                     llm-review--source-overlays)))
              (should (cl-every #'overlayp overlays))
              (should (llm-review-store-delete-comment
                       (llm-review-store-get-project project-root)
                       (llm-review-comment-id comment)))
              (should-not (gethash (llm-review-comment-id comment)
                                   llm-review--source-overlays))
              (should-not (seq-some #'overlay-buffer overlays))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-source-refresh-buffer-markers-restores-persisted-marker ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let* ((project (llm-review-store-empty-project project-root))
           (comment (llm-review-tests--make-comment 7 "Persisted marker" 2 "second")))
      (llm-review-store-add-comment project "src/example.el" comment)
      (llm-review-persist-save-project project)
      (clrhash llm-review--projects-by-root)
      (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
        (unwind-protect
            (progn
              (clrhash llm-review--source-overlays)
              (with-current-buffer source-buffer
                (llm-review-source-refresh-buffer-markers))
              (let ((overlays (gethash 7 llm-review--source-overlays)))
                (should (= 2 (length overlays)))
                (should (eq (overlay-buffer (car overlays)) source-buffer))
                (should-not (overlay-get (car overlays) 'face))
                (should (eq (overlay-get (cadr overlays) 'face)
                            'llm-review-source-range-face))
                (should (equal (overlay-get (car overlays) 'help-echo)
                               "LLM Review Comment\n\nPersisted marker"))
                (should (equal (overlay-get (cadr overlays) 'help-echo)
                               "LLM Review Comment\n\nPersisted marker"))
                (should-not (overlay-get (cadr overlays) 'before-string))
                (should (= (overlay-start (car overlays))
                           (with-current-buffer source-buffer
                             (save-excursion
                               (goto-char (point-min))
                               (forward-line 1)
                               (point)))))))
          (kill-buffer source-buffer))))))

(ert-deftest llm-review-source-display-fringe-only-omits-background-face ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((llm-review-source-display 'fringe)
          (source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (let (comment)
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Fringe only")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (set-mark (point))
                (forward-line 2)
                (activate-mark)
                (setq comment (llm-review-capture))))
            (let ((overlays (gethash (llm-review-comment-id comment)
                                     llm-review--source-overlays)))
              (should (= 3 (length overlays)))
              (should (= 2 (length (seq-filter (lambda (overlay)
                                                 (overlay-get overlay 'before-string))
                                               overlays))))
              (should-not (seq-some (lambda (overlay)
                                      (overlay-get overlay 'face))
                                    overlays))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-source-display-background-only-omits-fringe-markers ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((llm-review-source-display 'background)
          (source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (let (comment)
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Background only")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (set-mark (point))
                (forward-line 2)
                (activate-mark)
                (setq comment (llm-review-capture))))
            (let ((overlays (gethash (llm-review-comment-id comment)
                                     llm-review--source-overlays)))
              (should (= 1 (length overlays)))
              (should-not (overlay-get (car overlays) 'before-string))
              (should (eq (overlay-get (car overlays) 'face)
                          'llm-review-source-range-face))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-source-display-none-omits-source-overlays ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((llm-review-source-display nil)
          (source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (let (comment)
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "No marker")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (setq comment (llm-review-capture))))
            (should-not (gethash (llm-review-comment-id comment)
                                 llm-review--source-overlays)))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-edit-comment-works-from-source-line ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (let ((responses '("Original comment" "Edited from source")))
                         (lambda (&rest _args)
                           (prog1 (car responses)
                             (setq responses (cdr responses)))))))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)
                (llm-review-edit-comment)))
            (let* ((project (llm-review-store-get-project project-root))
                   (comment (car (llm-review-file-review-comments
                                  (car (llm-review-project-files project))))))
              (should (equal "Edited from source"
                             (llm-review-comment-comment comment)))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-delete-comment-works-from-source-line ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Delete from source")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (cl-letf (((symbol-function 'yes-or-no-p)
                       (lambda (&rest _args) t)))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-delete-comment)))
            (should-not (llm-review-store-get-project project-root)))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-delete-comment-removes-entry-and-persists-change ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (let ((comments '("Comment one" "Comment two")))
                         (lambda (&rest _args)
                           (prog1 (car comments)
                             (setq comments (cdr comments)))))))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)
                (forward-line 1)
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (cl-letf (((symbol-function 'yes-or-no-p)
                             (lambda (&rest _args) t)))
                    (with-current-buffer list-buffer
                      (goto-char (point-min))
                      (search-forward "Comment:\nComment one")
                      (beginning-of-line 0)
                      (llm-review-delete-comment)
                      (should-not (string-match-p "Comment one" (buffer-string)))
                      (should (string-match-p "Comment two" (buffer-string)))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer))))
            (clrhash llm-review--projects-by-root)
            (let ((loaded (llm-review-store-get-project project-root)))
              (should (= 1 (llm-review-tests--project-comment-count loaded)))
              (should (equal "Comment two"
                             (llm-review-comment-comment
                              (car (llm-review-file-review-comments
                                    (car (llm-review-project-files loaded)))))))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-edit-comment-updates-entry-and-persists-change ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\n"))
    (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
      (unwind-protect
          (progn
            (cl-letf (((symbol-function 'read-string)
                       (lambda (&rest _args) "Original comment")))
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (llm-review-capture)))
            (let ((list-buffer (llm-review-list)))
              (unwind-protect
                  (cl-letf (((symbol-function 'read-string)
                             (lambda (&rest _args) "Updated comment")))
                    (with-current-buffer list-buffer
                      (goto-char (point-min))
                      (search-forward "Comment:\nOriginal comment")
                      (beginning-of-line 0)
                      (llm-review-edit-comment)
                      (should (string-match-p "Updated comment" (buffer-string)))
                      (should-not (string-match-p "Original comment" (buffer-string)))))
                (when (buffer-live-p list-buffer)
                  (kill-buffer list-buffer))))
            (clrhash llm-review--projects-by-root)
            (let ((loaded (llm-review-store-get-project project-root)))
              (should (equal "Updated comment"
                             (llm-review-comment-comment
                              (car (llm-review-file-review-comments
                                    (car (llm-review-project-files loaded)))))))))
        (kill-buffer source-buffer)))))

(ert-deftest llm-review-visit-jumps-to-source-entry ()
  (llm-review-tests--with-project-files '(("src/example.el" . "first\nsecond\n"))
    (cl-letf (((symbol-function 'read-string)
               (lambda (&rest _args) "Use a more specific message.")))
      (let ((source-buffer (llm-review-tests--find-file project-root "src/example.el")))
        (unwind-protect
            (progn
              (with-current-buffer source-buffer
                (goto-char (point-min))
                (forward-line 1)
                (llm-review-capture))
              (let ((list-buffer (llm-review-list)))
                (unwind-protect
                    (with-current-buffer list-buffer
                      (goto-char (point-min))
                      (search-forward "Lines: 2-2")
                      (beginning-of-line)
                      (llm-review-visit)
                      (should (eq (current-buffer) source-buffer))
                      (should (= (line-number-at-pos) 2)))
                  (when (buffer-live-p list-buffer)
                    (kill-buffer list-buffer)))))
          (kill-buffer source-buffer))))))

;;; llm-review-tests.el ends here
