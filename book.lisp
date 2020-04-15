(in-package :stumpwm)

(defvar *book-directory* #P"~/Documents/books/")

(defun book-list () (uiop:directory-files *book-directory*))

(defcommand open-book () ()
  (let ((choice
          (select-from-menu (current-screen)
                            (loop for i in (book-list)
                                  collecting
                                  (list (nth 5 (cl-ppcre:split "/" (namestring i)))
                                        (namestring i))) nil 0 nil)))
    (when choice
        (run-shell-command (str:concat "zathura \"" (cadr choice) "\"")))))
