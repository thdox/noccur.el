;;; noccur.el --- Run multi-occur on project/dired files

;; Copyright (C) 2014  Nicolas Petton

;; Author: Nicolas Petton <petton.nicolas@gmail.com>
;; Keywords: convenience
;; Version: 0.1
;; Package: noccur
;; Package-Requires: ((projectile "0.10.0"))

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

;; occur-mode is one of the awesome modes that come builtin with Emacs.
;;
;; Sometimes I just want to run multi-occur on all (or a subdirectory)
;; of a project I'm working on. Used with keyboard macros it makes it
;; a snap to perform modifications on many buffers at once.
;; 
;; The way I use it is the following:

;; M-x noccur-project RET foo RET The occur buffer's content can then
;; be edited with occur-edit-mode (bound to e). To save changes in all
;; modified buffer and go back to occur-mode press C-c C-c.

;;; Code:

(require 'projectile)

(defun noccur-dired (regexp &optional nlines)
  "Perform `multi-occur' with REGEXP in all dired marked files.
When called with a prefix argument NLINES, display NLINES lines before and after."
  (interactive (occur-read-primary-args))
  (multi-occur (mapcar #'find-file (dired-get-marked-files)) regexp nlines))

(defun noccur-project (regexp &optional nlines)
  "Perform `multi-occur' in the current project files."
  (interactive (occur-read-primary-args))
  (let* ((directory (read-directory-name "Search in directory: "))
         (files (if (and directory (not (string= directory (projectile-project-root))))
                    (projectile-files-in-project-directory directory)
                  (projectile-current-project-files)))
         (buffers (mapcar #'find-file 
                          (mapcar #'(lambda (file)
                                      (expand-file-name file (projectile-project-root)))
                                  files))))
    (multi-occur buffers regexp nlines)))

(provide 'noccur)
