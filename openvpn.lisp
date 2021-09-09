(in-package :stumpwm)

(defvar *vpn-directory* #P"~/Documents/vpn/")

(defun vpn-config-list () (remove-if-not
                           #'(lambda (x) (search ".ovpn" (namestring x)))
                           (uiop:directory-files *vpn-directory*)))

(defun open-vpn (path)
  "takes a path and asks for sudo, then opens the process that splits off"
  (let ((command (str:concat "sudo -S openvpn --cd "
                             (namestring *vpn-directory*)
                             " --config "
                             "'" path "'")))
      (uiop:launch-program command)))



(defun list-open-vpns ()
  (let ((raw-proc-list (proc-regex "sudo.*openvpn")))
    (mapcar #'(lambda (proc-list)
                (list (cl-ppcre:regex-replace-all ".*/(.*)\.ovpn.*" (car proc-list)
                                                  "\\1")
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
      (when (open-vpn (cadr choice))
        (message "Connected...?")))))


(defcommand kill-vpn-menu () ()
  (when-let ((open-vpns (list-open-vpns)))
    (let ((choice (select-from-menu (current-screen) open-vpns nil 0 nil)))
      (when choice
        (sudo-terminate (cadr choice))))))
