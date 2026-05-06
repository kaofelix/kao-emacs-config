# llm-review

`llm-review` is an Emacs package for collecting project-scoped code review comments and exporting them for use with LLMs.

## Features

- Capture the active region or current line as a review item
- Group comments by file
- Review comments in a dedicated buffer
- Jump back to source locations
- Mark active comments in source buffers with fringe indicators
- Edit or delete comments from the review buffer
- Copy all comments for the current project to the kill ring
- Archive copied comments in a separate history buffer
- Persist comments across Emacs sessions
- Transient menu for common actions

## Commands

- `llm-review-menu`
- `llm-review-capture`
- `llm-review-list`
- `llm-review-copy`
- `llm-review-edit-comment`
- `llm-review-delete-comment`
- `llm-review-history`
- `llm-review-clear-project`

## Review buffer keys

- `RET` visit source
- `e` edit comment at point
- `d` delete comment at point
- `w` copy project comments
- `g` refresh
- `q` quit

## Example setup

```elisp
(use-package llm-review
  :ensure nil
  :load-path "packages/llm-review"
  :bind (("C-c l" . llm-review-menu)))
```

The package does not define a default global keybinding.

## Persistence

Projects and archived exports are stored under `llm-review-storage-directory`.

## Tests

The test file lives at:

- `packages/llm-review/tests/llm-review-tests.el`
