;;; setup-gdscript.el --- configs for GDScript for godotengine.org

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kcfelix@gmail.com>
;; Keywords: local

;;; Commentary:

;;

;;; Code:
(require 'use-package)

(use-package gdscript-mode
  :after (hydra)
  :commands (gdscript-hydra-show)
  :straight (gdscript-mode
             :type git
             :host github
             :repo "godotengine/emacs-gdscript-mode"
             :files ("gdscript-*.el"))
  :init
  (load-library "gdscript-hydra")

  :bind (:map gdscript-mode-map
         ("s-/" . gdscript-hydra-show)))

(provide 'setup-gdscript)
;;; setup-gdscript.el ends here

