(in-package :stumpwm)

(setf *shell-program* "/bin/bash")

(define-stumpwm-type :password (input prompt)
  (or (argument-pop input)
      (read-one-line (current-screen) prompt :password t)))

(define-stumpwm-type :shell-su (input prompt)
  (declare (ignore prompt))
  (let ((prompt "$ "))
    (or (argument-pop input)
        (completing-read (current-screen) prompt 'complete-program))))

(defun sudo (command &optional collect?)
  (let* ((pass (read-one-line (current-screen) "sudo password: " :password t))
         (command (concatenate 'string "sudo -S " command)))
    (with-input-from-string (st pass)
      (uiop:run-program command :input st
                                :output (when collect?
                                          '(:string :stripped t))))))

(defcommand sudo-shell (command &optional collect?) ((:shell-su ""))
  "no side effects, please (stump will break)"
  (if (eq 0 (search "sudo" command))
      (sudo command collect?)
      (if collect?
          (message "~a" (run-shell-command command t))
          (run-shell-command command))))

(defun sudo-terminate (pid)
  (sudo (concatenate 'string "kill " pid)))
