;;; tree-sitter-grep.el --- Run `tree-sitter-grep' and display the results -*- lexical-binding: t -*-

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

(defvar tree-sitter-grep--previous-window-configuration nil
  "The window configuration before `tree-sitter-grep--get-query' was called.")

(defconst tree-sitter-grep--query-buffer-name "*tree-sitter-grep-query*"
  "The name of the buffer where the user can enter a tree-sitter query.")

(defconst tree-sitter-grep--query-comment "; Enter a query
;
; C-c C-c  Run the query
; C-c C-k  Abort"
  "The comment that appears at the top of the query buffer.")

;;;###autoload
(defun tree-sitter-grep ()
  "Search the current directory using `tree-sitter-grep'."
  (interactive)
  (setq tree-sitter-grep--previous-window-configuration (current-window-configuration))
  (let ((buffer (get-buffer-create tree-sitter-grep--query-buffer-name)))
    (with-current-buffer buffer
      (erase-buffer)
      (insert "\n\n")
      (insert tree-sitter-grep--query-comment)
      (goto-char (point-min))
      (tree-sitter-grep-query-mode +1))
    (display-buffer buffer)
    (pop-to-buffer buffer)))

(defconst tree-sitter-grep-query-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'tree-sitter-grep-query-mode-run)
    (define-key map (kbd "C-c C-k") #'tree-sitter-grep-query-mode-abort)
    map)
  "Keymap for `tree-sitter-grep-query-mode'.")

(define-minor-mode tree-sitter-grep-query-mode
  "A minor mode for the buffer where the user can enter a tree-sitter query."
  :lighter " TSG Query"
  :keymap tree-sitter-grep-query-mode-map)

(defun tree-sitter-grep-query-mode-run ()
  "Run `tree-sitter-grep' with the contents of the current buffer as the query.
The output from the command goes to the \"*tree-sitter-grep*\"
buffer."
  (interactive)
  (let* ((query-file (make-temp-file "tree-sitter-grep-query")))
    (write-region nil nil query-file)
    (kill-buffer)
    (set-window-configuration tree-sitter-grep--previous-window-configuration)
    (compilation-start (format "tree-sitter-grep --query-file %s" query-file)
                       #'grep-mode
                       (lambda (_mode-name) "*tree-sitter-grep*"))))

(defun tree-sitter-grep-query-mode-abort ()
  "Abort the query."
  (interactive)
  (kill-buffer)
  (set-window-configuration tree-sitter-grep--previous-window-configuration))

;; Customize

(provide 'tree-sitter-grep)

;;; tree-sitter-grep.el ends here
