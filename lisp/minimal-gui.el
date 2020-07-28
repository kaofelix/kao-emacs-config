;;; minimal-gui.el --- remove GUI cruft
;; Copyright (C) 2014  Kao Felix

;;; Commentary:

;;

;;; Code:
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(set-frame-font "Source Code Pro-13" t t)

(provide 'minimal-gui)
;;; minimal-gui.el ends here
