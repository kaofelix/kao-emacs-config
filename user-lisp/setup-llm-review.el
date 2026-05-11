;;; setup-llm-review.el --- llm-review config -*- lexical-binding: t; -*-

;;; Commentary:

;; Local configuration for llm-review.

;;; Code:

(use-package llm-review
  :ensure nil
  :load-path "packages/llm-review"
  :commands (llm-review-menu
             llm-review-capture
             llm-review-list
             llm-review-history
             llm-review-ediff-capture-current-hunk
             llm-review-ediff-install-keybindings
             llm-review-copy
             llm-review-clear-project)
  :bind (("C-c l" . llm-review-menu))
  :config
  (with-eval-after-load 'ediff
    (add-hook 'ediff-keymap-setup-hook #'llm-review-ediff-install-keybindings)))

(provide 'setup-llm-review)
;;; setup-llm-review.el ends here
