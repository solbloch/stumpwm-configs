(in-package :stumpwm)

(defun last1 (lst)
  (car (last lst)))

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
    (if vpn-list
        (format nil "vpn~p:~{~a~^,~}"
                (length vpn-list)
                (mapcar #'(lambda (vpn)
                            (cl-ppcre:regex-replace-all
                             ".*/(.*)\.ovpn.*" (car vpn) "\\1"))
                        vpn-list))
        "no vpn")))

;; ("월요일" "화요일" "수요일" "목요일" "금요일" "토요일" "일요일")
(defun time? ()
  (let ((days '("Mon" "Tues" "Wed" "Thurs" "Fri" "Sat" "Sun")))
    (multiple-value-bind
          (second minute hour date month year day-of-week)
        (get-decoded-time)
      (declare (ignore second year))
      (format nil "~2,'0d:~2,'0d | ~a ~d/~d"
              hour
              minute
              ;; second
              (nth day-of-week days)
              month
              date))))

(defun cpu-temp ()
  (with-open-file (file "/sys/class/hwmon/hwmon0/temp1_input")
    (format nil "~a°" (float (/ (read file) 1000)))))

(defun weather-string ()
  (let ((weather-request (get-weather-request)))
    (if weather-request
        (format nil "~1$° ~a"
                (multi-val weather-request "main" "temp")
                (multi-val (car (multi-val weather-request "weather")) "description"))
        "weather unavailable")))

(defvar *mode-line-processing* nil)

(defun mode-line-processed ()
  *mode-line-processing*)

(defun update-mode-line-process ()
  (setf *mode-line-processing*
        (format nil "%g^>| ~{~A~^ | ~}"
                (list
                   ;; (weather-string)
                   (vpn-state)
                   (network-string)
                   (battery-string)
                   (get-volume-string)
                   (cpu-temp)
                   (time?)))))

;; (setf stumpwm:*screen-mode-line-format*
;;       (list '(:eval (mode-line-processed))))

(setf stumpwm:*screen-mode-line-format*
      (list "%g^>| "
            '(:eval (time?))))
