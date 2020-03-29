(in-package :stumpwm)

(defvar *dmenu-command* "dmenu -fn \"xos4 Terminess Powerline:size=16\" -l 20")

(defun dmenu-command-string (&key prompt)
  (if prompt
      (str:concat *dmenu-command* " -p \"" prompt "\"")))

(defun select-from-dmenu (input-list &optional (prompt nil))
  (let* ((input-string (str:join #\NEWLINE (mapcar #'car input-list)))
         (choice (with-input-from-string (input-stream input-string)
                   (uiop:run-program (dmenu-command-string :prompt prompt)
                                     :input input-stream
                                     :output '(:string :stripped t)))))
    (assoc choice input-list :test #'string=)))
