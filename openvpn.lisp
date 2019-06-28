(in-package :stumpwm)

(ql:quickload :uiop)

(defvar *vpn-directory* #P"~/GOOGLE/vpn/")

(defun vpn-config-list () (uiop:directory-files *vpn-directory*))

(defun open-vpn (path)
  "takes a path and asks for sudo, then opens the process that splits off, then kills the process that opened it"
  (let ((password (read-one-line (current-screen) "sudo password: " :password t))
        (command (concatenate 'string
                              "sudo -S openvpn --cd "
                              (namestring *vpn-directory*)
                              " --config "
                              "'" path "'")))
    (with-open-stream (st (make-string-input-stream password))
        (uiop:launch-program command :input st))))



(defun list-open-vpns ()
  (let ((raw-grep (cl-ppcre:split "\\n" (run-shell-command
                                         "pgrep -f -a '[s]udo.*openvpn' | awk '{print $NF, $1}'" t))))
    (loop for connection in raw-grep
          collecting (cl-ppcre:split " " connection))))

(defcommand connect-vpn-menu () ()
  (let ((choice
          (select-from-menu (current-screen)
                            (loop for i in (vpn-config-list)
                                  collecting
                                  (list (nth 5 (cl-ppcre:split "/" (namestring i)))
                                        (namestring i))) nil 0 nil)))
    (if (null choice)
        (throw 'error "Aborted.")
        (if (open-vpn (cadr choice))
            (message "Connected...?")
            (message "Broken, homie.")))))


(defcommand kill-vpn-menu () ()
  (when-let ((open-vpns (list-open-vpns)))
    (let ((choice (select-from-menu (current-screen) open-vpns nil 0 nil)))
      (if (null choice)
          (throw 'error "Aborted.")
          (sudo-terminate (cadr choice))))))
