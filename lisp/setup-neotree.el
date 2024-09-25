(use-package all-the-icons)
(use-package nerd-icons)

(use-package neotree
  :after (all-the-icons)
  :config
  (defun neotree-project ()
    "Open NeoTree in project root."
    (interactive)
    (if (and (neo-global--window-exists-p))
        (neotree-hide)
      (let ((project-dir (project-root (project-current t)))
            (file-name (buffer-file-name)))
        (progn
          (neotree-show)
          (neotree-dir project-dir)
          (neotree-find file-name)))))

  (with-eval-after-load 'doom-themes
    (doom-themes-neotree-config))

  (setq neo-theme 'icons
        neo-smart-open t
        neo-show-hidden-files t
        neo-show-updir-line nil
        neo-mode-line-type 'neotree
        neo-default-system-application "open"
        neo-hide-cursor t
        neo-window-fixed-size nil
        neo-window-width 35)

  :bind
  (("s-1" . #'neotree-project)
   :map neotree-mode-map
   ("C" . #'neotree-copy-node)
   ("D" . #'neotree-delete-node)
   ("R" . #'neotree-rename-node)
   ("+" . #'neotree-create-node)))
