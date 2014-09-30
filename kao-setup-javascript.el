;;; kao-setup-javascript.el --- setup javascript modes

;; Copyright (C) 2014  Kao Felix

;; Author: Kao Felix <kaofelix@Steelix.local>
;; Keywords: local

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.jshintrc$" . javascript-mode))
(add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

(eval-after-load 'dtrt-indent
  '(add-to-list 'dtrt-indent-hook-mapping-list '(js2-mode c/c++/java  js2-basic-offset)))

(require 'js2-refactor)
(js2r-add-keybindings-with-prefix "C-c C-r")

(require 'js2-imenu-extras)
(js2-imenu-extras-setup)

(add-hook 'js2-mode-hook 'dtrt-indent-adapt)

(provide 'kao-setup-javascript)
;;; kao-setup-javascript.el ends here
