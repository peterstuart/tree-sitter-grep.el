;;; tree-sitter-grep.el --- run `tree-sitter-grep' and display the results -*- lexical-binding: t -*-

;; Copyright (C) 2023 Peter Stuart

;; Author: Peter Stuart <peter@peterstuart.org>
;; Maintainer: Peter Stuart <peter@peterstuart.org>
;; Created: 6 Jun 2022
;; URL: https://github.com/peterstuart/tree-sitter-grep.el
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Run `tree-sitter-grep' and display the results in a compilation
;; buffer.

;;; Code:

(require 'grep)

;;;###autoload
(defun tree-sitter-grep (command-args)
  "Run tree-sitter-grep with user-specified COMMAND-ARGS.
The output from the command goes to the \"*tree-sitter-grep*\"
buffer."
  (interactive
   (list (read-shell-command
          "Run tree-sitter-grep (like this): "
          "tree-sitter-grep --query-source "
          'tree-sitter-grep-history)))
  (compilation-start command-args
                     #'grep-mode
                     (lambda (_mode-name) "*tree-sitter-grep*")))

;; Customize

(provide 'tree-sitter-grep)

;;; tree-sitter-grep.el ends here
