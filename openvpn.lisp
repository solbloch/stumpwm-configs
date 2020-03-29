(in-package :stumpwm)

(defvar *vpn-directory* #P"~/Documents/vpn/")

(defun vpn-config-list () (uiop:directory-files *vpn-directory*))

(defun open-vpn (path)
  "takes a path and asks for sudo, then opens the process that splits off"
  (let ((password (read-one-line (current-screen) "sudo password: " :password t))
        (command (str:concat "sudo -S openvpn --cd "
                             (namestring *vpn-directory*)
                             " --config "
                             "'" path "'")))
    (with-open-stream (st (make-string-input-stream password))
      (uiop:launch-program command :input st))))



(defun list-open-vpns ()
  (let ((raw-proc-list (proc-regex "sudo.*openvpn")))
    (mapcar #'(lambda (proc-list)
                (list (last1 (str:split " " (car proc-list)))
                      (cadr proc-list)))
            raw-proc-list)))

(defcommand connect-vpn-menu () ()
  (let ((choice (select-from-menu (current-screen)
                                  (mapcar #'(lambda (i)
                                              (list (file-namestring i)
                                                    (namestring i)))
                                          (vpn-config-list))
                                  nil 0 nil)))
    (when choice
      (if (open-vpn (cadr choice))
          (message "Connected...?")
          (message "Broken.")))))


(defcommand kill-vpn-menu () ()
  (when-let ((open-vpns (list-open-vpns)))
    (let ((choice (select-from-menu (current-screen) open-vpns nil 0 nil)))
      (when choice
        (sudo-terminate (cadr choice))))))
