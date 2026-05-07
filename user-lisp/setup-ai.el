;;; setup-ai.el --- configs for LLM integration packages -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:

(use-package pi-coding-agent
  :ensure t
  :init
  (defalias 'pi 'pi-coding-agent))

(provide 'setup-ai)
;;; setup-ai.el ends here



