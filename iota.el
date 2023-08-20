;;; iota.el --- Replace marker with increasing integers

;; Copyright © 2023 Thomas Voss

;; Author: Thomas Voss <mail@thomasvoss.com>
;; Keywords: abbrev data wp
;; URL: https://git.sr.ht/~mango/iota
;; Version: 1.0.0

;; Permission to use, copy, modify, and/or distribute this software for any
;; purpose with or without fee is hereby granted.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
;; REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
;; AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
;; INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
;; LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
;; OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;; PERFORMANCE OF THIS SOFTWARE.

;;; Commentary:

;; Iota is a very simple package that provides an easy way to replace strings in
;; a region with an incrementing count.  This can be useful in a variety of
;; settings for doing things such as creating numbered lists, creating
;; enumerations, and more.  The substrings to match are defined by the variable
;; ‘iota-regexp’ while the functions ‘iota’ and ‘iota-complex’ offer simple- and
;; advanced methods of enumeration.  You probably do not want to use these
;; functions in your emacs-lisp code; they are intended for interactive use.

;;; Code:

(defgroup iota nil
  "Simple- and easy enumeration creation."
  :prefix "iota-"
  :group 'editing)

(defcustom iota-regexp "\\<N\\>"
  "Regular expression to match substrings that should be replaced."
  :group 'iota
  :type '(regexp))

(defun iota (start end &optional initial)
  "Replace substrings in the region with incrementing integers.

This function replaces all substrings in the region of START and END that match
the regular expression defined by ‘iota-regexp’ with incrementing integers
beginning with INITIAL or 1 if INITIAL is nil.  When called interactively, the
universal argument can be used to specify INITIAL."
  (interactive "*r\np")
  (iota-complex start end initial #'1+))

(defun iota-complex (start end &optional initial function)
  "Replace substrings in the region with the result of FUNCTION on a count.

This function replaces all substrings in the region of START and END that match
the regular expression defined by ‘iota-regexp’ with the result of calling
FUNCTION with the argument N which starts at INITIAL and increments by 1 every
replacement."
  (interactive "*r\nnInitial value: \nxFunction: ")
  (let ((m1 (make-marker))
        (m2 (make-marker))
        (initial (or initial 1)))
    (set-marker m1 start)
    (set-marker m2 end)
    (save-mark-and-excursion
      (save-match-data
        (goto-char m1)
        (while (re-search-forward iota-regexp m2 'noerror)
          (replace-match (int-to-string initial))
          (setq initial (apply function initial nil)))))))

(provide 'iota)
;;; iota.el ends here
