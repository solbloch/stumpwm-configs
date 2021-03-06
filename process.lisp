(in-package :stumpwm)

(defun slurp (path)
  (with-open-file (st path :direction :input
                           :if-does-not-exist nil)
    (when (streamp st)
      (loop for line = (read-line st nil)
            while line collect line))))


(defun proc-regex (regex)
  "Return processes whose cmdline matches the regex.
Returns the form '((proc-cmd-string proc-id))."
  (loop for proc in (uiop:subdirectories #P"/proc")
        for proc-id = (cl-ppcre:all-matches-as-strings
                       "\\d+" (namestring proc))
        for proc-cmd-string = (when proc-id
                                (car (slurp (str:concat
                                             (directory-namestring proc) "cmdline"))))
        when (and proc-id (cl-ppcre:all-matches-as-strings regex proc-cmd-string))
          collect (list (str:replace-all " " " "proc-cmd-string) (car proc-id))))
