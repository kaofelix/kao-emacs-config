;;; setup-ediff.el --- Configuration for Ediff  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kao Felix

;; Author: Kao Felix <me@kaofelix.dev>
;; Keywords: local

;;; Commentary:

;; Configuration for Ediff, the visual diff tool.

;;; Code:

(use-package ediff
  :ensure nil
  :custom
  (ediff-diff-options "-w"
                      "Ignore whitespace in diffs.")
  (ediff-split-window-function 'split-window-horizontally
                               "Split windows horizontally.")
  (ediff-window-setup-function 'ediff-setup-windows-plain
                               "Use the current frame instead of a separate frame.")
  :config
  ;; Skip the "Quit this Ediff session?" confirmation prompt,
  ;; but still support the prefix arg that reverses `ediff-keep-variants'.
  (defun kao/ediff-quit-no-confirm (&optional reverse-default-keep-variants)
    "Quit Ediff without confirmation."
    (interactive "P")
    (ediff-really-quit reverse-default-keep-variants))
  (advice-add 'ediff-quit :override #'kao/ediff-quit-no-confirm))

(provide 'setup-ediff)
;;; setup-ediff.el ends here
