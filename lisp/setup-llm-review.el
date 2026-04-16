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
             llm-review-copy
             llm-review-clear-project)
  :bind (("C-c l" . llm-review-menu)))

(provide 'setup-llm-review)
;;; setup-llm-review.el ends here
