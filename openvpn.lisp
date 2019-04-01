(in-package :stumpwm)

(ql:quickload :uiop)

(defvar *vpn-directory* #P"~/GOOGLE/vpn/")

(defun vpn-config-list () (uiop:directory-files *vpn-directory*))

(defun open-vpn (path)
  "takes a path and asks for sudo, then opens the process that splits off, then kills the process that opened it"
  (let* ((password (read-one-line (current-screen) "sudo password: " :password t))
         (command (concatenate 'string
                               "echo "
                               password
                               " | sudo "
                               " -S openvpn --cd "
                               (namestring *vpn-directory*)
                               " --config "
                               "'"path"'"))
         (asynchronous-process (uiop:launch-program command)))
    (sleep 1)
    (uiop:terminate-process asynchronous-process)))

(defun list-open-vpns ()
  (let ((raw-grep (cl-ppcre:split
                   "\\n" (run-shell-command "ps aux | rg 'sudo.*[o]penvpn'" t))))
    (loop for connection in raw-grep collecting
      (list (nth 5 (cl-ppcre:split "/" (nth 16 (cl-ppcre:split "\\s+" connection))))
            (nth 1 (cl-ppcre:split "\\s+" connection))))))

(defcommand connect-vpn-menu () ()
  (let ((choice
          (select-from-menu (current-screen)
                            (loop for i in (vpn-config-list) collecting
                              (list (nth 5 (cl-ppcre:split "/" (namestring i)))
                                    (namestring i))) nil 0 nil)))
    (if (null choice)
        (throw 'error "Aborted.")
        (if (open-vpn (cadr choice))
            (message "Connected...?")
            (message "Broken, homie.")))))

(defcommand kill-vpn-menu () ()
  (when-let ((open-vpns (list-open-vpns)))
    (let ((choice
            (select-from-menu (current-screen)
                             open-vpns nil 0 nil)))
      (if (null choice)
          (throw 'error "Aborted.")
          (sudo-terminate (cadr choice))))))
