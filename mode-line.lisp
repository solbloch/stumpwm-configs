(in-package :stumpwm)

(defun last1 (lst)
  (car (last lst)))

(defun slurp (path)
  (with-open-file (st path)
    (loop for line = (read-line st nil)
          while line collect line)))

(defun network-interface ()
  (let ((proc-lines (slurp #P"/proc/net/route")))
    (when (> (length proc-lines) 1)
      (car (cl-ppcre:split "\\s" (cadr proc-lines))))))

(defun network-string ()
  (let* ((network-interface (network-interface))
         (up-down-binary (when network-interface
                           (slurp (str:concat "/sys/class/net/"
                                              network-interface
                                              "/carrier")))))
    (if (equalp "1" (car up-down-binary))
        (format nil "~a: ^2UP^7" network-interface)
        "^1DOWN^7")))

(defun vpn-state ()
  (let ((vpn-list (list-open-vpns)))
    (when vpn-list
      (format nil "~{~a~^, ~}"
              (mapcar #'(lambda (vpn)
                          (last1 (str:split "/" (last1 (str:split " " (car vpn))))))
                      vpn-list)))))

;; ("월요일" "화요일" "수요일" "목요일" "금요일" "토요일" "일요일")
(defun time? ()
  (let ((days '("Mon" "Tues" "Wed" "Thurs" "Fri" "Sat" "Sun")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (format nil "~2,'0d:~2,'0d:~2,'0d | ~a ~d/~d"
              hour
              minute
              second
              (nth day-of-week days)
              month
              date))))

(defun cpu-temp ()
  (with-open-file (file "/sys/class/hwmon/hwmon2/temp2_input")
    (format nil "~a" (float (/ (read file) 1000)))))

(setf stumpwm:*screen-mode-line-format*
      (list
       "%g^>"
       " | "
       '(:eval (vpn-state))
       " | "
       '(:eval (network-string))
       " | "
       '(:eval (battery-string))
       " | "
       '(:eval (cpu-temp))
       "° | "
       '(:eval (time?))))
