;;; early-init.el --- setup a minimal GUI early
(menu-bar-mode -1)
(when (eq window-system 'ns)
  (menu-bar-mode t))
(set-face-attribute 'default nil
                    :height 130
                    :family "Source Code Pro")
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

(setq-default ns-use-proxy-icon nil)
(setq-default frame-title-format "")
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
