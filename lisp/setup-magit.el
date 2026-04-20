;;; setup-magit.el --- set up for Magit

;;; Commentary:
;;

;;; Code:

(use-package magit
  :bind
  ("C-c g" . #'magit-project-status)
  (:map magit-mode-map
   ("C-M-u" . #'magit-section-up))
  (:map magit-status-mode-map
   ("e" . #'kao/magit-ediff-dwim)
   ("o" . #'magit-diff-visit-worktree-file-other-window))
  (:map magit-revision-mode-map
   ("o" . #'magit-diff-visit-worktree-file-other-window))
  :config
  (add-hook 'after-save-hook 'magit-after-save-refresh-status t)

  :custom
  (magit-save-repository-buffers 'dontask)
  (magit-ediff-dwim-show-on-hunks t)
  (magit-wip-mode t)
  ;; Use pipes instead of ptys. This prevents tools like lefthook from
  ;; detecting a terminal and launching a spinner whose \r characters
  ;; cause magit-process-filter to discard the actual hook output.
  ;; Trade-off: Magit can't prompt for SSH passphrases interactively
  ;; (use ssh-agent, credential helpers, or keychain instead).
  (magit-process-connection-type nil))

(defun kao/magit-ediff-dwim ()
  "Run magit-ediff-dwim, but open new files directly instead of ediffing."
  (interactive)
  (magit-section-case
    (file
     ;; Check if the file is in an untracked section
     (when-let ((parent (oref it parent)))
       (if (eq (oref parent type) 'untracked)
           ;; For new/untracked files, just open the file directly
           (magit-visit-thing)
         ;; For modified files, use normal ediff
         (magit-ediff-dwim))))
    ;; Fall through to normal magit-ediff-dwim for non-file sections
    (t (magit-ediff-dwim))))

(use-package browse-at-remote
  :bind
  ("C-c b" . #'browse-at-remote))

(provide 'setup-magit)

;;; setup-magit.el ends here
